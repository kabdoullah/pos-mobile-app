import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../domain/entities/sale.dart';
import '../providers/checkout_provider.dart';
import 'cash_payment_panel.dart';
import 'mixed_payment_panel.dart';
import 'payment_method_selector.dart';

/// Section « Paiement » de l'écran Encaisser : mode (Espèces / Mobile money /
/// Mixte), puis montant reçu, opérateur ou répartition. Le bouton de
/// validation et la monnaie restent dans la barre fixe de l'écran.
class SalePaymentSection extends StatelessWidget {
  /// Crée la section de paiement.
  const SalePaymentSection({
    required this.total,
    required this.checkout,
    required this.mode,
    required this.onModeChanged,
    required this.onOperatorSelected,
    required this.onCashChanged,
    required this.onMixedCashChanged,
    super.key,
  });

  /// Total du panier.
  final Decimal total;

  /// Brouillon de paiement courant.
  final CheckoutState checkout;

  /// Mode affiché (« Mobile money » peut être actif avant le choix de
  /// l'opérateur).
  final PaymentMode mode;

  /// Changement de mode.
  final ValueChanged<PaymentMode> onModeChanged;

  /// Choix de l'opérateur mobile money.
  final ValueChanged<PaymentMethod> onOperatorSelected;

  /// Montant reçu en espèces.
  final ValueChanged<Decimal?> onCashChanged;

  /// Espèces d'un paiement mixte.
  final ValueChanged<Decimal?> onMixedCashChanged;

  @override
  Widget build(BuildContext context) {
    final operator = mobileMoneyOperators.contains(checkout.method)
        ? checkout.method
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PaymentModeSelector(selected: mode, onSelected: onModeChanged),
        const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
        ...switch (mode) {
          PaymentMode.cash => [
            CashPaymentPanel(
              total: total,
              checkout: checkout,
              onCashChanged: onCashChanged,
            ),
          ],
          PaymentMode.mobileMoney => [
            MobileMoneyOperatorPicker(
              selected: operator,
              onSelected: onOperatorSelected,
            ),
            const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
            MobileMoneyCheckNote(amount: total),
          ],
          PaymentMode.mixed => [
            MixedPaymentPanel(
              total: total,
              checkout: checkout,
              onCashChanged: onMixedCashChanged,
            ),
          ],
        },
      ],
    );
  }
}
