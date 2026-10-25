import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';

/// Section de paramètres : titre puis ses lignes, sur une surface à plat
/// unique ([AppListGroup], pas de cartes imbriquées).
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
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.sm,
              bottom: AppSpacing.xs,
            ),
            child: Semantics(
              header: true,
              child: Text(
                title,
                style: AppTypography.labelMedium.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          AppListGroup(dividerIndent: 56, children: children),
        ],
      ),
    );
  }
}

/// Ligne de paramètre : icône, titre, description courte, et chevron si elle
/// ouvre un écran ou une feuille.
class SettingsTile extends StatelessWidget {
  /// Crée une ligne.
  const SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.showChevron = false,
    this.busy = false,
    this.trailing,
    this.destructive = false,
    super.key,
  });

  /// Icône de début.
  final IconData icon;

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

  /// Action destructive (déconnexion…) : couleur d'erreur.
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = destructive ? cs.error : null;

    return ListTile(
      leading: Icon(icon, color: color ?? cs.onSurfaceVariant),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color),
      ),
      subtitle: subtitle,
      onTap: busy ? null : onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      trailing: busy
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : trailing ??
                (showChevron
                    ? Icon(Icons.chevron_right, color: cs.onSurfaceVariant)
                    : null),
    );
  }
}
