import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart';
import 'package:mobile/features/sales/presentation/providers/cart_provider.dart';
import 'package:mobile/features/sales/presentation/providers/checkout_provider.dart';

Decimal d(String v) => Decimal.parse(v);

Product product({int? stock}) => Product(
  id: 'p1',
  name: 'Coca-Cola',
  unitPrice: d('2500'),
  currentStock: stock,
  updatedAt: DateTime(2026),
);

void main() {
  group('CheckoutState — espèces', () {
    test('champ vide = montant exact : encaissable, pas de monnaie', () {
      const state = CheckoutState();
      expect(state.method, PaymentMethod.cash);
      expect(state.canSubmitFor(d('10500')), isTrue);
      expect(state.changeFor(d('10500')), Decimal.zero);
    });

    test('calcule la monnaie à rendre', () {
      final state = CheckoutState(cashReceived: d('15000'));
      expect(state.changeFor(d('10500')), d('4500'));
      expect(state.cashErrorFor(d('10500')), isNull);
    });

    test('montant insuffisant bloque l’encaissement', () {
      final state = CheckoutState(cashReceived: d('10000'));
      expect(state.cashErrorFor(d('10500')), 'Montant insuffisant');
      expect(state.canSubmitFor(d('10500')), isFalse);
      expect(state.changeFor(d('10500')), Decimal.zero);
    });
  });

  group('CheckoutState — mixte', () {
    test('reste à payer puis paiement complet', () {
      final partial = CheckoutState(
        method: PaymentMethod.mixed,
        cashReceived: d('5000'),
      );
      expect(partial.remainingFor(d('10500')), d('5500'));
      expect(partial.canSubmitFor(d('10500')), isFalse);

      final full = CheckoutState(
        method: PaymentMethod.mixed,
        cashReceived: d('5000'),
        mobileMoney: d('5500'),
      );
      expect(full.remainingFor(d('10500')), Decimal.zero);
      expect(full.canSubmitFor(d('10500')), isTrue);
    });

    test('un excédent bloque (le use case exige l’égalité)', () {
      final state = CheckoutState(
        method: PaymentMethod.mixed,
        cashReceived: d('6000'),
        mobileMoney: d('5500'),
      );
      expect(state.remainingFor(d('10500')), d('-1000'));
      expect(state.canSubmitFor(d('10500')), isFalse);
    });
  });

  test('mobile money : toujours encaissable, sans monnaie', () {
    for (final method in [
      PaymentMethod.orangeMoney,
      PaymentMethod.mtn,
      PaymentMethod.wave,
    ]) {
      final state = CheckoutState(method: method);
      expect(state.canSubmitFor(d('10500')), isTrue);
      expect(state.changeFor(d('10500')), Decimal.zero);
    }
  });

  group('quickCashAmounts', () {
    test('arrondis supérieurs aux coupures courantes', () {
      expect(quickCashAmounts(d('10500')), [
        d('11000'),
        d('15000'),
        d('20000'),
      ]);
    });

    test('exclut le montant exact et dédoublonne', () {
      expect(quickCashAmounts(d('4000')), [d('5000'), d('10000')]);
      expect(quickCashAmounts(d('300')), [d('1000'), d('5000'), d('10000')]);
    });
  });

  group('Checkout notifier', () {
    test(
      'changer de moyen efface les montants ; reset revient aux espèces',
      () {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        container.listen(checkoutProvider, (_, _) {});
        final notifier = container.read(checkoutProvider.notifier);

        notifier.setCashReceived(d('15000'));
        notifier.selectMethod(PaymentMethod.mixed);
        expect(container.read(checkoutProvider).cashReceived, isNull);

        notifier.setMobileMoney(d('1000'));
        notifier.reset();
        final state = container.read(checkoutProvider);
        expect(state.method, PaymentMethod.cash);
        expect(state.mobileMoney, isNull);
      },
    );
  });

  group('Cart.addItem(quantity:)', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
      container.listen(cartProvider, (_, _) {});
    });
    tearDown(() => container.dispose());

    test('ajoute plusieurs unités puis cumule sur la ligne existante', () {
      final cart = container.read(cartProvider.notifier);
      expect(cart.addItem(product(stock: 10), quantity: 3), isTrue);
      expect(cart.addItem(product(stock: 10), quantity: 2), isTrue);

      final state = container.read(cartProvider);
      expect(state.items.single.quantity, 5);
      expect(state.unitCount, 5);
      expect(state.total, d('12500'));
      expect(cart.quantityOf('p1'), 5);
    });

    test('refuse de dépasser le stock (nouvelle ligne ou cumul)', () {
      final cart = container.read(cartProvider.notifier);
      expect(cart.addItem(product(stock: 2), quantity: 3), isFalse);
      expect(container.read(cartProvider).isEmpty, isTrue);

      expect(cart.addItem(product(stock: 2), quantity: 2), isTrue);
      expect(cart.addItem(product(stock: 2)), isFalse);
      expect(cart.quantityOf('p1'), 2);
    });
  });
}
