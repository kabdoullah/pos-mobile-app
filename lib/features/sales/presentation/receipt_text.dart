import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/phone_formatter.dart';
import '../../../core/widgets/index.dart';
import '../../auth/domain/entities/store.dart';
import '../domain/entities/cart_item.dart';
import '../domain/entities/payment_method_label.dart';
import '../domain/entities/sale.dart';

/// Reçu d'une vente en texte, à envoyer par WhatsApp.
///
/// Mêmes rubriques que le ticket imprimé (`ReceiptFormatter`), mais une
/// information par ligne : WhatsApp n'a pas de police à chasse fixe, des
/// colonnes alignées s'y décaleraient. `*…*` = gras dans WhatsApp.
///
/// Vente non synchronisée ([Sale.receiptNumber] = 0) : reçu provisoire, sans
/// numéro. [items] null : articles indisponibles, le total reste envoyé.
String buildReceiptText({
  required Store store,
  required Sale sale,
  List<CartItem>? items,
  String? sellerName,
}) {
  final lines = <String>['*${store.name}*'];
  void addIfPresent(String? value, [String prefix = '']) {
    if (value != null && value.isNotEmpty) lines.add('$prefix$value');
  }

  addIfPresent(store.address);
  addIfPresent(store.ncc, 'NCC : ');
  final phone = store.phone;
  if (phone != null && phone.isNotEmpty) {
    lines.add('Tél. ${formatPhoneCiDisplay(phone)}');
  }

  lines
    ..add('')
    ..add(
      sale.receiptNumber > 0
          ? 'Reçu n° ${sale.receiptNumber.toString().padLeft(6, '0')}'
          : 'Reçu provisoire (n° attribué à la synchronisation)',
    )
    ..add(DateFormat('dd/MM/yyyy HH:mm', 'fr_FR').format(sale.createdAt));
  addIfPresent(sellerName, 'Vendeur : ');

  if (items != null && items.isNotEmpty) {
    lines.add('');
    for (final item in items) {
      lines.add(
        '${item.productName} × ${item.quantity} : '
        '${formatFcfa(item.grossTotal)}',
      );
      if (item.discountAmount > Decimal.zero) {
        lines.add('  Réduction : −${formatFcfa(item.discountAmount)}');
      }
    }
  }

  lines.add('');
  // Remise globale (ADR-0009) : sous-total des lignes puis remise.
  if (sale.discountAmount > Decimal.zero) {
    lines
      ..add('Sous-total : ${formatFcfa(sale.subtotalAmount)}')
      ..add('Remise : −${formatFcfa(sale.discountAmount)}');
  }
  if (sale.vatAmount != Decimal.zero) {
    lines
      ..add('Total HT : ${formatFcfa(sale.totalAmount - sale.vatAmount)}')
      ..add('TVA : ${formatFcfa(sale.vatAmount)}')
      ..add('*Total TTC : ${formatFcfa(sale.totalAmount)}*');
  } else {
    lines.add('*Total : ${formatFcfa(sale.totalAmount)}*');
  }
  lines
    ..add('Paiement : ${sale.paymentMethod.label}')
    ..add('');
  addIfPresent(store.receiptFooterText);
  lines.add('Merci de votre visite !');

  return lines.join('\n');
}
