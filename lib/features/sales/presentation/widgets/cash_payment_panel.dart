import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/index.dart';
import '../providers/checkout_provider.dart';
import 'amount_input.dart';
import 'payment_result_box.dart';

/// Paiement en espèces : montant reçu en grand, montants rapides, puis
/// « À rendre au client » (ou « Il manque … ») recalculé à chaque frappe.
///
/// Champ vide = montant exact : une vente sans rendu de monnaie se valide
/// sans saisie.
class CashPaymentPanel extends StatelessWidget {
  /// Crée le panneau espèces.
  const CashPaymentPanel({
    required this.total,
    required this.checkout,
    required this.onCashChanged,
    super.key,
  });

  /// Total du panier.
  final Decimal total;

  /// Brouillon de paiement courant.
  final CheckoutState checkout;

  /// Nouveau montant reçu.
  final ValueChanged<Decimal?> onCashChanged;

  @override
  Widget build(BuildContext context) {
    final received = checkout.cashReceived;
    final missing = received == null ? Decimal.zero : total - received;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AmountInput(
          label: 'Montant reçu',
          hint: formatAmount(total),
          value: received,
          large: true,
          onChanged: onCashChanged,
        ),
        const SizedBox(height: AppSpacing.sm + 4),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _QuickAmountChip(
              label: 'Exact',
              isSelected: received == null || received == total,
              onTap: () => onCashChanged(null),
            ),
            for (final amount in quickCashAmounts(total))
              _QuickAmountChip(
                label: formatAmount(amount),
                isSelected: received == amount,
                onTap: () => onCashChanged(amount),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (missing > Decimal.zero)
          PaymentResultBox.missing(missing)
        else
          PaymentResultBox.change(checkout.changeFor(total)),
      ],
    );
  }
}

class _QuickAmountChip extends StatelessWidget {
  const _QuickAmountChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      showCheckmark: false,
      // Cible de 48 dp autour d'une puce de 40.
      materialTapTargetSize: MaterialTapTargetSize.padded,
      onSelected: (_) => onTap(),
    );
  }
}
