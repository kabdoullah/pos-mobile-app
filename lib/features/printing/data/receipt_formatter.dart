import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../core/utils/phone_formatter.dart';
import '../../auth/domain/entities/store.dart';
import '../../sales/domain/entities/cart_item.dart';
import '../../sales/domain/entities/sale.dart';

/// Met en forme les données du reçu en séquences d'octets ESC/POS pour papier
/// thermique 58 mm.
///
/// Largeur du reçu : 32 caractères à chasse fixe.
class ReceiptFormatter {
  static final _log = Logger();

  static const int _lineWidth = 32;
  static const String _separator = '--------------------------------';
  static const String _doubleSeparator = '================================';

  /// Construit les octets ESC/POS du reçu de la vente donnée.
  ///
  /// [items] peut être null lors d'une impression depuis l'historique (données
  /// de session hors ligne indisponibles).
  /// Lève une [Exception] si la mise en forme échoue.
  static Future<List<int>> format({
    required Store store,
    required Sale sale,
    List<CartItem>? items,
    String? sellerName,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    final bytes = <int>[];

    // --- EN-TÊTE ---
    bytes.addAll(_header(generator, store));

    // --- DATE / INFOS DU REÇU ---
    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm', 'fr_FR');
    bytes.addAll(
      _text(generator, 'Date : ${dateFormatter.format(sale.createdAt)}'),
    );
    bytes.addAll(
      _text(
        generator,
        sale.receiptNumber > 0
            ? 'Reçu N° ${sale.receiptNumber.toString().padLeft(6, '0')}'
            : 'Reçu : PROVISOIRE',
      ),
    );
    if (sellerName != null && sellerName.isNotEmpty) {
      bytes.addAll(_text(generator, 'Vendeur : $sellerName'));
    }
    bytes.addAll(_text(generator, _separator));

    // --- ARTICLES ---
    if (items != null && items.isNotEmpty) {
      bytes.addAll(
        _text(
          generator,
          '${items.length} article${items.length > 1 ? 's' : ''}',
        ),
      );
      for (final item in items) {
        bytes.addAll(_formatLineItem(generator, item));
      }
    } else {
      bytes.addAll(
        _text(
          generator,
          'Ticket provisoire - articles non disponibles',
          styles: const PosStyles(align: PosAlign.center),
        ),
      );
    }
    bytes.addAll(_text(generator, _separator));

    // --- TOTAUX ---
    if (sale.vatAmount != Decimal.zero) {
      final htAmount = sale.totalAmount - sale.vatAmount;
      bytes.addAll(
        _text(generator, _padLine('Sous-total HT', _formatFcfa(htAmount))),
      );
      bytes.addAll(
        _text(generator, _padLine('TVA', _formatFcfa(sale.vatAmount))),
      );
      bytes.addAll(_text(generator, _doubleSeparator));
      bytes.addAll(
        _text(
          generator,
          _padLine('TOTAL TTC', _formatFcfa(sale.totalAmount)),
          styles: const PosStyles(bold: true),
        ),
      );
    } else {
      bytes.addAll(_text(generator, _doubleSeparator));
      bytes.addAll(
        _text(
          generator,
          _padLine('TOTAL', _formatFcfa(sale.totalAmount)),
          styles: const PosStyles(bold: true),
        ),
      );
    }
    bytes.addAll(_text(generator, _separator));

    // --- PAIEMENT ---
    bytes.addAll(
      _text(generator, 'Mode : ${_paymentLabel(sale.paymentMethod)}'),
    );
    bytes.addAll(_text(generator, _separator));

    // --- PIED DE PAGE ---
    bytes.addAll(_footer(generator, store));
    bytes.addAll(generator.cut());

    _log.d('Receipt formatted: ${bytes.length} bytes');
    return bytes;
  }

  /// Construit les octets ESC/POS d'un ticket de test : en-tête, mention
  /// « Test d'impression », date et pied de page — sans numéro de reçu.
  static Future<List<int>> formatTestPage({required Store store}) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm', 'fr_FR');
    return [
      ..._header(generator, store),
      ..._text(
        generator,
        "TEST D'IMPRESSION",
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ),
      ..._text(
        generator,
        dateFormatter.format(DateTime.now()),
        styles: const PosStyles(align: PosAlign.center),
      ),
      ..._text(generator, "L'imprimante fonctionne."),
      ..._text(generator, _separator),
      ..._footer(generator, store),
      ...generator.cut(),
    ];
  }

  /// En-tête commun : nom de la boutique, NCC, adresse, séparateur.
  static List<int> _header(Generator generator, Store store) {
    final bytes = <int>[];
    bytes.addAll(
      _text(
        generator,
        store.name,
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ),
    );
    if (store.ncc != null && store.ncc!.isNotEmpty) {
      bytes.addAll(
        _text(
          generator,
          'NCC: ${store.ncc}',
          styles: const PosStyles(align: PosAlign.center),
        ),
      );
    }
    if (store.address != null && store.address!.isNotEmpty) {
      bytes.addAll(
        _text(
          generator,
          store.address!,
          styles: const PosStyles(align: PosAlign.center),
        ),
      );
    }
    final phone = store.phone;
    if (phone != null && phone.isNotEmpty) {
      bytes.addAll(
        _text(
          generator,
          'Tél. ${formatPhoneCiDisplay(phone)}',
          styles: const PosStyles(align: PosAlign.center),
        ),
      );
    }
    bytes.addAll(_text(generator, _separator));
    return bytes;
  }

  /// Pied de page commun : texte personnalisé puis remerciement.
  static List<int> _footer(Generator generator, Store store) {
    final bytes = <int>[];
    if (store.receiptFooterText != null &&
        store.receiptFooterText!.isNotEmpty) {
      bytes.addAll(
        _text(
          generator,
          store.receiptFooterText!,
          styles: const PosStyles(align: PosAlign.center),
        ),
      );
    }
    bytes.addAll(
      _text(
        generator,
        'Merci de votre visite !',
        styles: const PosStyles(align: PosAlign.center),
      ),
    );
    return bytes;
  }

  /// Remplacements des caractères absents du jeu Latin-1 de l'imprimante
  /// (fréquents dans les saisies au clavier du téléphone et les montants
  /// formatés en fr_FR).
  static const Map<String, String> _latin1Replacements = {
    '\u2019': "'", // apostrophe typographique ’
    '\u2018': "'",
    '\u201C': '"',
    '\u201D': '"',
    '\u2014': '-', // tiret cadratin —
    '\u2013': '-',
    '\u2026': '...',
    '\u202F': ' ', // espace fine insécable (séparateur de milliers fr_FR)
    '\u2009': ' ',
    '\u20AC': 'EUR',
  };

  /// Rend [text] imprimable : l'encodeur ESC/POS lève une exception sur tout
  /// caractère hors Latin-1, ce qui ferait échouer l'impression entière (un
  /// produit nommé « L’eau » suffirait).
  @visibleForTesting
  static String printable(String text) {
    final buffer = StringBuffer();
    for (final rune in text.runes) {
      if (rune <= 0xFF) {
        buffer.writeCharCode(rune);
      } else {
        buffer.write(_latin1Replacements[String.fromCharCode(rune)] ?? '?');
      }
    }
    return buffer.toString();
  }

  static List<int> _text(
    Generator generator,
    String text, {
    PosStyles styles = const PosStyles(),
  }) => generator.text(printable(text), styles: styles);

  /// Article sur deux lignes : nom du produit en ligne 1, qté × prix unitaire =
  /// total en ligne 2.
  static List<int> _formatLineItem(Generator gen, CartItem item) {
    final name = item.productName.length > _lineWidth
        ? '${item.productName.substring(0, _lineWidth - 3)}...'
        : item.productName;
    final detail = _padLine(
      '  ${item.quantity} x ${_formatFcfa(item.unitPrice)}',
      _formatFcfa(item.lineTotal),
    );
    return [..._text(gen, name), ..._text(gen, detail)];
  }

  /// Texte aligné à gauche et à droite, complété à [_lineWidth] caractères.
  static String _padLine(String left, String right) {
    final total = left.length + right.length;
    if (total >= _lineWidth) return '$left $right';
    return left + ' ' * (_lineWidth - total) + right;
  }

  /// Formate un montant Decimal en chaîne FCFA localisée.
  static String _formatFcfa(Decimal amount) {
    return NumberFormat('#,##0', 'fr_FR').format(amount.toDouble());
  }

  /// Retourne le libellé localisé du moyen de paiement.
  static String _paymentLabel(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cash => 'Espèces',
      PaymentMethod.orangeMoney => 'Orange Money',
      PaymentMethod.mtn => 'MTN Mobile Money',
      PaymentMethod.wave => 'Wave',
      PaymentMethod.mixed => 'Mixte',
    };
  }
}
