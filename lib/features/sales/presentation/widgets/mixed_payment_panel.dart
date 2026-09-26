import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../providers/checkout_provider.dart';
import 'amount_input.dart';

/// Paiement mixte : part espèces + part mobile money, avec le reste à payer
/// mis à jour en direct.
class MixedPaymentPanel extends StatelessWidget {
  /// Crée le panneau mixte.
  const MixedPaymentPanel({
    required this.total,
    required this.checkout,
    required this.onCashChanged,
    required this.onMobileMoneyChanged,
    super.key,
  });

  /// Total du panier.
  final Decimal total;

  /// Brouillon de paiement courant.
  final CheckoutState checkout;

  /// Nouvelle part espèces.
  final ValueChanged<Decimal?> onCashChanged;

  /// Nouvelle part mobile money.
  final ValueChanged<Decimal?> onMobileMoneyChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final remaining = checkout.remainingFor(total);

    final Widget status;
    if (remaining == Decimal.zero) {
      status = _StatusLine(
        icon: Icons.check_circle,
        text: 'Paiement complet',
        color: cs.primary,
      );
    } else if (remaining < Decimal.zero) {
      status = _StatusLine(
        icon: Icons.error_outline,
        text: 'Dépasse le total de ${formatFcfa(-remaining)}',
        color: cs.error,
      );
    } else {
      status = Row(
        children: [
          Expanded(
            child: _StatusLine(
              icon: Icons.hourglass_bottom,
              text: 'Reste à payer : ${formatFcfa(remaining)}',
              color: cs.onSurfaceVariant,
            ),
          ),
          TextButton(
            // Complète la part mobile money avec le reste.
            onPressed: () => onMobileMoneyChanged(
              (checkout.mobileMoney ?? Decimal.zero) + remaining,
            ),
            child: const Text('Compléter'),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: AmountInput(
                label: 'Espèces',
                value: checkout.cashReceived,
                onChanged: onCashChanged,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AmountInput(
                label: 'Mobile Money',
                value: checkout.mobileMoney,
                onChanged: onMobileMoneyChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(height: AppSpacing.buttonHeightSm, child: status),
      ],
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(
            text,
            style: AppTypography.labelMedium.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
