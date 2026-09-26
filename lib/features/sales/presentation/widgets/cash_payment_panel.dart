import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../providers/checkout_provider.dart';
import 'amount_input.dart';

/// Paiement en espèces : montant reçu, raccourcis et monnaie à rendre.
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
    final cs = Theme.of(context).colorScheme;
    final received = checkout.cashReceived;
    final change = checkout.changeFor(total);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AmountInput(
                label: 'Montant reçu',
                hint: 'Exact : ${formatAmount(total)}',
                value: received,
                errorText: checkout.cashErrorFor(total),
                onChanged: onCashChanged,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Monnaie',
                  style: AppTypography.labelSmall.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                AmountDisplay(
                  amount: change,
                  size: AmountSize.medium,
                  color: change > Decimal.zero ? cs.primary : null,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _QuickAmountChip(
                label: 'Exact',
                isSelected: received == null || received == total,
                onTap: () => onCashChanged(null),
              ),
              for (final amount in quickCashAmounts(total)) ...[
                const SizedBox(width: AppSpacing.sm),
                _QuickAmountChip(
                  label: formatAmount(amount),
                  isSelected: received == amount,
                  onTap: () => onCashChanged(amount),
                ),
              ],
            ],
          ),
        ),
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
      onSelected: (_) => onTap(),
    );
  }
}
