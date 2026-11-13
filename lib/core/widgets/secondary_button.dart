import 'package:flutter/material.dart';

import 'button_frame.dart';
import '../../app/theme/app_colors.dart';

/// Bouton d'action secondaire pleine largeur : fond `surface`, filet
/// `borderStrong`, texte `textPrimary` ; pressé = `surfaceSunken`.
///
/// Pour les actions moins importantes comme Annuler ou Retour.
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
    final colors = AppColors.of(context);
    final isDisabled = onPressed == null;

    return ButtonFrame(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      backgroundColor: isDisabled ? colors.surfaceSunken : colors.surface,
      foregroundColor: isDisabled ? colors.textDisabled : colors.textPrimary,
      progressColor: colors.textPrimary,
      pressedColor: colors.surfaceSunken,
      border: Border.all(
        color: isDisabled ? colors.border : colors.borderStrong,
      ),
    );
  }
}
