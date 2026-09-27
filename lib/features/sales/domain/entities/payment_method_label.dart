import 'sale.dart';

/// Libellé affiché d'un moyen de paiement.
extension PaymentMethodLabel on PaymentMethod {
  /// Libellé complet (ex. « Orange Money »).
  String get label => switch (this) {
    PaymentMethod.cash => 'Espèces',
    PaymentMethod.orangeMoney => 'Orange Money',
    PaymentMethod.mtn => 'MTN',
    PaymentMethod.wave => 'Wave',
    PaymentMethod.mixed => 'Mixte',
  };
}
