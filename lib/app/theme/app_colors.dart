import 'package:flutter/material.dart';

/// Light-mode color palette — Cacao & Or.
///
/// Primary: brun cacao profond (`#92400E`) — autorité, premium, Côte d'Ivoire
/// (#1 mondial cacao). Secondary: or/doré (`#CA8A04`) — prospérité, succès.
///
/// **Règle critique :** [textOnSecondary] est sombre (`#1C1107`), jamais blanc
/// sur or (contraste blanc/`#CA8A04` = 3.4:1 — insuffisant WCAG AA body text).
///
/// For dark-mode counterparts and stock status colors, use [AppSemanticColors]
/// via `Theme.of(context).extension<AppSemanticColors>()!`.
class AppColors {
  /// Empêche l'instanciation.
  AppColors._();

  // Primary — Brun cacao (Côte d'Ivoire #1 mondial cacao)
  /// Couleur principale de la marque. WCAG AA 7,1:1 sur blanc.
  static const Color primary = Color(0xFF92400E);

  /// Variante plus foncée pour les états pressé/actif.
  static const Color primaryDark = Color(0xFF78350F);

  /// Teinte plus claire pour le survol et la couleur principale en mode sombre.
  static const Color primaryLight = Color(0xFFFB923C);

  /// Fond de conteneur avec la couleur principale en accent.
  static const Color primaryContainer = Color(0xFFFEF3C7);

  // Secondary — Or/Doré (prospérité — ≠ jaune MTN #FFCC00)
  /// Couleur secondaire de la marque. Accent or pour les succès et mises en
  /// avant.
  static const Color secondary = Color(0xFFCA8A04);

  /// Variante plus foncée pour les états pressés secondaires.
  static const Color secondaryDark = Color(0xFF713F12);

  /// Teinte plus claire pour les mises en avant secondaires.
  static const Color secondaryLight = Color(0xFFFBBF24);

  /// Fond de conteneur avec la couleur secondaire en accent.
  static const Color secondaryContainer = Color(0xFFFEFCE8);

  // Neutral Surfaces (légèrement ivoire-chaud)
  /// Fond principal de l'app. Teinte ivoire chaude, moins fatigante pour les
  /// yeux.
  static const Color background = Color(0xFFFFFBF5);

  /// Surface par défaut des cartes, dialogues, bottom sheets.
  static const Color surface = Color(0xFFFFFFFF);

  /// Surface variante pour le fond des champs et des chips.
  static const Color surfaceVariant = Color(0xFFFEF9EE);

  /// Couleur de bordure des champs et des limites d'UI.
  static const Color border = Color(0xFFE7E5E4);

  /// Couleur des séparateurs de section.
  static const Color divider = Color(0xFFF5F0E8);

  // Couleurs de texte
  /// Texte principal. Quasi-noir chaud — lisibilité maximale sur surfaces
  /// ivoire.
  static const Color textPrimary = Color(0xFF1C1107);

  /// Texte secondaire pour références, lieux, libellés secondaires.
  static const Color textSecondary = Color(0xFF57534E);

  /// Texte désactivé / placeholder.
  static const Color textDisabled = Color(0xFFA8A29E);

  /// Texte sur fonds de couleur principale (toujours blanc — cacao 7,1:1 sur
  /// blanc).
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// Texte sur fonds de couleur secondaire.
  ///
  /// **Doit être foncé** — blanc sur or `#CA8A04` = 3,4:1 (échoue WCAG AA pour
  /// le corps de texte).
  static const Color textOnSecondary = Color(0xFF1C1107);

  // Couleurs sémantiques
  /// Erreur / rupture de stock. WCAG AA sur blanc.
  static const Color error = Color(0xFFBA1A1A);

  /// Teinte de fond des conteneurs en état d'erreur.
  static const Color errorContainer = Color(0xFFFFDAD6);

  /// État de succès. Vert forêt — distinct de l'or secondaire.
  static const Color success = Color(0xFF166534);

  /// Teinte de fond des conteneurs en état de succès.
  static const Color successContainer = Color(0xFFDCFCE7);

  /// Avertissement / stock bas / réapprovisionnement nécessaire.
  ///
  /// Rouge-orangé — visuellement distinct de l'or secondaire `#CA8A04`.
  static const Color warning = Color(0xFFEA580C);

  /// Teinte de fond des conteneurs en état d'avertissement.
  static const Color warningContainer = Color(0xFFFFEDD5);

  // Fonds des badges de paiement — couleurs des marques tierces, adaptées clair/sombre
  /// Fond du badge Orange Money.
  static Color orangeMoneyBg(Brightness b) =>
      b == Brightness.dark ? const Color(0xFF3D1A08) : const Color(0xFFFFF4ED);

  /// Fond du badge MTN Mobile Money.
  static Color mtnBg(Brightness b) =>
      b == Brightness.dark ? const Color(0xFF362508) : const Color(0xFFFFFBEB);

  /// Fond du badge Wave.
  static Color waveBg(Brightness b) =>
      b == Brightness.dark ? const Color(0xFF071830) : const Color(0xFFEFF6FF);

  // Utilitaires
  /// Voile (scrim) des modales et overlays.
  static const Color scrim = Color(0x991C1107);

  /// Contour des éléments inactifs.
  static const Color inactive = Color(0xFFE7E5E4);

  /// Fond sombre de l'overlay caméra coupée.
  static const Color cameraBackground = Color(0xFF0C0906);
}

/// Couleurs sémantiques adaptées au mode sombre, absentes de [ColorScheme].
///
/// [ColorScheme.error]/[ColorScheme.errorContainer] couvrent déjà la rupture de
/// stock, et [ColorScheme.tertiary]/[ColorScheme.tertiaryContainer] couvrent
/// déjà l'avertissement/stock bas. Cette extension n'ajoute que ce pour quoi le
/// [ColorScheme] de Material 3 n'a pas d'emplacement : un vrai vert « succès »
/// pour stock ok / mouvement d'entrée — distinct de [ColorScheme.secondary]
/// (or/doré), que l'app utilise déjà ailleurs pour les confirmations de type «
/// à jour ».
///
/// Récupérer via `Theme.of(context).extension<AppSemanticColors>()!`.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  /// Crée un jeu de couleurs sémantiques.
  const AppSemanticColors({
    required this.success,
    required this.successContainer,
  });

  /// Success / stock ok / mouvement d'entrée. WCAG AA on its own brightness's
  /// surface color.
  final Color success;

  /// Teinte de fond des conteneurs en état de succès (chips, cercles d'icône).
  final Color successContainer;

  /// Instance mode clair.
  static const light = AppSemanticColors(
    success: Color(0xFF166534), // vert forêt, WCAG AA sur blanc
    successContainer: Color(0xFFDCFCE7),
  );

  /// Instance mode sombre.
  static const dark = AppSemanticColors(
    success: Color(0xFF4ADE80), // green-400 — lisible sur surface quasi-noire
    successContainer: Color(0xFF14532D),
  );

  @override
  AppSemanticColors copyWith({Color? success, Color? successContainer}) {
    return AppSemanticColors(
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t) ?? success,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t) ??
          successContainer,
    );
  }
}
