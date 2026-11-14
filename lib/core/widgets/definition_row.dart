import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Ligne d'une liste de définitions v2 (récapitulatifs de caisse, détails) :
/// libellé à gauche en texte secondaire, valeur 16/500 tabulaire à droite,
/// filet dessous.
class DefinitionRow extends StatelessWidget {
  /// Crée la ligne.
  const DefinitionRow({
    required this.label,
    required this.value,
    this.emphasized = false,
    this.color,
    this.showDivider = true,
    this.semanticsLabel,
    super.key,
  });

  /// Libellé.
  final String label;

  /// Valeur affichée (montant formaté, texte court).
  final String value;

  /// Ligne de total : libellé et valeur en texte principal 600.
  final bool emphasized;

  /// Couleur sémantique du libellé et de la valeur (écart, erreur).
  final Color? color;

  /// Filet sous la ligne.
  final bool showDivider;

  /// Lecture d'écran (ex. « plus 40 175 FCFA ») ; par défaut libellé et
  /// valeur.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final labelColor =
        color ?? (emphasized ? colors.textPrimary : colors.textSecondary);
    final weight = emphasized || color != null
        ? FontWeight.w600
        : FontWeight.w500;
    return Semantics(
      container: true,
      label: semanticsLabel ?? '$label : $value',
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: showDivider
              ? Border(bottom: BorderSide(color: colors.border))
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.body.copyWith(
                    color: labelColor,
                    fontWeight: emphasized || color != null
                        ? FontWeight.w600
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                value,
                style: AppTypography.bodyStrong.copyWith(
                  color: color ?? colors.textPrimary,
                  fontWeight: weight,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
