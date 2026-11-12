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
    final lines = {
      's10452': [(productName: 'Riz local 1kg', quantity: 21)],
      's10451': [(productName: 'Lotus', quantity: 2)],
      's0': [(productName: 'Céleste', quantity: 1)],
    };

    test('vide ou « # » seul : toutes les ventes', () {
      expect(searchSales(sales, ''), sales);
      expect(searchSales(sales, '#'), sales);
    });

    test('n° de reçu : préfixe # accepté, correspondance partielle', () {
      expect(searchSales(sales, '#10452').map((s) => s.id), ['s10452']);
      expect(searchSales(sales, '1045'), hasLength(2));
    });

    test('montant', () {
      expect(searchSales(sales, '8000').map((s) => s.id), ['s10451']);
    });

    test('produit vendu, sans tenir compte de la casse', () {
      expect(searchSales(sales, 'riz', lines: lines).map((s) => s.id), [
        's10452',
      ]);
      // La vente non envoyée se retrouve par ce qu'elle contient.
      expect(searchSales(sales, 'CÉLESTE', lines: lines).map((s) => s.id), [
        's0',
      ]);
    });
  });

  test('saleLinesPreview', () {
    expect(saleLinesPreview(const []), '');
    expect(
      saleLinesPreview(const [
        (productName: 'Bacteril', quantity: 2),
        (productName: 'Céleste', quantity: 1),
        (productName: 'Eau de Javel 1L', quantity: 1),
      ]),
      'Bacteril ×2, Céleste, Eau de Javel 1L',
    );
    expect(
      saleLinesPreview(const [
        (productName: 'Huile Dinor 1L', quantity: 4),
        (productName: 'a', quantity: 1),
        (productName: 'b', quantity: 1),
        (productName: 'c', quantity: 1),
      ]),
      'Huile Dinor 1L ×4 + 3 autres',
    );
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
