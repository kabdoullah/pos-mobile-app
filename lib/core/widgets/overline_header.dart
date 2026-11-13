import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Sur-titre de groupe v2 (« AUJOURD'HUI », « ARTICLES · 4 ») : 13/600 en
/// majuscules, avec à droite une indication ([trailing]) ou un lien
/// ([actionLabel]).
class OverlineHeader extends StatelessWidget {
  /// Crée le sur-titre.
  const OverlineHeader(
    this.text, {
    this.trailing,
    this.actionLabel,
    this.onAction,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.md,
      AppSpacing.lg,
      AppSpacing.md,
      AppSpacing.xs + 2,
    ),
    super.key,
  });

  /// Texte du sur-titre (mis en majuscules).
  final String text;

  /// Indication discrète à droite (ex. « Pic : 10 h – 11 h »).
  final String? trailing;

  /// Lien à droite (ex. « Voir tout »), avec [onAction].
  final String? actionLabel;

  /// Action du lien.
  final VoidCallback? onAction;

  /// Marges du sur-titre.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final trailing = this.trailing;
    final actionLabel = this.actionLabel;
    return Padding(
      padding: padding,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 32),
        child: Row(
          children: [
            Semantics(
              header: true,
              child: Text(
                text.toUpperCase(),
                style: AppTypography.overline.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: actionLabel != null
                    ? TextButton(
                        onPressed: onAction,
                        style: TextButton.styleFrom(
                          minimumSize: const Size(0, 32),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                          ),
                          textStyle: AppTypography.labelLarge.copyWith(
                            fontSize: 15,
                          ),
                        ),
                        child: Text(actionLabel),
                      )
                    : trailing != null
                    ? Text(
                        trailing,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
