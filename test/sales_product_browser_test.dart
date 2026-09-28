import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/widgets/index.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/sales/presentation/widgets/product_browser.dart';

Product product(
  String name, {
  int? stock,
  int? minStock,
  String price = '2000',
  String? categoryId,
}) => Product(
  id: name,
  name: name,
  sellingPrice: Decimal.parse(price),
  purchasePrice: Decimal.parse('1234'),
  currentStock: stock,
  minStock: minStock,
  categoryId: categoryId,
  updatedAt: DateTime(2026),
);

final catalog = [
  product('Coca-Cola 33cl', stock: 24, categoryId: 'boissons'),
  product('Fanta', stock: 0, price: '1500', categoryId: 'boissons'),
  product('Pain', price: '250'),
  product('Savon', stock: 3, minStock: 5, price: '300'),
];

/// Appels reçus par le catalogue.
class Calls {
  final taps = <String>[];
  final quickAdds = <String>[];
  int retries = 0;
  int addProduct = 0;
}

Future<Calls> pump(
  WidgetTester tester,
  AsyncValue<List<Product>> products, {
  ThemeData? theme,
  Size size = const Size(360, 640),
  String? categoryId,
  Map<String, int> cartQuantities = const {},
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final calls = Calls();
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        theme: theme ?? AppTheme.light(),
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              ProductBrowser(
                products: products,
                categoryId: categoryId,
                cartQuantities: cartQuantities,
                onProductTap: (p) => calls.taps.add(p.id),
                onQuickAdd: (p) => calls.quickAdds.add(p.id),
                onRetry: () => calls.retries++,
                onAddProduct: () => calls.addProduct++,
              ),
            ],
          ),
        ),
      ),
    ),
  );
  // Pas de pumpAndSettle : les squelettes pulsent en continu.
  await tester.pump();
  return calls;
}

/// Colonnes de la grille ; 1 quand le catalogue est affiché en liste.
int columnCount(WidgetTester tester) {
  final grids = find.byType(SliverGrid);
  if (grids.evaluate().isEmpty) return 1;
  final grid = tester.widget<SliverGrid>(grids);
  return (grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount)
      .crossAxisCount;
}

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  for (final (name, theme) in [
    ('clair', AppTheme.light()),
    ('sombre', AppTheme.dark()),
  ]) {
    testWidgets('affiche nom, prix de vente et stock, thème $name', (
      tester,
    ) async {
      await pump(tester, AsyncData(catalog), theme: theme);
      expect(tester.takeException(), isNull);
      expect(find.text('Coca-Cola 33cl'), findsOneWidget);
      expect(find.text(formatFcfa(Decimal.parse('2000'))), findsOneWidget);
      expect(find.text('Produits'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('Stock : 24'), findsOneWidget);
      expect(find.text('Faible : 3'), findsOneWidget);
      expect(find.text('Rupture'), findsOneWidget);
      // Le prix d'achat n'apparaît jamais en caisse.
      expect(find.textContaining('1 234'), findsNothing);
    });
  }

  testWidgets('le bouton + ajoute, la carte ouvre la quantité', (tester) async {
    final calls = await pump(tester, AsyncData(catalog));
    await tester.tap(find.byTooltip('Ajouter Coca-Cola 33cl'));
    await tester.tap(find.text('Pain'));
    expect(calls.quickAdds, ['Coca-Cola 33cl']);
    expect(calls.taps, ['Pain']);
  });

  testWidgets('produit en rupture : visible mais non ajoutable', (
    tester,
  ) async {
    final calls = await pump(tester, AsyncData(catalog));
    await tester.tap(find.byTooltip('Ajouter Fanta'));
    await tester.tap(find.text('Fanta'));
    expect(calls.quickAdds, isEmpty);
    expect(calls.taps, isEmpty);
  });

  testWidgets('catalogue vide : invite à créer un produit', (tester) async {
    final calls = await pump(tester, const AsyncData(<Product>[]));
    expect(find.text('Aucun produit disponible'), findsOneWidget);
    await tester.tap(find.text('Ajouter un produit'));
    expect(calls.addProduct, 1);
  });

  testWidgets('chargement : squelettes, pas de gros indicateur', (
    tester,
  ) async {
    await pump(tester, const AsyncLoading<List<Product>>());
    expect(find.byType(SkeletonBox), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('erreur sans données : message et Réessayer', (tester) async {
    final calls = await pump(
      tester,
      AsyncError<List<Product>>(Exception('drift'), StackTrace.empty),
    );
    expect(find.text('Impossible de charger les produits'), findsOneWidget);
    await tester.tap(find.text('Réessayer'));
    expect(calls.retries, 1);
  });

  testWidgets('erreur avec données déjà chargées : les produits restent', (
    tester,
  ) async {
    final controller = StreamController<List<Product>>();
    addTearDown(controller.close);
    final products = StreamProvider<List<Product>>((ref) => controller.stream);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) => CustomScrollView(
                slivers: [
                  ProductBrowser(
                    products: ref.watch(products),
                    onProductTap: (_) {},
                    onQuickAdd: (_) {},
                    onRetry: () {},
                    onAddProduct: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    controller.add(catalog);
    await tester.pump();
    controller.addError(Exception('drift'));
    await tester.pump();

    expect(find.text('Coca-Cola 33cl'), findsOneWidget);
    expect(find.text('Impossible de charger les produits'), findsNothing);
  });

  testWidgets('catégorie : seuls ses produits, compteur ajusté', (
    tester,
  ) async {
    await pump(tester, AsyncData(catalog), categoryId: 'boissons');
    expect(find.text('Coca-Cola 33cl'), findsOneWidget);
    expect(find.text('Fanta'), findsOneWidget);
    expect(find.text('Pain'), findsNothing);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('quantité déjà au panier affichée sur la carte', (tester) async {
    await pump(
      tester,
      AsyncData(catalog),
      cartQuantities: const {'Coca-Cola 33cl': 2},
    );
    expect(find.text('2 au panier'), findsOneWidget);
  });

  testWidgets('liste sur téléphone, grille sur tablette', (tester) async {
    await pump(tester, AsyncData(catalog));
    expect(columnCount(tester), 1);

    await pump(tester, AsyncData(catalog), size: const Size(600, 900));
    expect(columnCount(tester), 1);

    await pump(tester, AsyncData(catalog), size: const Size(1024, 768));
    expect(columnCount(tester), 3);
    expect(tester.takeException(), isNull);
  });

  testWidgets('grande police : pas de débordement', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pump(tester, AsyncData(catalog));
    expect(tester.takeException(), isNull);
    await pump(tester, AsyncData(catalog), size: const Size(1024, 768));
    expect(tester.takeException(), isNull);
  });
}
