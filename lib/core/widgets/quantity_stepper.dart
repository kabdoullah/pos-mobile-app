import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Sélecteur de quantité ( − n + ) dans une pilule bordée ; la valeur s'anime
/// à chaque changement.
class QuantityStepper extends StatelessWidget {
  /// Crée un sélecteur de quantité. Un callback `null` désactive le bouton.
  const QuantityStepper({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
    this.large = false,
    this.field,
    this.removeTooltip,
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

  /// Infobulle de retrait : à 1, « − » devient une corbeille (ex. ligne de
  /// panier) ; `null` = « − » reste « Diminuer ».
  final String? removeTooltip;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final valueWidth = large ? 96.0 : 32.0;
    final removes = removeTooltip != null && quantity <= 1;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: cs.outline),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: removes ? Icons.delete_outline : Icons.remove,
            tooltip: removes ? removeTooltip! : 'Diminuer',
            onPressed: onDecrease,
            large: large,
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
                    style:
                        (large
                                ? AppTypography.titleLarge
                                : AppTypography.labelLarge)
                            .copyWith(
                              fontFeatures: AppTypography.tabularFigures,
                            ),
                  ),
                ),
          ),
          _StepButton(
            icon: Icons.add,
            tooltip: 'Augmenter',
            onPressed: onIncrease,
            large: large,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.large,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final onPressed = this.onPressed;
    return IconButton(
      tooltip: tooltip,
      color: Theme.of(context).colorScheme.primary,
      icon: Icon(icon, size: large ? 20 : 18),
      // Compact (lignes de panier) : pilule basse, boutons gardés larges
      // pour rester faciles à viser. Sans shrinkWrap, Material 3 rajoute une
      // zone tactile de 48 dp et la pilule reste haute.
      style: IconButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: large
            ? MaterialTapTargetSize.padded
            : MaterialTapTargetSize.shrinkWrap,
        fixedSize: large
            ? const Size.square(AppSpacing.minTapTarget)
            : const Size(40, 32),
        minimumSize: large
            ? const Size.square(AppSpacing.minTapTarget)
            : const Size(40, 32),
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
