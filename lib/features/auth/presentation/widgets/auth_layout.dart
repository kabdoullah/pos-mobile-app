import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/responsive/responsive.dart';

/// Squelette commun des écrans d'authentification : barre d'état adaptée au
/// thème, zone sûre, largeur de lecture limitée sur tablette.
class AuthScaffold extends StatelessWidget {
  /// Crée le squelette d'un écran d'authentification.
  const AuthScaffold({
    required this.child,
    this.scrollable = true,
    this.resizeToAvoidBottomInset = true,
    super.key,
  });

  /// Contenu de l'écran.
  final Widget child;

  /// true : formulaire qui défile (clavier ouvert, petit écran). false :
  /// [child] gère lui-même sa hauteur (ex. `FillOrScroll` des écrans PIN).
  final bool scrollable;

  /// Voir [Scaffold.resizeToAvoidBottomInset] — false sur les écrans PIN, qui
  /// n'ouvrent jamais le clavier système.
  final bool resizeToAvoidBottomInset;

  /// Largeur maximale du contenu (tablette, paysage).
  static const double _maxContentWidth = 480;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gutter = responsiveValue(
      context,
      small: AppSpacing.md,
      medium: AppSpacing.lg,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Barre d'état transparente (pas d'AppBar sur ces écrans) : sans couleur
      // explicite, Android affiche un fond gris. Seules les icônes suivent le
      // thème ; la barre de navigation garde le style du système.
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxContentWidth),
              child: SizedBox(
                width: double.infinity,
                child: scrollable
                    ? SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: EdgeInsets.all(gutter),
                        child: child,
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: gutter),
                        child: child,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// En-tête d'un écran d'authentification : titre et phrase qui explique
/// pourquoi on demande ces informations.
class AuthHeader extends StatelessWidget {
  /// Crée un en-tête.
  const AuthHeader({
    required this.title,
    required this.subtitle,
    this.centered = false,
    super.key,
  });

  /// Titre de l'écran.
  final String title;

  /// Explication courte sous le titre.
  final String subtitle;

  /// Centre le texte (écrans sans formulaire long : connexion, PIN).
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final align = centered ? TextAlign.center : TextAlign.start;
    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            textAlign: align,
            style: AppTypography.titleLarge.copyWith(color: cs.onSurface),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          textAlign: align,
          style: AppTypography.bodyMedium.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

/// Ton d'un [AuthBanner].
enum AuthBannerTone {
  /// Échec d'une action (connexion impossible, erreur réseau…).
  error,

  /// Information à connaître avant d'agir (session expirée…).
  warning,
}

/// Bandeau de message en tête de formulaire, annoncé par les lecteurs d'écran.
///
/// Réservé aux erreurs qui ne concernent pas un champ précis : les erreurs de
/// champ s'affichent sous le champ concerné.
class AuthBanner extends StatelessWidget {
  /// Crée un bandeau.
  const AuthBanner({
    required this.title,
    required this.message,
    this.tone = AuthBannerTone.error,
    super.key,
  });

  /// Titre court (« Connexion impossible »).
  final String title;

  /// Détail et action à mener.
  final String message;

  /// Ton du bandeau.
  final AuthBannerTone tone;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (background, foreground, icon) = switch (tone) {
      AuthBannerTone.error => (
        cs.errorContainer,
        cs.onErrorContainer,
        Icons.error_outline_rounded,
      ),
      AuthBannerTone.warning => (
        cs.tertiaryContainer,
        cs.onTertiaryContainer,
        Icons.schedule_rounded,
      ),
    };

    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(child: Icon(icon, color: foreground, size: 20)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelMedium.copyWith(
                      color: foreground,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    message,
                    style: AppTypography.bodySmall.copyWith(color: foreground),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ligne de validation inline : ✓ quand la règle est respectée, sinon puce
/// neutre. Icône et texte portent l'information, pas seulement la couleur.
class ValidationHint extends StatelessWidget {
  /// Crée une ligne de validation.
  const ValidationHint({required this.label, required this.isMet, super.key});

  /// Règle ou confirmation affichée.
  final String label;

  /// true si la règle est respectée.
  final bool isMet;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final success = Theme.of(context).extension<AppSemanticColors>()!.success;
    final color = isMet ? success : cs.onSurfaceVariant;
    return Semantics(
      label: '$label : ${isMet ? 'respecté' : 'non respecté'}',
      excludeSemantics: true,
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle_rounded : Icons.circle_outlined,
            size: 16,
            color: color,
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              label,
              style: AppTypography.captionText.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
