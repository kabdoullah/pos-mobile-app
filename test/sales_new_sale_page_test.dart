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
import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/catalog/domain/entities/product_page.dart';
import 'package:mobile/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:mobile/features/catalog/providers/catalog_di_providers.dart';
import 'package:mobile/features/sales/presentation/pages/new_sale_page.dart';
import 'package:mobile/features/sales/presentation/providers/cart_provider.dart';
import 'package:mobile/features/sales/presentation/widgets/product_browser.dart';
import 'package:mobile/features/sales/presentation/widgets/product_search_results.dart';
import 'package:mobile/features/sales/presentation/widgets/sale_cart.dart';

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

Product product(String name, {int? stock, String price = '2000'}) => Product(
  id: name,
  name: name,
  sellingPrice: Decimal.parse(price),
  currentStock: stock,
  updatedAt: DateTime(2026),
);

final catalog = [
  product('Coca-Cola 33cl', stock: 24),
  product('Eau 1,5L', stock: 1, price: '500'),
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

  testWidgets('panier vide : le catalogue est affiché', (tester) async {
    await pumpPage(tester);
    expect(tester.takeException(), isNull);
    expect(find.byType(ProductBrowser), findsOneWidget);
    expect(find.text('Coca-Cola 33cl'), findsOneWidget);
    expect(find.text('Votre panier est vide'), findsNothing);
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
    expect(find.text('Panier · 1'), findsOneWidget);
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
    expect(find.text('Rupture de stock'), findsOneWidget);
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

  testWidgets('le panier reste accessible et modifiable', (tester) async {
    final container = await pumpPage(tester);
    await tester.tap(find.byTooltip('Ajouter Coca-Cola 33cl'));
    await tester.pump();
    await tester.tap(find.byTooltip('Ajouter Coca-Cola 33cl'));
    await settleToast(tester);

    await tester.tap(find.text('Panier · 2'));
    await tester.pumpAndSettle();
    expect(find.byType(SaleCart), findsOneWidget);
    expect(find.byType(ProductBrowser), findsNothing);

    // Panier vidé : retour automatique au catalogue.
    container.read(cartProvider.notifier).clear();
    await tester.pumpAndSettle();
    expect(find.byType(ProductBrowser), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
