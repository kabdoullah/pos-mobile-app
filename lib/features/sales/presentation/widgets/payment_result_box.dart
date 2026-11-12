import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';

/// Encadré de résultat du paiement : « À rendre au client » en 34 sp sur
/// conteneur succès, ou « Il manque … » sur conteneur erreur.
///
/// C'est le chiffre que le vendeur lit au client : jamais en petit.
class PaymentResultBox extends StatelessWidget {
  /// Monnaie à rendre au client.
  const PaymentResultBox.change(this.amount, {this.centered = false, super.key})
    : isMissing = false;

  /// Somme qui manque pour couvrir le total.
  const PaymentResultBox.missing(
    this.amount, {
    this.centered = false,
    super.key,
  }) : isMissing = true;

  /// Montant affiché.
  final Decimal amount;

  /// Vrai : il manque [amount] ; faux : [amount] est à rendre.
  final bool isMissing;

  /// Centre le contenu (feuille de confirmation).
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final (background, foreground) = isMissing
        ? (cs.errorContainer, cs.onErrorContainer)
        : (semantic.successContainer, semantic.onSuccessContainer);
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: centered
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Text(
              isMissing ? 'Il manque' : 'À rendre au client',
              style: AppTypography.bodyMedium.copyWith(
                color: foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: AmountDisplay(
                amount: amount,
                size: AmountSize.hero,
                color: foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
