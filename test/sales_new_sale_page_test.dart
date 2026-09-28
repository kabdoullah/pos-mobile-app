import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/providers/connectivity_provider.dart';
import 'package:mobile/core/sync/sync_providers.dart';
import 'package:mobile/features/auth/domain/entities/store.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/auth/providers/store_provider.dart';
import 'package:mobile/features/catalog/domain/entities/category.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/catalog/domain/entities/product_page.dart';
import 'package:mobile/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:mobile/features/catalog/providers/catalog_di_providers.dart';
import 'package:mobile/features/sales/presentation/pages/new_sale_page.dart';
import 'package:mobile/features/sales/presentation/providers/cart_provider.dart';
import 'package:mobile/features/sales/presentation/providers/checkout_provider.dart';
import 'package:mobile/features/sales/presentation/widgets/product_browser.dart';
import 'package:mobile/features/sales/presentation/widgets/product_search_results.dart';
import 'package:mobile/features/sales/presentation/widgets/sale_cart.dart';
import 'package:mobile/features/sales/presentation/widgets/sale_checkout_panel.dart';
import 'package:mobile/features/sales/presentation/widgets/sale_scanner_panel.dart';

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

Product product(
  String name, {
  int? stock,
  String price = '2000',
  String? categoryId,
}) => Product(
  id: name,
  name: name,
  sellingPrice: Decimal.parse(price),
  currentStock: stock,
  categoryId: categoryId,
  updatedAt: DateTime(2026),
);

final catalog = [
  product('Coca-Cola 33cl', stock: 24, categoryId: 'boissons'),
  product('Eau 1,5L', stock: 1, price: '500', categoryId: 'boissons'),
  product('Fanta', stock: 0, price: '1500'),
];

Future<ProviderContainer> pumpPage(WidgetTester tester) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  // Caméra refusée : le bandeau affiche l'invite, sans monter MobileScanner.
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

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(_NoAuth.new),
        storeConfigProvider.overrideWith(_Store.new),
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
        pendingSyncCountProvider.overrideWith((ref) => Stream.value(0)),
        catalogRepositoryProvider.overrideWithValue(repo),
      ],
      child: MaterialApp(theme: AppTheme.light(), home: const NewSalePage()),
    ),
  );
  await tester.pumpAndSettle();
  return ProviderScope.containerOf(tester.element(find.byType(NewSalePage)));
}

/// Laisse expirer le toast de confirmation (minuteur de la page).
Future<void> settleToast(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 3));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  testWidgets('panier vide : catalogue puis panier vide, scanner replié', (
    tester,
  ) async {
    await pumpPage(tester);
    expect(tester.takeException(), isNull);
    expect(find.byType(ProductBrowser), findsOneWidget);
    expect(find.text('Coca-Cola 33cl'), findsOneWidget);
    expect(find.text('Ma boutique'), findsOneWidget);
    // Le panier est sous le catalogue, dans le même défilement.
    expect(find.text('Votre panier est vide'), findsOneWidget);
    // Scanner replié par défaut : il s'ouvre à la demande.
    expect(find.byType(SaleScannerPanel), findsNothing);
    await tester.tap(find.byTooltip('Scanner un code-barres'));
    await tester.pumpAndSettle();
    expect(find.byType(SaleScannerPanel), findsOneWidget);
  });

  testWidgets('les catégories filtrent le catalogue', (tester) async {
    await pumpPage(tester);
    expect(find.text('Fanta'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Boissons'));
    await tester.pumpAndSettle();
    expect(find.text('Fanta'), findsNothing);
    expect(find.text('Coca-Cola 33cl'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Tous'));
    await tester.pumpAndSettle();
    expect(find.text('Fanta'), findsOneWidget);
  });

  testWidgets('le bouton + ajoute une unité au panier partagé', (tester) async {
    final container = await pumpPage(tester);
    await tester.tap(find.byTooltip('Ajouter Coca-Cola 33cl'));
    await tester.pump();

    expect(
      container.read(cartProvider.notifier).quantityOf('Coca-Cola 33cl'),
      1,
    );
    expect(find.text('Coca-Cola 33cl ajouté'), findsOneWidget);
    // On reste sur le catalogue pour enchaîner les ajouts.
    expect(find.byType(ProductBrowser), findsOneWidget);
    expect(find.text('1 au panier'), findsOneWidget);
    expect(find.text('1 article'), findsOneWidget);
    await settleToast(tester);
  });

  testWidgets('la carte ouvre le choix de quantité existant', (tester) async {
    final container = await pumpPage(tester);
    await tester.tap(find.text('Coca-Cola 33cl'));
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsOneWidget);
    await tester.tap(find.textContaining('Ajouter · '));
    await tester.pumpAndSettle();
    expect(
      container.read(cartProvider.notifier).quantityOf('Coca-Cola 33cl'),
      1,
    );
    await settleToast(tester);
  });

  testWidgets('pas d’ajout au-delà du stock', (tester) async {
    final container = await pumpPage(tester);
    await tester.tap(find.byTooltip('Ajouter Eau 1,5L'));
    await tester.pump();
    await tester.tap(find.byTooltip('Ajouter Eau 1,5L'));
    await tester.pump();

    expect(container.read(cartProvider.notifier).quantityOf('Eau 1,5L'), 1);
    expect(
      find.text('Stock insuffisant · Stock disponible : 1'),
      findsOneWidget,
    );

    // La carte non plus n'ouvre pas la quantité quand tout est au panier.
    await settleToast(tester);
    await tester.tap(find.text('Eau 1,5L'));
    await tester.pump();
    expect(find.byType(BottomSheet), findsNothing);
    await settleToast(tester);
  });

  testWidgets('produit en rupture : visible, non ajoutable', (tester) async {
    final container = await pumpPage(tester);
    expect(find.text('Rupture'), findsOneWidget);
    await tester.tap(find.byTooltip('Ajouter Fanta'));
    await tester.pump();
    expect(container.read(cartProvider).isEmpty, isTrue);
  });

  testWidgets('la recherche remplace le catalogue, puis le rend', (
    tester,
  ) async {
    await pumpPage(tester);
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
    await settleToast(tester);
  });

  testWidgets('recherche sans résultat : propose le scanner', (tester) async {
    await pumpPage(tester);
    await tester.enterText(find.byType(TextField), 'xyz');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(find.text('Aucun produit trouvé'), findsOneWidget);

    await tester.tap(find.text('Scanner un code-barres'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductSearchResults), findsNothing);
    expect(find.byType(SaleScannerPanel), findsOneWidget);
  });

  testWidgets('espèces insuffisantes : la raison est rappelée en bas', (
    tester,
  ) async {
    final container = await pumpPage(tester);
    await tester.tap(find.byTooltip('Ajouter Coca-Cola 33cl'));
    await settleToast(tester);
    container
        .read(checkoutProvider.notifier)
        .setCashReceived(Decimal.parse('500'));
    await tester.pumpAndSettle();
    // Le champ espèces est plus bas dans le défilement : le panneau fixe
    // rappelle pourquoi l'encaissement est bloqué.
    expect(
      find.descendant(
        of: find.byType(SaleCheckoutPanel),
        matching: find.text('Montant insuffisant'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('le panier reste accessible et modifiable', (tester) async {
    final container = await pumpPage(tester);
    await tester.tap(find.byTooltip('Ajouter Coca-Cola 33cl'));
    await tester.pump();
    await tester.tap(find.byTooltip('Ajouter Coca-Cola 33cl'));
    await settleToast(tester);

    expect(find.text('2 au panier'), findsOneWidget);

    // Le compteur du panneau fixe fait défiler jusqu'au panier.
    await tester.tap(find.text('2 articles'));
    await tester.pumpAndSettle();
    expect(find.byType(SaleCart), findsOneWidget);
    final header = tester.getRect(find.text('Panier en cours'));
    expect(header.top, greaterThanOrEqualTo(0));
    expect(header.bottom, lessThan(800));

    container.read(cartProvider.notifier).updateQuantity('Coca-Cola 33cl', 3);
    await tester.pumpAndSettle();
    expect(find.text('3 articles'), findsOneWidget);

    // La croix retire la ligne, sans confirmation (comme le glissement).
    await tester.tap(find.byTooltip('Retirer Coca-Cola 33cl'));
    await tester.pumpAndSettle();
    expect(container.read(cartProvider).isEmpty, isTrue);
    expect(find.text('Votre panier est vide'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
