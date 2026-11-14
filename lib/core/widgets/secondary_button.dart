import 'package:flutter/material.dart';

import 'button_frame.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

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
    this.height = AppSpacing.buttonHeightSm,
    super.key,
  });

  /// Hauteur : 48 dp (v2) ; `AppSpacing.buttonHeight` (56 dp) pour les
  /// actions du parcours de vente (Nouvelle vente, Encaisser, Valider, reçu).
  final double height;

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
      height: height,
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
