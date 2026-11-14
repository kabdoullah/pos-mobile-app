import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Dialogue v2 : titre 20/600, message en `textSecondary`, contenu libre,
/// puis les actions empilées pleine largeur (l'action principale en haut,
/// « Annuler » en bouton texte dessous).
///
/// Le cadre (surface, rayon 12, ombre ou filet) vient du `DialogTheme`.
class AppDialog extends StatelessWidget {
  /// Crée un dialogue.
  const AppDialog({
    required this.title,
    required this.actions,
    this.message,
    this.body = const [],
    super.key,
  });

  /// Titre, formulé comme une question pour une confirmation.
  final String title;

  /// Phrase d'explication sous le titre.
  final String? message;

  /// Contenu supplémentaire entre le message et les actions.
  final List<Widget> body;

  /// Actions empilées de haut en bas.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final message = this.message;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          AppSpacing.lg,
          20,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: AppTypography.sectionTitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 12),
              Text(
                message,
                style: AppTypography.body.copyWith(color: colors.textSecondary),
              ),
            ],
            for (final child in body) ...[const SizedBox(height: 12), child],
            const SizedBox(height: AppSpacing.md),
            for (final (i, action) in actions.indexed) ...[
              if (i > 0) const SizedBox(height: AppSpacing.xs),
              action,
            ],
          ],
        ),
      ),
    );
  }
}

/// Bouton texte pleine largeur pour les actions tertiaires d'un dialogue
/// (Annuler, Revenir, Fermer).
class AppDialogTextAction extends StatelessWidget {
  /// Crée une action texte.
  const AppDialogTextAction({
    required this.label,
    required this.onPressed,
    super.key,
  });

  /// Libellé.
  final String label;

  /// Callback ; null désactive le bouton.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.buttonHeightSm,
      child: TextButton(onPressed: onPressed, child: Text(label)),
    );
  }
}
