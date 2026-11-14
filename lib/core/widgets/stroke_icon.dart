import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Pictogrammes dessinés de la maquette v2 (grille 24 × 24, trait 1,75,
/// extrémités arrondies), sans police d'icônes.
enum DesignIcon {
  /// Accueil : maison.
  home,

  /// Vendre : caisse enregistreuse.
  sell,

  /// Stock : caisse de rangement.
  stock,

  /// Historique : ticket.
  history,

  /// Paramètres : rouage.
  settings,

  /// Produit sans photo : colis.
  package,
}

/// Pictogramme dessiné [icon] de [size] points, en [color] (texte secondaire
/// par défaut).
class StrokeIcon extends StatelessWidget {
  /// Crée le pictogramme.
  const StrokeIcon(this.icon, {this.size = 24, this.color, super.key});

  /// Pictogramme à dessiner.
  final DesignIcon icon;

  /// Côté du pictogramme.
  final double size;

  /// Couleur du trait ; texte secondaire du thème par défaut.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _StrokeIconPainter(
        icon: icon,
        color: color ?? AppColors.of(context).textSecondary,
      ),
    );
  }
}

/// Pictogramme « colis » : produit sans photo (vignettes) et états vides du
/// catalogue.
class PackageIcon extends StatelessWidget {
  /// Crée le pictogramme de [size] points.
  const PackageIcon({this.size = 24, this.color, super.key});

  /// Côté du pictogramme.
  final double size;

  /// Couleur du trait ; texte secondaire du thème par défaut.
  final Color? color;

  @override
  Widget build(BuildContext context) =>
      StrokeIcon(DesignIcon.package, size: size, color: color);
}

class _StrokeIconPainter extends CustomPainter {
  const _StrokeIconPainter({required this.icon, required this.color});

  final DesignIcon icon;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.75
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(_pathFor(icon), paint);
  }

  /// Tracés de la maquette, transcrits du SVG (coordonnées absolues).
  static Path _pathFor(DesignIcon icon) {
    void line(Path p, double x1, double y1, double x2, double y2) => p
      ..moveTo(x1, y1)
      ..lineTo(x2, y2);
    final path = Path();
    switch (icon) {
      case DesignIcon.home:
        // M4 11l8-7 8 7v9h-5v-6H9v6H4z
        path
          ..moveTo(4, 11)
          ..lineTo(12, 4)
          ..lineTo(20, 11)
          ..lineTo(20, 20)
          ..lineTo(15, 20)
          ..lineTo(15, 14)
          ..lineTo(9, 14)
          ..lineTo(9, 20)
          ..lineTo(4, 20)
          ..close();
      case DesignIcon.sell:
        // M4 11h16v9H4z M7 4h10v4H7z M8 14h1 M11.5 14h1 M15 14h1 M8 17h8
        path
          ..addRect(const Rect.fromLTWH(4, 11, 16, 9))
          ..addRect(const Rect.fromLTWH(7, 4, 10, 4));
        line(path, 8, 14, 9, 14);
        line(path, 11.5, 14, 12.5, 14);
        line(path, 15, 14, 16, 14);
        line(path, 8, 17, 16, 17);
      case DesignIcon.stock:
        // M4 8h16v12H4z M3 4h18v4H3z M10 12h4
        path
          ..addRect(const Rect.fromLTWH(4, 8, 16, 12))
          ..addRect(const Rect.fromLTWH(3, 4, 18, 4));
        line(path, 10, 12, 14, 12);
      case DesignIcon.history:
        // M6 3h12v18l-3-2-3 2-3-2-3 2z M9 8h6 M9 12h6
        path
          ..moveTo(6, 3)
          ..lineTo(18, 3)
          ..lineTo(18, 21)
          ..lineTo(15, 19)
          ..lineTo(12, 21)
          ..lineTo(9, 19)
          ..lineTo(6, 21)
          ..close();
        line(path, 9, 8, 15, 8);
        line(path, 9, 12, 15, 12);
      case DesignIcon.settings:
        // Cercle r3 centré, puis 8 rayons.
        path.addOval(Rect.fromCircle(center: const Offset(12, 12), radius: 3));
        line(path, 12, 2, 12, 5);
        line(path, 12, 19, 12, 22);
        line(path, 2, 12, 5, 12);
        line(path, 19, 12, 22, 12);
        line(path, 4.9, 4.9, 7, 7);
        line(path, 17, 17, 19.1, 19.1);
        line(path, 4.9, 19.1, 7, 17);
        line(path, 17, 7, 19.1, 4.9);
      case DesignIcon.package:
        // M12 3l8 4.5v9L12 21l-8-4.5v-9z M4 7.5l8 4.5 8-4.5 M12 12v9
        path
          ..moveTo(12, 3)
          ..lineTo(20, 7.5)
          ..lineTo(20, 16.5)
          ..lineTo(12, 21)
          ..lineTo(4, 16.5)
          ..lineTo(4, 7.5)
          ..close()
          ..moveTo(4, 7.5)
          ..lineTo(12, 12)
          ..lineTo(20, 7.5);
        line(path, 12, 12, 12, 21);
    }
    return path;
  }

  @override
  bool shouldRepaint(_StrokeIconPainter oldDelegate) =>
      oldDelegate.icon != icon || oldDelegate.color != color;
}
