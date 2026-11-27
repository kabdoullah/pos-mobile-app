import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/widgets/index.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/sales/presentation/providers/sale_catalog_layout_provider.dart';
import 'package:mobile/features/sales/presentation/widgets/product_browser.dart';
import 'package:mobile/features/sales/presentation/widgets/sale_product_grid.dart';

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
  final adds = <String>[];
  final edits = <String>[];
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
  SaleCatalogLayout layout = SaleCatalogLayout.list,
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
                layout: layout,
                onAdd: (p) => calls.adds.add(p.id),
                onDecrease: (_) {},
                onEditQuantity: (p) => calls.edits.add(p.id),
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
    testWidgets('nom, prix ; stock seulement bas ou épuisé, thème $name', (
      tester,
    ) async {
      await pump(tester, AsyncData(catalog), theme: theme);
      expect(tester.takeException(), isNull);
      expect(find.text('Coca-Cola 33cl'), findsOneWidget);
      expect(
        find.textContaining(formatFcfa(Decimal.parse('2000'))),
        findsOneWidget,
      );
      expect(find.textContaining('24'), findsNothing);
      expect(find.textContaining('Stock bas · 3'), findsOneWidget);
      expect(find.textContaining('Rupture'), findsOneWidget);
      // Le prix d'achat n'apparaît jamais en caisse.
      expect(find.textContaining('1 234'), findsNothing);
    });
  }

  testWidgets('toucher la ligne ajoute, l’appui long ouvre la quantité', (
    tester,
  ) async {
    final calls = await pump(tester, AsyncData(catalog));
    await tester.tap(find.text('Coca-Cola 33cl'));
    await tester.tap(find.byTooltip('Ajouter Pain'));
    await tester.longPress(find.text('Savon'));
    expect(calls.adds, ['Coca-Cola 33cl', 'Pain']);
    expect(calls.edits, ['Savon']);
  });

  testWidgets('produit en rupture : visible mais non ajoutable', (
    tester,
  ) async {
    final calls = await pump(tester, AsyncData(catalog));
    await tester.tap(find.byTooltip('Ajouter Fanta'));
    await tester.tap(find.text('Fanta'));
    await tester.longPress(find.text('Fanta'));
    expect(calls.adds, isEmpty);
    expect(calls.edits, isEmpty);
  });

  testWidgets('catalogue vide : invite à créer un produit', (tester) async {
    final calls = await pump(tester, const AsyncData(<Product>[]));
    expect(find.text('Aucun produit pour l’instant'), findsOneWidget);
    await tester.tap(find.text('Créer un produit'));
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
                    onAdd: (_) {},
                    onDecrease: (_) {},
                    onEditQuantity: (_) {},
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

  testWidgets('catégorie : seuls ses produits', (tester) async {
    await pump(tester, AsyncData(catalog), categoryId: 'boissons');
    expect(find.text('Coca-Cola 33cl'), findsOneWidget);
    expect(find.text('Fanta'), findsOneWidget);
    expect(find.text('Pain'), findsNothing);
  });

  testWidgets('au panier : stepper avec la quantité à la place du +', (
    tester,
  ) async {
    await pump(
      tester,
      AsyncData(catalog),
      cartQuantities: const {'Coca-Cola 33cl': 2},
    );
    expect(find.byType(QuantityStepper), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.byTooltip('Ajouter Coca-Cola 33cl'), findsNothing);
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

  group('grille', () {
    const grid = SaleCatalogLayout.grid;

    testWidgets('3 colonnes sur téléphone, plus sur tablette', (tester) async {
      await pump(tester, AsyncData(catalog), layout: grid);
      expect(columnCount(tester), 3);
      expect(find.byType(SaleProductTile), findsNWidgets(4));

      await pump(
        tester,
        AsyncData(catalog),
        layout: grid,
        size: const Size(1024, 768),
      );
      expect(columnCount(tester), greaterThan(3));
      expect(tester.takeException(), isNull);
    });

    testWidgets('prix sans FCFA ; rupture à la place du prix', (tester) async {
      await pump(tester, AsyncData(catalog), layout: grid);
      expect(find.text(formatAmount(Decimal.parse('2000'))), findsOneWidget);
      expect(find.textContaining('FCFA'), findsNothing);
      expect(find.text('Rupture'), findsOneWidget);
      expect(find.text(formatAmount(Decimal.parse('1500'))), findsNothing);
      // Le prix d'achat n'apparaît jamais en caisse.
      expect(find.textContaining('1 234'), findsNothing);
    });

    testWidgets('toucher ajoute, appui long et pastille ouvrent la quantité', (
      tester,
    ) async {
      final calls = await pump(
        tester,
        AsyncData(catalog),
        layout: grid,
        cartQuantities: const {'Pain': 3},
      );
      await tester.tap(find.text('Coca-Cola 33cl'));
      await tester.longPress(find.text('Savon'));
      await tester.tap(find.text('3'));
      expect(calls.adds, ['Coca-Cola 33cl']);
      expect(calls.edits, ['Savon', 'Pain']);
      // Pas de « − » sur la tuile : la correction passe par la quantité.
      expect(find.byType(QuantityStepper), findsNothing);
    });

    testWidgets('sans photo : pictogramme image de 40 dp sur chaque tuile', (
      tester,
    ) async {
      await pump(tester, AsyncData(catalog), layout: grid);
      final icons = find.descendant(
        of: find.byType(SaleProductTile),
        matching: find.byType(StrokeIcon),
      );
      expect(icons, findsNWidgets(catalog.length));
      expect(tester.widget<StrokeIcon>(icons.first).size, 40);
      expect(tester.widget<StrokeIcon>(icons.first).icon, DesignIcon.image);
    });

    testWidgets('rupture : tuile inactive', (tester) async {
      final calls = await pump(tester, AsyncData(catalog), layout: grid);
      await tester.tap(find.text('Fanta'));
      await tester.longPress(find.text('Fanta'));
      expect(calls.adds, isEmpty);
      expect(calls.edits, isEmpty);
    });

    testWidgets('pastille : zone tactile d’au moins 44 dp', (tester) async {
      await pump(
        tester,
        AsyncData(catalog),
        layout: grid,
        cartQuantities: const {'Pain': 3},
      );
      final badge = find.ancestor(
        of: find.text('3'),
        matching: find.byType(GestureDetector),
      );
      final size = tester.getSize(badge.first);
      expect(size.width, greaterThanOrEqualTo(44));
      expect(size.height, greaterThanOrEqualTo(44));
    });

    testWidgets('grande police : pas de débordement, thème sombre', (
      tester,
    ) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await pump(
        tester,
        AsyncData(catalog),
        layout: grid,
        theme: AppTheme.dark(),
        cartQuantities: const {'Coca-Cola 33cl': 12},
      );
      expect(tester.takeException(), isNull);
    });
  });
}
