import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Widget d'indicateur de chargement cohérent.
///
/// Aux couleurs principales de l'app. Utilisé en ligne ou en plein écran.
class AppLoadingIndicator extends StatelessWidget {
  /// Crée un indicateur de chargement.
  const AppLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: 40,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        strokeWidth: 4,
      ),
    );
  }
}

/// Overlay de chargement en plein écran.
///
/// Bloque les interactions et affiche un indicateur centré avec un message
/// optionnel.
class AppLoadingScreen extends StatelessWidget {
  /// Crée un écran de chargement plein écran.
  const AppLoadingScreen({this.message, super.key});

  /// Message optionnel affiché sous l'indicateur.
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLoadingIndicator(),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                message!,
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
