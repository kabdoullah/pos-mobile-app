import 'package:flutter/widgets.dart';

/// Bord inférieur en dents de scie : le papier déchiré d'un ticket de caisse.
///
/// Signature visuelle de l'app : reçus à l'écran et bandeau de connexion.
class ZigzagClipper extends CustomClipper<Path> {
  /// Crée le découpage.
  const ZigzagClipper();

  /// Hauteur des dents : à réserver en bas du contenu découpé.
  static const double toothHeight = 6;
  static const double _toothWidth = 12;

  @override
  Path getClip(Size size) {
    final bottom = size.height - toothHeight;
    final path = Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, bottom);
    final teeth = (size.width / _toothWidth).ceil();
    final step = size.width / teeth;
    for (var i = teeth; i > 0; i--) {
      final x = i * step;
      path
        ..lineTo(x - step / 2, size.height)
        ..lineTo(x - step, bottom);
    }
    return path..close();
  }

  @override
  bool shouldReclip(ZigzagClipper oldClipper) => false;
}
