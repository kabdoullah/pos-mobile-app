import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/index.dart';
import '../providers/checkout_provider.dart';
import 'amount_input.dart';
import 'choice_row.dart';

/// Paiement en espèces : montant reçu (champ mis en avant) et montants
/// rapides. La monnaie à rendre est affichée dans la barre fixe de l'écran.
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

  /// Nouveau montant reçu (`null` = exact).
  final ValueChanged<Decimal?> onCashChanged;

  @override
  Widget build(BuildContext context) {
    final received = checkout.cashReceived;
    // « Exact » (null) puis les arrondis supérieurs, 3 au plus.
    final quick = quickCashAmounts(total).take(3);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AmountInput(
          label: 'Montant reçu',
          hint: formatAmount(total),
          value: received,
          errorText: checkout.cashErrorFor(total),
          onChanged: onCashChanged,
          large: true,
        ),
        const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
        ChoiceRow<Decimal?>(
          choices: [
            (value: null, label: 'Exact'),
            for (final amount in quick)
              (value: amount, label: formatAmount(amount)),
          ],
          selected: received == total ? null : received,
          onSelected: onCashChanged,
        ),
      ],
    );
  }
}
