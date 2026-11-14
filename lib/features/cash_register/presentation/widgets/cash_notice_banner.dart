import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';

/// Niveau d'un avertissement de caisse.
enum CashNoticeLevel {
  /// Information (recalcul, attente de synchro).
  info,

  /// Point à vérifier (opérations après clôture, retour refusé).
  warning,

  /// Refus du serveur.
  error,
}

/// Bandeau d'avertissement d'une session de caisse, pleine largeur (aplat
/// d'erreur pour un refus du serveur, note à plat sinon), avec un contenu
/// supplémentaire optionnel ([child] : champ et bouton de correction).
class CashNoticeBanner extends StatelessWidget {
  /// Crée un bandeau.
  const CashNoticeBanner({
    required this.message,
    this.level = CashNoticeLevel.info,
    this.title,
    this.child,
    super.key,
  });

  /// Titre en gras, optionnel.
  final String? title;

  /// Texte de l'avertissement.
  final String message;

  /// Niveau : fixe l'icône et la couleur.
  final CashNoticeLevel level;

  /// Contenu affiché sous le message (action de correction).
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final title = this.title;
    final child = this.child;
    final isError = level == CashNoticeLevel.error;
    // Refus du serveur : seul aplat de couleur (message bloquant). Point à
    // vérifier ou information : note à plat, point de couleur.
    final foreground = isError ? colors.onErrorSubtle : colors.textPrimary;
    final dot = switch (level) {
      CashNoticeLevel.info => colors.textSecondary,
      CashNoticeLevel.warning => colors.warning,
      CashNoticeLevel.error => colors.onErrorSubtle,
    };
    final style = AppTypography.body.copyWith(
      fontSize: 15,
      height: 1.4,
      color: foreground,
      fontFeatures: AppTypography.tabularFigures,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isError ? colors.errorSubtle : colors.surface,
        border: isError
            ? null
            : Border(
                top: BorderSide(color: colors.border),
                bottom: BorderSide(color: colors.border),
              ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + AppSpacing.xs,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: dot,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox.square(dimension: 8),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm + 2),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        if (title != null)
                          TextSpan(
                            text: '$title. ',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        TextSpan(text: message),
                      ],
                    ),
                    style: style,
                  ),
                ),
              ],
            ),
            if (child != null) ...[
              const SizedBox(height: AppSpacing.sm),
              child,
            ],
          ],
        ),
      ),
    );
  }
}
