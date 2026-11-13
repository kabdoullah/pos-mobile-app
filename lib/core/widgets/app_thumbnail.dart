import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';

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
      child: Center(
        child: CustomPaint(
          size: Size.square(size * 0.5),
          painter: _PackageIconPainter(color: colors.textSecondary),
        ),
      ),
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

/// Pictogramme « colis » de la maquette v2 (vue isométrique d'une boîte), au
/// trait 1,75 sur une grille 24 × 24, extrémités arrondies.
class _PackageIconPainter extends CustomPainter {
  const _PackageIconPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24;
    canvas.scale(scale);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.75
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    // Contour de la boîte.
    canvas
      ..drawPath(
        Path()
          ..moveTo(12, 3)
          ..lineTo(20, 7.5)
          ..lineTo(20, 16.5)
          ..lineTo(12, 21)
          ..lineTo(4, 16.5)
          ..lineTo(4, 7.5)
          ..close(),
        paint,
      )
      // Arêtes du dessus et arête centrale.
      ..drawPath(
        Path()
          ..moveTo(4, 7.5)
          ..lineTo(12, 12)
          ..lineTo(20, 7.5)
          ..moveTo(12, 12)
          ..lineTo(12, 21),
        paint,
      );
  }

  @override
  bool shouldRepaint(_PackageIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
