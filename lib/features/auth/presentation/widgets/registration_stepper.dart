import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

/// Progression du parcours d'inscription : « Étape 2 sur 3 · Boutique » et
/// une barre de progression. Une question par écran, la progression visible.
class RegistrationStepper extends StatelessWidget {
  /// Crée un indicateur d'étapes d'inscription.
  const RegistrationStepper({required this.currentStep, super.key});

  /// Index de l'étape courante (à partir de 1). Doit être compris entre 1 et
  /// [_labels.length].
  final int currentStep;

  static const List<String> _labels = ['Compte', 'Boutique', 'Sécurité'];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final totalSteps = _labels.length;
    final label =
        'Étape $currentStep sur $totalSteps · ${_labels[currentStep - 1]}';

    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.labelLarge.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: currentStep / totalSteps),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 4,
                color: cs.primary,
                backgroundColor: cs.surfaceContainerHigh,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
