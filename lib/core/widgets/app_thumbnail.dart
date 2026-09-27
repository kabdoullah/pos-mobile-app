import 'dart:io';

import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';

/// Vignette carrée d'une image locale, ou pictogramme si aucune image.
class AppThumbnail extends StatelessWidget {
  /// Crée une vignette de [size] points.
  const AppThumbnail({
    required this.file,
    this.size = 44,
    this.placeholder = Icons.inventory_2_outlined,
    super.key,
  });

  /// Fichier image (null = pictogramme).
  final File? file;

  /// Côté de la vignette.
  final double size;

  /// Pictogramme affiché sans image.
  final IconData placeholder;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final file = this.file;
    // Décodage à la taille affichée : pas d'image pleine résolution en mémoire.
    final cacheSize = (size * MediaQuery.devicePixelRatioOf(context)).round();
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: SizedBox.square(
        dimension: size,
        child: file == null
            ? ColoredBox(
                color: cs.surfaceContainerHighest,
                child: Icon(
                  placeholder,
                  size: size * 0.5,
                  color: cs.onSurfaceVariant,
                ),
              )
            : Image.file(
                file,
                fit: BoxFit.cover,
                cacheWidth: cacheSize,
                gaplessPlayback: true,
                errorBuilder: (_, _, _) => ColoredBox(
                  color: cs.surfaceContainerHighest,
                  child: Icon(placeholder, color: cs.onSurfaceVariant),
                ),
              ),
      ),
    );
  }
}
