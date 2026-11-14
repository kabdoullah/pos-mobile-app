import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';

/// Section de paramètres : sur-titre puis ses lignes, en liste à plat
/// pleine largeur.
class SettingsSection extends StatelessWidget {
  /// Crée une section.
  const SettingsSection({
    required this.title,
    required this.children,
    super.key,
  });

  /// Titre de la section (ex. « Caisse »).
  final String title;

  /// Lignes de la section.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OverlineHeader(title),
        FlatList(children: children),
      ],
    );
  }
}

/// Ligne de paramètre : titre, état ou description courte dessous, élément
/// de fin (action, chevron) ; [below] ajoute un contrôle pleine largeur
/// (ex. apparence).
class SettingsTile extends StatelessWidget {
  /// Crée une ligne.
  const SettingsTile({
    required this.title,
    this.subtitle,
    this.onTap,
    this.showChevron = false,
    this.busy = false,
    this.trailing,
    this.destructive = false,
    this.below,
    super.key,
  });

  /// Titre.
  final String title;

  /// Description courte ou état (ex. imprimante connectée).
  final Widget? subtitle;

  /// Action ; `null` rend la ligne informative.
  final VoidCallback? onTap;

  /// Affiche un chevron (navigation vers un écran ou une feuille).
  final bool showChevron;

  /// Action en cours : remplace l'élément de fin par un indicateur.
  final bool busy;

  /// Élément de fin personnalisé (prioritaire sur le chevron).
  final Widget? trailing;

  /// Action destructive (suppression du compte) : couleur d'erreur.
  final bool destructive;

  /// Contrôle affiché sous le titre, sur toute la largeur.
  final Widget? below;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final subtitle = this.subtitle;
    final below = this.below;
    final trailing = busy
        ? const Padding(
            padding: EdgeInsets.all(AppSpacing.sm + 2),
            child: SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        : this.trailing ??
              (showChevron
                  ? Icon(Icons.chevron_right, color: colors.textSecondary)
                  : null);

    return InkWell(
      onTap: busy ? null : onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            trailing == null ? AppSpacing.md : AppSpacing.xs,
            AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.bodyStrong.copyWith(
                            color: destructive ? colors.error : null,
                          ),
                        ),
                        if (subtitle != null)
                          DefaultTextStyle.merge(
                            style: AppTypography.bodySmall.copyWith(
                              color: colors.textSecondary,
                            ),
                            child: subtitle,
                          ),
                      ],
                    ),
                  ),
                  ?trailing,
                ],
              ),
              if (below != null) ...[
                const SizedBox(height: AppSpacing.sm),
                below,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
