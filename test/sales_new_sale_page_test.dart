import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/providers/connectivity_provider.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/core/sync/sync_providers.dart';
import 'package:mobile/core/widgets/index.dart';
import 'package:mobile/features/auth/domain/entities/store.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/auth/providers/store_provider.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_session.dart';
import 'package:mobile/features/cash_register/domain/repositories/cash_register_repository.dart';
import 'package:mobile/features/cash_register/providers/cash_register_di_providers.dart';
import 'package:mobile/features/catalog/domain/entities/category.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/catalog/domain/entities/product_page.dart';
import 'package:mobile/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:mobile/features/catalog/providers/catalog_di_providers.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart';
import 'package:mobile/features/sales/presentation/pages/new_sale_page.dart';
import 'package:mobile/features/sales/presentation/pages/sale_checkout_page.dart';
import 'package:mobile/features/sales/presentation/pages/sale_scanner_page.dart';
import 'package:mobile/features/sales/presentation/providers/cart_provider.dart';
import 'package:mobile/features/sales/presentation/providers/checkout_provider.dart';
import 'package:mobile/features/sales/presentation/widgets/product_browser.dart';
import 'package:mobile/features/sales/presentation/widgets/product_search_results.dart';

/// Évite que l'orchestrateur de synchro (pastille réseau) initialise la vraie
/// authentification.
class _NoAuth extends Auth {
  @override
  Future<AuthStatus> build() async => const AuthUnauthenticated();
}

class _Store extends StoreConfig {
  @override
  Future<Store?> build() async =>
      const Store(name: 'Ma boutique', isSubjectToVat: false);
}

class _MockCatalog extends Mock implements CatalogRepository {}

class _MockCashRegister extends Mock implements CashRegisterRepository {}

Decimal d(String value) => Decimal.parse(value);

Product product(
  String name, {
  int? stock,
  String price = '2000',
  String? categoryId,
}) => Product(
  id: name,
  name: name,
  sellingPrice: d(price),
  currentStock: stock,
  categoryId: categoryId,
  updatedAt: DateTime(2026),
);

final catalog = [
  product('Coca-Cola 33cl', stock: 24, categoryId: 'boissons'),
  product('Eau 1,5L', stock: 1, price: '500', categoryId: 'boissons'),
  product('Fanta', stock: 0, price: '1500'),
];

final openSession = CashSession(
  id: 's1',
  deviceId: 'device-1',
  status: CashSessionStatus.open,
  openingAmount: d('10000'),
  openedAt: DateTime.utc(2026, 11, 10, 8),
  syncStatus: CashSyncStatus.synced,
  serverRecalculated: false,
);

/// Monte l'écran Vendre dans un routeur minimal (Vendre, Encaisser, Scanner).
///
/// [registerOpen] : session ouverte observée par l'écran Vendre.
/// [sessionAtSubmit] : session lue à la validation (null = caisse fermée).
Future<ProviderContainer> pumpPage(
  WidgetTester tester, {
  bool registerOpen = true,
  bool sessionAtSubmit = false,
}) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  // Caméra refusée : le scanner affiche l'invite, sans monter MobileScanner.
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  const permissions = MethodChannel('flutter.baseflow.com/permissions/methods');
  messenger.setMockMethodCallHandler(
    permissions,
    (call) async => switch (call.method) {
      'requestPermissions' => {for (final p in call.arguments as List) p: 0},
      _ => 0,
    },
  );
  addTearDown(() => messenger.setMockMethodCallHandler(permissions, null));

  final repo = _MockCatalog();
  when(repo.watchProducts).thenAnswer((_) => Stream.value(catalog));
  when(repo.watchCategories).thenAnswer(
    (_) => Stream.value(const [Category(id: 'boissons', name: 'Boissons')]),
  );
  when(
    () => repo.getProducts(
      query: any(named: 'query'),
      limit: any(named: 'limit'),
    ),
  ).thenAnswer((inv) async {
    final q = (inv.namedArguments[#query] as String).toLowerCase();
    return ProductPage(
      items: catalog.where((p) => p.name.toLowerCase().contains(q)).toList(),
      nextCursor: null,
      hasMore: false,
    );
  });

  final cash = _MockCashRegister();
  when(
    cash.watchActiveSession,
  ).thenAnswer((_) => Stream.value(registerOpen ? openSession : null));
  when(
    cash.getActiveSession,
  ).thenAnswer((_) async => sessionAtSubmit ? openSession : null);

  final router = GoRouter(
    initialLocation: Routes.newSale,
    routes: [
      GoRoute(path: Routes.newSale, builder: (_, _) => const NewSalePage()),
      GoRoute(
        path: Routes.saleCheckout,
        builder: (_, _) => const SaleCheckoutPage(),
      ),
      GoRoute(
        path: Routes.saleScanner,
        builder: (_, _) => const SaleScannerPage(),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(_NoAuth.new),
        cashRegisterRepositoryProvider.overrideWithValue(cash),
        storeConfigProvider.overrideWith(_Store.new),
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
        pendingSyncCountProvider.overrideWith((ref) => Stream.value(0)),
        catalogRepositoryProvider.overrideWithValue(repo),
      ],
      child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return ProviderScope.containerOf(tester.element(find.byType(NewSalePage)));
}

/// Laisse expirer le toast (minuteur de la page).
Future<void> settleToast(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 5));
  await tester.pumpAndSettle();
}

PrimaryButton primaryButton(WidgetTester tester, String label) =>
    tester.widget<PrimaryButton>(find.widgetWithText(PrimaryButton, label));

/// Ajoute [times] fois Coca-Cola puis ouvre l'écran Encaisser.
Future<void> openCheckoutWithCoca(WidgetTester tester, {int times = 2}) async {
  for (var i = 0; i < times; i++) {
    await tester.tap(find.text('Coca-Cola 33cl'));
    await tester.pump();
  }
  await tester.tap(find.textContaining('Encaisser · '));
  await tester.pumpAndSettle();
  expect(find.byType(SaleCheckoutPage), findsOneWidget);
}

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  group('Vendre', () {
    testWidgets('titre, catalogue et amorce du panier vide', (tester) async {
      await pumpPage(tester);
      expect(tester.takeException(), isNull);
      expect(find.text('Vendre'), findsOneWidget);
      expect(find.byType(ProductBrowser), findsOneWidget);
      expect(find.text('Coca-Cola 33cl'), findsOneWidget);
      expect(
        find.text('Touchez un produit ou scannez-le pour commencer.'),
        findsOneWidget,
      );
      expect(find.textContaining('Caisse fermée'), findsNothing);
    });

    testWidgets('les onglets de catégories filtrent le catalogue', (
      tester,
    ) async {
      await pumpPage(tester);
      expect(find.text('Fanta'), findsOneWidget);

      await tester.tap(find.text('Boissons'));
      await tester.pumpAndSettle();
      expect(find.text('Fanta'), findsNothing);
      expect(find.text('Coca-Cola 33cl'), findsOneWidget);

      await tester.tap(find.text('Tous'));
      await tester.pumpAndSettle();
      expect(find.text('Fanta'), findsOneWidget);
    });

    testWidgets('toucher la ligne ajoute ; le stepper ajuste et retire', (
      tester,
    ) async {
      final container = await pumpPage(tester);
      final cart = container.read(cartProvider.notifier);

      await tester.tap(find.text('Coca-Cola 33cl'));
      await tester.pump();
      expect(cart.quantityOf('Coca-Cola 33cl'), 1);
      expect(find.text('1 article'), findsOneWidget);
      expect(find.text('Encaisser · ${formatFcfa(d('2000'))}'), findsOneWidget);

      await tester.tap(find.byTooltip('Augmenter'));
      await tester.pump();
      expect(cart.quantityOf('Coca-Cola 33cl'), 2);
      await tester.tap(find.byTooltip('Diminuer'));
      await tester.pump();
      expect(cart.quantityOf('Coca-Cola 33cl'), 1);

      // À 1, « − » devient la corbeille : retrait annulable.
      await tester.tap(find.byTooltip('Retirer Coca-Cola 33cl'));
      await tester.pump();
      expect(container.read(cartProvider).isEmpty, isTrue);
      expect(find.text('Coca-Cola 33cl retiré du panier'), findsOneWidget);
      await tester.tap(find.text('Annuler'));
      await tester.pump();
      expect(cart.quantityOf('Coca-Cola 33cl'), 1);
      await settleToast(tester);
      expect(tester.takeException(), isNull);
    });

    testWidgets('pas d’ajout au-delà du stock', (tester) async {
      final container = await pumpPage(tester);
      await tester.tap(find.text('Eau 1,5L'));
      await tester.pump();
      await tester.tap(find.text('Eau 1,5L'));
      await tester.pump();

      expect(container.read(cartProvider.notifier).quantityOf('Eau 1,5L'), 1);
      expect(find.text('Stock insuffisant · disponible : 1'), findsOneWidget);
      await settleToast(tester);
    });

    testWidgets('produit en rupture : visible, non ajoutable', (tester) async {
      final container = await pumpPage(tester);
      expect(find.textContaining('Rupture'), findsOneWidget);
      await tester.tap(find.text('Fanta'));
      await tester.tap(find.byTooltip('Ajouter Fanta'));
      await tester.pump();
      expect(container.read(cartProvider).isEmpty, isTrue);
    });

    testWidgets('appui long : choix de quantité', (tester) async {
      final container = await pumpPage(tester);
      await tester.longPress(find.text('Coca-Cola 33cl'));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
      await tester.tap(find.text('Ajouter au panier'));
      await tester.pumpAndSettle();
      expect(
        container.read(cartProvider.notifier).quantityOf('Coca-Cola 33cl'),
        1,
      );
    });

    testWidgets('la recherche remplace le catalogue, puis le rend', (
      tester,
    ) async {
      final container = await pumpPage(tester);
      await tester.enterText(find.byType(TextField), 'eau');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.byType(ProductSearchResults), findsOneWidget);
      expect(find.byType(ProductBrowser), findsNothing);
      expect(find.text('Coca-Cola 33cl'), findsNothing);

      // Ajout depuis la recherche : la recherche se vide, le catalogue revient.
      await tester.tap(find.byTooltip('Ajouter Eau 1,5L'));
      await tester.pumpAndSettle();
      expect(find.byType(ProductSearchResults), findsNothing);
      expect(find.byType(ProductBrowser), findsOneWidget);
      expect(container.read(cartProvider.notifier).quantityOf('Eau 1,5L'), 1);
    });

    testWidgets('caméra refusée : retour à la saisie du code', (tester) async {
      await pumpPage(tester);
      await tester.enterText(find.byType(TextField), 'xyz');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      expect(find.text('Aucun produit trouvé'), findsOneWidget);

      await tester.tap(find.text('Scanner un code-barres'));
      await tester.pumpAndSettle();
      expect(find.byType(SaleScannerPage), findsOneWidget);
      expect(find.text('La caméra est bloquée'), findsOneWidget);

      await tester.tap(find.text('Saisir le code à la main'));
      await tester.pumpAndSettle();
      expect(find.byType(SaleScannerPage), findsNothing);
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.focusNode!.hasFocus, isTrue);
    });

    testWidgets(
      'caisse fermée : annoncée, « Ouvrir la caisse », panier gardé',
      (tester) async {
        final container = await pumpPage(tester, registerOpen: false);
        expect(
          find.textContaining('Ouvrez-la pour pouvoir encaisser'),
          findsOneWidget,
        );
        await tester.tap(find.text('Coca-Cola 33cl'));
        await tester.pump();

        await tester.tap(
          find.widgetWithText(PrimaryButton, 'Ouvrir la caisse'),
        );
        await tester.pumpAndSettle();
        expect(find.text('Fond de caisse'), findsOneWidget);
        expect(container.read(cartProvider).unitCount, 1);
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('Encaisser', () {
    testWidgets('lignes, total, monnaie à rendre ou ce qui manque', (
      tester,
    ) async {
      final container = await pumpPage(tester);
      await openCheckoutWithCoca(tester);

      expect(find.text('ARTICLES · 2'), findsOneWidget);
      expect(find.text('2 × ${formatFcfa(d('2000'))}'), findsOneWidget);
      expect(find.text('À rendre au client'), findsOneWidget);

      container.read(checkoutProvider.notifier).setCashReceived(d('500'));
      await tester.pumpAndSettle();
      expect(find.text('Il manque'), findsOneWidget);
      expect(find.text(formatFcfa(d('3500'))), findsOneWidget);
      expect(primaryButton(tester, 'Valider la vente').onPressed, isNull);

      container.read(checkoutProvider.notifier).setCashReceived(d('5000'));
      await tester.pumpAndSettle();
      expect(find.text('À rendre au client'), findsOneWidget);
      expect(find.text(formatFcfa(d('1000'))), findsOneWidget);
      expect(primaryButton(tester, 'Valider la vente').onPressed, isNotNull);
      expect(tester.takeException(), isNull);
    });

    testWidgets('mobile money : l’opérateur est choisi avant de valider', (
      tester,
    ) async {
      final container = await pumpPage(tester);
      await openCheckoutWithCoca(tester);

      await tester.tap(find.text('Mobile money'));
      await tester.pumpAndSettle();
      expect(find.text('Choisissez l’opérateur mobile money'), findsOneWidget);
      expect(primaryButton(tester, 'Valider la vente').onPressed, isNull);

      await tester.tap(find.text('Wave'));
      await tester.pumpAndSettle();
      expect(container.read(checkoutProvider).method, PaymentMethod.wave);
      expect(find.text('À recevoir · Wave'), findsOneWidget);
      expect(primaryButton(tester, 'Valider la vente').onPressed, isNotNull);
    });

    testWidgets('mixte : le reste en mobile money se calcule seul', (
      tester,
    ) async {
      final container = await pumpPage(tester);
      await openCheckoutWithCoca(tester);

      await tester.tap(find.text('Mixte'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '1000');
      await tester.pumpAndSettle();

      expect(container.read(checkoutProvider).mobileMoney, d('3000'));
      expect(find.text('Complet'), findsOneWidget);
      expect(primaryButton(tester, 'Valider la vente').onPressed, isNotNull);
    });

    testWidgets('ligne modifiée en place ; retrait annulable', (tester) async {
      final container = await pumpPage(tester);
      await openCheckoutWithCoca(tester);

      await tester.tap(find.text('Coca-Cola 33cl'));
      await tester.pumpAndSettle();
      expect(find.text('Remise sur la ligne'), findsOneWidget);
      await tester.tap(find.byTooltip('Augmenter'));
      await tester.pump();
      expect(
        container.read(cartProvider.notifier).quantityOf('Coca-Cola 33cl'),
        3,
      );

      await tester.tap(find.text('Retirer'));
      await tester.pumpAndSettle();
      expect(container.read(cartProvider).isEmpty, isTrue);
      expect(find.text('Panier vide'), findsOneWidget);
      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();
      expect(container.read(cartProvider).unitCount, 3);
    });

    testWidgets('caisse fermée à la validation : ouverture, panier gardé', (
      tester,
    ) async {
      final container = await pumpPage(tester);
      await openCheckoutWithCoca(tester);

      await tester.tap(find.widgetWithText(PrimaryButton, 'Valider la vente'));
      await tester.pumpAndSettle();
      expect(find.text('Fond de caisse'), findsOneWidget);
      expect(container.read(cartProvider).unitCount, 2);
      // Sous l'écran d'ouverture, l'encaissement reste en place.
      expect(
        find.byType(SaleCheckoutPage, skipOffstage: false),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('Vider : confirmation, puis retour à Vendre', (tester) async {
      final container = await pumpPage(tester);
      await openCheckoutWithCoca(tester);

      await tester.tap(find.text('Vider'));
      await tester.pumpAndSettle();
      expect(
        find.text('Les 2 articles seront retirés. Le stock n’est pas modifié.'),
        findsOneWidget,
      );
      await tester.tap(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.text('Vider le panier'),
        ),
      );
      await tester.pumpAndSettle();
      expect(container.read(cartProvider).isEmpty, isTrue);
      expect(find.byType(SaleCheckoutPage), findsNothing);
    });
  });
}
