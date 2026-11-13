import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';

/// Hauteur de la zone caméra du scanner de vente.
const double saleScannerPanelHeight = 260;

/// Zone caméra du scanner de vente : image pleine largeur, cadre de visée au
/// trait de la couleur de marque et consigne en bas.
///
/// Le [MobileScanner] n'est monté que si [isActive] : le démonter libère la
/// caméra (feuille ouverte, page recouverte).
class SaleScannerPanel extends StatelessWidget {
  /// Crée la zone caméra.
  const SaleScannerPanel({
    required this.controller,
    required this.isActive,
    required this.isPermissionGranted,
    required this.isCheckingPermission,
    required this.onDetect,
    required this.onOpenAppSettings,
    required this.onManualEntry,
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

  /// Appelé à chaque détection de code-barres.
  final void Function(BarcodeCapture) onDetect;

  /// Ouvre les réglages système (permission refusée).
  final VoidCallback onOpenAppSettings;

  /// Revient à la saisie du code au clavier (permission refusée).
  final VoidCallback onManualEntry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: saleScannerPanelHeight,
      child: ColoredBox(
        color: AppColors.cameraBackground,
        child: switch ((isCheckingPermission, isPermissionGranted)) {
          (true, _) => const Center(child: AppLoadingIndicator()),
          (false, false) => _PermissionDenied(
            onOpen: onOpenAppSettings,
            onManualEntry: onManualEntry,
          ),
          _ => Stack(
            fit: StackFit.expand,
            children: [
              if (isActive)
                MobileScanner(controller: controller, onDetect: onDetect),
              const CustomPaint(painter: _ViewfinderPainter()),
              Positioned(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.md - 2,
                child: Text(
                  'Placez le code-barres dans le cadre',
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(
                    fontSize: 15,
                    color: AppColors.onCamera,
                  ),
                ),
              ),
            ],
          ),
        },
      ),
    );
  }
}

class _PermissionDenied extends StatelessWidget {
  const _PermissionDenied({required this.onOpen, required this.onManualEntry});

  final VoidCallback onOpen;
  final VoidCallback onManualEntry;

  @override
  Widget build(BuildContext context) {
    final brand = AppColors.dark.action;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.no_photography_outlined, color: AppColors.onCamera),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Accès à la caméra refusé.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyStrong.copyWith(color: AppColors.onCamera),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.sm,
            children: [
              TextButton(
                onPressed: onOpen,
                style: TextButton.styleFrom(foregroundColor: brand),
                child: const Text('Autoriser'),
              ),
              TextButton(
                onPressed: onManualEntry,
                style: TextButton.styleFrom(foregroundColor: brand),
                child: const Text('Saisir le code à la main'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Voile sombre percé d'un cadre de visée horizontal (forme d'un code EAN),
/// bordé de la couleur de marque.
class _ViewfinderPainter extends CustomPainter {
  const _ViewfinderPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: size.center(Offset.zero).translate(0, -AppSpacing.sm),
      width: (size.width - AppSpacing.xxl).clamp(0, 220),
      height: (size.height - AppSpacing.xxl).clamp(0, 110),
    );
    final hole = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(AppSpacing.radiusSm),
    );

    canvas
      ..drawPath(
        Path()
          ..addRect(Offset.zero & size)
          ..addRRect(hole)
          ..fillType = PathFillType.evenOdd,
        Paint()..color = AppColors.cameraScrim,
      )
      ..drawRRect(
        hole,
        Paint()
          ..color = AppColors.light.brand
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
