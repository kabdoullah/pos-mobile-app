# API

> Conventions et lien vers la doc auto-générée. Dernière mise à jour : 29 avril 2026.

## Documentation interactive auto-générée

FastAPI génère automatiquement une documentation interactive (Swagger UI) qui liste tous les endpoints avec leurs schémas de requête et réponse.

| Environnement | URL Swagger | URL ReDoc |
|---|---|---|
| Local | http://localhost:8000/docs | http://localhost:8000/redoc |
| Production | https://api.pos-mobile-ci.com/docs | https://api.pos-mobile-ci.com/redoc |

**Cette documentation auto-générée est la référence exhaustive.** Le document que tu lis ici contient uniquement les conventions transverses, pas la liste détaillée des endpoints.

## Conventions générales

### Préfixe d'API et versioning

Tous les endpoints sont préfixés par `/api/v1/`. Exemple : `POST /api/v1/auth/login`.

Le versioning par numéro entier dans l'URL permet de faire évoluer l'API en cassant la compatibilité sans casser les clients existants. Quand on aura un `v2`, les deux versions cohabiteront pendant la migration.

### Format de données

- Toujours JSON (`Content-Type: application/json`)
- UTF-8
- Dates au format ISO 8601 avec timezone : `2026-04-29T14:30:00+00:00`
- Montants en string décimal pour préserver la précision : `"1500.00"` (pas `1500.00` en number JSON)

### Authentification

Toutes les routes sauf `/auth/register`, `/auth/login`, `/auth/forgot-password`, `/auth/reset-password` et `/health` requièrent un header :

```
Authorization: Bearer <jwt_token>
```

Le token est obtenu via `POST /api/v1/auth/login`. Sa durée de vie est de 1 heure. Pour le renouveler sans ressaisir le mot de passe, utiliser le refresh token via `POST /api/v1/auth/refresh`.

### Codes de retour

| Code | Signification | Quand |
|---|---|---|
| 200 | OK | GET réussi, action réussie |
| 201 | Created | POST qui crée une ressource |
| 204 | No Content | DELETE réussi |
| 400 | Bad Request | Payload invalide (validation Pydantic) |
| 401 | Unauthorized | JWT manquant, invalide ou expiré |
| 403 | Forbidden | JWT valide mais pas les droits |
| 404 | Not Found | Ressource inexistante ou hors tenant |
| 409 | Conflict | Conflit de sync (état serveur plus récent) |
| 422 | Unprocessable Entity | Payload syntaxiquement valide mais sémantiquement faux |
| 429 | Too Many Requests | Rate limit dépassé |
| 500 | Internal Server Error | Bug serveur |

### Format des erreurs

Toutes les erreurs suivent un format unifié :

```json
{
  "detail": "Message lisible par un humain",
  "code": "PRODUCT_NOT_FOUND",
  "field": "product_id"
}
```

Le champ `code` est un identifiant stable côté client pour i18n et logique conditionnelle. Le champ `field` est présent uniquement pour les erreurs de validation.

### Pagination

Les endpoints qui retournent des listes utilisent une pagination par cursor :

```
GET /api/v1/sales?limit=50&cursor=<opaque_token>
```

Réponse :

```json
{
  "items": [...],
  "next_cursor": "<opaque_token_or_null>",
  "has_more": true
}
```

Pourquoi cursor plutôt qu'offset/limit : les ventes sont insérées en flux continu, l'offset deviendrait incorrect si une vente est insérée pendant la pagination. Le cursor garantit la cohérence.

### Idempotence

Tous les endpoints `POST` qui créent des ressources synchronisées (notamment `/sync/sales`) acceptent un UUID v4 généré par le client comme identifiant. Le serveur fait un `INSERT ON CONFLICT DO NOTHING` côté DB.

Conséquence : un retry après timeout réseau ne crée pas de doublon.

## Endpoints clés (vue d'ensemble)

Liste non exhaustive des endpoints principaux. Voir Swagger pour les schémas complets.

### Authentification

```
POST   /api/v1/auth/register             Créer un compte (phone_number + password, email optionnel)
POST   /api/v1/auth/login                Obtenir un JWT (phone_number + password)
POST   /api/v1/auth/refresh              Renouveler l'access token (nouveau refresh token renvoyé)
POST   /api/v1/auth/forgot-password      Demander un email de reset (comptes avec email uniquement)
POST   /api/v1/auth/reset-password       Confirmer le reset avec token
```

Identifiant : numéro de téléphone au format E.164 (ADR-0006). L'email ne sert qu'à la récupération du compte ; sans email, la récupération passe par le support. Le PIN reste local à l'appareil et n'est jamais envoyé à l'API.

### Profil

```
GET    /api/v1/users/me                   Mon profil (téléphone, email, display_name)
PATCH  /api/v1/users/me                   Nom affiché « Vendeur : … » sur les reçus (vide = retiré)
DELETE /api/v1/users/me                   Supprimer le compte et toutes les données de la boutique (body {password}, 403 si faux, ADR-0011)
```

### Boutique

```
GET    /api/v1/stores/me                  Récupérer ma boutique
PATCH  /api/v1/stores/me                  Mettre à jour ma boutique
PUT    /api/v1/stores/me/logo             Définir le logo (multipart, champ `file`)
GET    /api/v1/stores/me/logo             Logo WebP (ETag, 304 si If-None-Match)
DELETE /api/v1/stores/me/logo             Retirer le logo
```

`phone` (E.164, ex. `+2250700000000`) est imprimé sur les reçus. Le reçu PDF
(`GET /api/v1/sales/{id}/receipt`) affiche aussi le logo et « Vendeur : … »
(nom affiché de l'utilisateur qui a synchronisé la vente, `sales.created_by` ;
absent pour les ventes antérieures).

### Catalogue

```
GET    /api/v1/products                  Lister les produits (paginé)
POST   /api/v1/products                  Créer un produit
GET    /api/v1/products/{id}             Récupérer un produit
PATCH  /api/v1/products/{id}             Mettre à jour un produit
DELETE /api/v1/products/{id}             Soft delete un produit
GET    /api/v1/products/by-barcode/{ean} Recherche par code-barres
PUT    /api/v1/products/{id}/image       Définir l'image (multipart, champ `file`)
GET    /api/v1/products/{id}/image       Image WebP (ETag, 304 si If-None-Match)
DELETE /api/v1/products/{id}/image       Retirer l'image
GET    /api/v1/categories                Lister les catégories actives (par nom)
POST   /api/v1/categories                Créer une catégorie (409 si nom déjà pris)
PATCH  /api/v1/categories/{id}           Renommer une catégorie
DELETE /api/v1/categories/{id}           Soft delete (détache ses produits)
```

Un produit porte au plus une catégorie (`category_id`, nullable). En PATCH et en
synchro, `category_id` absent = inchangé, `null` = retiré ; une catégorie
inconnue de la boutique donne 422 (ADR-0008).

Images (produit, logo) : JPEG, PNG ou WebP, 5 Mo max (413 au-delà, 422 si ce
n'est pas une image). Ré-encodées en WebP sans métadonnées EXIF : 512 px max
pour un produit, 384 px de large pour le logo (imprimante 58 mm). Le binaire ne
passe jamais par la synchro : `image_version` / `logo_version` (SHA-256, null
sans image) servent de clé de cache, et changer d'image bumpe `updated_at`.

### Ventes

```
GET    /api/v1/sales                     Lister les ventes (paginé)
GET    /api/v1/sales/{id}                Détail d'une vente
GET    /api/v1/sales/today/summary       Résumé des ventes du jour
```

Note : `POST /api/v1/sales` existe (idempotent sur l'id de la vente), mais l'app crée ses ventes hors ligne et les envoie uniquement via `/sync/sales`.

### Synchronisation

```
POST   /api/v1/sync/sales                Push événements ventes (batch)
POST   /api/v1/sync/returns              Push retours clients (lots de 50, après les ventes)
PUT    /api/v1/sync/categories           Push état catégorie (à envoyer avant les produits)
PUT    /api/v1/sync/products             Push état produit
GET    /api/v1/sync/changes              Pull des changements depuis un timestamp
```

Ordre de push côté app : ventes → retours → catégories → produits.

`POST /sync/returns` (ADR-0010) renvoie un résultat par retour : `created`, `already_exists` (renvoi du même UUID), `rejected` avec un `error_code` définitif (`sale_not_found`, `item_not_in_sale`, `quantity_exceeded`, `amount_mismatch`) — à ne pas renvoyer — ou `failed` (erreur inattendue, à renvoyer). Le serveur verrouille la vente, recalcule le montant remboursé et refuse tout écart avec celui de l'app.

`GET /sync/changes` renvoie les phases dans l'ordre catégories → produits →
ventes → retours : une catégorie arrive toujours avant ses produits, une vente
avant ses retours.

### Système

```
GET    /health                           Health check (pas de /api/v1)
GET    /                                 Bienvenue + version
```

## Rate limiting

**Pas encore implémenté** : `fastapi-limiter` est déclaré dans les dépendances du backend mais n'est branché sur aucune route. Limites prévues :

| Endpoint | Limite |
|---|---|
| `/auth/login` | 5 tentatives par minute par IP |
| `/auth/forgot-password` | 3 par heure par IP |
| Autres endpoints authentifiés | 100 par minute par utilisateur |

En cas de dépassement, le serveur renverra `429 Too Many Requests` avec un header `Retry-After` indiquant le nombre de secondes à attendre.

## Client Flutter

Le client HTTP n'est pas généré depuis OpenAPI. Les interfaces Retrofit (`@GET`, `@POST`…) et les DTO (`freezed` + `json_serializable`) sont écrits à la main, puis leur implémentation est générée par `make gen` :

- interfaces : `lib/features/<feature>/data/datasources/*_remote_datasource.dart` et `lib/core/sync/sync_remote_datasource.dart`
- DTO : `lib/core/network/api_models/`

Tout changement de schéma côté API doit être reporté à la main dans le DTO correspondant (montants en `String`).

## Versioning et compatibilité

Pendant le MVP, l'API évolue rapidement. **Chaque déploiement peut casser la compatibilité avec les anciennes versions de l'app Flutter en bêta.** Cette tolérance disparaît après le passage en GA.

Conventions :

- Une minor version Flutter (ex: 1.2.0 → 1.3.0) peut nécessiter un déploiement backend
- Les changements cassants côté API impliquent une migration côté Flutter à pousser via Play Store
- Pour les changements non cassants (nouveau champ optionnel par exemple), pas de problème

## Outils de test manuel

### Avec curl

```bash
# Login
curl -X POST https://api.pos-mobile-ci.com/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"+2250700000000","password":"TestPassword123"}'

# Lister les produits avec un token
curl https://api.pos-mobile-ci.com/api/v1/products \
  -H "Authorization: Bearer <TOKEN>"
```

### Avec httpie (plus lisible)

```bash
http POST https://api.pos-mobile-ci.com/api/v1/auth/login \
  phone_number=+2250700000000 password=TestPassword123

http GET https://api.pos-mobile-ci.com/api/v1/products \
  Authorization:"Bearer <TOKEN>"
```

### Avec Insomnia / Bruno

Une collection Bruno est fournie dans `tools/bruno/` avec tous les endpoints pré-configurés et les variables d'environnement (local, staging, prod).
