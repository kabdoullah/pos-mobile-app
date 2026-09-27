import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Bloc de chargement (squelette) : réserve la place du contenu à venir au
/// lieu d'un indicateur plein écran. Pulsation douce, respecte le mode sombre.
class SkeletonBox extends StatefulWidget {
  /// Crée un bloc squelette de taille fixe.
  const SkeletonBox({
    this.width = double.infinity,
    required this.height,
    this.radius = AppSpacing.radiusMd,
    super.key,
  });

  /// Largeur (par défaut : toute la largeur disponible).
  final double width;

  /// Hauteur du bloc.
  final double height;

  /// Rayon des angles.
  final double radius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    lowerBound: 0.5,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Semantics(
      label: 'Chargement',
      child: FadeTransition(
        opacity: _controller,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        ),
      ),
    );
  }
}
