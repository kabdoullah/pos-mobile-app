import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';

/// Hauteur du bandeau caméra de la caisse.
const double saleScannerPanelHeight = 168;

// La zone caméra reste sombre quel que soit le thème de l'app.
const _cameraBackground = Color(0xFF0C0906);
const _cameraOverlay = Color(0x991C1107);
const _cameraForeground = Color(0xB3FFFFFF);
// Or secondaire du thème, accent du viseur.
const _viewfinderColor = Color(0xFFCA8A04);

/// Bandeau caméra compact : scan en continu au-dessus du panier.
///
/// Le [MobileScanner] n'est monté que si [isActive] : le démonter libère la
/// caméra (bottom sheet ouvert, page recouverte, bandeau replié).
class SaleScannerPanel extends StatelessWidget {
  /// Crée le bandeau caméra.
  const SaleScannerPanel({
    required this.controller,
    required this.isActive,
    required this.isPermissionGranted,
    required this.isCheckingPermission,
    required this.isTorchOn,
    required this.onDetect,
    required this.onToggleTorch,
    required this.onOpenAppSettings,
    super.key,
  });

  /// Contrôleur de la caméra, possédé par la page.
  final MobileScannerController controller;

  /// La caméra doit tourner (sinon fond sombre en pause).
  final bool isActive;

  /// Permission caméra accordée.
  final bool isPermissionGranted;

  /// Demande de permission en cours.
  final bool isCheckingPermission;

  /// Torche allumée.
  final bool isTorchOn;

  /// Appelé à chaque détection de code-barres.
  final void Function(BarcodeCapture) onDetect;

  /// Allume ou éteint la torche.
  final VoidCallback onToggleTorch;

  /// Ouvre les réglages système (permission refusée).
  final VoidCallback onOpenAppSettings;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: saleScannerPanelHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: ColoredBox(
          color: _cameraBackground,
          child: switch ((isCheckingPermission, isPermissionGranted)) {
            (true, _) => const Center(child: AppLoadingIndicator()),
            (false, false) => _PermissionDenied(onOpen: onOpenAppSettings),
            _ when !isActive => const SizedBox.expand(),
            _ => Stack(
              fit: StackFit.expand,
              children: [
                MobileScanner(controller: controller, onDetect: onDetect),
                const CustomPaint(painter: _ViewfinderPainter()),
                Positioned(
                  top: AppSpacing.xs,
                  right: AppSpacing.xs,
                  child: IconButton(
                    tooltip: isTorchOn ? 'Éteindre la torche' : 'Torche',
                    color: _cameraForeground,
                    icon: Icon(
                      isTorchOn ? Icons.flashlight_off : Icons.flashlight_on,
                    ),
                    onPressed: onToggleTorch,
                  ),
                ),
              ],
            ),
          },
        ),
      ),
    );
  }
}

class _PermissionDenied extends StatelessWidget {
  const _PermissionDenied({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          const Icon(Icons.no_photography_outlined, color: _cameraForeground),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Accès caméra refusé. Recherchez les produits par nom, ou '
              'autorisez la caméra.',
              style: AppTypography.bodySmall.copyWith(color: _cameraForeground),
            ),
          ),
          TextButton(
            onPressed: onOpen,
            style: TextButton.styleFrom(foregroundColor: _viewfinderColor),
            child: const Text('Autoriser'),
          ),
        ],
      ),
    );
  }
}

/// Voile sombre percé d'un viseur horizontal (forme d'un code EAN) avec coins
/// accentués.
class _ViewfinderPainter extends CustomPainter {
  const _ViewfinderPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: (size.width - AppSpacing.xxl).clamp(0, 280),
      height: (size.height - AppSpacing.xl).clamp(0, 110),
    );
    final hole = RRect.fromRectAndRadius(rect, const Radius.circular(12));

    canvas.drawPath(
      Path()
        ..addRect(Offset.zero & size)
        ..addRRect(hole)
        ..fillType = PathFillType.evenOdd,
      Paint()..color = _cameraOverlay,
    );

    final corner = Paint()
      ..color = _viewfinderColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const len = 20.0;
    for (final (point, dx, dy) in [
      (rect.topLeft, 1.0, 1.0),
      (rect.topRight, -1.0, 1.0),
      (rect.bottomLeft, 1.0, -1.0),
      (rect.bottomRight, -1.0, -1.0),
    ]) {
      canvas
        ..drawLine(point, point.translate(len * dx, 0), corner)
        ..drawLine(point, point.translate(0, len * dy), corner);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
