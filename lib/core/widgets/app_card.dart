import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_colors.dart';

/// Surface de contenu, à plat ou élevée.
///
/// Plat (v2) : aucune ombre sur ce qui est posé, la structure vient des
/// filets. [elevated] désigne l'encadré qui doit se détacher (l'état de la
/// caisse, le total) : rayon de surface (12) au lieu du rayon de contrôle.
/// Cliquable en option.
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

  /// Encadré mis en avant (rayon 12). Un seul par écran, sinon il ne
  /// signale plus rien.
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final borderRadius = BorderRadius.circular(
      elevated ? AppSpacing.radiusLg : AppSpacing.radiusMd,
    );
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: borderRadius,
        border: Border.all(color: colors.border),
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
