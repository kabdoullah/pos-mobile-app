import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';

/// État de la caisse à la clôture : écart (compté moins théorique) nul,
/// positif ou négatif.
enum DiscrepancyKind {
  /// Écart nul.
  balanced,

  /// Plus d'espèces que prévu.
  surplus,

  /// Moins d'espèces que prévu.
  deficit;

  /// État correspondant à l'écart [discrepancy].
  static DiscrepancyKind of(Decimal discrepancy) => discrepancy == Decimal.zero
      ? balanced
      : discrepancy > Decimal.zero
      ? surplus
      : deficit;
}

/// Libellé français de l'écart : « Caisse équilibrée », « Excédent de X » ou
/// « Déficit de X » (X en valeur absolue, en FCFA).
String discrepancyLabel(Decimal discrepancy) =>
    switch (DiscrepancyKind.of(discrepancy)) {
      DiscrepancyKind.balanced => 'Caisse équilibrée',
      DiscrepancyKind.surplus => 'Excédent de ${formatFcfa(discrepancy)}',
      DiscrepancyKind.deficit => 'Déficit de ${formatFcfa(discrepancy.abs())}',
    };

/// Couleurs (fond, texte) de l'écart : succès si équilibrée, avertissement
/// pour un excédent, erreur pour un déficit. Paires « conteneur / texte sur
/// conteneur » du thème : lisibles (≥ 4,5:1) en clair comme en sombre.
({Color background, Color foreground}) discrepancyColors(
  BuildContext context,
  Decimal discrepancy,
) {
  final cs = Theme.of(context).colorScheme;
  final semantic = Theme.of(context).extension<AppSemanticColors>()!;
  return switch (DiscrepancyKind.of(discrepancy)) {
    DiscrepancyKind.balanced => (
      background: semantic.successContainer,
      foreground: semantic.success,
    ),
    DiscrepancyKind.surplus => (
      background: cs.tertiaryContainer,
      foreground: cs.onTertiaryContainer,
    ),
    DiscrepancyKind.deficit => (
      background: cs.errorContainer,
      foreground: cs.onErrorContainer,
    ),
  };
}

/// Pastille d'état de la caisse : équilibrée, excédent ou déficit.
class DiscrepancyBadge extends StatelessWidget {
  /// Crée la pastille pour l'écart [discrepancy].
  const DiscrepancyBadge({required this.discrepancy, super.key});

  /// Écart : montant compté moins solde théorique.
  final Decimal discrepancy;

  @override
  Widget build(BuildContext context) {
    final colors = discrepancyColors(context, discrepancy);
    final color = colors.foreground;
    final label = discrepancyLabel(discrepancy);
    final icon = switch (DiscrepancyKind.of(discrepancy)) {
      DiscrepancyKind.balanced => Icons.check_circle_outline,
      DiscrepancyKind.surplus => Icons.trending_up,
      DiscrepancyKind.deficit => Icons.trending_down,
    };
    return Semantics(
      container: true,
      label: label,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  label,
                  style: AppTypography.labelLarge.copyWith(
                    color: color,
                    fontFeatures: AppTypography.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
