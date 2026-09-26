import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
    required Decimal totalAmount,
    required Decimal vatAmount,
    required PaymentMethod paymentMethod,
    required DateTime createdAt,
  }) = _Sale;
}
