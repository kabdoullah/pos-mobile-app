import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/returns/domain/refund_calculator.dart';

/// Mêmes cas que `tests/test_returns.py` du backend : les deux
/// implémentations doivent rester identiques (ADR-0010).
void main() {
  Decimal d(String v) => Decimal.parse(v);
  const a = '00000000-0000-0000-0000-000000000001';
  const b = '00000000-0000-0000-0000-000000000002';
  const c = '00000000-0000-0000-0000-000000000003';

  group('montant payé par ligne', () {
    test('sans remise globale : le total net de chaque ligne', () {
      final paid = RefundCalculator.allocatePaidAmounts([
        (id: a, lineTotal: d('3000')),
        (id: b, lineTotal: d('2500')),
      ], d('5500'));
      expect(paid, {a: d('3000'), b: d('2500')});
    });

    test('remise globale au prorata, somme = total encaissé', () {
      final paid = RefundCalculator.allocatePaidAmounts([
        (id: a, lineTotal: d('1000')),
        (id: b, lineTotal: d('1000')),
        (id: c, lineTotal: d('1000')),
      ], d('2900'));
      // Égalité de reste : départagée par l'id croissant.
      expect(paid, {a: d('967'), b: d('967'), c: d('966')});
    });

    test('la remise suit le poids de chaque ligne', () {
      final paid = RefundCalculator.allocatePaidAmounts([
        (id: a, lineTotal: d('3000')),
        (id: b, lineTotal: d('1000')),
      ], d('3600'));
      expect(paid, {a: d('2700'), b: d('900')});
    });

    test('vente gratuite : rien à rembourser', () {
      expect(
        RefundCalculator.allocatePaidAmounts([
          (id: a, lineTotal: Decimal.zero),
        ], Decimal.zero),
        {a: Decimal.zero},
      );
    });
  });

  group('montant d’un retour', () {
    test('retours successifs : 2 puis 3 sur 5 = montant payé', () {
      final first = RefundCalculator.refundFor(
        paid: d('1001'),
        sold: 5,
        alreadyReturned: 0,
        quantity: 2,
      );
      final second = RefundCalculator.refundFor(
        paid: d('1001'),
        sold: 5,
        alreadyReturned: 2,
        quantity: 3,
      );
      expect((first, second), (d('400'), d('601')));
      expect(first + second, d('1001'));
    });

    test('unité par unité : jamais plus que le payé', () {
      final refunds = [
        for (var already = 0; already < 3; already++)
          RefundCalculator.refundFor(
            paid: d('1000'),
            sold: 3,
            alreadyReturned: already,
            quantity: 1,
          ),
      ];
      expect(refunds, [d('333'), d('333'), d('334')]);
    });

    test('grands montants sans débordement', () {
      final paid = RefundCalculator.allocatePaidAmounts([
        (id: a, lineTotal: d('9999999999.99')),
        (id: b, lineTotal: d('1')),
      ], d('9999999990'));
      expect(paid.values.fold(Decimal.zero, (s, v) => s + v), d('9999999990'));
    });
  });
}
