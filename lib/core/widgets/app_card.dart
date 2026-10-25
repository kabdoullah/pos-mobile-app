import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_colors.dart';

/// Surface de contenu, à plat ou élevée.
///
/// La hiérarchie d'un écran tient en trois niveaux : le fond de page, les
/// surfaces à plat (listes, groupes — fine bordure, sans ombre) et une seule
/// surface élevée, réservée à l'objet principal de l'écran (total, vente en
/// cours). Cliquable en option.
class AppCard extends StatelessWidget {
  /// Crée une surface.
  const AppCard({
    required this.child,
    this.onTap,
    this.padding = AppSpacing.md,
    this.elevated = false,
    super.key,
  });

  /// Contenu de la surface.
  final Widget child;

  /// Callback au tap sur la surface. Si null, elle n'est pas cliquable.
  final VoidCallback? onTap;

  /// Padding interne autour de l'enfant.
  final double padding;

  /// Surface élevée : ombre teintée cacao et coins plus arrondis. Une seule
  /// par écran, sinon elle ne signale plus rien.
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final borderRadius = BorderRadius.circular(
      elevated ? AppSpacing.radiusLg : AppSpacing.radiusMd,
    );
    return Container(
      decoration: BoxDecoration(
        color: elevated ? semantic.raisedSurface : cs.surface,
        borderRadius: borderRadius,
        border: elevated ? null : Border.all(color: cs.outlineVariant),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: semantic.elevationShadow.withValues(alpha: 0.14),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Padding(padding: EdgeInsets.all(padding), child: child),
        ),
      ),
    );
  }
}
