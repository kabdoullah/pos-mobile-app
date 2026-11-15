# Publication iOS — App Store (Ma Caisse)

Première soumission : version 1.7.0 (build 14), le 15 novembre 2026.

## Identité de l'app

| Élément | Valeur |
|---|---|
| Nom App Store | Ma Caisse – Caisse & Stock (« Ma Caisse » est déjà pris) |
| Nom sous l'icône | Ma Caisse (`CFBundleDisplayName`, `ios/Runner/Info.plist`) |
| Bundle ID | `ci.pos.macaisse` (identique à l'`applicationId` Android) |
| Équipe Apple | Ndoua Amani Guy Roland — `3NRR8L4663` |
| SKU | `macaisse-ios` |
| Apple ID de l'app | 6834899990 |
| Catégories | Business, Finance |
| Classification | 4+ |
| Prix | Gratuit |
| Confidentialité | https://kabdoullah.github.io/pos-mobile/privacy-policy |
| Assistance | https://kabdoullah.github.io/pos-mobile/ |

`ci.pos.macaisse.app` n'est **pas** utilisable : une équipe personnelle (compte gratuit) l'a réservé lors d'une installation de test, et un compte gratuit ne peut pas libérer un App ID.

## Prérequis sur le Mac

- Xcode avec, dans **Réglages → Comptes**, un Apple ID membre de l'équipe `3NRR8L4663` (rôle Admin ou App Manager). Sans lui : `No Account for Team "3NRR8L4663"`.
- Signature automatique (`CODE_SIGN_STYLE = Automatic`) : Xcode crée seul le certificat de distribution et le profil.
- `ios/ExportOptions.plist` : `method = app-store-connect`, `teamID = 3NRR8L4663`.

## Publier une nouvelle version

1. Augmenter `version:` dans `pubspec.yaml`. Le numéro de build (après le `+`) doit être strictement supérieur au dernier envoyé — il est partagé avec le `versionCode` Android.
2. Construire l'IPA (entrée prod, pas de flavor iOS) :
   ```bash
   flutter build ipa --release -t lib/main_prod.dart --export-options-plist=ios/ExportOptions.plist
   ```
   L'archive est dans `build/ios/archive/Runner.xcarchive`, l'IPA dans `build/ios/ipa/`.
3. Envoyer : `open build/ios/archive/Runner.xcarchive` → Organizer → **Distribute App** → App Store Connect → Upload.
4. Attendre le traitement (10 à 60 min) dans App Store Connect → **TestFlight**. Tester le build via l'app TestFlight.
5. App Store Connect → Distribution → **+ Version** : la version doit porter le même numéro que le build (`1.7.0` ↔ `1.7.0 (14)`), sinon le build n'est pas proposé.
6. Renseigner « What's New », sélectionner le build, **Add for Review** → **Submit for Review**.
7. Avant la soumission, ouvrir l'app une fois pour réveiller le serveur Render (démarrage à froid d'environ 1 min).

Flutter réécrit parfois `ios/Runner.xcodeproj/project.pbxproj` (`objectVersion`) et supprime les `Package.resolved` du projet iOS pendant un build : restaurer ces derniers avec `git checkout --` avant de commiter.

## Chiffrement (export compliance)

`Info.plist` déclare `ITSAppUsesNonExemptEncryption = false` (HTTPS uniquement) : App Store Connect ne pose pas la question à chaque build.

## Captures d'écran

Dans `store-assets/screenshots/ios/` :

| Fichiers | Taille | Emplacement App Store Connect |
|---|---|---|
| `0*.png`, `appstore-*.png` | 1320 × 2868 | iPhone grand écran (6,9") |
| `6.3/*.png` | 1206 × 2622 | iPhone with Dynamic Island (medium display) |
| `appstore-icone-1024.png` | 1024 × 1024 | Icône |

Un fichier déposé dans le mauvais emplacement donne « File dimensions are invalid ». Les captures de l'app se prennent sur le simulateur iPhone Pro Max (`xcrun simctl io <id> screenshot`), et se redimensionnent en 6,3" avec `sips -z 2622 1206`.

## Review Apple

- **Compte de démo** : obligatoire, l'app exige une connexion. Les identifiants sont dans App Store Connect → App Review → Sign-In Information (ne pas les commiter). Le compte doit avoir une boutique, des produits et quelques ventes.
- **Notes au testeur** : après la connexion, créer un PIN à 4 chiffres (local à l'appareil) ; ouvrir la caisse avant de vendre ; l'imprimante Bluetooth est facultative ; le serveur peut mettre jusqu'à une minute à répondre au premier lancement.
- **Suppression de compte** : exigée par Apple, disponible dans Paramètres (ADR-0011).
- **App Privacy** : coordonnées (téléphone, nom, e-mail facultatif), photos (produits, logo), historique des ventes — liées à l'utilisateur, sans suivi publicitaire, finalité « fonctionnement de l'app ».
- **Classification d'âge** : « Non » partout (pas de contenu généré partagé entre utilisateurs, pas de navigateur, pas de messagerie).

## Tester sur un iPhone sans passer par TestFlight

```bash
flutter run --release -d <id-iphone> -t lib/main_prod.dart
```

Le premier lancement peut être refusé (« profile has not been explicitly trusted ») : sur l'iPhone, Réglages → Général → VPN et gestion de l'appareil → faire confiance au développeur. Si `flutter run` échoue à l'installation, `xcrun devicectl device install app --device <id> build/ios/iphoneos/Runner.app` donne l'erreur exacte.
