import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../refund_calculator.dart';

part 'returnable_line.freezed.dart';

/// Ligne d'une vente vue depuis l'écran de retour : quantités déjà rendues et
/// montant réellement payé (valeurs figées à la vente, jamais le prix actuel).
@freezed
sealed class ReturnableLine with _$ReturnableLine {
  /// Crée une [ReturnableLine].
  const factory ReturnableLine({
    required String saleItemId,

    /// Produit (null si supprimé côté serveur).
    String? productId,
    required String productName,

    /// Prix unitaire figé à la vente.
    required Decimal unitPrice,

    /// Réduction de la ligne figée à la vente.
    required Decimal discountAmount,
    required int soldQuantity,

    /// Quantité déjà rendue (retours refusés par le serveur exclus).
    required int returnedQuantity,

    /// Part du total encaissé de la vente, remise globale répartie.
    required Decimal paidAmount,
  }) = _ReturnableLine;

  const ReturnableLine._();

  /// Quantité encore retournable.
  int get returnableQuantity => soldQuantity - returnedQuantity;

  /// Montant remboursable pour [quantity] unités rendues maintenant.
  Decimal refundFor(int quantity) => RefundCalculator.refundFor(
    paid: paidAmount,
    sold: soldQuantity,
    alreadyReturned: returnedQuantity,
    quantity: quantity,
  );
}
