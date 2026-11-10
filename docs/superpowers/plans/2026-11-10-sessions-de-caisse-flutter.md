# Sessions de caisse — Flutter — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Permettre au commerçant d'ouvrir, suivre et clôturer la caisse de son téléphone, hors ligne d'abord. Les ventes et les retours sont rattachés à la session, et le tout est synchronisé avec l'API backend déjà livrée.

**Architecture:** Nouvelle feature `lib/features/cash_register/` en 4 couches (domain, data, providers, presentation). Drift passe en v10. La file `SyncQueue` reçoit 3 nouveaux types. `PushService` et `SyncOrchestrator` sont étendus. Les parcours de vente et de retour existants reçoivent seulement l'id de session et un garde « caisse ouverte ».

**Tech Stack:** Flutter, Riverpod 3 (`riverpod_generator`), Drift, freezed / json_serializable, Retrofit / Dio, `decimal`, GoRouter, mocktail.

**Spec:** `../pos-mobile/docs/superpowers/specs/2026-11-10-sessions-de-caisse-design.md` (§2, §3, §7). **Contrat API faisant foi :** `../pos-mobile/docs/api.md`, section « Sessions de caisse » (branche backend `feat/cash-register-backend`). Les DTO doivent lui correspondre champ pour champ.

## Global Constraints

- Lire `CLAUDE.md`, `.claude/rules/mobile-conventions.md` (dans `../pos-mobile/.claude/rules/`) et `lib/features/README.md` avant de coder.
- Montants : `Decimal` dans le domaine, `String` dans les DTO, `TextColumn` dans Drift. Toujours `Decimal.parse` à la lecture et ne jamais comparer des chaînes : le serveur renvoie `"25000.00"` et parfois `"0"`. Jamais de `double` ni de `int.parse`.
- Couches : `domain` en Dart pur ; `presentation` n'importe jamais `data` ; les providers de DI sont dans `providers/cash_register_di_providers.dart`, les providers d'UI dans `presentation/providers/`.
- Écritures déclenchées depuis l'UI : passer par un contrôleur `@Riverpod(keepAlive: true)` (invariant CLAUDE.md « Riverpod writes and auto-dispose »).
- Horodatages : UTC, générés une seule fois puis persistés. **`closed_at` doit être renvoyé à l'identique à chaque retry de la clôture** (règle de rejeu du serveur).
- Ordre d'envoi de la synchro : ouvertures → ventes → retours → mouvements → clôtures → catégories → produits.
- Design system existant : `AppSpacing`, `AppTypography`, `AppColors`, `AppSemanticColors`, widgets `core/widgets` (`AmountDisplay`, `AppCard`, `PrimaryButton`, `ConfirmDialog`…), mode sombre. Aucune couleur codée en dur. Le bottom navigation ne change pas.
- Tests à plat dans `test/`, nommés `cash_register_<chose>_test.dart`. Drift en mémoire via `AppDatabase.forTesting(NativeDatabase.memory())`, mocks via `mocktail`.
- Avant chaque commit : `make gen` (si une table, un DTO ou un provider a changé), `make format`, `make analyze` sans nouveau warning, et les tests de la tâche.
- Commits `type(scope): message` en français, **sans trailer Co-Authored-By**. Branche `feat/cash-register`, créée depuis `main`. **Ne jamais committer les fichiers iOS déjà modifiés sur `main`** (`ios/Runner.xcodeproj/project.pbxproj`, `Package.resolved`) ni `android/build/`.

## Review Focus

1. **Vente mixte.** La part espèces vient de `checkout.cashReceived`, c'est-à-dire la part et non le montant reçu avec la monnaie rendue. Le solde ne compte que cette part. Testé en Task 3.
2. **Retry de clôture après un timeout.** Le payload renvoyé est identique, `closed_at` compris, et ne doit pas être régénéré. Testé en Task 4.
3. **Clôture en file alors qu'une vente de la session est encore `pending` ou `failed`.** La clôture n'est pas envoyée. Testé en Task 4.
4. **Changement de compte sur le téléphone** (`wipeBusinessData`). Les tables de caisse sont vidées, mais l'identifiant d'appareil survit. Testé en Task 1.
5. **Solde négatif** (remboursement espèces supérieur au solde, C3). L'écran de clôture reste utilisable et le montant théorique négatif est envoyé tel quel. Testé en Task 6.

---

### Task 1: Drift v10, DTO de vente et de retour, effacement

**Files:**
- Modify: `lib/database/app_database.dart` : tables `CashSessions` et `CashMovements` ; colonnes `Sales.cashAmount`, `Sales.mobileMoneyAmount` et `Sales.cashSessionId` (TEXT nullable) ; `SaleReturns.cashSessionId` (TEXT nullable) ; `schemaVersion => 10` ; bloc `if (from < 10)` (createTable ×2, addColumn ×4).
- Modify: `lib/core/network/api_models/sale_dto.dart` (`SaleDto.cashSessionId`, `@JsonKey(name: 'cash_session_id')`, nullable) et `lib/core/network/api_models/sale_return_dto.dart` (`SaleReturnCreateDto.cashSessionId`, `SaleReturnDto.cashSessionId`).
- Modify: `lib/core/sync/pull_service.dart` : à l'insertion d'une vente tirée du serveur, écrire `cashAmount`, `mobileMoneyAmount` et `cashSessionId` ; même chose pour `cashSessionId` sur les retours.
- Modify: `lib/core/sync/local_data_reset_service.dart` : `wipeBusinessData` supprime aussi `cashMovements` puis `cashSessions`.
- Test: `test/cash_register_database_test.dart`

**Interfaces:**
- Produit les tables Drift `CashSessions` et `CashMovements` :
  - **CashSessions** : `id` (PK), `deviceId`, `status` (`open` ou `closed`), `openingAmount`, `openingNote?`, `openedAt`, `expectedAmount?`, `clientExpectedAmount?`, `countedAmount?`, `discrepancyAmount?`, `closingNote?`, `closedAt?`, `serverRecalculated` (bool, défaut false), `syncStatus` (`pending`, `synced` ou `rejected`, défaut `pending`), `rejectionCode?`. Les montants sont en TEXT.
  - **CashMovements** : `id` (PK), `sessionId`, `type` (`cash_in` ou `cash_out`), `reason`, `amount`, `note?`, `createdAt`, `syncStatus`, `rejectionCode?`.

- [ ] **Step 1: Tests qui échouent.**
  - `migration v9 to v10 keeps sales and adds cash tables` : créer une base au schéma v9 (DDL brut, ou `SchemaVerifier` si déjà en place), insérer une vente, migrer, puis vérifier que la vente est intacte, que `cash_amount` est NULL et que les tables de caisse existent.
  - `wipeBusinessData clears cash tables`.
  - `pull stores cash split and session of a mixed sale` : à partir d'un `SyncChangesDto` contenant une vente `mixed` (`cash_amount` "3000.00") et `cash_session_id`, la ligne Drift porte ces valeurs.
- [ ] **Step 2:** `flutter test test/cash_register_database_test.dart`. Résultat attendu : FAIL.
- [ ] **Step 3:** Implémenter, puis `make gen`.
- [ ] **Step 4:** Les tests passent, ainsi que les tests existants `returns_*`, `sync_*` et `mappers_characterization_test.dart`.
- [ ] **Step 5: Commit** `feat(cash): schéma local des sessions de caisse (drift v10)`.

---

### Task 2: Domaine — entités, calcul du solde, identifiant d'appareil

**Files:**
- Create: `lib/features/cash_register/domain/entities/cash_session.dart`, `cash_movement.dart`, `cash_summary.dart`, `cash_labels.dart` (libellés FR des motifs)
- Create: `lib/features/cash_register/domain/cash_balance_calculator.dart`
- Create: `lib/core/storage/device_id_storage.dart`
- Test: `test/cash_register_balance_calculator_test.dart`, `test/cash_register_device_id_test.dart`

**Interfaces:**
- Produit :
  - **Énumérations :** `enum CashSessionStatus { open, closed }`, `enum CashMovementType { cashIn, cashOut }`, `enum CashMovementReason { topUp, float, expense, withdrawal, supplies, other }`.
  - **Correspondance avec l'API :** des fonctions dans `cash_labels.dart` font le lien avec les valeurs de l'API (`top_up`…). `CashMovementReason.allowedFor(CashMovementType)` renvoie `top_up`, `float` et `other` pour une entrée ; `expense`, `withdrawal`, `supplies` et `other` pour une sortie.
  - **Entités `CashSession` et `CashMovement` :** immuables, champs de la Task 1, montants en `Decimal`, `syncStatus` sous forme d'enum `CashSyncStatus { pending, synced, rejected }`.
  - **`CashSummary`** :
    - `openingAmount`, `cashSales`, `cashSalesCount`, `mobileMoneySales`, `cashIn`, `cashOut`, `cashRefunds` et `expectedAmount`, tous en `Decimal` sauf le compteur ;
    - `rejectedCashRefunds` (`Decimal`), pour l'avertissement de C4.
  - **`CashBalanceCalculator.summarize({required Decimal openingAmount, required List<CashSaleLine> sales, required List<CashMovement> movements, required List<CashRefundLine> refunds}) -> CashSummary`.**
    - `CashSaleLine` contient `paymentMethod`, `totalAmount` et `cashAmount?` ; `CashRefundLine` contient `refundMethod`, `refundAmount` et `rejected` (bool).
    - Part espèces d'une vente : `cash` → total ; `mixed` → `cashAmount` ; mobile money → 0.
    - Les remboursements sont pris en compte uniquement si `refundMethod == cash` et `!rejected` ; les remboursements rejetés vont dans `rejectedCashRefunds`.
    - `cashSalesCount` compte les ventes `cash` et `mixed`, comme le serveur.
  - **`DeviceIdStorage`** :
    - `Future<String> getOrCreate()` crée un UUID v4 au premier appel et renvoie le même ensuite ;
    - stockage dans `flutter_secure_storage` sous la clé `cash_device_id`, hors de Drift, donc l'identifiant survit à `wipeBusinessData` ;
    - le constructeur accepte un `FlutterSecureStorage?` pour les tests, sur le modèle de `StoreSuspensionStorage`.

- [ ] **Step 1: Tests qui échouent.** Ce sont les cas du serveur, avec une ouverture à `Decimal.parse('10000')` :
  - `no operations -> 10000` ;
  - `cash sale 3000 -> 13000` ;
  - `wave sale 5000 excluded, mobileMoneySales 5000` ;
  - `mixed 8000 (cash 3000) -> 13000` ;
  - `in 5000 / out 3500 -> 11500` ;
  - `cash refund 1000 counted, orange refund 500 not` ;
  - `rejected cash refund 2000 not counted, rejectedCashRefunds 2000` ;
  - `refund bigger than drawer gives negative balance (-2000)` ;
  - `decimal amounts 1500.50`.
  
  Tests de `DeviceIdStorage` : `same id twice` et `id survives a new instance`, sur un `FlutterSecureStorage` mocké.
- [ ] **Step 2:** FAIL attendu. **Step 3:** implémenter. **Step 4:** PASS attendu.
- [ ] **Step 5: Commit** `feat(cash): domaine et calcul du solde théorique`.

---

### Task 3: Repository local, use cases, rattachement des ventes et retours

**Files:**
- Create: `lib/features/cash_register/domain/repositories/cash_register_repository.dart`
- Create: `lib/features/cash_register/domain/usecases/open_cash_session_usecase.dart`, `record_cash_movement_usecase.dart`, `close_cash_session_usecase.dart`
- Create: `lib/features/cash_register/data/repositories/cash_register_repository_impl.dart`, `lib/features/cash_register/data/models/cash_mappers.dart`
- Create: `lib/features/cash_register/providers/cash_register_di_providers.dart`
- Modify: `lib/core/sync/sync_queue_repository.dart` : `enqueueCashSessionOpen`, `enqueueCashMovement` et `enqueueCashSessionClose` (entity types `cash_session_open`, `cash_movement` et `cash_session_close`)
- Modify: `lib/features/sales/domain/repositories/sales_repository.dart`, `.../data/repositories/sales_repository_impl.dart`, `.../domain/usecases/create_sale_usecase.dart` : paramètre `String? cashSessionId`. La vente persiste `cashSessionId`, `cashAmount` et `mobileMoneyAmount` ; le payload envoie `cash_session_id`.
- Modify: `lib/features/returns/...` (repository, usecase, impl) : paramètre `String? cashSessionId`, persisté et envoyé dans le payload.
- Test: `test/cash_register_repository_test.dart`, `test/cash_register_usecases_test.dart`

**Interfaces:**
- Produit `CashRegisterRepository` :
  - `Stream<CashSession?> watchActiveSession()` ;
  - `Future<CashSession?> getActiveSession()` ;
  - `Stream<CashSummary> watchSummary(String sessionId)` ;
  - `Stream<List<CashMovement>> watchMovements(String sessionId)`, du plus récent au plus ancien ;
  - `Future<CashSession> openSession({required Decimal openingAmount, String? note})` ;
  - `Future<CashMovement> recordMovement({required String sessionId, required CashMovementType type, required CashMovementReason reason, required Decimal amount, String? note})` ;
  - `Future<CashSession> closeSession({required String sessionId, required Decimal countedAmount, String? note})` ;
  - `Stream<List<CashSession>> watchLocalHistory()` ;
  - `Future<void> applyServerClosure(String sessionId, CashSessionDetail detail)`, utilisée en Task 4.
  
  Chaque écriture se fait dans une seule transaction Drift : ligne métier et entrée de file.
- Use cases (exceptions typées `CashRegisterException` avec un `code`) :
  - **`OpenCashSessionUseCase`** : refus `session_already_open` si une session est déjà ouverte sur l'appareil, et `invalid_amount` si le montant est négatif.
  - **`RecordCashMovementUseCase`** :
    - refus `no_open_session` ;
    - refus `invalid_amount` si le montant est ≤ 0 ;
    - refus `note_required` si le motif est `other` et la note vide ;
    - refus `insufficient_cash` pour une sortie supérieure au solde local (D3) ; une sortie égale au solde est acceptée ;
    - refus `reason_type_mismatch` si le motif ne correspond pas au type.
  - **`CloseCashSessionUseCase`** :
    - refus `no_open_session` ;
    - refus `invalid_amount` si le montant compté est négatif ;
    - refus `note_required` si l'écart est différent de 0 et la note vide ;
    - `client_expected_amount` = solde local au moment de la clôture, éventuellement négatif ;
    - `closed_at` est généré ici une seule fois et persisté.
- Payloads mis en file : la forme exacte des requêtes de `../pos-mobile/docs/api.md` (open, movements, close), plus `session_id` dans le payload des mouvements et de la clôture pour l'URL.

- [ ] **Step 1: Tests qui échouent** (Drift en mémoire) :
  - `open then watchActiveSession emits it and enqueues cash_session_open` ;
  - `second open on device refused` ;
  - `cash_out above balance refused, equal allowed` ;
  - `close computes discrepancy and stores client_expected_amount and closed_at` ;
  - `close with non-zero gap requires note` ;
  - `close payload re-read from queue is byte-identical` (Review Focus 2) ;
  - `createSale with session persists cashSessionId and mixed cash part; summary counts only the cash part` (Review Focus 1) ;
  - `cash return attached to active session decreases balance; mobile return does not`.
- [ ] **Step 2:** FAIL attendu. **Step 3:** implémenter, puis `make gen`. **Step 4:** PASS attendu, avec `sales_*`, `returns_*` et `create_sale_usecase_test.dart` toujours verts.
- [ ] **Step 5: Commit** `feat(cash): sessions locales et rattachement des ventes et retours`.

---

### Task 4: API et synchronisation

**Files:**
- Create: `lib/core/network/api_models/cash_session_dto.dart`. DTO freezed en snake_case : `CashSessionDto`, `CashMovementDto`, `CashSummaryDto`, `CashSessionDetailDto` (`session`, `summary`, `movements`), `CashSessionPageDto` (`items`, `next_cursor`, `has_more`), `CashSessionOpenRequestDto`, `CashMovementCreateRequestDto` et `CashSessionCloseRequestDto`. Les champs correspondent à `api.md` champ pour champ et les montants sont des `String`.
- Create: `lib/features/cash_register/data/datasources/cash_register_remote_datasource.dart` (Retrofit) :
  - `POST /api/v1/cash-sessions` ;
  - `GET /api/v1/cash-sessions/active?device_id=` ;
  - `GET /api/v1/cash-sessions?cursor=&limit=&device_id=` ;
  - `GET /api/v1/cash-sessions/{id}` ;
  - `POST /api/v1/cash-sessions/{id}/movements` ;
  - `POST /api/v1/cash-sessions/{id}/close`.
- Modify: `lib/core/sync/push_service.dart` : `pushPendingCashSessionOpens()`, `pushPendingCashMovements()`, `pushPendingCashSessionCloses()`.
- Modify: `lib/core/sync/sync_orchestrator.dart` : ordre d'envoi des Global Constraints.
- Modify: `lib/core/sync/sync_providers.dart` (DI du datasource si c'est là que vit celui de la synchro)
- Test: `test/cash_register_sync_test.dart`, `test/cash_register_dto_test.dart`

**Interfaces / règles de réponse** (les codes sont lus via `ApiException.code`, `core/network/api_exception.dart`) :
- **Ouverture :** 200 ou 201 → `synced`. Une 409 `CASH_SESSION_ALREADY_OPEN` ou `IDEMPOTENCY_CONFLICT` → session `rejected` avec son code, et l'entrée de file passe en rejected.
- **Mouvement :**
  - 200 ou 201 → `synced` ;
  - 422 `INSUFFICIENT_CASH` ou 409 `CASH_SESSION_CLOSED` / `IDEMPOTENCY_CONFLICT` → `rejected` avec son code ;
  - 404 → réessayer, car l'ouverture n'est pas encore connue du serveur.
- **Clôture :**
  - **envoyée seulement s'il ne reste aucune entrée `pending`, `syncing` ou `failed`** pour l'ouverture, les ventes, les retours ou les mouvements de cette session. Le lien se fait par `Sales.cashSessionId`, `SaleReturns.cashSessionId` et `CashMovements.sessionId` ;
  - 200 → `applyServerClosure` avec les valeurs du serveur : `expected_amount`, `discrepancy_amount` et `server_recalculated` ;
  - 409 `CASH_SESSION_CLOSED` → `GET /{id}`, `applyServerClosure`, l'entrée passe en rejected avec `rejectionCode`, et l'écran le signale ;
  - 404 → réessayer.
- **Réseau, 5xx ou boutique suspendue :** même traitement que `_pushReturn` (`incrementRetry` ou `_keepIfSuspended`).

- [ ] **Step 1: Tests qui échouent** (datasource mocké) :
  - `dto parses api.md examples` : les JSON de `api.md`, avec `"25000.00"` et `"0"` ;
  - `push order: open before sales before returns before movements before closes` ;
  - `close held while a session sale is pending, sent once it is synced` (Review Focus 3) ;
  - `close retry resends identical closed_at` (Review Focus 2) ;
  - `INSUFFICIENT_CASH marks movement rejected` ;
  - `movement 404 is retried` ;
  - `server close with different expected updates local session and flags serverRecalculated` ;
  - `CASH_SESSION_CLOSED on close aligns local session from GET`.
- [ ] **Step 2:** FAIL attendu. **Step 3:** implémenter, puis `make gen`. **Step 4:** PASS attendu, avec `sync_*` toujours vert.
- [ ] **Step 5: Commit** `feat(sync): synchroniser les sessions et mouvements de caisse`.

---

### Task 5: Gardes dans les parcours existants

**Files:**
- Create: `lib/features/cash_register/presentation/providers/cash_register_providers.dart` :
  - `activeCashSessionProvider`, un `StreamProvider` ;
  - `cashSummaryProvider(sessionId)` ;
  - `cashMovementsProvider(sessionId)` ;
  - le contrôleur `CashRegisterController` (`keepAlive`), avec `open`, `recordMovement` et `close`, qui déclenche `syncNow()` si l'appareil est en ligne, comme `SaleSubmission`.
- Modify: `lib/features/sales/presentation/providers/sales_providers.dart` : `SaleSubmission.submit()` lit la session active. **Sans session, il lève `CashRegisterException('no_open_session')` et rien n'est enregistré.** Avec une session, il passe `cashSessionId`.
- Modify: l'écran ou le panneau d'encaissement qui appelle `submit()` : sur `no_open_session`, ouvrir la feuille « Ouvrir la caisse » (Task 6). Après l'ouverture, le commerçant valide de nouveau. Le panier est conservé.
- Modify: `lib/features/returns/presentation/providers/returns_providers.dart` : passer `cashSessionId` de la session active. **Un remboursement `cash` sans session ouverte lève `no_open_session`** (C6). Un remboursement mobile money sans session reste possible, avec `cashSessionId` à null.
- Modify: `lib/features/settings/presentation/pages/settings_page.dart` : déconnexion **refusée** tant qu'une session est ouverte, avec le message « Clôturez la caisse avant de vous déconnecter. »
- Test: `test/cash_register_guards_test.dart`

- [ ] **Step 1: Tests qui échouent** :
  - `submit without open session throws and keeps cart` ;
  - `submit with session attaches it` ;
  - `cash refund without session refused, wave refund allowed` ;
  - `logout blocked while session open`.
- [ ] **Step 2:** FAIL attendu. **Step 3:** implémenter. **Step 4:** PASS attendu, avec `sales_sale_submission_test.dart`, `returns_pages_test.dart` et `settings_page_layout_test.dart` toujours verts. Mettre à jour leurs fixtures avec une session ouverte si c'est nécessaire.
- [ ] **Step 5: Commit** `feat(cash): caisse ouverte requise pour encaisser et rembourser en espèces`.

---

### Task 6: Écrans et navigation

**Files:**
- Create, dans `lib/features/cash_register/presentation/` :
  - **pages :** `cash_register_page.dart` (caisse active, ou invitation à ouvrir), `close_cash_session_page.dart` (récapitulatif, saisie du montant compté, état, note, confirmation), `cash_session_history_page.dart`, `cash_session_detail_page.dart` ;
  - **widgets :** `open_cash_session_sheet.dart`, `cash_movement_sheet.dart` (paramétré par type), `cash_summary_card.dart`, `cash_movement_tile.dart`, `discrepancy_badge.dart` (équilibrée, excédent ou déficit, couleurs `AppSemanticColors`).
- Modify: `lib/core/router/app_router.dart` : `Routes.cashRegister = '/cash'`, `cashClose = '/cash/close'`, `cashHistory = '/cash/history'`, `cashSessionDetail = '/cash/sessions/:id'`. Routes plein écran, hors `StatefulShellRoute`.
- Modify: `lib/features/home/presentation/pages/home_page.dart` : carte « Caisse » sous `TodaySummary`. Elle affiche le solde théorique (`AmountDisplay`) ou « Caisse fermée · Ouvrir », et un tap mène à `/cash`.
- Test: `test/cash_register_pages_test.dart`

Exigences UX :
- **Caisse active :** le solde théorique est l'élément dominant, suivi du détail de la formule (ouverture + ventes espèces + entrées − sorties − remboursements espèces) et des 10 derniers mouvements. Les actions sont Entrée, Sortie et Clôturer.
- **Clôture :**
  - l'état se met à jour pendant la saisie : « Caisse équilibrée », « Excédent de X » ou « Déficit de X » ;
  - la note devient obligatoire dès que l'écart est différent de 0 ;
  - le bouton ouvre un `ConfirmDialog` qui récapitule l'ouverture, les ventes espèces, les entrées, les sorties, les remboursements, le solde théorique, le montant compté et l'écart ;
  - un solde négatif s'affiche tel quel (Review Focus 5).
- **Session clôturée :**
  - si le serveur a recalculé le montant, la bannière dit « Montant recalculé par le serveur : X (affiché : Y) » ;
  - si `late_impact` est différent de 0, la bannière dit « Opérations arrivées après clôture : ±X » ; ce cas n'est visible qu'en ligne, via `GET /{id}` ;
  - si `rejectedCashRefunds` est supérieur à 0, la bannière dit « Retour refusé : X FCFA rendus non comptés ».
- **Historique :** la liste du serveur en ligne (tous les appareils, pagination) ; les sessions locales hors ligne, avec un bandeau « Hors ligne : sessions de ce téléphone uniquement ».
- **États :** vide, chargement (`SkeletonBox` / `LoadingIndicator`) et erreur, partout. Cibles tactiles ≥ 48 dp. Libellés `Semantics` sur les montants.

- [ ] **Step 1: Tests de widgets qui échouent** (providers surchargés) :
  - `closed state shows open button` ;
  - `active page shows expected balance and recent movements` ;
  - `close page shows surplus/deficit/balanced and requires note on gap` ;
  - `close page accepts negative expected balance` ;
  - `detail shows server-recalculated and late-impact banners` ;
  - `home card navigates to /cash` ;
  - `dark mode renders without hard-coded colors`, sur le modèle de `core_dark_mode_contrast_test.dart`.
- [ ] **Step 2:** FAIL attendu. **Step 3:** implémenter. **Step 4:** PASS attendu, avec `home_page_layout_test.dart` et `router_full_screen_routes_test.dart` toujours verts.
- [ ] **Step 5: Commit** `feat(cash): écrans d'ouverture, de suivi, de clôture et d'historique`.

---

### Task 7: Vérification de bout en bout sur émulateur et documentation

**Files:**
- Modify: `CLAUDE.md` (Features status, et ordre de synchro dans « Sync ») et `lib/features/README.md` si la liste des features y figure.

- [ ] **Step 1:** Lancer `make gen && make format && make analyze && make test`. Résultat attendu : 0 erreur et tous les tests verts.
- [ ] **Step 2:** Démarrer l'API locale depuis `../pos-mobile` (`make dev`, branche `feat/cash-register-backend`, base migrée) et lancer l'app sur l'émulateur Android en la pointant sur l'API locale. Voir `docs/flavors.md` pour l'URL (`10.0.2.2:8000` depuis l'émulateur).
- [ ] **Step 3: Parcours à dérouler et à capturer** (captures d'écran à chaque étape) :
  1. ouvrir la caisse avec 10 000 ;
  2. vente espèces de 3 000 ;
  3. vente Wave de 5 000 ;
  4. vente mixte de 8 000, dont 3 000 en espèces ;
  5. retour espèces de 1 000 sur la vente espèces, une fois synchronisée (un retour exige une vente synchronisée, ADR-0010) ;
  6. entrée de 5 000 ;
  7. sortie de 2 000 ;
  8. vérifier le solde de 18 000 (10 000 + 3 000 + 3 000 − 1 000 + 5 000 − 2 000 ; la vente Wave n'est pas comptée) ;
  9. tenter une sortie supérieure au solde, qui doit être refusée ;
  10. passer en mode avion, faire une vente espèces de 1 000 (solde 19 000) et clôturer avec 19 500 et une note (excédent de 500) ;
  11. revenir en ligne : la synchro envoie la vente puis la clôture ;
  12. vérifier via `GET /api/v1/cash-sessions/{id}` que `expected_amount` vaut `"19000.00"` et `discrepancy_amount` `"500.00"`.
- [ ] **Step 4:** Mettre à jour la documentation.
- [ ] **Step 5: Commit** `docs(cash): sessions de caisse dans l'app`.
