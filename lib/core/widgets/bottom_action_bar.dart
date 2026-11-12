import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Barre d'action fixée en bas de l'écran : l'action principale reste
/// visible quel que soit le défilement (« Nouvelle vente », « Clôturer la
/// caisse », « Valider la vente »).
///
/// Fond de l'écran, filet en haut, marges 12 × 16 dp. Plusieurs [children]
/// s'empilent avec 8 dp d'écart.
class BottomActionBar extends StatelessWidget {
  /// Crée une barre d'action.
  const BottomActionBar({required this.children, super.key});

  /// Boutons de la barre, de haut en bas.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (i, child) in children.indexed) ...[
                if (i > 0) const SizedBox(height: AppSpacing.sm),
                child,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
