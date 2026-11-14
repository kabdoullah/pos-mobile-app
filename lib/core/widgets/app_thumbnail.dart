import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import 'stroke_icon.dart';

/// Vignette carrée d'une image, ou pictogramme « colis » de la maquette v2 si
/// aucune image, pendant le chargement ou en cas d'erreur.
class AppThumbnail extends StatelessWidget {
  /// Crée une vignette de [size] points.
  const AppThumbnail({required this.image, this.size = 44, super.key});

  /// Image affichée (null = pictogramme).
  final ImageProvider? image;

  /// Côté de la vignette.
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final image = this.image;
    // Décodage à la taille affichée : pas d'image pleine résolution en mémoire.
    final cacheSize = (size * MediaQuery.devicePixelRatioOf(context)).round();
    final fallback = ColoredBox(
      color: colors.surfaceSunken,
      child: Center(child: PackageIcon(size: size * 0.5)),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: SizedBox.square(
        dimension: size,
        child: image == null
            ? fallback
            : Image(
                image: ResizeImage(image, width: cacheSize),
                fit: BoxFit.cover,
                gaplessPlayback: true,
                frameBuilder: (_, child, frame, wasSynchronouslyLoaded) =>
                    frame == null && !wasSynchronouslyLoaded ? fallback : child,
                errorBuilder: (_, _, _) => fallback,
              ),
      ),
    );
  }
}
