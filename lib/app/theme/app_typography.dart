import 'package:flutter/material.dart';

/// Système typographique (refonte v2).
///
/// Une seule famille, Inter (OFL), embarquée dans `assets/fonts/` pour
/// fonctionner hors ligne : grande hauteur d'x lisible au soleil, chiffres
/// tabulaires natifs et espace fine insécable U+202F (séparateur de milliers
/// de `intl` en `fr_FR`). Trois graisses seulement : 400, 500, 600.
///
/// Échelle v2 : [figureHero] 32/600, [figureLarge] 24/600, [screenTitle]
/// 22/600, [sectionTitle] 20/600, [bodyStrong] 16/500, [body] 16/400
/// (minimum du texte courant), [meta] 14/500, [overline] 13/600. Les anciens
/// noms (titleLarge, amountDisplay…) restent des alias vers cette échelle.
///
/// Les couleurs sont volontairement absentes — appliquées via
/// [ThemeData.textTheme] pour que le passage clair/sombre fonctionne
/// automatiquement. Les widgets qui ont besoin d'une couleur explicite
/// utilisent `.copyWith(color: Theme.of(context).colorScheme.xxx)`.
class AppTypography {
  /// Empêche l'instanciation.
  AppTypography._();

  /// Famille déclarée dans `pubspec.yaml`. Répétée dans chaque style : les
  /// écrans utilisent souvent [AppTypography] directement, hors du thème.
  static const String fontFamily = 'Inter';

  /// Chiffres à chasse fixe : les montants ne « bougent » pas quand ils
  /// changent et s'alignent en colonne.
  static const List<FontFeature> tabularFigures = [
    FontFeature.tabularFigures(),
  ];

  // Échelle v2

  /// Le chiffre décisif de l'écran (à rendre, solde, total). 32/600, un seul
  /// par écran.
  static const TextStyle figureHero = TextStyle(
    fontFamily: fontFamily,
    fontFeatures: tabularFigures,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.5,
  );

  /// Montant mis en avant, secondaire au héros. 24/600.
  static const TextStyle figureLarge = TextStyle(
    fontFamily: fontFamily,
    fontFeatures: tabularFigures,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.25,
  );

  /// Titre d'écran (AppBar). 22/600.
  static const TextStyle screenTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.2,
  );

  /// Titre de section, de feuille ou de dialogue. 20/600.
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.35,
    letterSpacing: -0.1,
  );

  /// Texte appuyé : nom de produit, valeur d'une ligne. 16/500.
  static const TextStyle bodyStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0,
  );

  /// Texte courant. 16/400. **Taille minimale du texte courant.**
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
  );

  /// Métadonnées : horodatage, numéro, stock. 14/500.
  static const TextStyle meta = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Sur-titre de groupe (« AUJOURD'HUI »). 13/600, à écrire en majuscules.
  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.8,
  );

  // Alias de l'échelle précédente, rattachés à l'échelle v2.

  /// Grand texte display. Alias de [figureHero].
  static const TextStyle displayLarge = figureHero;

  /// Texte display moyen. 28/600.
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.4,
  );

  /// Grand titre. Alias de [screenTitle].
  static const TextStyle titleLarge = screenTitle;

  /// Titre d'AppBar. Alias de [screenTitle].
  static const TextStyle appBarTitle = screenTitle;

  /// Titre moyen. Alias de [sectionTitle].
  static const TextStyle titleMedium = sectionTitle;

  /// Grand texte courant. Alias de [bodyStrong] (la v2 n'a pas de corps
  /// 18 sp : l'emphase passe par la graisse).
  static const TextStyle bodyLarge = bodyStrong;

  /// Texte courant standard. Alias de [body].
  static const TextStyle bodyMedium = body;

  /// Petit texte courant. 14/400. Infos complémentaires / secondaires.
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
    letterSpacing: 0,
  );

  /// Grand libellé. 16/600. Texte de bouton, libellés d'action.
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Libellé moyen. Alias de [meta].
  static const TextStyle labelMedium = meta;

  /// Petit libellé. 12/500. Libellés de la barre de navigation uniquement.
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0,
  );

  /// Affichage de montant. Alias de [figureHero].
  static const TextStyle amountDisplay = figureHero;

  /// Grand montant. Alias de [figureLarge].
  static const TextStyle amountLarge = figureLarge;

  /// Texte de légende. 13/400. Métadonnées secondaires.
  static const TextStyle captionText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Forme du message d'erreur sous un champ (14/500). Appliquer
  /// `colorScheme.error` à l'appel.
  static const TextStyle errorText = meta;

  /// Forme du message de succès (14/500). Appliquer le jeton `success` de
  /// `AppColors` à l'appel.
  static const TextStyle successText = meta;

  /// Forme du texte d'indice / placeholder (16/400, comme la saisie).
  /// Appliquer `colorScheme.onSurfaceVariant` à l'appel.
  static const TextStyle hintText = body;
}
