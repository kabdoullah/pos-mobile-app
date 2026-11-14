import 'package:flutter/material.dart';

import 'button_frame.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

/// Bouton d'action principal pleine largeur, couleur `action` (cacao), plat.
///
/// 48 dp de haut, 56 dp dans le parcours de vente ([height]). Un seul par
/// écran. Gère les états de chargement et désactivé.
class PrimaryButton extends StatelessWidget {
  /// Crée un bouton principal.
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.loadingLabel,
    this.icon,
    this.trailingIcon,
    this.isDangerous = false,
    this.height = AppSpacing.buttonHeightSm,
    super.key,
  });

  /// Hauteur : 48 dp (v2) ; `AppSpacing.buttonHeight` (56 dp) pour les
  /// actions du parcours de vente (Nouvelle vente, Encaisser, Valider, reçu).
  final double height;

  /// Action destructive (supprimer, vider) : fond `error` au lieu de `action`.
  final bool isDangerous;

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
      height: height,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      loadingLabel: loadingLabel,
      icon: icon,
      trailingIcon: trailingIcon,
      backgroundColor: isDisabled
          ? colors.surfaceSunken
          : isDangerous
          ? colors.error
          : colors.action,
      foregroundColor: isDisabled
          ? colors.textDisabled
          : isDangerous
          ? colors.surface
          : colors.onAction,
      progressColor: isDangerous ? colors.surface : colors.onAction,
      pressedColor: isDangerous
          ? colors.textPrimary.withValues(alpha: 0.12)
          : colors.actionPressed,
    );
  }
}
