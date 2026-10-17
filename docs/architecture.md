# Architecture

> Document vivant. Dernière mise à jour : 29 avril 2026 — version 1.0.

Ce document décrit l'architecture technique du système POS Mobile CI. Il est destiné à toute personne qui veut comprendre comment le système est construit avant de coder ou d'opérer dessus.

## Sommaire

1. [Vision technique](#vision-technique)
2. [Diagramme de contexte](#diagramme-de-contexte)
3. [Diagramme de conteneurs](#diagramme-de-conteneurs)
4. [Architecture du backend](#architecture-du-backend)
5. [Architecture mobile](#architecture-mobile)
6. [Synchronisation offline-online](#synchronisation-offline-online)
7. [Sécurité](#sécurité)
8. [Déploiement](#déploiement)
9. [Évolutivité et limites](#évolutivité-et-limites)

## Vision technique

Le système est un produit SaaS multi-tenant qui permet à des commerçants en Côte d'Ivoire d'utiliser un smartphone Android comme terminal de point de vente. Trois principes directeurs structurent l'architecture :

1. **Local-first.** Le téléphone est la source de vérité opérationnelle. Le backend est une copie consolidée et un point de synchronisation. Conséquence : l'app fonctionne intégralement sans réseau pendant des heures.
2. **Simplicité opérationnelle.** Une seule personne peut développer, déployer et opérer le système. Aucun choix qui ajouterait du Kubernetes, du Kafka, ou d'autres composants nécessitant une équipe d'ops.
3. **Coût d'infrastructure minimal.** Tout est open source ou utilise des offres gratuites. L'infrastructure tourne pour moins de 10 € par mois jusqu'à plusieurs centaines de commerçants.

## Diagramme de contexte

```mermaid
flowchart TD
    Commercant([Commerçant<br/>boutique de quartier])
    System[POS Mobile CI<br/>App Flutter + API FastAPI<br/>+ PostgreSQL]
    Brevo[Brevo SMTP<br/>Email transactionnel]
    Printer[Imprimante BT 58mm<br/>ESC/POS thermique]

    Commercant -->|Encaisse, gère catalogue| System
    System -->|Envoie emails| Brevo
    System -->|Imprime via Bluetooth| Printer
```

Le système a un seul acteur principal (le commerçant) et deux dépendances externes : Brevo pour les emails de récupération de mot de passe (comptes ayant renseigné un email), et l'imprimante Bluetooth pour les reçus.

## Diagramme de conteneurs

```mermaid
flowchart TD
    User([Commerçant])

    subgraph Phone[Téléphone Android]
        FlutterApp[App Flutter<br/>Riverpod, dio]
        LocalDB[(SQLite local<br/>via drift)]
        Native[Modules natifs<br/>caméra, BT, secure storage]
        FlutterApp <--> LocalDB
        FlutterApp <--> Native
    end

    subgraph VPS[Serveur VPS Hetzner]
        Caddy[Caddy<br/>reverse proxy + TLS]
        FastAPI[FastAPI + uvicorn<br/>modules auth, catalog,<br/>sales, sync, stores]
        PG[(PostgreSQL 16<br/>multi-tenant + RLS)]
        Caddy --> FastAPI
        FastAPI --> PG
    end

    Brevo[Brevo SMTP]
    Printer[Imprimante BT]

    User --> FlutterApp
    FlutterApp -->|HTTPS REST + JWT| Caddy
    FastAPI -->|SMTP TLS| Brevo
    Native -.->|Bluetooth ESC/POS| Printer
```

Le téléphone et le VPS communiquent uniquement via HTTPS. Aucune autre connexion entre les deux. Le téléphone communique aussi en local via Bluetooth avec l'imprimante.

## Architecture du backend

### Style : monolithe modulaire

L'API FastAPI est un seul process déployé. À l'intérieur, le code est organisé en modules métier :

```
backend/app/
├── main.py                  Point d'entrée FastAPI
├── core/                    Config, DB, sécurité, utils transverses
├── modules/
│   ├── auth/                Inscription, connexion, JWT, reset password
│   ├── stores/              Configuration boutique
│   ├── catalog/             CRUD produits
│   ├── sales/               Création de ventes (immuables)
│   └── sync/                Endpoints de synchronisation
└── tests/
```

Chaque module suit la même structure interne :

```
modules/sales/
├── router.py                Routes FastAPI (couche HTTP)
├── service.py               Logique métier
├── repository.py            Accès données (SQLAlchemy)
├── schemas.py               Modèles Pydantic (DTO)
├── models.py                Modèles SQLAlchemy (entités DB)
└── exceptions.py            Exceptions métier spécifiques
```

Cette séparation permet de tester chaque couche indépendamment et facilite l'évolution future vers des microservices si le projet l'exige (très peu probable avant 2-3 ans).

Voir [ADR-0001 : monolithe modulaire](adr/0001-monolithe-modulaire.md) pour la justification de ce choix.

### Communication entre modules

Les modules communiquent uniquement via leurs services exposés, jamais directement via les repositories. Exemple : si le module `sales` a besoin de vérifier qu'un produit existe, il appelle `catalog_service.get_product()`, pas `catalog_repository.find_by_id()`.

Les imports croisés entre modules suivent une règle simple : un module peut importer le `service.py` et `schemas.py` d'un autre, mais jamais ses `repository.py` ou `models.py`.

### Authentification et autorisation

L'authentification est basée sur JWT. Chaque requête authentifiée porte un header `Authorization: Bearer <token>`.

Le token contient un payload minimal :

```json
{
  "sub": "<user_uuid>",
  "store_id": "<store_uuid>",
  "type": "access",
  "exp": 1735689600
}
```

Le refresh token ne porte que `sub`, `type: "refresh"` et `exp`.

Le `store_id` est extrait du JWT et injecté dans le contexte de la session PostgreSQL pour activer le Row-Level Security (voir section sécurité).

L'access token a une durée de vie de 1 heure. Un refresh token longue durée (30 jours) permet de renouveler sans ressaisir le mot de passe.

L'identifiant est le numéro de téléphone (E.164) + mot de passe ; l'email est optionnel et ne sert qu'à la récupération du compte. Sur l'appareil, un PIN local à 4 chiffres (hashé PBKDF2, jamais envoyé au serveur) protège l'usage quotidien : 5 tentatives, puis blocage 5 minutes. Côté app, le parcours d'authentification est un état `AuthStatus` (inscription → boutique → PIN → authentifié) lu par le routeur.

**Verrouillage après inactivité.** Après 5 minutes sans toucher l'écran (`AppConfig.sessionLockMinutes`), la session se verrouille et le PIN est redemandé ; l'utilisateur reste connecté (jetons conservés, pas d'appel réseau).

- Le temps passé en arrière-plan compte : au retour au premier plan, l'écart avec le dernier toucher est mesuré sur l'horloge (les timers ne sont pas fiables quand l'app est suspendue, surtout sur iOS).
- Mécanisme : `SessionLock` (`features/auth/presentation/providers/session_lock_provider.dart`) arme un timer en `AuthAuthenticated`, réarmé par chaque toucher (un `Listener` dans `lib/app/app.dart`, dialogues compris). À l'échéance, `Auth.lock()` repasse en `AuthPinRequired` et le routeur ouvre l'écran PIN existant (tentatives et blocage inchangés).
- Après déverrouillage, l'app revient à l'accueil. Le panier en cours est conservé (provider `Cart` gardé en vie) et vidé au changement de compte (`Auth._resetStoreCache`). Le montant reçu et le moyen de paiement sont à ressaisir.
- La synchro s'arrête pendant le verrouillage et reprend au déverrouillage (elle n'agit qu'en `AuthAuthenticated`).
- Limites : la saisie au clavier et les scans caméra ne comptent pas comme activité ; un sélecteur système (fichier, appareil photo) ouvert plus de 5 minutes verrouille au retour.

Voir [ADR-0006 : authentification phone-first](adr/0006-auth-phone-first.md), qui remplace [ADR-0004](adr/0004-auth-email-pin.md).

## Architecture mobile

### Découpage en couches (clean-ish architecture)

L'app Flutter est organisée en feature-first, avec à l'intérieur de chaque feature une séparation par couches :

```
mobile/lib/
├── main.dart
├── core/                    Config, theme, constantes, erreurs
├── features/
│   ├── auth/
│   │   ├── data/            DataSources (local + remote), repository impl
│   │   ├── domain/          Entities, repository interface, use cases
│   │   └── presentation/    Pages, widgets, providers Riverpod
│   ├── catalog/
│   ├── sales/
│   ├── printing/
│   └── sync/
├── shared/                  Widgets et helpers réutilisés
└── database/                Configuration drift (SQLite local)
```

Le découpage par feature évite la dispersion d'une fonctionnalité dans 4 dossiers différents — quand tu travailles sur les ventes, tout est dans `features/sales/`.

### State management : Riverpod

Tous les états applicatifs passent par Riverpod. Les providers sont organisés par feature et exposés via des fichiers `providers.dart`.

Pourquoi Riverpod plutôt que Provider ou BLoC :

- Type-safety à la compilation (vs Provider)
- Plus simple à apprendre et tester que BLoC
- Excellente intégration avec drift (StreamProviders réactifs sur la DB)
- Permet de tester les use cases sans monter d'UI

### Génération de code

Plusieurs packages Flutter utilisent `build_runner` pour générer du code :

- `drift` : génère les classes de tables et de DAO depuis les classes Dart
- `freezed` : génère les classes immutables (entities) avec `copyWith`, `==`, `hashCode`
- `riverpod_generator` : annotations pour générer les providers
- `retrofit` : génère le client HTTP depuis une classe annotée

Commande à lancer après chaque modification d'un fichier annoté :

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Pour le mode watch pendant le développement :

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Synchronisation offline-online

### Principe hybride

Le système utilise deux modèles de synchronisation différents selon la nature de la donnée :

| Donnée | Modèle | Justification |
|---|---|---|
| Ventes | Événementiel append-only | Les ventes sont immuables (événements comptables). Pas de modification possible après création. |
| Retours clients | Événementiel append-only | Un retour est un événement distinct de la vente, immuable ; le serveur valide quantités et montant ([ADR-0010](adr/0010-retours-clients.md)). |
| Catalogue (produits, catégories) | État avec last-write-wins | Les produits sont mutables (changement de prix, modification de nom). |

Voir [ADR-0003 : synchronisation hybride](adr/0003-sync-hybride.md) pour la justification détaillée.

### Flux de sync ventes (événementiel)

```mermaid
sequenceDiagram
    participant App as App Flutter
    participant Local as SQLite local
    participant Queue as sync_queue
    participant API as FastAPI
    participant DB as PostgreSQL

    App->>Local: Crée vente (UUID v4 client)
    Local->>Queue: Ajoute à la queue (status=pending)
    Note over App,Queue: Connexion réseau revient
    App->>API: POST /sync/sales (batch d'événements)
    API->>DB: INSERT ON CONFLICT DO NOTHING (par UUID)
    API-->>App: 200 OK avec UUIDs traités
    App->>Queue: Marque comme synced (status=synced)
    App->>Queue: Supprime les entrées synced
```

L'idempotence est garantie par le UUID client : si l'app envoie deux fois la même vente (parce que la première réponse a été perdue), le serveur ne crée pas de doublon.

### Flux de sync retours clients (ADR-0010)

Même modèle que les ventes, sur une vente déjà synchronisée (numéro de reçu attribué) :

1. L'app enregistre le retour hors ligne dans une seule transaction drift : retour, lignes, réintégration du stock local des articles revendables, entrée `sale_return` dans `sync_queue`.
2. Après les ventes, l'app envoie `POST /sync/returns`. Le serveur verrouille la vente, vérifie les quantités déjà retournées et recalcule le remboursement (`RefundCalculator` côté app, `refund.py` côté serveur — implémentations identiques).
3. Un refus définitif (`rejected`) marque le retour `rejected` localement et **annule la réintégration du stock local** ; l'argent a pu être rendu, le commerçant régularise à la main.

Les chiffres du jour et la marge sont nets des remboursements.

### Flux de sync catalogue (état)

```mermaid
sequenceDiagram
    participant App as App Flutter
    participant Local as SQLite local
    participant API as FastAPI
    participant DB as PostgreSQL

    App->>Local: Modifie produit (updated_at = now, dirty=true)
    Note over App,Local: Connexion réseau revient
    App->>API: PUT /sync/products (état complet)
    API->>DB: SELECT updated_at FROM products WHERE id=...
    alt updated_at client > updated_at serveur
        API->>DB: UPDATE products SET ...
        API-->>App: 200 OK
    else updated_at serveur > updated_at client
        API-->>App: 409 Conflict (avec données serveur)
    end
    App->>Local: dirty=false (et applique données serveur si conflit)
```

Le last-write-wins basé sur `updated_at` est suffisant pour le MVP (un seul commerçant par compte, modifications concurrentes très rares). En cas de conflit, le client respecte le serveur.

### Pull au démarrage

Au lancement de l'app et à chaque retour en ligne, l'app récupère les changements depuis la dernière sync :

```
GET /sync/changes?since=<timestamp_iso8601>
```

La réponse contient les ventes (avec leurs lignes), retours, catégories et produits modifiés côté serveur depuis ce timestamp. Utile principalement pour le scénario "changement de téléphone" où `since=null` pour rapatrier tout l'historique de la boutique.

## Sécurité

### Multi-tenancy avec Row-Level Security

Toutes les tables qui contiennent des données métier ont une colonne `store_id`. Pour garantir qu'aucun bug applicatif ne puisse exposer les données d'une boutique à une autre, PostgreSQL Row-Level Security est activé sur ces tables.

Voir [ADR-0002 : multi-tenancy avec RLS](adr/0002-multi-tenancy-rls.md) pour les détails.

Principe :

```sql
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON products
  USING (store_id = current_setting('app.current_store_id')::uuid);
```

À chaque requête authentifiée, le middleware FastAPI extrait le `store_id` du JWT et l'injecte dans la session PostgreSQL :

```sql
SET LOCAL app.current_store_id = '<uuid_extrait_du_jwt>';
```

Toute requête qui tenterait de lire ou écrire sur une autre boutique renverrait zéro lignes ou un échec, indépendamment de ce que le code applicatif demande.

### Stockage des secrets

Aucun secret en dur dans le code ou dans le repo Git. Tout est dans :

- `backend/.env` (jamais committé, présent dans `.gitignore`)
- Variables d'environnement Docker en production

Liste des secrets à gérer :

- `DATABASE_URL` (mot de passe PostgreSQL)
- `JWT_SECRET_KEY` (clé symétrique pour signer les JWT, 32 bytes minimum)
- `BREVO_SMTP_PASSWORD`
- `BACKBLAZE_B2_KEY` (pour les backups)

Pour générer un JWT secret en local :

```bash
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

### Protection contre les attaques courantes

| Attaque | Mitigation |
|---|---|
| Brute force login | Prévu : rate limiting via fastapi-limiter (5 tentatives/min/IP), pas encore branché |
| Brute force PIN | Compteur local, 5 tentatives puis blocage 5 min |
| Appareil laissé ouvert sans surveillance | Verrouillage de session après 5 min sans toucher, PIN redemandé |
| SQL injection | SQLAlchemy avec paramètres bindés, jamais de string concat |
| XSS | Pas de UI web servie par l'API, donc surface réduite |
| CSRF | API stateless avec JWT, pas de cookies de session |
| MITM | TLS forcé (HTTPS uniquement) via Caddy |
| Replay attacks | JWT à courte durée (1h) ; un nouveau refresh token (30 jours) est émis à chaque refresh, sans révocation de l'ancien |

## Déploiement

### Infrastructure cible

- **VPS** : Hetzner CPX11 (4 €/mois, 2 vCPU, 2 Go RAM, 40 Go SSD)
- **OS** : Ubuntu 24.04 LTS
- **Orchestration** : Docker Compose (3 services : caddy, api, postgres)
- **Backups** : pg_dump quotidien chiffré vers Backblaze B2

Pas d'ADR dédié à l'hébergement. **Actuellement**, l'API de bêta tourne sur Render (offre gratuite, `https://pos-mobile-vkuh.onrender.com`, démarrage à froid ~50 s absorbé par le timeout HTTP de 60 s de l'app) ; le VPS Hetzner ci-dessus reste la cible de production.

### Procédure de déploiement

Voir [runbook.md](runbook.md) pour les procédures détaillées.

### Environnements

| Environnement | Usage | Hébergement |
|---|---|---|
| `local` | Développement sur la machine du dev | Docker Compose local |
| `staging` | Tests d'intégration et bêta privée | VPS Hetzner identique à prod |
| `production` | Commerçants payants | VPS Hetzner avec backups |

Au MVP, `staging` et `production` peuvent être le même VPS pour économiser. À séparer dès qu'il y a 50+ utilisateurs.

## Évolutivité et limites

### Capacité estimée de l'architecture actuelle

| Métrique | Limite estimée |
|---|---|
| Commerçants actifs | ~200 sans changement |
| Ventes par jour total | ~20 000 |
| Taille DB après 1 an | ~5 Go |
| Requêtes API simultanées | ~50 |

### À partir de quel volume faut-il évoluer ?

| Symptôme observé | Action recommandée |
|---|---|
| CPU VPS > 70% en moyenne | Passer sur CPX21 (8 €/mois) |
| Latence API > 500ms p95 | Profiler les requêtes lentes, ajouter des index |
| DB > 30 Go | Mettre en place de l'archivage (ventes > 2 ans) |
| > 500 commerçants | Séparer la DB sur un VPS dédié |
| > 2000 commerçants | Envisager un read-replica PostgreSQL |
| > 10000 commerçants | Refonte vers une architecture distribuée |

### Ce qui est explicitement hors-scope du MVP

Ces sujets sont identifiés comme importants mais reportés à des phases ultérieures :

- Plateforme iOS
- Multi-vendeurs par boutique
- Multi-boutiques par compte
- Intégration directe Mobile Money (Wave, Orange, MTN)
- Renouvellement automatique d'abonnement
- Tableaux de bord analytiques avancés
- Application web compagnon (back-office propriétaire)
- Audit log complet (qui a fait quoi quand)
- Synchronisation temps-réel (push via WebSocket)

## Références

- [ADR-0001 : monolithe modulaire](adr/0001-monolithe-modulaire.md)
- [ADR-0002 : multi-tenancy avec RLS PostgreSQL](adr/0002-multi-tenancy-rls.md)
- [ADR-0003 : synchronisation hybride événementiel + état](adr/0003-sync-hybride.md)
- [ADR-0004 : authentification email + PIN](adr/0004-auth-email-pin.md) (remplacé par ADR-0006)
- [ADR-0005 : stack Flutter + FastAPI](adr/0005-stack-flutter-fastapi.md)
- [ADR-0006 : authentification phone-first](adr/0006-auth-phone-first.md)
- [ADR-0007 : ledger des mouvements de stock](adr/0007-stock-movements.md)
- [ADR-0008 : catégories, images et reçus](adr/0008-categories-images-recus.md)
- [ADR-0009 : prix d'achat, remises et marge](adr/0009-prix-achat-remises-marge.md)
- [ADR-0010 : retours clients](adr/0010-retours-clients.md)
- [Modèle de données](data-model.md)
- [Runbook opérationnel](runbook.md)
