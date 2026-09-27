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
import '../../features/catalog/presentation/pages/product_form_page.dart';
import '../../features/catalog/presentation/pages/product_import_page.dart';
import '../../features/catalog/presentation/pages/barcode_scanner_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/inventory/presentation/pages/product_detail_page.dart';
import '../../features/inventory/presentation/pages/stock_history_page.dart';
import '../../features/inventory/presentation/pages/stock_overview_page.dart';
import '../../features/sales/presentation/pages/new_sale_page.dart';
import '../../features/sales/presentation/pages/sales_history_page.dart';
import '../../features/sales/presentation/pages/sale_detail_page.dart';
import '../../features/sales/domain/entities/sale.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/printing/presentation/pages/bluetooth_setup_page.dart';
import 'main_shell.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

/// Routes de navigation de l'app.
abstract class Routes {
  /// Écran de démarrage / chargement.
  static const String splash = '/splash';

  /// Parcours d'inscription (inscription par téléphone + mot de passe).
  static const String register = '/register';

  /// Création du PIN après la première connexion.
  static const String pinSetup = '/pin-setup';

  /// Connexion quotidienne par PIN.
  static const String pinLogin = '/pin-login';

  /// Connexion par téléphone pour la récupération de compte / un nouvel
  /// appareil.
  static const String emailLogin = '/email-login';

  /// Écran de configuration de la boutique.
  static const String storeSetup = '/store-setup';

  /// Tutoriel d'onboarding.
  static const String tutorial = '/tutorial';

  // Les 5 onglets principaux (Racines des branches)

  /// Écran d'accueil / tableau de bord.
  static const String home = '/home';

  /// Vue d'ensemble du stock (produits à réapprovisionner, ajustement rapide).
  static const String inventory = '/stock';

  /// Historique des ventes (ventes passées avec filtre par date).
  static const String salesHistory = '/sales/history';

  /// Page des paramètres.
  static const String settings = '/settings';

  // Sous-routes (Détails)

  /// Création d'un produit.
  static const String productNew = '/catalog/new';

  /// Fiche produit (paramètre de chemin :id).
  static const String productDetail = '/catalog/:id';

  /// Mouvements de stock de tous les produits.
  static const String stockMovements = '/stock/movements';

  /// Modification d'un produit (paramètre de chemin :id).
  static const String productEdit = '/catalog/:id/edit';

  /// Historique des mouvements de stock d'un produit (paramètre de chemin :id).
  static const String productStockHistory = '/catalog/:id/movements';

  /// Import de produits en masse depuis un fichier CSV/Excel.
  static const String productImport = '/catalog/import';

  /// Modale de scan de code-barres.
  static const String barcodeScanner = '/scan';

  /// Onglet Vendre : caisse (scan, panier, paiement et encaissement sur un
  /// seul écran).
  static const String newSale = '/sales/new';

  /// Détail d'une vente (reçoit la [Sale] via `extra`).
  static const String saleDetail = '/sales/detail';

  /// Configuration de l'imprimante Bluetooth.
  static const String bluetoothSetup = '/settings/printer';
}

/// Configuration racine du routeur.
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
        // Ordre des branches = ordre de l'enum ShellBranch (main_shell.dart).
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
          // BRANCHE 2 : VENDRE (caisse). La page reste montée quand on change
          // d'onglet : le panier est conservé, la caméra se coupe d'elle-même.
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.newSale,
                builder: (context, state) => const NewSalePage(),
              ),
            ],
          ),
          // BRANCHE 3 : STOCK
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.inventory,
                builder: (context, state) => const StockOverviewPage(),
              ),
            ],
          ),
          // BRANCHE 4 : HISTORIQUE DES VENTES
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.salesHistory,
                builder: (context, state) => const SalesHistoryPage(),
              ),
            ],
          ),
          // BRANCHE 5 : PARAMÈTRES
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.settings,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),

      // Écrans hors des onglets : plein écran, empilés par-dessus la shell.
      //
      // Ne JAMAIS déclarer une page plein écran comme sous-route d'une branche
      // (même avec parentNavigatorKey racine) : un `push` depuis une page déjà
      // au-dessus de la shell (caisse, détail de vente) reconstruit la shell
      // et fait planter le Navigator (clés de page dupliquées). Les chemins
      // restent ceux d'origine (/catalog/new…), seule la déclaration change.
      GoRoute(
        path: Routes.productNew,
        // extra : code-barres scanné en caisse, pré-rempli dans le formulaire.
        builder: (context, state) => ProductFormPage(
          initialBarcode: state.extra is String ? state.extra! as String : null,
        ),
      ),
      GoRoute(
        path: Routes.productImport,
        builder: (context, state) => const ProductImportPage(),
      ),
      GoRoute(
        path: Routes.productEdit,
        builder: (context, state) =>
            ProductFormPage(productId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.productStockHistory,
        builder: (context, state) =>
            StockHistoryPage(productId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.bluetoothSetup,
        builder: (context, state) => const BluetoothSetupPage(),
      ),
      // Déclarée après /catalog/new et /catalog/import : sinon « new » et
      // « import » seraient pris pour un :id.
      GoRoute(
        path: Routes.productDetail,
        builder: (context, state) =>
            ProductDetailPage(productId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.stockMovements,
        builder: (context, state) => const StockHistoryPage(),
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
