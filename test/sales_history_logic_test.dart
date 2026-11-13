import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/features/sales/domain/entities/sale.dart';
import 'package:mobile/features/sales/presentation/pages/date_range_filter_sheet.dart';
import 'package:mobile/features/sales/presentation/providers/sales_providers.dart';

Sale sale(int receipt, String total) => Sale(
  discountAmount: Decimal.zero,
  id: 's$receipt',
  receiptNumber: receipt,
  totalAmount: Decimal.parse(total),
  vatAmount: Decimal.zero,
  paymentMethod: PaymentMethod.cash,
  createdAt: DateTime(2026, 9, 27),
);

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  final sales = [sale(10452, '10500'), sale(10451, '8000'), sale(0, '500')];

  test('salesTotals : nombre et chiffre d’affaires', () {
    final totals = salesTotals(sales);
    expect(totals.count, 3);
    expect(totals.total, Decimal.parse('19000'));
    expect(salesTotals(const []).total, Decimal.zero);
  });

  group('searchSales', () {
    test('vide ou sans chiffre : toutes les ventes', () {
      expect(searchSales(sales, ''), sales);
      expect(searchSales(sales, '#'), sales);
    });

    test('n° de reçu : préfixe # accepté, correspondance partielle', () {
      expect(searchSales(sales, '#10452').map((s) => s.id), ['s10452']);
      expect(searchSales(sales, '1045'), hasLength(2));
    });

    test('montant, espaces ignorés', () {
      expect(searchSales(sales, '8 000').map((s) => s.id), ['s10451']);
    });

    test('vente sans numéro : retrouvée par son montant seulement', () {
      // 10 500 et 500 contiennent « 500 » ; le n° 0 n'est jamais cherché.
      expect(searchSales(sales, '500').map((s) => s.id), ['s10452', 's0']);
      expect(searchSales(sales, '9'), isEmpty);
    });
  });

  test('groupSalesByDay : un groupe par jour, ordre conservé', () {
    Sale at(String id, DateTime createdAt) =>
        sale(1, '1000').copyWith(id: id, createdAt: createdAt);
    final groups = groupSalesByDay([
      at('a', DateTime(2026, 10, 25, 18)),
      at('b', DateTime(2026, 10, 25, 9)),
      at('c', DateTime(2026, 10, 24, 20)),
    ]);
    expect(groups.map((g) => g.day), [
      DateTime(2026, 10, 25),
      DateTime(2026, 10, 24),
    ]);
    expect(groups.first.sales.map((s) => s.id), ['a', 'b']);
    expect(groups.last.sales.map((s) => s.id), ['c']);
    expect(groupSalesByDay(const []), isEmpty);
  });

  test('periodLabel : préréglages et période personnalisée', () {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    expect(periodLabel(DateTimeRange(start: today, end: today)), "Aujourd'hui");
    expect(
      periodLabel(DateTimeRange(start: yesterday, end: yesterday)),
      'Hier',
    );
    expect(
      periodLabel(
        DateTimeRange(start: DateTime(2025, 1, 3), end: DateTime(2025, 1, 9)),
      ),
      '3 janv. – 9 janv.',
    );
  });
}
