import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/providers/connectivity_provider.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/sales/domain/entities/cart_item.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart';
import 'package:mobile/features/sales/domain/usecases/create_sale_usecase.dart';
import 'package:mobile/features/sales/presentation/providers/cart_provider.dart';
import 'package:mobile/features/sales/presentation/providers/checkout_provider.dart';
import 'package:mobile/features/sales/presentation/providers/sales_providers.dart';
import 'package:mobile/features/sales/providers/sales_di_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockCreateSaleUseCase extends Mock implements CreateSaleUseCase {}

Decimal d(String value) => Decimal.parse(value);

final _coca = Product(
  id: 'p1',
  name: 'Coca-Cola 33cl',
  sellingPrice: d('1000'),
  updatedAt: DateTime(2026),
);

Sale _sale() => Sale(
  id: 'sale-1',
  receiptNumber: 0,
  totalAmount: d('2000'),
  vatAmount: Decimal.zero,
  discountAmount: Decimal.zero,
  paymentMethod: PaymentMethod.cash,
  createdAt: DateTime(2026),
);

void main() {
  late _MockCreateSaleUseCase useCase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(PaymentMethod.cash);
    registerFallbackValue(Decimal.zero);
    registerFallbackValue(<CartItem>[]);
  });

  When<Future<Sale>> whenCreateSale() => when(
    () => useCase(
      items: any(named: 'items'),
      discount: any(named: 'discount'),
      totalAmount: any(named: 'totalAmount'),
      vatAmount: any(named: 'vatAmount'),
      paymentMethod: any(named: 'paymentMethod'),
      cashAmount: any(named: 'cashAmount'),
      mobileMoneyAmount: any(named: 'mobileMoneyAmount'),
    ),
  );

  setUp(() {
    useCase = _MockCreateSaleUseCase();
    container = ProviderContainer(
      overrides: [
        createSaleUseCaseProvider.overrideWithValue(useCase),
        isOnlineProvider.overrideWith((ref) => Stream.value(false)),
      ],
    );
    addTearDown(container.dispose);
    // Comme l'écran de caisse : panier et brouillon de paiement observés.
    container
      ..listen(cartProvider, (_, _) {})
      ..listen(checkoutProvider, (_, _) {});
    container.read(cartProvider.notifier).addItem(_coca, quantity: 2);
  });

  SaleSubmission submission() =>
      container.read(saleSubmissionProvider.notifier);

  test('enregistre la vente, vide le panier et rend la monnaie', () async {
    whenCreateSale().thenAnswer((_) async => _sale());
    container.read(checkoutProvider.notifier).setCashReceived(d('5000'));

    final completed = await submission().submit();

    expect(completed?.sale.id, 'sale-1');
    expect(completed?.items.single.quantity, 2);
    expect(completed?.change, d('3000'));
    expect(container.read(cartProvider).isEmpty, isTrue);
    expect(container.read(checkoutProvider).cashReceived, isNull);
    expect(container.read(saleSubmissionProvider), isFalse);
    verify(
      () => useCase(
        items: any(named: 'items'),
        discount: any(named: 'discount'),
        totalAmount: d('2000'),
        vatAmount: Decimal.zero,
        paymentMethod: PaymentMethod.cash,
        // Hors paiement mixte, pas de ventilation des montants.
        cashAmount: null,
        mobileMoneyAmount: null,
      ),
    ).called(1);
  });

  test('ne fait rien si le paiement est incomplet', () async {
    container.read(checkoutProvider.notifier).setCashReceived(d('1000'));

    expect(await submission().submit(), isNull);
    expect(container.read(cartProvider).isEmpty, isFalse);
    verifyNever(
      () => useCase(
        items: any(named: 'items'),
        totalAmount: any(named: 'totalAmount'),
        vatAmount: any(named: 'vatAmount'),
        paymentMethod: any(named: 'paymentMethod'),
      ),
    );
  });

  test('ignore un second appui pendant l’encaissement', () async {
    final pending = Completer<Sale>();
    whenCreateSale().thenAnswer((_) => pending.future);

    final first = submission().submit();
    expect(container.read(saleSubmissionProvider), isTrue);
    expect(await submission().submit(), isNull);

    pending.complete(_sale());
    expect(await first, isNotNull);
    verify(
      () => useCase(
        items: any(named: 'items'),
        discount: any(named: 'discount'),
        totalAmount: any(named: 'totalAmount'),
        vatAmount: any(named: 'vatAmount'),
        paymentMethod: any(named: 'paymentMethod'),
        cashAmount: any(named: 'cashAmount'),
        mobileMoneyAmount: any(named: 'mobileMoneyAmount'),
      ),
    ).called(1);
  });

  test('en cas d’échec, garde le panier et propage l’erreur', () async {
    whenCreateSale().thenThrow(StateError('disque plein'));

    await expectLater(submission().submit(), throwsStateError);
    expect(container.read(cartProvider).isEmpty, isFalse);
    expect(container.read(saleSubmissionProvider), isFalse);
  });
}
