import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../providers/checkout_provider.dart';
import 'amount_input.dart';

/// Paiement mixte : espèces reçues ; le reste, payé en mobile money, se
/// calcule seul.
class MixedPaymentPanel extends StatelessWidget {
  /// Crée le panneau mixte.
  const MixedPaymentPanel({
    required this.total,
    required this.checkout,
    required this.onCashChanged,
    super.key,
  });

  /// Total du panier.
  final Decimal total;

  /// Brouillon de paiement courant.
  final CheckoutState checkout;

  /// Nouvelles espèces reçues.
  final ValueChanged<Decimal?> onCashChanged;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final mobile = checkout.mobileMoney;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AmountInput(
          label: 'Espèces reçues',
          value: checkout.cashReceived,
          onChanged: onCashChanged,
          large: true,
        ),
        const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Reste en mobile money · '),
              TextSpan(
                text: mobile == null ? '—' : formatFcfa(mobile),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          style: AppTypography.bodyStrong.copyWith(
            fontSize: 15,
            color: colors.textPrimary,
            fontFeatures: AppTypography.tabularFigures,
          ),
        ),
        if (mobile != null && mobile > Decimal.zero) ...[
          const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
          MobileMoneyCheckNote(amount: mobile),
        ],
      ],
    );
  }
}

/// Rappel avant de valider un paiement mobile money : vérifier le SMS de
/// réception de [amount].
class MobileMoneyCheckNote extends StatelessWidget {
  /// Crée le rappel.
  const MobileMoneyCheckNote({required this.amount, super.key});

  /// Montant attendu en mobile money.
  final Decimal amount;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Text(
      'Vérifiez sur votre téléphone le SMS de réception de '
      '${formatFcfa(amount)} avant de valider.',
      style: AppTypography.body.copyWith(
        fontSize: 15,
        height: 1.4,
        color: colors.textSecondary,
      ),
    );
  }
}
