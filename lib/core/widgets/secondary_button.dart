import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import 'button_frame.dart';

/// Bouton d'action secondaire pleine largeur, bordé (48 dp).
///
/// Pour les actions moins importantes que l'action principale de l'écran
/// (« Scanner un produit », « Partager le reçu »). Libellé cacao, jamais or :
/// l'or ne sert pas de couleur de texte (2,9:1).
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
      height: AppSpacing.buttonHeightSm,
      backgroundColor: Colors.transparent,
      foregroundColor: isDisabled
          ? cs.onSurface.withValues(alpha: 0.45)
          : cs.primary,
      progressColor: cs.primary,
      border: Border.all(color: isDisabled ? cs.outlineVariant : cs.outline),
      boxShadow: const [],
    );
  }
}
