import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Vignette carrée d'une image, ou pictogramme si aucune image, pendant le
/// chargement ou en cas d'erreur.
class AppThumbnail extends StatelessWidget {
  /// Crée une vignette de [size] points.
  const AppThumbnail({
    required this.image,
    this.size = 44,
    this.placeholder = Icons.inventory_2_outlined,
    super.key,
  });

  /// Image affichée (null = pictogramme).
  final ImageProvider? image;

  /// Côté de la vignette.
  final double size;

  /// Pictogramme affiché sans image.
  final IconData placeholder;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final image = this.image;
    // Décodage à la taille affichée : pas d'image pleine résolution en mémoire.
    final cacheSize = (size * MediaQuery.devicePixelRatioOf(context)).round();
    final fallback = ColoredBox(
      color: cs.surfaceContainerHighest,
      child: Icon(placeholder, size: size * 0.5, color: cs.onSurfaceVariant),
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
