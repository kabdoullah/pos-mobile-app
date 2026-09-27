# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
make install       # flutter pub get
make gen           # code generation — run after model/table/provider changes
make gen-watch     # watch mode (regenerates continuously)
make analyze       # static analysis (must pass before commit)
make format        # dart format (fails if diff — run before commit)
make test          # flutter test all
make run           # dev flavor on emulator/device (--flavor dev -t lib/main.dart)
make run-prod      # prod flavor, release
make build-apk     # release APK (prod flavor)
make build-apk-dev # debug APK (dev flavor)
make build-aab     # release AAB (Play Store)
make clean         # clear Flutter + dart_tool caches
```

**Before every commit:** `make format && make analyze`. CI (`.github/workflows/mobile-ci.yml`) runs `flutter analyze --fatal-infos`, so infos fail CI even though `make analyze` passes them. A pre-commit hook enforces Conventional Commits (`feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `build`, `ci`, `revert`).

**Single test:** `flutter test test/inventory_stock_adjustment_test.dart`, or by name: `flutter test --plain-name "rolls over"`

## App entry points and flavors

Two entry points, two flavors:
- `lib/main.dart` — `AppFlavor.dev`, application ID suffix `.dev`
- `lib/main_prod.dart` — `AppFlavor.prod`

Both currently point at `https://pos-mobile-vkuh.onrender.com` (`docs/flavors.md` lists `https://api.pos-mobile-ci.com` for prod — check before a release).

Both call `AppConfig.setup(flavor:, apiUrl:)` before `runApp`. `AppConfig.isDev` gates debug features. Constants (timeout, PIN lockout, etc.) live in `AppConfig` — see `core/config.dart`.

## Architecture

Feature-first Clean Architecture. Full features have 3 layers; presentation-only features (home, onboarding, settings) have only `presentation/`:

```
lib/features/<feature>/
├── domain/       Pure business logic — entities (freezed), repository interfaces
├── data/         Concrete implementations — local/remote datasources, DTOs, repositories
├── providers/    DI only — wires data → domain (imported by presentation, never data directly)
└── presentation/ Flutter UI — pages, widgets, Riverpod state providers
```

Two provider locations:
- `<feature>/providers/<feature>_di_providers.dart` — DI: repos, datasources, usecases
- `<feature>/presentation/providers/` — UI state: notifiers, AsyncValue

**Dependency rules:** `presentation` → `domain` + `providers/` (never `data` directly). `data` → `domain` only. `domain` → nothing. Cross-feature: import other feature's `domain` and `providers/`, never `data`.

**Global structure:**
- `lib/core/` — `AppConfig`, theme (Cacao & Or palette), GoRouter, Dio/Retrofit network, secure storage, sync logic
- `lib/database/` — drift schema (Products, Categories, Sales, SaleItems, SyncQueue, SyncMetadata tables)
- `test/` — flat test files, no directory mirroring lib/

## Features status

| Feature | Status |
|---|---|
| `auth` | Implemented — phone+password registration, phone login, PIN setup/verify, token refresh, store setup |
| `catalog` | Implemented — product form/import, barcode scanning, local sync (the product list lives in the Stock tab, `inventory`) |
| `sales` | Implemented — cart, payment, receipt printing, sale history |
| `inventory` | Implemented — Stock tab (summary, product list, filters), product detail page, manual adjustments, movement history per product or for all products. **Online-only**: movements are server-authoritative (no drift table); only `Products.currentStock` is refreshed locally |
| `printing` | Implemented — Bluetooth thermal printer (ESC/POS via `print_bluetooth_thermal`) |
| `sync` | Implemented in `core/sync/` (not a feature folder) — offline event queue, catalog dirty-flag sync, connectivity awareness |
| `home` | Implemented — dashboard shell (presentation only) |
| `onboarding` | Implemented — tutorial (presentation only) |
| `settings` | Implemented — settings (presentation only) |

## Auth flow (ADR-0006 — phone-first)

Identifier is phone number (E.164), not email. Email is optional (account recovery only).

```
Unauthenticated → [phone+password login] → StoreSetupRequired (first reg)
                                          → PinSetupRequired (first device login)
                                          → PinRequired (PIN exists, not yet verified)
                                          → Authenticated
```

`StoreSetupRequired` is reached after `register()`, and again on relaunch/re-login while the store step is unfinished: `register()` persists a per-user "store setup pending" flag (`SecureTokenStorage`, survives `clearTokens`) that `proceedToPinSetup()` clears. The backend already creates a default "Ma boutique" store at registration, so this cannot be derived from the server. During registration, PIN setup can go back to the store step (`Auth.returnToStoreSetup()`).

The redirect logic is the pure function `authRedirect()` in `app_router.dart` (tested in `test/router_auth_redirect_test.dart`). PIN failures are typed (`WrongPin` / `PinLocked`, `auth/domain/entities/pin_failure.dart`), bad credentials are `InvalidCredentials`, and a session expiry yields `AuthUnauthenticated(sessionExpired: true)` (the PIN is kept).

`AuthStatus` sealed class in `auth_providers.dart`. Router reads `AsyncValue<AuthStatus>` and redirects accordingly. `Routes.emailLogin` maps to `PhoneLoginPage` (name kept for backward compat).

Phone utilities: `core/utils/phone_formatter.dart` — `toE164Ci()` (local → E.164), `formatPhoneCiDisplay()` (display), `isValidLocalPhoneCi()`.

## Key conventions

**State management (Riverpod):** `@riverpod` with `riverpod_generator`. Complex state uses sealed classes (e.g., `AuthStatus`).

**Local database (drift):** Schema in `lib/database/app_database.dart`. Run `make gen` after any table/column change. Monetary amounts stored as `TextColumn`.

**Monetary amounts (FCFA):** Domain entities use `Decimal` (package `decimal`). API DTOs use `String`. Drift uses `TextColumn`. Mappers convert at boundaries — `Decimal.parse()` inbound, `.toString()` outbound. Never use `double` or `int.parse` for money.

**Networking:** Dio with auth/refresh interceptors (`core/network/`). Retrofit generates typed clients. `httpTimeoutSeconds = 60` (absorbs Render free-tier cold start ~50s).

**Secure storage:** JWT and PBKDF2-hashed PIN in `flutter_secure_storage`. PIN never sent to backend. 5 attempts → 5-minute lockout.

**Sync:** Sales append-only via `SyncQueue` (UUID v4 client-side, idempotent). Catalog and categories (ADR-0008): `dirty=true` flag, push full state — push order is sales → categories → products (a product is held while its category is not yet accepted by the server). Pull on app start + connectivity restored; it merges a locally-created category into a server one with the same name, and stores pulled sale items.

**Theme:** "Cacao & Or" — primary brun cacao `#92400E`, secondary or `#CA8A04`. `textOnSecondary` is dark (never white on gold — fails WCAG AA). Use `AppSemanticColors` extension for dark-mode and stock-status colors.

**Code generation:** `make gen` covers `drift_dev`, `freezed`, `json_serializable`, `riverpod_generator`, `retrofit_generator`.

**Linter:** single quotes, trailing commas, `const` constructors, `prefer_final_*`, no `dynamic`/`print`, `public_member_api_docs` on all public API.

**Testing:** Flat under `test/`, named `<feature>_<concept>_test.dart`. Mock with `mocktail`.

## Cross-cutting invariants (easy to break)

- **Riverpod writes and auto-dispose:** never perform a write through an auto-dispose provider that the calling screen does not `watch` — it is disposed mid-`await` and throws after the server call succeeded (the user retries → duplicate write). Use a `keepAlive` controller, e.g. `StockAdjustment` in `inventory_providers.dart`, `StoreConfig` in `auth/providers/store_provider.dart`.
- **Account switch:** `Auth` clears the cached store config (`StoreRepository.clearLocal()` + invalidate `storeConfigProvider`) on login/register/logout; `SyncOrchestrator.syncNow()` wipes drift business data (and the product-photo/logo disk cache, `ImageFileCache`) when the token's `store_id` differs from the last active store; the seller name (`SellerProfile`) is cleared with the store config. Anything new cached per-account must follow the same path.
- **Tabs:** `ShellBranch` enum (`core/router/main_shell.dart`) must stay in the same order as the `StatefulShellRoute` branches in `app_router.dart` and the `NavigationBar` destinations. Use `goBranch(ShellBranch.x.index)`, never a literal index.
- **Low-stock rule** exists twice: `Product.stockLevel` (Dart) and the SQL in `CatalogRepositoryImpl.watchLowStockProducts()`. Change both together.
- **"Today"-scoped providers** must watch `todayProvider` (`home_providers.dart`), which rebuilds at local midnight; `watchTodayStats()` fixes the day at subscription.
- **Known inversion:** `core/sync/sync_orchestrator.dart` imports `features/auth` (sync waits for `AuthAuthenticated`). Don't add more core → feature imports.
- **Testing `SyncOrchestrator`:** `syncNow()` is a no-op unless `authProvider` is `AuthAuthenticated`, and it reads `tokenStorageProvider` + `databaseProvider` — override all three (see `test/sync_orchestrator_test.dart`). Tests use `package:clock` + `fake_async` for time.

## App initialization

`main.dart` → `AppConfig.setup()` → `initializeDateFormatting('fr_FR')` → `ProviderScope` (overrides `tokenStorageProvider` with `secureTokenStorageProvider`) → `PosMobileApp` (GoRouter + theme).

## Key files by responsibility

- `core/config.dart` — `AppConfig`, `AppFlavor`, all thresholds/constants
- `core/router/app_router.dart` — GoRouter config, `Routes` constants, auth-redirect logic
- `core/network/dio_client.dart` — Dio with auth/refresh interceptors
- `core/network/token_storage.dart` — JWT persistence interface
- `core/storage/pin_storage.dart` — PBKDF2-HMAC-SHA256 PIN hashing
- `core/sync/` — `SyncOrchestrator`, offline queue, push/pull services, sync API client, DI (`sync_providers.dart`)
- `database/database_provider.dart` — `databaseProvider` (app-wide drift singleton)
- `core/utils/phone_formatter.dart` — Ivorian phone number formatting/validation
- `features/auth/presentation/providers/auth_providers.dart` — `AuthStatus` sealed class + `Auth` notifier
- `features/sales/data/models/sale_mappers.dart` — domain `Sale` ↔ API/database (includes Decimal handling)

## Global rules

- No hardcoded secrets — everything via secure storage or build config, never committed.
- Never `git push --force` on main.
- Always plan mode before non-trivial tasks (Shift+Tab × 2).
- Before any architectural change, read ADRs in `docs/adr/` (0001–0006 in order). If your decision differs, propose a new ADR that supersedes the old one.

## See also

- Architecture details: `docs/architecture.md`; layer rules: `lib/features/README.md`
- Data model: `docs/data-model.md`; API: `docs/api.md`; error mapping: `docs/error-mapping.md`; flavors: `docs/flavors.md`
- ADRs: `docs/adr/`
- Conventions (path-scoped): `.claude/rules/mobile-conventions.md`
