import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logger/logger.dart';

import 'page_transitions.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/pin_setup_page.dart';
import '../../features/auth/presentation/pages/pin_login_page.dart';
import '../../features/auth/presentation/pages/phone_login_page.dart';
import '../../features/auth/presentation/pages/store_setup_page.dart';
import '../../features/onboarding/presentation/pages/tutorial_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/catalog/presentation/pages/catalog_page.dart';
import '../../features/catalog/presentation/pages/product_form_page.dart';
import '../../features/catalog/presentation/pages/product_import_page.dart';
import '../../features/catalog/presentation/pages/barcode_scanner_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/inventory/presentation/pages/stock_history_page.dart';
import '../../features/sales/presentation/pages/new_sale_page.dart';
import '../../features/sales/presentation/pages/payment_page.dart';
import '../../features/sales/presentation/pages/sale_success_page.dart';
import '../../features/sales/presentation/pages/sales_history_page.dart';
import '../../features/sales/presentation/pages/sale_detail_page.dart';
import '../../features/sales/domain/entities/sale.dart';
import '../../features/sales/domain/entities/cart_item.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/printing/presentation/pages/bluetooth_setup_page.dart';
import 'main_shell.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

/// Navigation routes for the app.
abstract class Routes {
  /// Splash/loading screen.
  static const String splash = '/splash';

  /// Onboarding flow (email + password registration).
  static const String register = '/register';

  /// PIN setup after first login.
  static const String pinSetup = '/pin-setup';

  /// Daily PIN login.
  static const String pinLogin = '/pin-login';

  /// Email login for account recovery / new device.
  static const String emailLogin = '/email-login';

  /// Store configuration screen.
  static const String storeSetup = '/store-setup';

  /// Onboarding tutorial.
  static const String tutorial = '/tutorial';

  // Les 4 onglets principaux (Racines des branches)

  /// Home/dashboard screen.
  static const String home = '/home';

  /// Catalog (product list).
  static const String catalog = '/catalog';

  /// Sales history (past sales with date filtering).
  static const String salesHistory = '/sales/history';

  /// Settings page.
  static const String settings = '/settings';

  // Sous-routes (Détails)

  /// Create new product.
  static const String productNew = '/catalog/new';

  /// Edit product (path parameter :id).
  static const String productEdit = '/catalog/:id/edit';

  /// Product stock movement history (path parameter :id).
  static const String productStockHistory = '/catalog/:id/movements';

  /// Bulk product import from a CSV/Excel file.
  static const String productImport = '/catalog/import';

  /// Barcode scanner modal.
  static const String barcodeScanner = '/scan';

  /// New sale (create sale from cart).
  static const String newSale = '/sales/new';

  /// Payment method selection.
  static const String payment = '/sales/payment';

  /// Sale success confirmation.
  static const String saleSuccess = '/sales/success';

  /// Sale detail view (receives [Sale] via `extra`).
  static const String saleDetail = '/sales/detail';

  /// Bluetooth printer setup.
  static const String bluetoothSetup = '/settings/printer';
}

/// Root router configuration.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final logger = Logger();
  logger.i('[Router] Creating router instance');

  late GoRouter router;

  // CORRECTIF ESSENTIEL : Force GoRouter à réévaluer le 'redirect' dès que l'état d'authentification change
  ref.listen(authProvider, (previous, next) {
    logger.i('[Router] Auth state changed, refreshing router');
    router.refresh();
  });

  router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    redirect: (BuildContext context, GoRouterState state) {
      final authValue = ref.read(authProvider);
      final publicRoutes = {Routes.register, Routes.emailLogin};
      final authRoutes = {
        Routes.splash,
        Routes.register,
        Routes.emailLogin,
        Routes.pinSetup,
        Routes.pinLogin,
        Routes.storeSetup,
      };

      final targetRoute = authValue.when(
        loading: () => null,
        error: (_, _) {
          final pinRoutes = {Routes.pinLogin, Routes.pinSetup};
          if (publicRoutes.contains(state.fullPath)) return null;
          if (pinRoutes.contains(state.fullPath)) return null;
          return Routes.emailLogin;
        },
        data: (status) {
          return switch (status) {
            AuthUnauthenticated() =>
              publicRoutes.contains(state.fullPath) ? null : Routes.emailLogin,
            AuthStoreSetupRequired() => Routes.storeSetup,
            AuthPinSetupRequired() => Routes.pinSetup,
            AuthPinRequired() => Routes.pinLogin,
            AuthAuthenticated() =>
              authRoutes.contains(state.fullPath) ? Routes.home : null,
          };
        },
      );

      final shouldRedirect =
          targetRoute != null && targetRoute != state.fullPath;
      return shouldRedirect ? targetRoute : null;
    },
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: Routes.register,
        pageBuilder: (context, state) =>
            PageTransitions.fade(context, state, const RegisterPage()),
      ),
      GoRoute(
        path: Routes.emailLogin,
        pageBuilder: (context, state) =>
            PageTransitions.fade(context, state, const PhoneLoginPage()),
      ),
      GoRoute(
        path: Routes.pinSetup,
        pageBuilder: (context, state) =>
            PageTransitions.fade(context, state, const PinSetupPage()),
      ),
      GoRoute(
        path: Routes.pinLogin,
        pageBuilder: (context, state) =>
            PageTransitions.fade(context, state, const PinLoginPage()),
      ),
      GoRoute(
        path: Routes.storeSetup,
        pageBuilder: (context, state) =>
            PageTransitions.fade(context, state, const StoreSetupPage()),
      ),
      GoRoute(
        path: Routes.tutorial,
        pageBuilder: (context, state) =>
            PageTransitions.fade(context, state, const TutorialPage()),
      ),

      // ==========================================
      // IMPLEMENTATION DU STATEFUL SHELL ROUTE
      // ==========================================
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) {
          // On enveloppe le shell dans votre MainShell (qui contient Scaffold + votre AppBottomNavBar)
          return PageTransitions.fade(
            context,
            state,
            MainShell(navigationShell: navigationShell),
          );
        },
        branches: [
          // BRANCHE 1 : ACCUEIL
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          // BRANCHE 2 : CATALOGUE
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.catalog,
                builder: (context, state) => const CatalogPage(),
                routes: [
                  // ATTENTION : 'parentNavigatorKey: _rootNavigatorKey' force la page à s'ouvrir
                  // en PLEIN ÉCRAN par-dessus votre barre de navigation.
                  GoRoute(
                    path: 'new', // Résout en /catalog/new
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ProductFormPage(),
                  ),
                  GoRoute(
                    path: ':id/edit', // Résout en /catalog/:id/edit
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return ProductFormPage(productId: id);
                    },
                  ),
                  GoRoute(
                    path: ':id/movements', // Résout en /catalog/:id/movements
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return StockHistoryPage(productId: id);
                    },
                  ),
                  GoRoute(
                    path: 'import', // Résout en /catalog/import
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ProductImportPage(),
                  ),
                ],
              ),
            ],
          ),
          // BRANCHE 3 : HISTORIQUE DES VENTES
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.salesHistory,
                builder: (context, state) => const SalesHistoryPage(),
              ),
            ],
          ),
          // BRANCHE 4 : PARAMÈTRES
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                builder: (context, state) => const SettingsPage(),
                routes: [
                  GoRoute(
                    path: 'printer', // Résout en /settings/printer
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const BluetoothSetupPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Écrans hors des onglets : plein écran, empilés par-dessus la shell.
      GoRoute(
        path: Routes.newSale,
        pageBuilder: (context, state) =>
            PageTransitions.slideRight(context, state, const NewSalePage()),
      ),
      GoRoute(
        path: Routes.payment,
        pageBuilder: (context, state) =>
            PageTransitions.scale(context, state, const PaymentPage()),
      ),
      GoRoute(
        path: Routes.saleSuccess,
        pageBuilder: (context, state) {
          ({Sale sale, List<CartItem> items})? extra;
          try {
            extra = state.extra as ({Sale sale, List<CartItem> items})?;
          } on TypeError {
            extra = null;
          }
          final child = extra == null
              ? const SalesHistoryPage()
              : SaleSuccessPage(sale: extra.sale, items: extra.items);
          return PageTransitions.fadeScale(context, state, child);
        },
      ),
      GoRoute(
        path: Routes.saleDetail,
        pageBuilder: (context, state) {
          Sale? sale;
          try {
            sale = state.extra as Sale?;
          } on TypeError {
            sale = null;
          }
          final child = sale == null
              ? const SalesHistoryPage()
              : SaleDetailPage(sale: sale);
          return PageTransitions.scale(context, state, child);
        },
      ),
      GoRoute(
        path: Routes.barcodeScanner,
        pageBuilder: (context, state) =>
            PageTransitions.scale(context, state, const BarcodeScannerPage()),
      ),
    ],
  );

  return router;
}
