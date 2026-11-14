import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_count.dart';
import 'package:mobile/features/cash_register/domain/entities/denomination.dart';

Decimal d(String v) => Decimal.parse(v);

const bill10000 = Denomination(DenominationType.bill, 10000);
const bill5000 = Denomination(DenominationType.bill, 5000);
const bill2000 = Denomination(DenominationType.bill, 2000);
const bill500 = Denomination(DenominationType.bill, 500);
const coin500 = Denomination(DenominationType.coin, 500);
const coin250 = Denomination(DenominationType.coin, 250);
const coin5 = Denomination(DenominationType.coin, 5);

void main() {
  group('fcfaDenominations', () {
    test('gamme BCEAO, identique au serveur (DENOMINATIONS)', () {
      final bills = [
        for (final x in fcfaDenominations)
          if (x.isBill) x.value,
      ];
      final coins = [
        for (final x in fcfaDenominations)
          if (!x.isBill) x.value,
      ];
      expect(bills, [10000, 5000, 2000, 1000, 500]);
      expect(coins, [500, 250, 200, 100, 50, 25, 10, 5]);
    });

    test('500 billet et 500 pièce sont deux coupures distinctes', () {
      expect(bill500 == coin500, isFalse);
      expect(fcfaDenominations.toSet(), hasLength(fcfaDenominations.length));
    });

    test('valeurs API bill / coin', () {
      expect(denominationTypeToApi(DenominationType.bill), 'bill');
      expect(denominationTypeFromApi('coin'), DenominationType.coin);
      expect(() => denominationTypeFromApi('note'), throwsArgumentError);
    });
  });

  group('CashCount', () {
    test('comptage vierge : toutes les coupures à zéro, totaux nuls', () {
      final count = CashCount.empty();
      expect(count.quantities.keys, fcfaDenominations);
      expect(count.quantities.values.every((q) => q == 0), isTrue);
      expect(count.total, Decimal.zero);
      expect(count.billCount, 0);
      expect(count.coinCount, 0);
    });

    test('total des billets, des pièces et total général', () {
      final count = CashCount.empty()
          .withQuantity(bill10000, 3)
          .withQuantity(bill5000, 2)
          .withQuantity(bill2000, 5)
          .withQuantity(coin500, 1)
          .withQuantity(coin250, 4)
          .withQuantity(coin5, 3);

      expect(count.billsTotal, d('50000'));
      expect(count.coinsTotal, d('1515'));
      expect(count.total, d('51515'));
      expect(count.billCount, 10);
      expect(count.coinCount, 8);
      expect(count.subtotalOf(bill10000), d('30000'));
    });

    test('quantité nulle : sous-total nul, coupure conservée', () {
      final count = CashCount.empty()
          .withQuantity(bill10000, 2)
          .withQuantity(bill10000, 0);
      expect(count.subtotalOf(bill10000), Decimal.zero);
      expect(count.quantities.containsKey(bill10000), isTrue);
      expect(count, CashCount.empty());
    });

    test('quantité négative ou trop grande refusée', () {
      final count = CashCount.empty();
      expect(() => count.withQuantity(bill10000, -1), throwsArgumentError);
      expect(
        () => count.withQuantity(bill10000, CashCount.maxQuantity + 1),
        throwsArgumentError,
      );
      expect(
        () => CashCount.fromQuantities({bill10000: -2}),
        throwsArgumentError,
      );
    });

    test('coupure inconnue refusée à la saisie, conservée à la lecture', () {
      const coin1 = Denomination(DenominationType.coin, 1);
      expect(
        () => CashCount.empty().withQuantity(coin1, 1),
        throwsArgumentError,
      );
      final stored = CashCount.fromQuantities({coin1: 3, bill500: 1});
      expect(stored.total, d('503'));
      expect(stored.quantities.keys, [bill500, coin1]);
      expect(
        () => CashCount.fromQuantities({
          const Denomination(DenominationType.bill, 0): 1,
        }),
        throwsArgumentError,
      );
    });

    test('ordre : billets puis pièces, coupure décroissante', () {
      final count = CashCount.fromQuantities({
        coin5: 1,
        bill500: 1,
        coin500: 1,
        bill10000: 1,
      });
      expect(count.quantities.keys, [bill10000, bill500, coin500, coin5]);
    });

    test("égalité indépendante de l'ordre de saisie", () {
      final a = CashCount.empty()
          .withQuantity(bill5000, 1)
          .withQuantity(coin250, 2);
      final b = CashCount.empty()
          .withQuantity(coin250, 2)
          .withQuantity(bill5000, 1);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('quantité inhabituelle signalée', () {
      final count = CashCount.empty()
          .withQuantity(bill10000, 250)
          .withQuantity(coin5, 150)
          .withQuantity(coin250, 201);
      expect(count.isUnusual(bill10000), isTrue); // 2 500 000 FCFA
      expect(count.isUnusual(coin5), isFalse);
      expect(count.isUnusual(coin250), isTrue); // plus de 200 pièces
      expect(count.isUnusual(bill5000), isFalse);
    });
  });

  group('CashCount.parseQuantity', () {
    test('entiers acceptés, champ vide = 0', () {
      expect(CashCount.parseQuantity('12'), 12);
      expect(CashCount.parseQuantity(' 3 '), 3);
      expect(CashCount.parseQuantity(''), 0);
      expect(CashCount.parseQuantity('100000'), 100000);
    });

    test('quantité invalide : décimale, signe, texte, trop grande', () {
      for (final text in ['1.5', '2,0', '-1', '+3', 'abc', '1e3', '100001']) {
        expect(CashCount.parseQuantity(text), isNull, reason: text);
      }
    });
  });
}
