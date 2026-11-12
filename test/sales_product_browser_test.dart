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
  final adds = <String>[];
  final decreases = <String>[];
  final opens = <String>[];
  int retries = 0;
  int addProduct = 0;
  int scanProduct = 0;
  int importProducts = 0;
}

Widget browser(
  AsyncValue<List<Product>> products,
  Calls calls, {
  String? categoryId,
  Map<String, int> cartQuantities = const {},
}) => ProductBrowser(
  products: products,
  categoryId: categoryId,
  cartQuantities: cartQuantities,
  onAdd: (p) => calls.adds.add(p.id),
  onDecrease: (p) => calls.decreases.add(p.id),
  onOpen: (p) => calls.opens.add(p.id),
  onRetry: () => calls.retries++,
  onAddProduct: () => calls.addProduct++,
  onScanProduct: () => calls.scanProduct++,
  onImportProducts: () => calls.importProducts++,
);

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
              browser(
                products,
                calls,
                categoryId: categoryId,
                cartQuantities: cartQuantities,
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

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  for (final (name, theme) in [
    ('clair', AppTheme.light()),
    ('sombre', AppTheme.dark()),
  ]) {
    testWidgets('nom, prix de vente, alertes de stock seulement, thème $name', (
      tester,
    ) async {
      await pump(tester, AsyncData(catalog), theme: theme);
      expect(tester.takeException(), isNull);
      expect(find.text('Coca-Cola 33cl'), findsOneWidget);
      expect(find.text(formatFcfa(Decimal.parse('2000'))), findsOneWidget);
      // Stock normal : rien ; bas ou rupture : un badge en toutes lettres.
      expect(find.text('Stock : 24'), findsNothing);
      expect(find.text('Stock bas : 3'), findsOneWidget);
      expect(find.text('Rupture'), findsOneWidget);
      // Le prix d'achat n'apparaît jamais en caisse.
      expect(find.textContaining('1 234'), findsNothing);
    });
  }

  testWidgets('toucher la ligne ou le + ajoute ; appui long = quantité', (
    tester,
  ) async {
    final calls = await pump(tester, AsyncData(catalog));
    await tester.tap(find.byTooltip('Ajouter Coca-Cola 33cl'));
    await tester.tap(find.text('Pain'));
    await tester.longPress(find.text('Savon'));
    expect(calls.adds, ['Coca-Cola 33cl', 'Pain']);
    expect(calls.opens, ['Savon']);
  });

  testWidgets('produit en rupture : visible mais non ajoutable', (
    tester,
  ) async {
    final calls = await pump(tester, AsyncData(catalog));
    await tester.tap(find.byTooltip('Ajouter Fanta'));
    await tester.tap(find.text('Fanta'));
    expect(calls.adds, isEmpty);
  });

  testWidgets('au panier : stepper à la place du +', (tester) async {
    final calls = await pump(
      tester,
      AsyncData(catalog),
      cartQuantities: const {'Coca-Cola 33cl': 2},
    );
    expect(find.byTooltip('Ajouter Coca-Cola 33cl'), findsNothing);
    expect(find.byType(QuantityStepper), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    await tester.tap(find.byTooltip('Diminuer'));
    await tester.tap(find.byTooltip('Augmenter'));
    expect(calls.decreases, ['Coca-Cola 33cl']);
    expect(calls.adds, ['Coca-Cola 33cl']);
  });

  testWidgets('catalogue vide : créer, scanner ou importer', (tester) async {
    final calls = await pump(tester, const AsyncData(<Product>[]));
    expect(find.text('Aucun produit pour l’instant'), findsOneWidget);
    await tester.tap(find.text('Créer un produit'));
    await tester.tap(find.text('Scanner un produit'));
    await tester.tap(find.text('Importer une liste'));
    expect(calls.addProduct, 1);
    expect(calls.scanProduct, 1);
    expect(calls.importProducts, 1);
  });

  testWidgets('chargement : squelettes, pas de gros indicateur', (
    tester,
  ) async {
    await pump(tester, const AsyncLoading<List<Product>>());
    expect(find.byType(SkeletonBox), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('erreur sans données : rassure et propose Réessayer', (
    tester,
  ) async {
    final calls = await pump(
      tester,
      AsyncError<List<Product>>(Exception('drift'), StackTrace.empty),
    );
    expect(find.text('Le catalogue ne s’affiche pas'), findsOneWidget);
    await tester.tap(find.text('Réessayer'));
    expect(calls.retries, 1);
  });

  testWidgets('erreur avec données déjà chargées : les produits restent', (
    tester,
  ) async {
    final controller = StreamController<List<Product>>();
    addTearDown(controller.close);
    final products = StreamProvider<List<Product>>((ref) => controller.stream);
    final calls = Calls();

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) => CustomScrollView(
                slivers: [browser(ref.watch(products), calls)],
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
    expect(find.text('Le catalogue ne s’affiche pas'), findsNothing);
  });

  testWidgets('catégorie : seuls ses produits', (tester) async {
    await pump(tester, AsyncData(catalog), categoryId: 'boissons');
    expect(find.text('Coca-Cola 33cl'), findsOneWidget);
    expect(find.text('Fanta'), findsOneWidget);
    expect(find.text('Pain'), findsNothing);
  });

  testWidgets('liste sur téléphone, colonnes sur tablette', (tester) async {
    double top(String name) => tester.getTopLeft(find.text(name)).dy;

    await pump(tester, AsyncData(catalog));
    expect(top('Fanta'), greaterThan(top('Coca-Cola 33cl')));

    await pump(tester, AsyncData(catalog), size: const Size(1024, 768));
    expect(top('Fanta'), top('Coca-Cola 33cl'));
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
