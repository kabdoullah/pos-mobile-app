import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile/features/auth/domain/entities/store.dart';
import 'package:mobile/features/printing/data/receipt_formatter.dart';
import 'package:mobile/features/returns/domain/entities/sale_return.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart';

String _text(List<int> bytes) => latin1.decode(bytes, allowInvalid: true);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => initializeDateFormatting('fr_FR'));

  final sale = Sale(
    discountAmount: Decimal.zero,
    id: 's1',
    receiptNumber: 12,
    totalAmount: Decimal.fromInt(3000),
    vatAmount: Decimal.zero,
    paymentMethod: PaymentMethod.cash,
    createdAt: DateTime(2026, 9, 27, 10),
  );

  SaleReturn saleReturn({int number = 4}) => SaleReturn(
    id: 'r1',
    saleId: 's1',
    returnNumber: number,
    reason: ReturnReason.defective,
    refundMethod: RefundMethod.wave,
    refundAmount: Decimal.fromInt(2000),
    createdAt: DateTime(2026, 10, 2, 15),
    syncStatus: ReturnSyncStatus.synced,
    lines: const [],
  );

  test('le reçu de retour cite la vente, les articles et le montant', () async {
    final text = _text(
      await ReceiptFormatter.formatReturn(
        store: const Store(name: 'Boutique Awa', isSubjectToVat: false),
        sale: sale,
        saleReturn: saleReturn(),
        lines: [
          (
            productName: 'Coca 33cl',
            quantity: 2,
            refundAmount: Decimal.fromInt(2000),
          ),
        ],
      ),
    );
    expect(text, contains('REÇU DE RETOUR'));
    expect(text, contains('Retour N° 000004'));
    expect(text, contains('Vente N° 000012 du 27/09/2026'));
    expect(text, contains('Coca 33cl'));
    expect(text, contains('2 rendus'));
    expect(text, contains('REMBOURSÉ'));
    expect(text, contains('Mode : Wave'));
    expect(text, contains('Motif : Produit défectueux'));
  });

  test('retour pas encore synchronisé : numéro provisoire', () async {
    final text = _text(
      await ReceiptFormatter.formatReturn(
        store: const Store(name: 'Boutique Awa', isSubjectToVat: false),
        sale: sale,
        saleReturn: saleReturn(number: 0),
        lines: const [],
      ),
    );
    expect(text, contains('Retour : PROVISOIRE'));
  });
}
