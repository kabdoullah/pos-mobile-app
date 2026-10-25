import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Lignes regroupées sur une seule surface à plat : fond `surface`, fine
/// bordure, filets entre les lignes. Remplace une pile de cartes séparées.
///
/// Les lignes posent leur propre `InkWell` : l'encre est découpée aux coins
/// arrondis du groupe.
class AppListGroup extends StatelessWidget {
  /// Crée un groupe de lignes.
  const AppListGroup({
    required this.children,
    this.dividerIndent = AppSpacing.md,
    super.key,
  });

  /// Lignes du groupe, de haut en bas.
  final List<Widget> children;

  /// Retrait à gauche des filets (aligné sur le texte des lignes).
  final double dividerIndent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, child) in children.indexed) ...[
            if (i > 0) _GroupDivider(indent: dividerIndent),
            child,
          ],
        ],
      ),
    );
  }
}

/// Variante sliver d'[AppListGroup] pour les longues listes paresseuses.
class SliverAppListGroup extends StatelessWidget {
  /// Crée un groupe de lignes paresseux.
  const SliverAppListGroup({
    required this.itemCount,
    required this.itemBuilder,
    this.dividerIndent = AppSpacing.md,
    super.key,
  });

  /// Nombre de lignes.
  final int itemCount;

  /// Construit la ligne d'indice donné.
  final IndexedWidgetBuilder itemBuilder;

  /// Retrait à gauche des filets (aligné sur le texte des lignes).
  final double dividerIndent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DecoratedSliver(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: cs.outlineVariant),
      ),
      sliver: SliverList.separated(
        itemCount: itemCount,
        separatorBuilder: (_, _) => _GroupDivider(indent: dividerIndent),
        // Material propre à chaque ligne : sans lui, l'encre serait peinte
        // sous le fond du groupe, donc invisible.
        itemBuilder: (context, index) => Material(
          type: MaterialType.transparency,
          child: itemBuilder(context, index),
        ),
      ),
    );
  }
}

class _GroupDivider extends StatelessWidget {
  const _GroupDivider({required this.indent});

  final double indent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: indent,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}
