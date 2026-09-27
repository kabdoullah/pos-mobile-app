import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/features/auth/domain/entities/store.dart';
import 'package:mobile/features/printing/data/receipt_formatter.dart';
import 'package:mobile/features/sales/domain/entities/cart_item.dart';
import 'package:mobile/features/sales/domain/entities/discount.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart';

String _text(List<int> bytes) => latin1.decode(bytes, allowInvalid: true);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => initializeDateFormatting('fr_FR'));

  final sale = Sale(
    discountAmount: Decimal.zero,
    id: 's1',
    receiptNumber: 12,
    totalAmount: Decimal.fromInt(1500),
    vatAmount: Decimal.zero,
    paymentMethod: PaymentMethod.cash,
    createdAt: DateTime(2026, 9, 27, 10),
  );

  test('le ticket affiche le téléphone de la boutique et le vendeur', () async {
    final bytes = await ReceiptFormatter.format(
      store: const Store(
        name: 'Boutique Awa',
        isSubjectToVat: false,
        phone: '+2250701020304',
      ),
      sale: sale,
      sellerName: 'Awa',
    );
    final text = _text(bytes);
    expect(text, contains('07 01 02 03 04'));
    expect(text, contains('Vendeur : Awa'));
  });

  test('sans téléphone ni vendeur : lignes absentes', () async {
    final text = _text(
      await ReceiptFormatter.format(
        store: const Store(name: 'Boutique Awa', isSubjectToVat: false),
        sale: sale,
      ),
    );
    expect(text, isNot(contains('Vendeur')));
    expect(text, isNot(contains('+225')));
  });

  test(
    'caractères hors Latin-1 (apostrophe typographique, montants) imprimables',
    () async {
      final bytes = await ReceiptFormatter.format(
        store: const Store(
          name: 'Chez l’Ivoirien',
          isSubjectToVat: false,
          receiptFooterText: 'Merci — à bientôt…',
        ),
        sale: sale,
        items: [
          CartItem(
            productId: 'p1',
            productName: 'L’eau minérale 1,5L',
            unitPrice: Decimal.fromInt(1500),
            quantity: 1,
          ),
        ],
        sellerName: 'Awa 🙂',
      );
      final text = _text(bytes);
      expect(text, contains("Chez l'Ivoirien"));
      expect(text, contains("L'eau minérale"));
      expect(text, contains('Merci - à bientôt...'));
      expect(text, contains('Vendeur : Awa ?'));
      expect(text, contains('1 500'));
    },
  );

  test('réductions : brut, réduction de ligne, remise globale ; jamais le '
      "prix d'achat", () async {
    final text = _text(
      await ReceiptFormatter.format(
        store: const Store(name: 'Boutique Awa', isSubjectToVat: false),
        sale: Sale(
          id: 's2',
          receiptNumber: 13,
          totalAmount: Decimal.fromInt(3000),
          vatAmount: Decimal.zero,
          paymentMethod: PaymentMethod.cash,
          createdAt: DateTime(2026, 9, 27, 10),
          discount: Discount(
            type: DiscountType.amount,
            value: Decimal.fromInt(500),
          ),
          discountAmount: Decimal.fromInt(500),
        ),
        items: [
          CartItem(
            productId: 'p1',
            productName: 'Coca-Cola',
            unitPrice: Decimal.fromInt(2000),
            quantity: 2,
            purchaseUnitPrice: Decimal.fromInt(1234),
            discount: Discount(
              type: DiscountType.amount,
              value: Decimal.fromInt(500),
            ),
          ),
        ],
      ),
    );
    expect(text, contains(RegExp(r'  2 x 2 000 +4 000')));
    expect(text, contains(RegExp(r'  Réduction +-500')));
    expect(text, contains(RegExp(r'Sous-total +3 500')));
    expect(text, contains(RegExp(r'Remise +-500')));
    expect(text, contains(RegExp(r'TOTAL +3 000')));
    expect(text, isNot(contains('1 234')));
  });

  test('printable : Latin-1 conservé, le reste remplacé', () {
    expect(
      ReceiptFormatter.printable('Reçu n° 12 – « payé »'),
      'Reçu n° 12 - « payé »',
    );
    expect(ReceiptFormatter.printable('10\u202F500 FCFA'), '10 500 FCFA');
    expect(ReceiptFormatter.printable('漢'), '?');
  });
}
