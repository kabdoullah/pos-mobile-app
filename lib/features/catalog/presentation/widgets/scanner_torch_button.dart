import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Bouton « Lampe » de la barre d'un scanner : allume ou éteint le flash.
///
/// L'état affiché vient du contrôleur (pas d'un booléen local) : il reste
/// juste quand la caméra redémarre ou que le système coupe le flash. Masqué
/// tant que la caméra n'a pas démarré ou si l'appareil n'a pas de flash.
class ScannerTorchButton extends StatelessWidget {
  /// Crée le bouton lampe lié à [controller].
  const ScannerTorchButton({required this.controller, super.key});

  /// Contrôleur de la caméra, possédé par la page.
  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MobileScannerState>(
      valueListenable: controller,
      builder: (context, state, _) {
        if (!state.isRunning || state.torchState == TorchState.unavailable) {
          return const SizedBox.shrink();
        }
        final isOn = state.torchState == TorchState.on;
        return TextButton.icon(
          onPressed: () => unawaited(controller.toggleTorch()),
          icon: Icon(
            isOn ? Icons.flashlight_off : Icons.flashlight_on,
            size: 20,
          ),
          label: Text(isOn ? 'Éteindre' : 'Lampe'),
        );
      },
    );
  }
}
