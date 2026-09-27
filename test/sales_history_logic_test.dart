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

  group('searchSalesByReceipt', () {
    test('vide ou sans chiffre : toutes les ventes', () {
      expect(searchSalesByReceipt(sales, ''), sales);
      expect(searchSalesByReceipt(sales, '#'), sales);
    });

    test('préfixe # accepté, correspondance partielle', () {
      expect(searchSalesByReceipt(sales, '#10452').map((s) => s.id), [
        's10452',
      ]);
      expect(searchSalesByReceipt(sales, '1045'), hasLength(2));
    });

    test('une vente sans numéro ne correspond jamais', () {
      expect(searchSalesByReceipt(sales, '0'), hasLength(2));
    });
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
