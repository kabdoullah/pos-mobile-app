import 'package:flutter/material.dart';

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

/// Bandeau d'avertissement d'une session de caisse, avec un contenu
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
    final cs = Theme.of(context).colorScheme;
    final (color, icon) = switch (level) {
      CashNoticeLevel.info => (cs.primary, Icons.info_outline),
      CashNoticeLevel.warning => (cs.tertiary, Icons.warning_amber_outlined),
      CashNoticeLevel.error => (cs.error, Icons.error_outline),
    };
    final title = this.title;
    final child = this.child;
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      Text(
                        title,
                        style: AppTypography.labelLarge.copyWith(
                          color: cs.onSurface,
                        ),
                      ),
                    Text(
                      message,
                      style: AppTypography.bodyMedium.copyWith(
                        color: cs.onSurface,
                        fontFeatures: AppTypography.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (child != null) ...[const SizedBox(height: AppSpacing.md), child],
        ],
      ),
    );
  }
}
