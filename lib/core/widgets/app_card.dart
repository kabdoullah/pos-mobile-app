import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Conteneur de carte minimal avec une élévation discrète.
///
/// Inspiré du design plat de Wave. Fond blanc avec ombre discrète et coins
/// arrondis. Cliquable en option.
class AppCard extends StatelessWidget {
  /// Crée une carte.
  const AppCard({
    required this.child,
    this.onTap,
    this.padding = AppSpacing.md,
    super.key,
  });

  /// Contenu de la carte.
  final Widget child;

  /// Callback au tap sur la carte. Si null, la carte n'est pas cliquable.
  final VoidCallback? onTap;

  /// Padding interne autour de l'enfant.
  final double padding;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(AppSpacing.radiusMd);
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
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
