import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'discount.freezed.dart';

/// Nature d'une réduction (ADR-0009).
enum DiscountType {
  /// Montant fixe en FCFA retiré du total concerné.
  amount,

  /// Pourcentage du total concerné.
  percentage,
}

/// Réduction appliquée à une ligne du panier ou à toute la vente (ADR-0009).
///
/// La réduction porte sur un total brut (ligne : prix × quantité ; vente :
/// sous-total), jamais sur le prix catalogue du produit.
@freezed
sealed class Discount with _$Discount {
  /// Crée une réduction. Utiliser [validate] avant de l'appliquer.
  const factory Discount({
    required DiscountType type,

    /// Montant en FCFA ([DiscountType.amount]) ou pourcentage
    /// ([DiscountType.percentage]).
    required Decimal value,
  }) = _Discount;

  const Discount._();

  static final Decimal _hundred = Decimal.fromInt(100);

  /// Montant retiré de [gross], plafonné à [gross] (jamais de total négatif).
  ///
  /// Un pourcentage est arrondi au franc entier, demi vers le haut.
  Decimal amountOn(Decimal gross) {
    if (gross <= Decimal.zero || value <= Decimal.zero) return Decimal.zero;
    final raw = switch (type) {
      DiscountType.amount => value,
      DiscountType.percentage => Decimal.fromBigInt(
        (gross * value / _hundred).round(),
      ),
    };
    return raw > gross ? gross : raw;
  }

  /// Réduction ajustée à un nouveau [gross] (quantité ou panier modifié) :
  /// un montant supérieur à [gross] est ramené à [gross] ; `null` si [gross]
  /// est nul (plus rien à réduire). Un pourcentage reste inchangé.
  Discount? fitTo(Decimal gross) {
    if (gross <= Decimal.zero) return null;
    if (type == DiscountType.amount && value > gross) {
      return copyWith(value: gross);
    }
    return this;
  }

  /// Message d'erreur si la réduction est invalide pour [gross], sinon `null`.
  ///
  /// Règles : valeur strictement positive, pourcentage ≤ 100, montant ≤ [gross].
  String? validate(Decimal gross) {
    if (value <= Decimal.zero) return 'La réduction doit être positive';
    switch (type) {
      case DiscountType.percentage:
        if (value > _hundred) return 'Le pourcentage ne peut dépasser 100 %';
      case DiscountType.amount:
        if (value > gross) return 'La réduction dépasse le montant';
    }
    return null;
  }
}
