import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/features/home/presentation/providers/home_providers.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart';
import 'package:mobile/features/sales/domain/repositories/sales_repository.dart';

DailyStats stats({
  int count = 0,
  String total = '0',
  String cash = '0',
  String mobile = '0',
  String refund = '0',
}) => (
  saleCount: count,
  totalAmount: Decimal.parse(total),
  cashTotal: Decimal.parse(cash),
  mobileMoneyTotal: Decimal.parse(mobile),
  refundTotal: Decimal.parse(refund),
);

void main() {
  group('averageBasket', () {
    test('null sans vente', () {
      expect(averageBasket(stats()), isNull);
    });

    test('arrondi au franc', () {
      expect(
        averageBasket(stats(count: 3, total: '10000')),
        Decimal.parse('3333'),
      );
      expect(
        averageBasket(stats(count: 2, total: '10500')),
        Decimal.parse('5250'),
      );
    });

    test('un retour ne change pas le panier moyen des ventes', () {
      // 3 ventes pour 10 000, dont 1 000 remboursés : encaissé net 9 000.
      expect(
        averageBasket(stats(count: 3, total: '9000', refund: '1000')),
        Decimal.parse('3333'),
      );
    });
  });

  group('salesByHour', () {
    Sale sale(int hour, String total) => Sale(
      id: 'sale-$hour-$total',
      receiptNumber: 1,
      totalAmount: Decimal.parse(total),
      vatAmount: Decimal.zero,
      discountAmount: Decimal.zero,
      paymentMethod: PaymentMethod.cash,
      createdAt: DateTime(2026, 10, 25, hour, 30),
    );

    test('24 cases à zéro sans vente', () {
      final totals = salesByHour(const []);
      expect(totals, hasLength(24));
      expect(totals.every((t) => t == Decimal.zero), isTrue);
    });

    test('cumule les ventes de la même heure', () {
      final totals = salesByHour([
        sale(9, '1500'),
        sale(9, '500'),
        sale(14, '12000'),
      ]);
      expect(totals[9], Decimal.parse('2000'));
      expect(totals[14], Decimal.parse('12000'));
      expect(totals[10], Decimal.zero);
    });
  });

  group('cashSharePercent', () {
    test('null si rien encaissé', () {
      expect(cashSharePercent(stats()), isNull);
    });

    test('part des espèces arrondie', () {
      expect(cashSharePercent(stats(cash: '2000', mobile: '1000')), 67);
      expect(cashSharePercent(stats(cash: '0', mobile: '500')), 0);
      expect(cashSharePercent(stats(cash: '500', mobile: '0')), 100);
    });
  });
}
