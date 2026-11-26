import 'package:flutter/material.dart';

/// Palette v3 « Cacao, Teal & Indigo » : une instance claire, une sombre.
///
/// Trois couleurs de marque, chacune avec un rôle : le cacao pour agir
/// ([action], [brand]), le teal pour la performance ([performance] :
/// bénéfice, marge, activité) et l'indigo pour comparer ([compare] :
/// répartitions, séries secondaires). Les statuts ([success], [warning],
/// [error]) restent à part et s'accompagnent toujours d'un mot. Le reste est
/// neutre.
///
/// Règles d'usage : une seule surface teintée par écran, un seul bouton cacao
/// plein par écran, pas de dégradé ni d'ombre colorée. Une couleur de marque
/// « 500 » ([brand], [performance], [compare]) ne sert au texte qu'à partir
/// de 24 pt ; en dessous, on prend sa variante texte.
///
/// Le [ColorScheme] du thème est construit à partir de ces jetons (voir
/// `app_theme.dart`) : les widgets Material les reçoivent sans rien faire. Les
/// jetons sans emplacement dans [ColorScheme] se lisent avec [AppColors.of].
///
/// Tous les couples texte/fond passent l'AA (4,5:1) dans les deux modes ; le
/// vert de succès est volontairement éloigné du teal (ΔE ≈ 29, ≈ 26 pour un
/// deutéranope) pour qu'un bénéfice ne se lise jamais comme un statut.
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
    required this.actionText,
    required this.actionSubtle,
    required this.onActionSubtle,
    required this.performance,
    required this.performanceText,
    required this.performanceSubtle,
    required this.performanceMuted,
    required this.compare,
    required this.compareMuted,
    required this.compareText,
    required this.success,
    required this.successSubtle,
    required this.warning,
    required this.warningSubtle,
    required this.error,
    required this.errorSubtle,
    required this.onErrorSubtle,
    required this.elevationShadow,
  });

  /// Fond d'écran. Un cran plus foncé que la v3 d'origine pour détacher
  /// les surfaces blanches.
  final Color canvas;

  /// Listes, champs, feuilles.
  final Color surface;

  /// Vignettes, piste du contrôle segmenté, état désactivé, recherche.
  /// En sombre, c'est le troisième palier (surface élevée).
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

  /// Cacao 500 : logo, indicateurs, grands chiffres (24 pt et plus).
  /// Jamais pour du texte courant.
  final Color brand;

  /// Cacao 600 : bouton principal, onglet actif, sélection. Sur le fond,
  /// un texte cliquable prend [actionText].
  final Color action;

  /// Texte et icônes sur [action].
  final Color onAction;

  /// [action] pressé.
  final Color actionPressed;

  /// Cacao 700 : liens et boutons texte, lisibles sur le fond comme sur
  /// la surface.
  final Color actionText;

  /// Fond d'une ligne sélectionnée.
  final Color actionSubtle;

  /// Texte sur [actionSubtle].
  final Color onActionSubtle;

  /// Teal 500 : graphiques de performance (barre en avant), grands
  /// chiffres de bénéfice. Jamais pour un succès.
  final Color performance;

  /// Teal 700 : texte de performance (bénéfice, marge).
  final Color performanceText;

  /// Teal 100 : bande teintée du bénéfice.
  final Color performanceSubtle;

  /// Teal 300 : barres secondaires d'un graphique de performance.
  final Color performanceMuted;

  /// Indigo 500 : comparaisons, série principale d'une répartition.
  final Color compare;

  /// Indigo 300 : série secondaire d'une répartition.
  final Color compareMuted;

  /// Indigo 700 : texte de comparaison (« par rapport à hier »).
  final Color compareText;

  /// Statut positif (texte, point de statut).
  final Color success;

  /// Fond d'un message positif ; le texte y prend [success].
  final Color successSubtle;

  /// Statut d'alerte (texte, point de statut).
  final Color warning;

  /// Fond d'un message d'alerte ; le texte y prend [warning].
  final Color warningSubtle;

  /// Statut d'erreur (texte, point de statut).
  final Color error;

  /// Fond du message bloquant.
  final Color errorSubtle;

  /// Texte du message bloquant.
  final Color onErrorSubtle;

  /// Ombre des éléments flottants (feuille, menu, toast). Transparente en
  /// sombre : l'élévation s'y lit par un filet [border].
  final Color elevationShadow;

  /// Mode clair (par défaut).
  static const light = AppColors(
    canvas: Color(0xFFF0EEE9),
    surface: Color(0xFFFFFFFF),
    surfaceSunken: Color(0xFFEAE7E1),
    border: Color(0xFFE5E2DA),
    borderStrong: Color(0xFF848880),
    textPrimary: Color(0xFF252923),
    textSecondary: Color(0xFF63675F),
    textDisabled: Color(0xFFA3A79E),
    brand: Color(0xFFB96F43),
    action: Color(0xFFA8653D),
    onAction: Color(0xFFFFFFFF),
    actionPressed: Color(0xFF945935),
    actionText: Color(0xFF945935),
    actionSubtle: Color(0xFFF1E4DA),
    onActionSubtle: Color(0xFF945935),
    performance: Color(0xFF398477),
    performanceText: Color(0xFF327469),
    performanceSubtle: Color(0xFFE0EFEB),
    performanceMuted: Color(0xFFB4D3CD),
    compare: Color(0xFF6879A5),
    compareMuted: Color(0xFFBBC3D6),
    compareText: Color(0xFF596A95),
    success: Color(0xFF28793C),
    successSubtle: Color(0xFFE2F0E4),
    warning: Color(0xFF8D641C),
    warningSubtle: Color(0xFFF9F1E2),
    error: Color(0xFFCA2B2B),
    errorSubtle: Color(0xFFFAE6E6),
    onErrorSubtle: Color(0xFFCA2B2B),
    elevationShadow: Color(0xFF252923),
  );

  /// Mode sombre.
  static const dark = AppColors(
    canvas: Color(0xFF151713),
    surface: Color(0xFF1E211D),
    surfaceSunken: Color(0xFF282C27),
    border: Color(0xFF33382F),
    borderStrong: Color(0xFF737869),
    textPrimary: Color(0xFFF1F0EB),
    textSecondary: Color(0xFFA5AAA0),
    textDisabled: Color(0xFF5C6157),
    brand: Color(0xFFC98D69),
    action: Color(0xFFC98D69),
    onAction: Color(0xFF1F140D),
    actionPressed: Color(0xFFD9A585),
    actionText: Color(0xFFC98D69),
    actionSubtle: Color(0xFF3D3125),
    onActionSubtle: Color(0xFFE0B497),
    performance: Color(0xFF48A897),
    performanceText: Color(0xFF48A897),
    performanceSubtle: Color(0xFF23352F),
    performanceMuted: Color(0xFF2F5048),
    compare: Color(0xFF8D9ABB),
    compareMuted: Color(0xFF3E465A),
    compareText: Color(0xFF8D9ABB),
    success: Color(0xFF3FB25E),
    successSubtle: Color(0xFF1E3524),
    warning: Color(0xFFD69A32),
    warningSubtle: Color(0xFF433921),
    error: Color(0xFFE27878),
    errorSubtle: Color(0xFF432A26),
    onErrorSubtle: Color(0xFFF09A9A),
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

  /// Fond de la zone caméra (avant l'image, caméra en pause), quel que soit
  /// le mode.
  static const Color cameraBackground = Color(0xFF0B0C0A);

  /// Texte posé sur la zone caméra, quel que soit le mode.
  static const Color onCamera = Color(0xFFEDEEE9);

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
    Color? actionText,
    Color? actionSubtle,
    Color? onActionSubtle,
    Color? performance,
    Color? performanceText,
    Color? performanceSubtle,
    Color? performanceMuted,
    Color? compare,
    Color? compareMuted,
    Color? compareText,
    Color? success,
    Color? successSubtle,
    Color? warning,
    Color? warningSubtle,
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
      actionText: actionText ?? this.actionText,
      actionSubtle: actionSubtle ?? this.actionSubtle,
      onActionSubtle: onActionSubtle ?? this.onActionSubtle,
      performance: performance ?? this.performance,
      performanceText: performanceText ?? this.performanceText,
      performanceSubtle: performanceSubtle ?? this.performanceSubtle,
      performanceMuted: performanceMuted ?? this.performanceMuted,
      compare: compare ?? this.compare,
      compareMuted: compareMuted ?? this.compareMuted,
      compareText: compareText ?? this.compareText,
      success: success ?? this.success,
      successSubtle: successSubtle ?? this.successSubtle,
      warning: warning ?? this.warning,
      warningSubtle: warningSubtle ?? this.warningSubtle,
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
      actionText: l(actionText, other.actionText),
      actionSubtle: l(actionSubtle, other.actionSubtle),
      onActionSubtle: l(onActionSubtle, other.onActionSubtle),
      performance: l(performance, other.performance),
      performanceText: l(performanceText, other.performanceText),
      performanceSubtle: l(performanceSubtle, other.performanceSubtle),
      performanceMuted: l(performanceMuted, other.performanceMuted),
      compare: l(compare, other.compare),
      compareMuted: l(compareMuted, other.compareMuted),
      compareText: l(compareText, other.compareText),
      success: l(success, other.success),
      successSubtle: l(successSubtle, other.successSubtle),
      warning: l(warning, other.warning),
      warningSubtle: l(warningSubtle, other.warningSubtle),
      error: l(error, other.error),
      errorSubtle: l(errorSubtle, other.errorSubtle),
      onErrorSubtle: l(onErrorSubtle, other.onErrorSubtle),
      elevationShadow: l(elevationShadow, other.elevationShadow),
    );
  }
}
