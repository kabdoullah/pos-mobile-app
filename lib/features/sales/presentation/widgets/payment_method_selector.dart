import 'package:flutter/material.dart';

import '../../../../core/widgets/index.dart';
import '../../domain/entities/sale.dart';
import 'choice_row.dart';

/// Mode de paiement affiché à l'écran Encaisser. « Mobile money » regroupe
/// les trois opérateurs ([PaymentMethod.orangeMoney], [PaymentMethod.mtn],
/// [PaymentMethod.wave]), choisis ensuite avec [MobileMoneyOperatorPicker].
enum PaymentMode {
  /// Espèces.
  cash,

  /// Mobile money (un opérateur).
  mobileMoney,

  /// Espèces + mobile money.
  mixed;

  /// Mode correspondant à un moyen de paiement enregistré.
  static PaymentMode of(PaymentMethod method) => switch (method) {
    PaymentMethod.cash => cash,
    PaymentMethod.mixed => mixed,
    PaymentMethod.orangeMoney ||
    PaymentMethod.mtn ||
    PaymentMethod.wave => mobileMoney,
  };
}

/// Opérateurs mobile money, dans l'ordre d'affichage.
const mobileMoneyOperators = [
  PaymentMethod.orangeMoney,
  PaymentMethod.mtn,
  PaymentMethod.wave,
];

/// Nom affiché d'un moyen de paiement à l'écran Encaisser.
String paymentMethodLabel(PaymentMethod method) => switch (method) {
  PaymentMethod.cash => 'Espèces',
  PaymentMethod.orangeMoney => 'Orange Money',
  PaymentMethod.mtn => 'MTN',
  PaymentMethod.wave => 'Wave',
  PaymentMethod.mixed => 'Mixte',
};

/// Contrôle segmenté Espèces / Mobile money / Mixte.
class PaymentModeSelector extends StatelessWidget {
  /// Crée le sélecteur.
  const PaymentModeSelector({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Mode actif.
  final PaymentMode selected;

  /// Appelé au choix d'un mode.
  final ValueChanged<PaymentMode> onSelected;

  @override
  Widget build(BuildContext context) {
    return SegmentedControl<PaymentMode>(
      segments: const [
        (value: PaymentMode.cash, label: 'Espèces'),
        (value: PaymentMode.mobileMoney, label: 'Mobile money'),
        (value: PaymentMode.mixed, label: 'Mixte'),
      ],
      selected: selected,
      onChanged: onSelected,
    );
  }
}

/// Choix de l'opérateur mobile money : Orange Money / MTN / Wave.
class MobileMoneyOperatorPicker extends StatelessWidget {
  /// Crée le choix d'opérateur.
  const MobileMoneyOperatorPicker({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Opérateur choisi ; `null` = pas encore choisi.
  final PaymentMethod? selected;

  /// Appelé au choix d'un opérateur.
  final ValueChanged<PaymentMethod> onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceRow<PaymentMethod>(
      choices: [
        for (final method in mobileMoneyOperators)
          (value: method, label: paymentMethodLabel(method)),
      ],
      selected: selected,
      onSelected: onSelected,
    );
  }
}
