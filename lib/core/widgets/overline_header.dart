import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Titre de groupe (« Aujourd'hui », « Articles · 4 ») : 16/600 en casse
/// normale, avec à droite une indication ([trailing]) ou un lien
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

  /// Texte du titre, affiché tel quel.
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
        // spaceBetween : la place laissée par un titre court revient avant
        // l'indication, qui reste collée au bord droit.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Titre long (petit écran, grande police) : il passe à la ligne
            // au lieu de déborder.
            Flexible(
              flex: 3,
              child: Semantics(
                header: true,
                child: Text(
                  text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.groupTitle.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ),
            // Sans lien ni indication, le titre prend toute la largeur
            // (sinon il passait à la ligne pour rien).
            if (actionLabel != null || trailing != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 2,
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
                            textStyle: AppTypography.label,
                          ),
                          child: Text(actionLabel),
                        )
                      : trailing != null
                      ? Text(
                          trailing,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.metaRegular.copyWith(
                            color: colors.textSecondary,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
