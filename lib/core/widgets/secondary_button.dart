import 'package:flutter/material.dart';

import 'button_frame.dart';

/// Bouton d'action secondaire pleine largeur avec contour or.
///
/// Pour les actions moins importantes comme Annuler ou Retour. Hauteur minimale
/// de 56 dp pour des zones tactiles confortables.
class SecondaryButton extends StatelessWidget {
  /// Crée un bouton secondaire.
  const SecondaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    super.key,
  });

  /// Texte du bouton.
  final String label;

  /// Callback à l'appui sur le bouton. Si null, le bouton est désactivé.
  final VoidCallback? onPressed;

  /// Indique si le bouton est en état de chargement.
  final bool isLoading;

  /// Icône de début optionnelle.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDisabled = onPressed == null;

    return ButtonFrame(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      backgroundColor: isDisabled ? cs.surfaceContainerHighest : cs.surface,
      foregroundColor: isDisabled
          ? cs.onSurface.withValues(alpha: 0.38)
          : cs.secondary,
      progressColor: cs.secondary,
      border: Border.all(
        color: isDisabled ? cs.outlineVariant : cs.secondary,
        width: 2,
      ),
      boxShadow: isDisabled
          ? const []
          : [
              BoxShadow(
                color: cs.secondary.withValues(alpha: 0.12),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
    );
  }
}
