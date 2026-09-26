import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/theme/app_animations.dart';
import '../../app/theme/app_colors.dart';

/// Indicateur de chargement animé avec variation de taille/opacité.
///
/// Alternative soignée au CircularProgressIndicator standard. Grossit et
/// rétrécit en boucle tout en tournant, pour attirer l'attention.
class AnimatedLoadingSpinner extends StatefulWidget {
  /// Crée un indicateur de chargement animé.
  const AnimatedLoadingSpinner({
    this.size = 48,
    this.color = AppColors.primary,
    super.key,
  });

  /// Taille de l'indicateur (diamètre).
  final double size;

  /// Couleur de l'indicateur.
  final Color color;

  @override
  State<AnimatedLoadingSpinner> createState() => _AnimatedLoadingSpinnerState();
}

class _AnimatedLoadingSpinnerState extends State<AnimatedLoadingSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );
    unawaited(_controller.repeat(reverse: true));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox.square(
        dimension: widget.size,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(widget.color),
        ),
      ),
    );
  }
}
