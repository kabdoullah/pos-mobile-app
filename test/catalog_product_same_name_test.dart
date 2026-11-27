import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';

Product _product(String id, String name, {DateTime? deletedAt}) => Product(
  id: id,
  name: name,
  sellingPrice: Decimal.fromInt(500),
  updatedAt: DateTime(2026),
  deletedAt: deletedAt,
);

void main() {
  final products = [
    _product('p1', 'Lotus'),
    _product('p2', 'Riz  local 1kg'),
    _product('p3', 'Savon', deletedAt: DateTime(2026)),
  ];

  test('même nom à la casse et aux espaces près', () {
    expect(findProductWithSameName(products, '  lotus ')?.id, 'p1');
    expect(findProductWithSameName(products, 'riz local 1KG')?.id, 'p2');
  });

  test('nom différent, vide ou produit supprimé : aucun doublon', () {
    expect(findProductWithSameName(products, 'Lotus XL'), isNull);
    expect(findProductWithSameName(products, '   '), isNull);
    expect(findProductWithSameName(products, 'Savon'), isNull);
  });

  test('le produit modifié ne se signale pas lui-même', () {
    expect(findProductWithSameName(products, 'Lotus', excludeId: 'p1'), isNull);
  });
}
