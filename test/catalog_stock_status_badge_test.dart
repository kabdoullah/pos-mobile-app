import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/catalog/presentation/widgets/stock_status_badge.dart';

Product product({int? stock, int? minStock}) => Product(
  id: 'p',
  name: 'Produit',
  sellingPrice: Decimal.parse('1000'),
  currentStock: stock,
  minStock: minStock,
  updatedAt: DateTime(2026),
);

Future<void> pump(
  WidgetTester tester,
  Product product, {
  bool showQuantity = false,
  ThemeData? theme,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: theme ?? AppTheme.light(),
      home: Scaffold(
        body: StockStatusBadge(product: product, showQuantity: showQuantity),
      ),
    ),
  );
}

void main() {
  for (final (name, theme) in [
    ('clair', AppTheme.light()),
    ('sombre', AppTheme.dark()),
  ]) {
    testWidgets('caisse : libellés avec quantité, thème $name', (tester) async {
      for (final (p, label) in [
        (product(stock: 24), 'Stock : 24'),
        (product(stock: 3, minStock: 5), 'Faible : 3'),
        (product(stock: 0), 'Rupture'),
        (product(stock: -2), 'Rupture'),
      ]) {
        await pump(tester, p, showQuantity: true, theme: theme);
        expect(find.text(label), findsOneWidget);
      }
    });
  }

  testWidgets('caisse : pas de badge si le stock n’est pas suivi', (
    tester,
  ) async {
    await pump(tester, product(), showQuantity: true);
    expect(find.byType(Text), findsNothing);
  });

  testWidgets('onglet Stock : libellés d’état inchangés', (tester) async {
    await pump(tester, product(stock: 24));
    expect(find.text('Disponible'), findsOneWidget);
    await pump(tester, product(stock: 3, minStock: 5));
    expect(find.text('Stock faible'), findsOneWidget);
    await pump(tester, product());
    expect(find.text('Non suivi'), findsOneWidget);
  });
}
