import 'package:flutter/material.dart';

/// Système typographique pour POS Mobile CI.
///
/// Échelle optimisée pour les utilisateurs peu à l'aise avec la lecture, la
/// lisibilité en plein soleil et l'accessibilité. Pas de police personnalisée
/// au MVP — Roboto est la police par défaut d'Android. Graisse minimale w400
/// (normal), w500–w600 de préférence pour la clarté des boutons/libellés.
///
/// Les couleurs sont volontairement absentes — appliquées via
/// [ThemeData.textTheme] pour que le passage clair/sombre fonctionne
/// automatiquement. Les widgets qui ont besoin d'une couleur explicite
/// utilisent `.copyWith(color: Theme.of(context).colorScheme.xxx)`.
class AppTypography {
  /// Empêche l'instanciation.
  AppTypography._();

  // Échelle display (texte très grand, mis en avant)
  /// Grand texte display. 40 sp, w700.
  static const TextStyle displayLarge = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  /// Texte display moyen. 34 sp, w700.
  static const TextStyle displayMedium = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: 0,
  );

  // Échelle headline (grand, mis en avant)
  /// Grand titre. 26 sp, w600. Titres d'AppBar, en-têtes de section.
  static const TextStyle titleLarge = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0,
  );

  /// Titre moyen. 20 sp, w600. Titres de dialogue, en-têtes d'élément de liste.
  static const TextStyle titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.15,
  );

  // Échelle body (texte de lecture)
  /// Grand texte courant. 18 sp, w400.
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.5,
  );

  /// Texte courant standard. 16 sp, w400. **Taille minimale du texte courant.**
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.25,
  );

  /// Petit texte courant. 14 sp, w400. Infos complémentaires / secondaires.
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.4,
  );

  // Échelle label (boutons, tags, contrôles)
  /// Grand libellé. 16 sp, w600. Texte de bouton, libellés d'action.
  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.5,
  );

  /// Libellé moyen. 14 sp, w500. Texte de chip, libellés de bouton secondaire.
  static const TextStyle labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.4,
  );

  /// Petit libellé. 12 sp, w500. Petits caractères, notes de bas de page.
  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.4,
  );

  // Styles sémantiques — forme seulement, couleur appliquée à l'appel via
  // colorScheme
  /// Affichage de montant. 34 sp, w700. Grands totaux FCFA, récapitulatifs de
  /// transaction.
  static const TextStyle amountDisplay = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  /// Grand montant. 28 sp, w700. Montants de ligne, sous-totaux.
  static const TextStyle amountLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: 0,
  );

  /// Texte de légende. 13 sp, w400. Métadonnées, horodatages.
  static const TextStyle captionText = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.4,
  );

  /// Forme du style de message d'erreur. Appliquer `colorScheme.error` à
  /// l'appel.
  static const TextStyle errorText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.25,
  );

  /// Forme du style de message de succès. Appliquer `colorScheme.secondary` à
  /// l'appel.
  static const TextStyle successText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.25,
  );

  /// Forme du texte d'indice / placeholder. Appliquer
  /// `colorScheme.onSurfaceVariant` à l'appel.
  static const TextStyle hintText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.25,
  );
}
