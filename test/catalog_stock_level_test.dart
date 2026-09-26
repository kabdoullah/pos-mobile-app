import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';

Product _product({int? stock, int? minStock}) => Product(
  id: 'p1',
  name: 'Riz',
  unitPrice: Decimal.fromInt(500),
  currentStock: stock,
  minStock: minStock,
  updatedAt: DateTime(2026),
);

void main() {
  test('untracked stock has no level', () {
    expect(_product(minStock: 5).stockLevel, isNull);
  });

  test('zero stock is out of stock, with or without threshold', () {
    expect(_product(stock: 0).stockLevel, StockLevel.outOfStock);
    expect(_product(stock: 0, minStock: 3).stockLevel, StockLevel.outOfStock);
  });

  test('stock at or below threshold is low', () {
    expect(_product(stock: 3, minStock: 3).stockLevel, StockLevel.low);
    expect(_product(stock: 1, minStock: 3).stockLevel, StockLevel.low);
  });

  test('stock above threshold or without threshold is normal', () {
    expect(_product(stock: 4, minStock: 3).stockLevel, StockLevel.normal);
    expect(_product(stock: 1).stockLevel, StockLevel.normal);
  });
}
