import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/features/home/presentation/providers/home_providers.dart';
import 'package:mobile/features/sales/domain/repositories/sales_repository.dart';

DailyStats stats({
  int count = 0,
  String total = '0',
  String cash = '0',
  String mobile = '0',
}) => (
  saleCount: count,
  totalAmount: Decimal.parse(total),
  cashTotal: Decimal.parse(cash),
  mobileMoneyTotal: Decimal.parse(mobile),
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
