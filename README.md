# Ma Caisse — application mobile

Application de caisse (POS) Flutter pour les PME en Côte d'Ivoire : ventes hors ligne, catalogue, stock, retours clients et reçus imprimés en Bluetooth. Android et iOS.

Backend : dépôt `pos-mobile` (FastAPI + PostgreSQL), déployé sur `https://pos-mobile-vkuh.onrender.com`.

## Fonctionnalités

| Feature | Contenu |
|---|---|
| `auth` | Inscription et connexion par téléphone + mot de passe, PIN local, configuration de la boutique, suppression du compte (ADR-0011) |
| `catalog` | Produits, catégories, photos, import, scan de codes-barres |
| `sales` | Panier, paiement (espèces / mobile money / mixte), réductions, reçu, historique |
| `inventory` | Onglet Stock, ajustements manuels, historique des mouvements (en ligne uniquement) |
| `returns` | Retours clients d'une vente synchronisée, remboursement, reçu de retour (ADR-0010) |
| `printing` | Imprimante thermique Bluetooth ESC/POS 58 mm |
| `home`, `onboarding`, `settings` | Tableau de bord, tutoriel, paramètres |

La synchronisation hors ligne vit dans `lib/core/sync/` : file d'événements pour les ventes et retours, flag `dirty` pour le catalogue, pull au démarrage et au retour du réseau (ADR-0003, ADR-0008).

## Stack

- **Flutter 3.44+** / Dart 3.11+
- **Riverpod 3** (`riverpod_generator`) pour l'état
- **drift** pour la base SQLite locale
- **dio + retrofit** pour l'API, **freezed / json_serializable** pour les modèles
- **decimal** pour tous les montants en FCFA (jamais de `double`)
- **mobile_scanner** pour les codes-barres
- **print_bluetooth_thermal + esc_pos_utils_plus** pour l'impression

## Démarrage rapide

```bash
make install     # flutter pub get
make gen         # génère drift, freezed, riverpod, retrofit
make run         # flavor dev (lib/main.dart) sur l'émulateur ou l'appareil
make gen-watch   # régénère le code en continu
```

Relancer `make gen` après toute modification de table, de modèle ou de provider.

## Structure

```
lib/
├── main.dart, main_prod.dart   Points d'entrée (flavor dev / prod)
├── app/                        App racine et thème « Cacao & Or »
├── core/                       Config, réseau, routeur, stockage sécurisé, sync, widgets partagés
├── database/                   Schéma drift
└── features/<feature>/
    ├── domain/                 Entités, interfaces de repository (Dart pur)
    ├── data/                   Datasources, DTO, implémentations
    ├── providers/              Injection de dépendances
    └── presentation/           Pages, widgets, providers d'état
test/                           Tests à plat : <feature>_<concept>_test.dart
```

Règles de dépendances entre couches : `lib/features/README.md`. Détails et invariants : `CLAUDE.md`, `docs/architecture.md`.

## Configuration

L'URL de l'API est passée à `AppConfig.setup()` dans chaque point d'entrée :

| Flavor | Entrée | ID d'application | API |
|---|---|---|---|
| dev | `lib/main.dart` | `ci.pos.macaisse.dev` (Android) | `https://pos-mobile-vkuh.onrender.com` |
| prod | `lib/main_prod.dart` | `ci.pos.macaisse` | `https://pos-mobile-vkuh.onrender.com` |

`docs/flavors.md` mentionne `https://api.pos-mobile-ci.com` pour la prod : vérifier l'URL avant une release. Le timeout HTTP de 60 s absorbe le démarrage à froid de Render (environ 50 s).

Pages publiques (GitHub Pages du dépôt backend) :

- Politique de confidentialité : https://kabdoullah.github.io/pos-mobile/privacy-policy
- Suppression du compte : https://kabdoullah.github.io/pos-mobile/account-deletion

## Commandes

```bash
make help          # liste les commandes
make format        # dart format
make analyze       # analyse statique
make test          # tous les tests
make build-apk     # APK release (prod)
make build-apk-dev # APK debug (dev)
make build-aab     # AAB release (Play Store)
make clean         # vide les caches
```

Avant chaque commit : `make format && make analyze`. La CI lance `flutter analyze --fatal-infos` : un simple « info » la fait échouer. Les messages de commit suivent Conventional Commits (hook pre-commit).

Un seul test : `flutter test test/inventory_stock_adjustment_test.dart` ou `flutter test --plain-name "rolls over"`.

## Release Android (Play Store)

```bash
make build-aab   # flutter build appbundle --release --flavor prod -t lib/main_prod.dart
```

- **Signature** : `android/app/build.gradle.kts` lit `android/key.properties` (non versionné, comme le keystore `*.jks`). Sans ce fichier, le build retombe sur la clé debug. Procédure : `docs/build-apk-prod.md`.
- **ABI** : seulement `arm64-v8a` et `armeabi-v7a` (`x86_64` ne correspond à aucun appareil vendu en Côte d'Ivoire). Le Play Store découpe l'AAB par ABI.
- **MLKit unbundled** : `dev.steenbakker.mobile_scanner.useUnbundled=true` dans `android/gradle.properties`. Les modèles de scan viennent de Google Play Services (-0,7 Mo).
- **Prérequis** : Android SDK cmdline-tools installés (`flutter doctor` sans `✗` sur la toolchain Android).

## Release iOS (App Store)

```bash
flutter build ipa --release -t lib/main_prod.dart
```

- Pas de flavor sur iOS : un seul schéma `Runner`, bundle `ci.pos.macaisse`. `make run` (`--flavor dev`) ne fonctionne donc que sur Android.
- iOS 15.0 minimum, iPhone uniquement. Dépendances iOS via Swift Package Manager (`Package.resolved` versionné, pas de Podfile).
- `Info.plist` déclare la caméra, la photothèque et le Bluetooth (`NSBluetoothAlwaysUsageDescription`), et `ITSAppUsesNonExemptEncryption = false` (HTTPS standard uniquement).
- **Impression** : sur iOS, `print_bluetooth_thermal` ne parle qu'en Bluetooth basse consommation (BLE). Une imprimante en Bluetooth classique uniquement n'apparaîtra pas : tester l'imprimante réelle sur iPhone.
- **Examen Apple** : fournir un compte de démo (téléphone, mot de passe, PIN) et réveiller le backend Render avant l'examen.

## Icônes

Les sources sont dans `assets/launcher_icons/`, hors du glob `assets/images/` du `pubspec.yaml` : elles servent seulement au build. Après une modification :

```bash
dart run flutter_launcher_icons
```
