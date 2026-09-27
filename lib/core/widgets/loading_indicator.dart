import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

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
