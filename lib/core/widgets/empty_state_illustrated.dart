import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';
import 'primary_button.dart';

/// État vide avec illustration SVG.
///
/// Alternative soignée aux états vides avec icône seule. Illustration SVG
/// terracotta + émeraude, titre, message, bouton d'action optionnel.
class EmptyStateIllustrated extends StatelessWidget {
  /// Crée un état vide illustré.
  const EmptyStateIllustrated({
    required this.illustration,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.illustrationSize = 180,
    super.key,
  });

  /// Illustration SVG (sous forme de String, ex. depuis la classe
  /// Illustrations).
  final String illustration;

  /// Texte du titre.
  final String title;

  /// Texte du message descriptif.
  final String message;

  /// Libellé du bouton d'action optionnel.
  final String? actionLabel;

  /// Callback au tap sur le bouton d'action.
  final VoidCallback? onAction;

  /// Taille de l'illustration (largeur/hauteur).
  final double illustrationSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.square(
                dimension: illustrationSize,
                child: SvgPicture.string(illustration),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                title,
                style: AppTypography.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                message,
                style: AppTypography.bodyMedium,
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
