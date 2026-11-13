import 'package:flutter/material.dart';

import 'button_frame.dart';
import '../../app/theme/app_colors.dart';

/// Bouton d'action principal pleine largeur, couleur `action` (cacao), plat.
///
/// 56 dp de haut : geste répété au comptoir. Un seul par écran. Gère les
/// états de chargement et désactivé.
class PrimaryButton extends StatelessWidget {
  /// Crée un bouton principal.
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.loadingLabel,
    this.icon,
    this.trailingIcon,
    super.key,
  });

  /// Texte du bouton.
  final String label;

  /// Callback à l'appui sur le bouton. Si null, le bouton est désactivé.
  final VoidCallback? onPressed;

  /// Indique si le bouton est en état de chargement.
  final bool isLoading;

  /// Libellé affiché à côté de l'indicateur pendant le chargement (ex.
  /// « Connexion… »). Sans libellé, seul l'indicateur est affiché.
  final String? loadingLabel;

  /// Icône de début optionnelle.
  final IconData? icon;

  /// Icône de fin optionnelle (ex. flèche pour les actions directionnelles).
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDisabled = onPressed == null;

    return ButtonFrame(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      loadingLabel: loadingLabel,
      icon: icon,
      trailingIcon: trailingIcon,
      backgroundColor: isDisabled ? colors.surfaceSunken : colors.action,
      foregroundColor: isDisabled ? colors.textDisabled : colors.onAction,
      progressColor: colors.onAction,
      pressedColor: colors.actionPressed,
    );
  }
}
