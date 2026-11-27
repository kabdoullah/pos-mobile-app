import 'package:flutter/material.dart';

/// Système typographique (refonte v2).
///
/// Une seule famille, Inter (OFL), embarquée dans `assets/fonts/` pour
/// fonctionner hors ligne : grande hauteur d'x lisible au soleil, chiffres
/// tabulaires natifs et espace fine insécable U+202F (séparateur de milliers
/// de `intl` en `fr_FR`). Trois graisses seulement : 400, 500, 600.
///
/// Échelle v2 — un nom par rôle, pas d'alias :
///
/// | Style            | Taille/graisse | Rôle                                  |
/// |------------------|----------------|---------------------------------------|
/// | [figureHero]     | 32/600 tab.    | le chiffre décisif de l'écran         |
/// | [figureInput]    | 28/600 tab.    | saisie d'un montant en grand          |
/// | [figureLarge]    | 24/600 tab.    | montant secondaire                    |
/// | [screenTitle]    | 22/600         | titre d'écran                         |
/// | [sectionTitle]   | 20/600         | titre de section, feuille, dialogue   |
/// | [figureSmall]    | 18/600 tab.    | chiffre dans une tuile ou une ligne   |
/// | [heading]        | 18/600         | titre d'un état vide ou d'un bloc     |
/// | [label]          | 16/600         | libellé de bouton                     |
/// | [groupTitle]     | 16/600         | titre de groupe dans une liste        |
/// | [bodyStrong]     | 16/500         | texte appuyé, onglets, segments       |
/// | [body]           | 16/400         | texte courant — **taille minimale**   |
/// | [meta]           | 14/500         | métadonnées, messages sous un champ   |
/// | [metaRegular]    | 14/400         | métadonnées secondaires               |
/// | [caption]        | 13/400         | légende sous un indicateur            |
/// | [navLabel]       | 12/500         | barre de navigation uniquement        |
///
/// Pas de `fontSize` à la main : une taille absente de l'échelle est un jeton
/// manquant, à ajouter ici.
///
/// Les couleurs sont volontairement absentes — appliquées via
/// [ThemeData.textTheme] pour que le passage clair/sombre fonctionne
/// automatiquement. Les widgets qui ont besoin d'une couleur explicite
/// utilisent `.copyWith(color: AppColors.of(context).xxx)`.
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

  // Chiffres

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

  /// Saisie d'un montant en grand (champ `large`). 28/600.
  static const TextStyle figureInput = TextStyle(
    fontFamily: fontFamily,
    fontFeatures: tabularFigures,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.4,
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

  /// Chiffre dans une tuile ou une ligne (stock, total d'une ligne). 18/600.
  static const TextStyle figureSmall = TextStyle(
    fontFamily: fontFamily,
    fontFeatures: tabularFigures,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.45,
    letterSpacing: 0,
  );

  // Titres

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

  /// Titre d'un état vide ou d'un bloc dans la page. 18/600.
  static const TextStyle heading = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.45,
    letterSpacing: 0,
  );

  // Texte

  /// Libellé de bouton et d'action. 16/600.
  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Texte appuyé : nom de produit, valeur d'une ligne, onglet. 16/500.
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

  /// Métadonnées : horodatage, numéro, stock, message sous un champ. 14/500.
  static const TextStyle meta = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Métadonnées secondaires, moins appuyées que [meta]. 14/400.
  static const TextStyle metaRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
    letterSpacing: 0,
  );

  /// Titre de groupe dans une liste (« Aujourd'hui », « Paiement »). 16/600,
  /// en casse normale : les petites majuscules espacées se lisaient mal en
  /// plein soleil et pour les yeux fatigués.
  static const TextStyle groupTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Légende sous un indicateur (force du PIN, étape). 13/400.
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Libellés de la barre de navigation uniquement. 12/500.
  static const TextStyle navLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0,
  );
}
