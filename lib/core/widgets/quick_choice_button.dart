import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Choix rapide v2 (montant proposé, motif, opérateur) : 44 dp, filet 1 dp,
/// choix actif bordé 2 dp couleur action. Largeur du contenu ; pour des
/// largeurs égales, l'envelopper dans un `Expanded`.
class QuickChoiceButton extends StatelessWidget {
  /// Crée le bouton.
  const QuickChoiceButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  /// Libellé.
  final String label;

  /// Choix actif.
  final bool isSelected;

  /// Appelé au toucher.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final radius = BorderRadius.circular(AppSpacing.radiusSm);
    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: isSelected
              ? BorderSide(color: colors.action, width: 2)
              : BorderSide(color: colors.border),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Center(
                widthFactor: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: AppTypography.bodyStrong.copyWith(
                      fontSize: 15,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      fontFeatures: AppTypography.tabularFigures,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
