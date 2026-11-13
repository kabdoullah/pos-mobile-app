import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Pictogramme « colis » de la maquette v2 : produit sans photo (vignettes)
/// et états vides du catalogue. Dessiné au trait, sans police d'icônes.
class PackageIcon extends StatelessWidget {
  /// Crée le pictogramme de [size] points, en [color] (texte secondaire par
  /// défaut).
  const PackageIcon({this.size = 24, this.color, super.key});

  /// Côté du pictogramme.
  final double size;

  /// Couleur du trait ; texte secondaire du thème par défaut.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _PackageIconPainter(
        color: color ?? AppColors.of(context).textSecondary,
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
