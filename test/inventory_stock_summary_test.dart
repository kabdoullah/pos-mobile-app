import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/inventory/domain/entities/stock_summary.dart';
import 'package:mobile/features/inventory/presentation/providers/inventory_providers.dart';

Product product(
  String name, {
  int? stock,
  int? min,
  String price = '500',
  String? barcode,
}) => Product(
  id: name,
  name: name,
  unitPrice: Decimal.parse(price),
  currentStock: stock,
  minStock: min,
  barcode: barcode,
  updatedAt: DateTime(2026),
);

final catalog = [
  product(
    'Coca-Cola',
    stock: 24,
    min: 10,
    price: '2500',
    barcode: '5449000000996',
  ),
  product('Eau', stock: 2, min: 5),
  product('Riz', stock: 0, price: '8000'),
  product('Sucre', stock: 3, min: 5),
  product('Pain'), // stock non suivi
];

void main() {
  group('StockSummary.fromProducts', () {
    test('compte, valeur au prix de vente, alertes', () {
      final summary = StockSummary.fromProducts(catalog);
      expect(summary.productCount, 5);
      // 24×2500 + 2×500 + 3×500 (rupture et non suivi : 0)
      expect(summary.stockValue, Decimal.parse('62500'));
      // Stock faible inclut les ruptures (même règle que l'accueil).
      expect(summary.lowStockCount, 3);
      expect(summary.outOfStockCount, 1);
    });

    test('catalogue vide', () {
      final summary = StockSummary.fromProducts(const []);
      expect(summary.productCount, 0);
      expect(summary.stockValue, Decimal.zero);
    });
  });

  group('filterStockProducts', () {
    List<String> names(List<Product> products) =>
        products.map((p) => p.name).toList();

    test('tous : ordre d’origine', () {
      expect(names(filterStockProducts(catalog, filter: StockFilter.all)), [
        'Coca-Cola',
        'Eau',
        'Riz',
        'Sucre',
        'Pain',
      ]);
    });

    test('stock faible : ruptures d’abord, puis stock croissant', () {
      expect(
        names(filterStockProducts(catalog, filter: StockFilter.lowStock)),
        ['Riz', 'Eau', 'Sucre'],
      );
    });

    test('ruptures uniquement', () {
      expect(
        names(filterStockProducts(catalog, filter: StockFilter.outOfStock)),
        ['Riz'],
      );
    });

    test('recherche par nom (casse ignorée) ou code-barres', () {
      expect(
        names(
          filterStockProducts(catalog, filter: StockFilter.all, query: 'cOCA'),
        ),
        ['Coca-Cola'],
      );
      expect(
        names(
          filterStockProducts(catalog, filter: StockFilter.all, query: '54490'),
        ),
        ['Coca-Cola'],
      );
      expect(
        filterStockProducts(
          catalog,
          filter: StockFilter.lowStock,
          query: 'coca',
        ),
        isEmpty,
      );
    });
  });
}
