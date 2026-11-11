import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../providers/checkout_provider.dart';
import 'amount_input.dart';

/// Paiement mixte : espèces reçues, puis le reste en mobile money se calcule
/// seul.
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

  /// Nouvelle part espèces (la part mobile money en découle).
  final ValueChanged<Decimal?> onCashChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final mobile = checkout.mobileMoney;
    // Une saisie en cours (champ vide) n'est pas encore une erreur.
    final error = checkout.cashReceived == null
        ? null
        : checkout.mixedErrorFor(total);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AmountInput(
          label: '1. Espèces reçues',
          value: checkout.cashReceived,
          large: true,
          errorText: error,
          onChanged: onCashChanged,
        ),
        const SizedBox(height: AppSpacing.md),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: '2. Reste en mobile money : '),
              TextSpan(
                text: mobile == null ? '—' : formatFcfa(mobile),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
            ],
          ),
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
        if (mobile != null && mobile > Decimal.zero) ...[
          const SizedBox(height: AppSpacing.sm),
          MobileMoneyCheckHint(amount: mobile),
        ],
      ],
    );
  }
}

/// Rappel avant de valider un paiement mobile money : vérifier le message de
/// réception sur le téléphone.
class MobileMoneyCheckHint extends StatelessWidget {
  /// Crée le rappel pour [amount].
  const MobileMoneyCheckHint({required this.amount, super.key});

  /// Montant attendu en mobile money.
  final Decimal amount;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Vérifiez sur votre téléphone le message de réception de '
      '${formatFcfa(amount)} avant de valider.',
      style: AppTypography.bodyMedium.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        height: 1.4,
      ),
    );
  }
}
