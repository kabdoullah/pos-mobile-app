import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

/// Progression de l'inscription en 3 étapes : « Étape N sur 3 » et une
/// barre fine (2 dp) couleur action.
class RegistrationStepper extends StatelessWidget {
  /// Crée l'indicateur d'étapes.
  const RegistrationStepper({required this.currentStep, super.key});

  /// Index de l'étape courante (à partir de 1), entre 1 et 3.
  final int currentStep;

  static const List<String> _labels = ['Compte', 'Boutique', 'Sécurité'];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final total = _labels.length;
    return Semantics(
      label: 'Étape $currentStep sur $total : ${_labels[currentStep - 1]}',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Étape $currentStep sur $total',
              style: AppTypography.bodySmall.copyWith(
                color: colors.textSecondary,
                fontFeatures: AppTypography.tabularFigures,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(1),
            child: SizedBox(
              height: 2,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(color: colors.border),
                  AnimatedFractionallySizedBox(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.centerLeft,
                    widthFactor: currentStep / total,
                    child: ColoredBox(color: colors.action),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
