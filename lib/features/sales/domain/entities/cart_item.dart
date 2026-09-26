import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';

/// Entité CartItem — une ligne produit dans un panier.
@freezed
sealed class CartItem with _$CartItem {
  const factory CartItem({
    required String productId,
    required String productName,
    required Decimal unitPrice,
    required int quantity,

    /// Stock disponible au moment de l'ajout au panier (null = illimité).
    int? availableStock,
  }) = _CartItem;
  const CartItem._();

  /// Total de la ligne : quantité × prix unitaire (tous deux en FCFA).
  Decimal get lineTotal => unitPrice * Decimal.fromInt(quantity);
}
