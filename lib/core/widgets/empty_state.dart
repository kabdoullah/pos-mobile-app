import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import 'stroke_icon.dart';
import 'primary_button.dart';

/// Affichage d'état vide pour les listes et conteneurs (v2) : pictogramme au
/// trait 32 dp en texte secondaire, sans pastille ; titre 18/600, phrase 16,
/// une action. Centré, sur un ton encourageant.
class EmptyState extends StatelessWidget {
  /// Crée un état vide.
  const EmptyState({
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon,
    this.graphic,
    super.key,
  }) : assert(
         (icon == null) != (graphic == null),
         'Fournir soit une icône, soit un pictogramme dessiné.',
       );

  /// Icône Material à afficher.
  final IconData? icon;

  /// Pictogramme dessiné à la place de [icon] (ex. [PackageIcon]).
  final Widget? graphic;

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
    final colors = AppColors.of(context);
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child:
                    graphic ??
                    Icon(icon, size: 32, color: colors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                style: AppTypography.bodyStrong.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: AppTypography.body.copyWith(color: colors.textSecondary),
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
