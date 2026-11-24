import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/core/widgets/index.dart';
import 'package:mobile/features/auth/domain/entities/store.dart';
import 'package:mobile/features/sales/domain/entities/cart_item.dart';
import 'package:mobile/features/sales/domain/entities/discount.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart';
import 'package:mobile/features/sales/presentation/receipt_text.dart';

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  Decimal d(int v) => Decimal.fromInt(v);

  const store = Store(
    name: 'Boutique Awa',
    address: 'Cocody, Abidjan',
    isSubjectToVat: false,
    phone: '+2250700000000',
    receiptFooterText: 'Ni repris ni échangé',
  );

  Sale sale({
    int receiptNumber = 123,
    int total = 1900,
    int vat = 0,
    int discount = 0,
  }) => Sale(
    id: 's1',
    receiptNumber: receiptNumber,
    totalAmount: d(total),
    vatAmount: d(vat),
    paymentMethod: PaymentMethod.orangeMoney,
    createdAt: DateTime(2026, 11, 24, 14, 32),
    discountAmount: d(discount),
  );

  final items = [
    CartItem(
      productId: 'p1',
      productName: 'Coca 33 cl',
      unitPrice: d(500),
      quantity: 2,
    ),
    CartItem(
      productId: 'p2',
      productName: 'Pain',
      unitPrice: d(1000),
      quantity: 1,
      discount: Discount(type: DiscountType.amount, value: d(100)),
    ),
  ];

  test(
    'vente synchronisée : en-tête, numéro, lignes, total, paiement, pied',
    () {
      final text = buildReceiptText(
        store: store,
        sale: sale(),
        items: items,
        sellerName: 'Moussa',
      );

      expect(text, startsWith('*Boutique Awa*\n'));
      expect(text, contains('Cocody, Abidjan'));
      expect(text, contains('Tél. +225 07 00 00 00 00'));
      expect(text, contains('Reçu n° 000123'));
      expect(text, contains('24/11/2026 14:32'));
      expect(text, contains('Vendeur : Moussa'));
      expect(text, contains('Coca 33 cl × 2 : ${formatFcfa(d(1000))}'));
      expect(text, contains('Pain × 1 : ${formatFcfa(d(1000))}'));
      expect(text, contains('Réduction : −${formatFcfa(d(100))}'));
      expect(text, contains('*Total : ${formatFcfa(d(1900))}*'));
      expect(text, contains('Paiement : Orange Money'));
      expect(text, contains('Ni repris ni échangé'));
      expect(text, endsWith('Merci de votre visite !'));
    },
  );

  test('vente non synchronisée : reçu provisoire, sans numéro', () {
    final text = buildReceiptText(
      store: store,
      sale: sale(receiptNumber: 0),
      items: items,
    );

    expect(text, contains('Reçu provisoire'));
    expect(text, isNot(contains('Reçu n°')));
    expect(text, isNot(contains('Vendeur')));
  });

  test('remise globale : sous-total puis remise', () {
    final text = buildReceiptText(
      store: store,
      sale: sale(total: 1700, discount: 200),
      items: items,
    );

    expect(text, contains('Sous-total : ${formatFcfa(d(1900))}'));
    expect(text, contains('Remise : −${formatFcfa(d(200))}'));
    expect(text, contains('*Total : ${formatFcfa(d(1700))}*'));
  });

  test('TVA : HT, TVA puis total TTC', () {
    final text = buildReceiptText(
      store: store,
      sale: sale(total: 1180, vat: 180),
      items: items,
    );

    expect(text, contains('Total HT : ${formatFcfa(d(1000))}'));
    expect(text, contains('TVA : ${formatFcfa(d(180))}'));
    expect(text, contains('*Total TTC : ${formatFcfa(d(1180))}*'));
  });

  test('articles indisponibles : le total reste envoyé', () {
    final text = buildReceiptText(store: store, sale: sale());

    expect(text, contains('*Total : ${formatFcfa(d(1900))}*'));
    expect(text, isNot(contains('×')));
  });
}
