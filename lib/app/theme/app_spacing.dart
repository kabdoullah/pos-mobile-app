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

  // Jetons de rayon de bordure
  /// Petit rayon d'angle. 8 pt — chips, petits boutons, coins de dialogue.
  static const double radiusSm = 8;

  /// Rayon d'angle moyen. 12 pt — champs, boutons standards, importance
  /// modérée.
  static const double radiusMd = 12;

  /// Grand rayon d'angle. 16 pt — cartes, bottom sheets, surfaces surélevées.
  static const double radiusLg = 16;

  /// Très grand rayon d'angle. 24 pt — grandes cartes, modales mises en avant.
  static const double radiusXl = 24;

  /// Entièrement arrondi. 999 pt — chips, badges, éléments circulaires.
  static const double radiusFull = 999;

  // Zones tactiles / tailles adaptées au toucher
  /// Hauteur de bouton — gros doigts, usage rapide à une main. Padding vertical
  /// généreux.
  /// Usage : ElevatedButton, OutlinedButton, boutons d'action principaux et
  /// secondaires.
  static const double buttonHeight = 56;

  /// Hauteur de bouton secondaire — un peu plus petite que le principal,
  /// toujours facile à toucher.
  /// Usage : boutons tertiaires, boutons retour, actions d'annulation.
  static const double buttonHeightSm = 48;

  /// Hauteur de champ de saisie — identique au bouton principal pour la
  /// cohérence visuelle et les appuis de gros doigts.
  /// Usage : TextField, TextFormField, champs de recherche, listes déroulantes.
  static const double inputHeight = 56;

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
