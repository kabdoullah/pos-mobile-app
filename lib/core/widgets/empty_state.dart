import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import 'primary_button.dart';

/// Affichage d'état vide pour les listes et conteneurs.
///
/// Affiché quand aucune donnée n'est disponible. Comprend une icône, un titre,
/// un message et un bouton d'action optionnel. Centré, sur un ton encourageant.
class EmptyState extends StatelessWidget {
  /// Crée un état vide.
  const EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  /// Icône à afficher (grande, couleur principale).
  final IconData icon;

  /// Texte du titre.
  final String title;

  /// Texte du message descriptif.
  final String message;

  /// Libellé du bouton d'action optionnel.
  final String? actionLabel;

  /// Callback au tap sur le bouton d'action.
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icône dans une pastille : présente sans écraser le message,
              // y compris clavier ouvert sur petit écran.
              DecoratedBox(
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Icon(icon, size: 48, color: cs.primary),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                style: AppTypography.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    label: actionLabel!,
                    onPressed: onAction,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
