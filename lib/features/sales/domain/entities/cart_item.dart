import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'discount.dart';

part 'cart_item.freezed.dart';

/// Entité CartItem — une ligne produit dans un panier, ou une ligne d'une vente
/// enregistrée (instantané des prix au moment de la vente, ADR-0009).
@freezed
sealed class CartItem with _$CartItem {
  const factory CartItem({
    required String productId,
    required String productName,

    /// Prix de vente unitaire au moment de l'ajout au panier.
    required Decimal unitPrice,
    required int quantity,

    /// Stock disponible au moment de l'ajout au panier (null = illimité).
    int? availableStock,

    /// Prix d'achat unitaire au moment de l'ajout (null = non renseigné).
    /// Donnée interne : jamais affichée au client.
    Decimal? purchaseUnitPrice,

    /// Réduction de la ligne (null = aucune).
    Discount? discount,
  }) = _CartItem;
  const CartItem._();

  /// Total brut de la ligne : quantité × prix unitaire (FCFA).
  Decimal get grossTotal => unitPrice * Decimal.fromInt(quantity);

  /// Montant de la réduction de la ligne (0 sans réduction).
  Decimal get discountAmount => discount?.amountOn(grossTotal) ?? Decimal.zero;

  /// Total net de la ligne : brut − réduction, jamais négatif.
  Decimal get lineTotal => grossTotal - discountAmount;

  /// Copie avec une nouvelle quantité ; la réduction est ajustée au nouveau
  /// total brut (voir [Discount.fitTo]).
  CartItem withQuantity(int newQuantity) {
    final updated = copyWith(quantity: newQuantity);
    return updated.copyWith(discount: discount?.fitTo(updated.grossTotal));
  }

  /// Coût d'achat de la ligne ; `null` si le prix d'achat est inconnu.
  Decimal? get purchaseCost {
    final cost = purchaseUnitPrice;
    return cost == null ? null : cost * Decimal.fromInt(quantity);
  }

  /// Marge réelle de la ligne (total net − coût) ; `null` si le coût est
  /// inconnu. Ne tient pas compte d'une remise globale sur la vente.
  Decimal? get margin {
    final cost = purchaseCost;
    return cost == null ? null : lineTotal - cost;
  }
}
