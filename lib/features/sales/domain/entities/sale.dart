import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'discount.dart';

part 'sale.freezed.dart';

/// Enum PaymentMethod — moyens de paiement disponibles.
enum PaymentMethod {
  /// Paiement en espèces.
  cash,

  /// Orange Money (mobile money).
  orangeMoney,

  /// MTN mobile money.
  mtn,

  /// Wave mobile money.
  wave,

  /// Paiement mixte (espèces + mobile money).
  mixed,
}

/// Entité vente — enregistrement de vente immuable.
@freezed
sealed class Sale with _$Sale {
  const factory Sale({
    required String id,
    required int receiptNumber,

    /// Total encaissé, remise globale déduite.
    required Decimal totalAmount,
    required Decimal vatAmount,
    required PaymentMethod paymentMethod,
    required DateTime createdAt,

    /// Remise globale sur la vente (null = aucune), distincte des réductions
    /// de ligne (ADR-0009).
    Discount? discount,

    /// Montant de la remise globale tel qu'enregistré à la vente.
    required Decimal discountAmount,
  }) = _Sale;

  const Sale._();

  /// Sous-total avant remise globale (somme des totaux nets des lignes).
  Decimal get subtotalAmount => totalAmount + discountAmount;
}
