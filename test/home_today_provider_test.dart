import 'package:clock/clock.dart';
import 'package:decimal/decimal.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/home/presentation/providers/home_providers.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart';
import 'package:mobile/features/sales/domain/repositories/sales_repository.dart';
import 'package:mobile/features/sales/providers/sales_di_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockSalesRepository extends Mock implements SalesRepository {}

Sale _sale(DateTime at, String total) => Sale(
  discountAmount: Decimal.zero,
  id: 'sale-${at.toIso8601String()}',
  receiptNumber: 0,
  totalAmount: Decimal.parse(total),
  vatAmount: Decimal.zero,
  paymentMethod: PaymentMethod.cash,
  createdAt: at,
);

void main() {
  test('todayProvider rolls over to the new day at midnight', () {
    fakeAsync((async) {
      withClock(async.getClock(DateTime(2026, 9, 26, 23, 58)), () {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        container.listen(todayProvider, (_, _) {});

        expect(container.read(todayProvider), DateTime(2026, 9, 26));

        async.elapse(const Duration(minutes: 1));
        expect(container.read(todayProvider), DateTime(2026, 9, 26));

        async.elapse(const Duration(minutes: 1));
        expect(container.read(todayProvider), DateTime(2026, 9, 27));
      });
    });
  });

  test('yesterdayAtSameTimeProvider : hier, coupé à l’heure actuelle, '
      'recalculé toutes les 5 minutes', () {
    fakeAsync((async) {
      withClock(async.getClock(DateTime(2026, 11, 24, 10, 30)), () {
        final repository = _MockSalesRepository();
        final yesterday = DateTime(2026, 11, 23);
        when(
          () => repository.watchSalesByDateRange(yesterday, yesterday),
        ).thenAnswer(
          (_) => Stream.value([
            _sale(DateTime(2026, 11, 23, 9), '1000'),
            _sale(DateTime(2026, 11, 23, 10, 33), '2000'),
            _sale(DateTime(2026, 11, 23, 18), '5000'),
          ]),
        );
        final container = ProviderContainer(
          overrides: [salesRepositoryProvider.overrideWithValue(repository)],
        );
        addTearDown(container.dispose);
        container.listen(yesterdayAtSameTimeProvider, (_, _) {});

        async.flushMicrotasks();
        var value = container.read(yesterdayAtSameTimeProvider).value;
        expect(value?.amount, Decimal.parse('1000'));
        expect(value?.count, 1);
        expect(value?.at, DateTime(2026, 11, 24, 10, 30));

        // 10:35 : la vente d'hier à 10:33 entre dans la comparaison.
        async.elapse(const Duration(minutes: 5));
        async.flushMicrotasks();
        value = container.read(yesterdayAtSameTimeProvider).value;
        expect(value?.amount, Decimal.parse('3000'));
        expect(value?.at, DateTime(2026, 11, 24, 10, 35));
      });
    });
  });
}
