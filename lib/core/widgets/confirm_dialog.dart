import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Affiche un dialogue de confirmation.
///
/// Retourne true si l'utilisateur confirme, false s'il annule.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirmer',
  String cancelLabel = 'Annuler',
  bool isDangerous = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      contentPadding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      // Un seul enfant (la Row) : AlertDialog n'empile jamais les boutons.
      // Annuler à gauche, l'action à droite, à largeur égale ; un libellé
      // long passe sur deux lignes dans son bouton.
      actions: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 56,
                child: TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    cancelLabel,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    // Même taille que l'action : annuler est un vrai choix.
                    style: AppTypography.labelLarge.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // Couleurs du thème : correctes en clair comme en sombre.
                    backgroundColor: isDangerous
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                    foregroundColor: isDangerous
                        ? Theme.of(context).colorScheme.onError
                        : Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    confirmLabel,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  return result ?? false;
}
