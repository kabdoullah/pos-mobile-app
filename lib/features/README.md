# Features

Chaque feature suit la même structure en 4 couches :

```
feature_name/
├── data/                     Couche données (concrète)
│   ├── datasources/
│   │   ├── feature_local_datasource.dart    Lit/écrit dans SQLite via drift
│   │   └── feature_remote_datasource.dart   Appelle l'API via dio/retrofit
│   ├── models/               DTO (avec freezed + json_serializable)
│   └── repositories/
│       └── feature_repository_impl.dart     Implémentation du repository
├── domain/                   Couche métier (abstraite, indépendante)
│   ├── entities/             Modèles métier (immutables, freezed)
│   ├── repositories/         Interfaces des repositories
│   └── usecases/             Cas d'usage métier (Dart pur, ZÉRO Riverpod)
├── providers/                Couche DI (wiring, instantiation)
│   └── feature_di_providers.dart   Providers Riverpod pour repo + usecases
└── presentation/             Couche UI (Flutter + Riverpod)
    ├── pages/                Écrans complets
    ├── widgets/              Widgets spécifiques à la feature
    └── providers/            Providers Riverpod pour l'état UI (notifiers)
```

## Règles de dépendances

- `domain` n'importe **RIEN** d'autre (Dart pur) : pas de `riverpod`, pas de `flutter`, pas de `data`
- `data` importe `domain` uniquement (pour implémenter les interfaces)
- `providers/` (couche DI) importe `data` ET `domain` — c'est le **SEUL** endroit hors `data` autorisé à connaître `data/`
- `presentation` importe `domain` et `providers/` (couche DI) — **JAMAIS** `data` directement
- Une feature peut importer le `domain` (et les `providers/`) d'une autre feature, jamais sa `data`

**Flux de dépendance :**
```
domain (Dart pur)
  ↑
data (implémentations concrètes)
  ↑
providers/ (wiring DI : expose les interfaces du domain, instancie les impls du data)
  ↑
presentation (UI consomme les providers, reçoit les entités du domain)
```

Cette organisation force le découplage : on peut changer d'API ou de DB locale sans impacter la couche UI, grâce à la couche DI qui centralise l'instantiation.

## Liste des features

| Feature | Description | Statut |
|---|---|---|
| `auth` | Inscription par téléphone, login, PIN, refresh token, configuration boutique | Implémenté |
| `catalog` | Fiche produit, import, scan, catégories | Implémenté |
| `sales` | Panier, paiement, reçu, historique | Implémenté |
| `inventory` | Onglet Stock, ajustements, historique des mouvements (en ligne uniquement) | Implémenté |
| `returns` | Retours clients, remboursement manuel, reçu de retour (ADR-0010) | Implémenté |
| `printing` | Bluetooth, impression ESC/POS | Implémenté |
| `home` / `onboarding` / `settings` | Présentation uniquement | Implémenté |

La synchronisation n'est pas une feature : elle vit dans `lib/core/sync/`.
