import 'package:flutter/material.dart';

import 'button_frame.dart';

/// Bouton d'action principal pleine largeur aux couleurs de la marque
/// (brun cacao).
///
/// Conçu pour l'accessibilité et une UX mobile d'abord. Hauteur minimale de 56
/// dp pour des zones tactiles confortables. Gère les états de chargement et
/// désactivé.
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
    final cs = Theme.of(context).colorScheme;
    final isDisabled = onPressed == null;

    return ButtonFrame(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      loadingLabel: loadingLabel,
      icon: icon,
      trailingIcon: trailingIcon,
      backgroundColor: isDisabled ? cs.surfaceContainerHigh : cs.primary,
      // Désactivé : onPrimary sur le fond grisé était illisible (blanc sur
      // gris clair, brun foncé sur brun en sombre).
      foregroundColor: isDisabled
          ? cs.onSurface.withValues(alpha: 0.45)
          : cs.onPrimary,
      progressColor: cs.onPrimary,
      // Bouton à plat : la couleur suffit à le distinguer, et une ombre cacao
      // ferait un halo en mode sombre.
      boxShadow: const [],
    );
  }
}
