import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/sale.dart';

part 'checkout_provider.g.dart';

/// Coupures proposées en raccourci pour le montant reçu en espèces.
const _cashRoundingSteps = [1000, 5000, 10000];

/// Brouillon de paiement de la caisse : moyen choisi et montants saisis.
///
/// Les règles définitives restent dans `CreateSaleUseCase` ; cet état ne sert
/// qu'à guider la saisie (monnaie, reste à payer, bouton activé ou non).
class CheckoutState {
  /// Crée un brouillon de paiement. Espèces par défaut : c'est le cas le plus
  /// fréquent en caisse.
  const CheckoutState({
    this.method = PaymentMethod.cash,
    this.cashReceived,
    this.mobileMoney,
  });

  /// Moyen de paiement sélectionné.
  final PaymentMethod method;

  /// Espèces saisies : montant reçu (espèces) ou part espèces (mixte). `null`
  /// si le champ est vide.
  final Decimal? cashReceived;

  /// Part mobile money d'un paiement mixte. `null` si le champ est vide.
  final Decimal? mobileMoney;

  /// Monnaie à rendre en espèces. Un champ vide vaut « montant exact ».
  Decimal changeFor(Decimal total) {
    if (method != PaymentMethod.cash) return Decimal.zero;
    final change = (cashReceived ?? total) - total;
    return change > Decimal.zero ? change : Decimal.zero;
  }

  /// Reste à payer d'un paiement mixte (négatif si les montants dépassent le
  /// total).
  Decimal remainingFor(Decimal total) {
    final paid = (cashReceived ?? Decimal.zero) + (mobileMoney ?? Decimal.zero);
    return total - paid;
  }

  /// Message d'erreur à afficher sous le champ espèces, sinon `null`.
  String? cashErrorFor(Decimal total) {
    final cash = cashReceived;
    if (method == PaymentMethod.cash && cash != null && cash < total) {
      return 'Montant insuffisant';
    }
    return null;
  }

  /// Indique si la vente peut être encaissée pour ce [total].
  bool canSubmitFor(Decimal total) {
    return switch (method) {
      PaymentMethod.cash => cashErrorFor(total) == null,
      PaymentMethod.mixed => remainingFor(total) == Decimal.zero,
      PaymentMethod.orangeMoney ||
      PaymentMethod.mtn ||
      PaymentMethod.wave => true,
    };
  }
}

/// Raccourcis de montant reçu : les arrondis supérieurs du [total] aux
/// coupures courantes (1 000, 5 000, 10 000), sans doublon, triés.
List<Decimal> quickCashAmounts(Decimal total) {
  final amounts = <Decimal>{};
  for (final step in _cashRoundingSteps) {
    final stepDecimal = Decimal.fromInt(step);
    final rounded =
        Decimal.fromBigInt((total / stepDecimal).ceil()) * stepDecimal;
    if (rounded > total) amounts.add(rounded);
  }
  return amounts.toList()..sort();
}

/// Brouillon de paiement de l'écran de caisse.
///
/// Auto-dispose : l'écran de caisse le `watch` pendant toute sa durée de vie.
@riverpod
class Checkout extends _$Checkout {
  @override
  CheckoutState build() => const CheckoutState();

  /// Change de moyen de paiement et efface les montants saisis.
  void selectMethod(PaymentMethod method) {
    state = CheckoutState(method: method);
  }

  /// Met à jour le montant espèces saisi.
  void setCashReceived(Decimal? amount) {
    state = CheckoutState(
      method: state.method,
      cashReceived: amount,
      mobileMoney: state.mobileMoney,
    );
  }

  /// Met à jour la part mobile money d'un paiement mixte.
  void setMobileMoney(Decimal? amount) {
    state = CheckoutState(
      method: state.method,
      cashReceived: state.cashReceived,
      mobileMoney: amount,
    );
  }

  /// Revient au brouillon initial (après une vente).
  void reset() {
    state = const CheckoutState();
  }
}
