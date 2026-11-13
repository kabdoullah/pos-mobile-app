/// Jetons d'espacement et de mise en page pour POS Mobile CI.
///
/// Tous les espacements suivent une grille de base de 8 pt pour la cohérence et
/// le rythme. Les rayons de bordure suivent une progression similaire pour la
/// cohérence visuelle. Les zones tactiles respectent ou dépassent les standards
/// d'accessibilité WCAG (44 dp minimum) et conviennent aux utilisateurs à
/// dextérité limitée ou aux gros doigts.
class AppSpacing {
  /// Empêche l'instanciation
  AppSpacing._();

  // Jetons d'espacement (grille de base 8 pt)
  /// Très petit espacement. 4 pt — micro-padding à l'intérieur des composants.
  static const double xs = 4;

  /// Petit espacement. 8 pt — padding standard des petits éléments, espacement
  /// serré.
  static const double sm = 8;

  /// Espacement moyen. 16 pt — padding standard des cartes, champs, sections.
  static const double md = 16;

  /// Grand espacement. 24 pt — padding des sections principales et rythme
  /// vertical.
  static const double lg = 24;

  /// Très grand espacement. 32 pt — espacement généreux pour aérer.
  static const double xl = 32;

  /// Espacement 2XL. 48 pt — espace entre les grands blocs de mise en page.
  static const double xxl = 48;

  /// Espacement 3XL. 64 pt — très grand espace vertical pour l'onboarding et
  /// les états vides.
  static const double xxxl = 64;

  // Jetons de rayon de bordure (v2 : deux rayons utiles, 8 et 12)
  /// Rayon des contrôles. 8 pt — boutons, champs, chips, stepper.
  static const double radiusSm = 8;

  /// Rayon des contrôles. 8 pt — alias de [radiusSm] (boutons, champs).
  static const double radiusMd = 8;

  /// Rayon des surfaces. 12 pt — feuilles, dialogues, vignettes, encadrés.
  static const double radiusLg = 12;

  /// Rayon des surfaces. 12 pt — alias de [radiusLg].
  static const double radiusXl = 12;

  /// Entièrement arrondi. 999 pt — points de statut uniquement.
  static const double radiusFull = 999;

  // Zones tactiles / tailles adaptées au toucher
  /// Hauteur des actions du parcours de vente (Nouvelle vente, Encaisser,
  /// Valider, reçu) : geste répété au comptoir, une main occupée.
  static const double buttonHeight = 56;

  /// Hauteur standard des contrôles (v2) : boutons hors parcours de vente,
  /// boutons secondaires et tertiaires.
  static const double buttonHeightSm = 48;

  /// Hauteur de champ de saisie : 48 pt, comme les contrôles (v2).
  /// Usage : TextField, TextFormField, champs de recherche, listes déroulantes.
  static const double inputHeight = 48;

  /// Taille de bouton icône — 48 pt minimum pour la zone tactile, peut grandir
  /// pour des icônes plus grandes.
  /// Usage : IconButton, boutons d'action flottants, actions en ligne.
  static const double iconButtonSize = 48;

  /// Taille minimale de zone tactile selon les recommandations WCAG (44 pt).
  /// La plupart des éléments interactifs devraient au moins faire cette taille
  /// ; plus grand, c'est mieux.
  static const double minTapTarget = 44;

  // Préréglages de padding/marge
  /// Padding symétrique pour les conteneurs standards.
  /// Usage : EdgeInsets des cartes, dialogues, padding autour du contenu.
  static const double contentPadding = md; // 16pt
}
