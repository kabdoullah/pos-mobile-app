import 'package:flutter/material.dart';

/// Palette « Cacao & Sauge » (refonte v2) : une instance claire, une sombre.
///
/// Principe : une couleur = une intention. [action] (cacao) veut dire « agir »
/// (bouton principal, lien, sélection) ; [success], [warning] et [error] sont
/// des statuts, toujours accompagnés d'un mot. Le reste est neutre (sauge).
///
/// Le [ColorScheme] du thème est construit à partir de ces jetons (voir
/// `app_theme.dart`) : les widgets Material les reçoivent sans rien faire. Les
/// jetons sans emplacement dans [ColorScheme] (canvas, surfaceSunken, brand,
/// actionPressed…) se lisent avec [AppColors.of].
///
/// Le mode sombre n'est pas une inversion : fond vert-noir, surfaces par
/// paliers de luminance, statuts éclaircis, action en cacao clair avec texte
/// foncé. Tous les couples texte/fond passent l'AA (4,5:1) dans les deux modes.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  /// Crée un jeu de jetons de couleur.
  const AppColors({
    required this.canvas,
    required this.surface,
    required this.surfaceSunken,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.brand,
    required this.action,
    required this.onAction,
    required this.actionPressed,
    required this.actionSubtle,
    required this.onActionSubtle,
    required this.success,
    required this.warning,
    required this.error,
    required this.errorSubtle,
    required this.onErrorSubtle,
    required this.elevationShadow,
  });

  /// Fond d'écran.
  final Color canvas;

  /// Listes, champs, feuilles.
  final Color surface;

  /// Vignettes, piste du contrôle segmenté, état désactivé, recherche.
  final Color surfaceSunken;

  /// Filets et séparateurs.
  final Color border;

  /// Bord de champ, stepper, bouton secondaire (3:1 non-texte).
  final Color borderStrong;

  /// Texte et montants.
  final Color textPrimary;

  /// Libellés et métadonnées.
  final Color textSecondary;

  /// Texte désactivé seulement (jamais pour une information).
  final Color textDisabled;

  /// Couleur de marque : accents graphiques (3:1), jamais du texte.
  final Color brand;

  /// Bouton principal, lien, sélection.
  final Color action;

  /// Texte et icônes sur [action].
  final Color onAction;

  /// [action] pressé.
  final Color actionPressed;

  /// Fond d'une ligne sélectionnée.
  final Color actionSubtle;

  /// Texte sur [actionSubtle].
  final Color onActionSubtle;

  /// Statut positif (texte, point de statut).
  final Color success;

  /// Statut d'alerte (texte, point de statut).
  final Color warning;

  /// Statut d'erreur (texte, point de statut).
  final Color error;

  /// Fond du message bloquant : le seul aplat sémantique.
  final Color errorSubtle;

  /// Texte du message bloquant.
  final Color onErrorSubtle;

  /// Ombre des éléments flottants (feuille, menu, toast). Transparente en
  /// sombre : l'élévation s'y lit par un filet [border].
  final Color elevationShadow;

  /// Mode clair (par défaut).
  static const light = AppColors(
    canvas: Color(0xFFF5F3EF),
    surface: Color(0xFFFFFFFF),
    surfaceSunken: Color(0xFFEFECE6),
    border: Color(0xFFE8E5DE),
    borderStrong: Color(0xFF8F9389),
    textPrimary: Color(0xFF252923),
    textSecondary: Color(0xFF5F635B),
    textDisabled: Color(0xFFA3A79E),
    brand: Color(0xFFC87942),
    action: Color(0xFF9A5527),
    onAction: Color(0xFFFFFFFF),
    actionPressed: Color(0xFF7F4520),
    actionSubtle: Color(0xFFF6E9DE),
    onActionSubtle: Color(0xFF7F4520),
    success: Color(0xFF1F7A52),
    warning: Color(0xFF9A6200),
    error: Color(0xFFC23B3B),
    errorSubtle: Color(0xFFFBE7E5),
    onErrorSubtle: Color(0xFFA63030),
    elevationShadow: Color(0xFF252923),
  );

  /// Mode sombre.
  static const dark = AppColors(
    canvas: Color(0xFF141613),
    surface: Color(0xFF1C1F1B),
    surfaceSunken: Color(0xFF111310),
    border: Color(0xFF2E322C),
    borderStrong: Color(0xFF737869),
    textPrimary: Color(0xFFEDEEE9),
    textSecondary: Color(0xFFA3A79B),
    textDisabled: Color(0xFF5C6157),
    brand: Color(0xFFD08A55),
    action: Color(0xFFE09A63),
    onAction: Color(0xFF1A0F06),
    actionPressed: Color(0xFFEBAE7E),
    actionSubtle: Color(0xFF3A2617),
    onActionSubtle: Color(0xFFF2C29A),
    success: Color(0xFF4FBF8A),
    warning: Color(0xFFE8B45C),
    error: Color(0xFFF07A7A),
    errorSubtle: Color(0xFF3A1A1A),
    onErrorSubtle: Color(0xFFFFA3A3),
    elevationShadow: Color(0x00000000),
  );

  /// Fond du splash natif clair (`flutter_native_splash.yaml` : `color`).
  /// L'écran de démarrage Flutter le reprend pour éviter un flash.
  static const Color splashLight = Color(0xFFFFFBF5);

  /// Fond du splash natif sombre (`flutter_native_splash.yaml` :
  /// `color_dark`).
  static const Color splashDark = Color(0xFF1C1107);

  /// Voile posé sur l'image caméra du scanner, quel que soit le mode.
  static const Color cameraScrim = Color(0x99141613);

  /// Jetons du thème courant.
  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  @override
  AppColors copyWith({
    Color? canvas,
    Color? surface,
    Color? surfaceSunken,
    Color? border,
    Color? borderStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? brand,
    Color? action,
    Color? onAction,
    Color? actionPressed,
    Color? actionSubtle,
    Color? onActionSubtle,
    Color? success,
    Color? warning,
    Color? error,
    Color? errorSubtle,
    Color? onErrorSubtle,
    Color? elevationShadow,
  }) {
    return AppColors(
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      brand: brand ?? this.brand,
      action: action ?? this.action,
      onAction: onAction ?? this.onAction,
      actionPressed: actionPressed ?? this.actionPressed,
      actionSubtle: actionSubtle ?? this.actionSubtle,
      onActionSubtle: onActionSubtle ?? this.onActionSubtle,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      errorSubtle: errorSubtle ?? this.errorSubtle,
      onErrorSubtle: onErrorSubtle ?? this.onErrorSubtle,
      elevationShadow: elevationShadow ?? this.elevationShadow,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      canvas: l(canvas, other.canvas),
      surface: l(surface, other.surface),
      surfaceSunken: l(surfaceSunken, other.surfaceSunken),
      border: l(border, other.border),
      borderStrong: l(borderStrong, other.borderStrong),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      textDisabled: l(textDisabled, other.textDisabled),
      brand: l(brand, other.brand),
      action: l(action, other.action),
      onAction: l(onAction, other.onAction),
      actionPressed: l(actionPressed, other.actionPressed),
      actionSubtle: l(actionSubtle, other.actionSubtle),
      onActionSubtle: l(onActionSubtle, other.onActionSubtle),
      success: l(success, other.success),
      warning: l(warning, other.warning),
      error: l(error, other.error),
      errorSubtle: l(errorSubtle, other.errorSubtle),
      onErrorSubtle: l(onErrorSubtle, other.onErrorSubtle),
      elevationShadow: l(elevationShadow, other.elevationShadow),
    );
  }
}
