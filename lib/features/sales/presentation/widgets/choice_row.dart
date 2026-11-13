import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

/// Un choix de [ChoiceRow].
typedef Choice<T> = ({T value, String label});

/// Rangée de choix de largeurs égales (montants rapides, opérateurs) : 44 dp,
/// filet 1 dp, choix actif bordé 2 dp couleur action.
class ChoiceRow<T> extends StatelessWidget {
  /// Crée la rangée.
  const ChoiceRow({
    required this.choices,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Choix, de gauche à droite.
  final List<Choice<T>> choices;

  /// Valeur active ; `null` = aucune.
  final T? selected;

  /// Appelé au choix d'une valeur.
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (i, choice) in choices.indexed) ...[
          if (i > 0) const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _ChoiceButton(
              label: choice.label,
              isSelected: choice.value == selected,
              onTap: () => onSelected(choice.value),
            ),
          ),
        ],
      ],
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
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
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                  ),
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
