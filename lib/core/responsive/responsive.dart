import 'package:flutter/material.dart';

/// Helpers de design responsive pour adapter l'UI aux différentes tailles
/// d'écran.
///
/// L'app POS vise une large gamme d'appareils Android (écrans de 4,5" à 6,7").
/// Ces helpers permettent des mises en page sur une seule base de code qui
/// s'adaptent des petits téléphones d'entrée de gamme aux grands écrans, sans
/// UI complètement différentes.
extension ResponsiveContext on BuildContext {
  /// Largeur de l'écran en pixels logiques.
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Hauteur de l'écran en pixels logiques.
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Padding de l'appareil (marges de la zone sûre) — somme de tous les côtés.
  EdgeInsets get devicePadding => MediaQuery.of(this).padding;

  /// Vrai si la largeur d'écran < 360 dp. Petits téléphones d'entrée de gamme
  /// (4,5"–5,0").
  bool get isSmallScreen => screenWidth < 360;

  /// Vrai si la largeur d'écran ≥ 360 dp et < 600 dp. Téléphones moyens
  /// (5,0"–6,0").
  bool get isMediumScreen => screenWidth >= 360 && screenWidth < 600;

  /// Vrai si la largeur d'écran ≥ 600 dp. Grands téléphones et tablettes (6,0"
  /// et plus).
  bool get isLargeScreen => screenWidth >= 600;

  /// Orientation : vrai en paysage (largeur > hauteur).
  bool get isLandscape => screenWidth > screenHeight;

  /// Orientation : vrai en portrait (hauteur > largeur).
  bool get isPortrait => screenHeight > screenWidth;

  /// Densité de pixels de l'appareil (pixels logiques → pixels physiques).
  /// Aide à détecter les écrans retina / haute densité.
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// Hauteur restante une fois retirées les barres d'état et de navigation
  /// (zone sûre).
  /// Utile pour calculer l'espace restant dans les mises en page.
  double get availableHeight {
    final padding = MediaQuery.of(this).padding;
    return screenHeight - padding.top - padding.bottom;
  }
}

/// Choisit une valeur selon la catégorie de taille d'écran.
///
/// Permet un design responsive fluide sans media queries. Retourne la valeur la
/// plus adaptée à la taille d'écran courante.
///
/// Exemple :
/// ```dart
/// final padding = responsiveValue<double>(
///   context,
///   small: 8,
///   medium: 16,
///   large: 24,
/// );
/// ```
T responsiveValue<T>(
  BuildContext context, {
  required T small,
  required T medium,
  T? large,
}) {
  if (context.isLargeScreen && large != null) {
    return large;
  }
  if (context.isSmallScreen) {
    return small;
  }
  return medium;
}

/// Choisit un mode de mise en page selon la taille d'écran.
///
/// Simplifie le choix entre une mise en page à une colonne (téléphone) et à
/// plusieurs colonnes (tablette). Retourne `LayoutMode.compact` pour les petits
/// écrans, `LayoutMode.expanded` pour les moyens/grands.
///
/// Exemple :
/// ```dart
/// final layout = responsiveLayout(context);
/// if (layout == LayoutMode.compact) {
///   return SingleChildScrollView(...);
/// } else {
///   return Row(...);
/// }
/// ```
LayoutMode responsiveLayout(BuildContext context) {
  return context.isSmallScreen ? LayoutMode.compact : LayoutMode.expanded;
}

/// Catégorie de mise en page pour les décisions de design responsive.
enum LayoutMode {
  /// Mise en page verticale à une colonne (téléphones). Largeur < 360 dp.
  compact,

  /// Mise en page à plusieurs colonnes ou plus large (tablettes ou grands
  /// téléphones). Largeur ≥ 360 dp.
  expanded,
}

/// Constantes de points de rupture pour des media queries manuelles (si
/// besoin).
abstract class ResponsiveBreakpoints {
  /// Seuil petit écran : 360 dp. Inclut la plupart des téléphones Android
  /// d'entrée de gamme.
  static const double small = 360;

  /// Seuil écran moyen : 600 dp. Inclut la plupart des tablettes.
  static const double medium = 600;

  /// Seuil grand écran : 900 dp. Grandes tablettes et appareils pliables.
  static const double large = 900;
}
