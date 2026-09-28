import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

/// Sélecteur de quantité [-] n [+] ; la valeur s'anime à chaque changement.
class QuantityStepper extends StatelessWidget {
  /// Crée un sélecteur de quantité. Un callback `null` désactive le bouton.
  const QuantityStepper({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
    this.large = false,
    this.field,
    super.key,
  });

  /// Quantité affichée.
  final int quantity;

  /// Diminue la quantité.
  final VoidCallback? onDecrease;

  /// Augmente la quantité.
  final VoidCallback? onIncrease;

  /// Variante agrandie (feuille de quantité).
  final bool large;

  /// Champ de saisie affiché à la place de la valeur (quantité tapée au
  /// clavier) ; `null` = valeur en lecture seule.
  final Widget? field;

  @override
  Widget build(BuildContext context) {
    final valueWidth = large ? 96.0 : 36.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepButton(
          icon: Icons.remove,
          tooltip: 'Diminuer',
          onPressed: onDecrease,
        ),
        SizedBox(
          width: valueWidth,
          child:
              field ??
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Text(
                  '$quantity',
                  key: ValueKey(quantity),
                  textAlign: TextAlign.center,
                  style: large
                      ? AppTypography.titleLarge
                      : AppTypography.titleMedium,
                ),
              ),
        ),
        _StepButton(
          icon: Icons.add,
          tooltip: 'Augmenter',
          onPressed: onIncrease,
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final onPressed = this.onPressed;
    return IconButton.filledTonal(
      tooltip: tooltip,
      icon: Icon(icon, size: 20),
      constraints: const BoxConstraints.tightFor(
        width: AppSpacing.minTapTarget,
        height: AppSpacing.minTapTarget,
      ),
      onPressed: onPressed == null
          ? null
          : () {
              unawaited(HapticFeedback.selectionClick());
              onPressed();
            },
    );
  }
}
