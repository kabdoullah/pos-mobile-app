import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../presentation/providers/auth_providers.dart';

/// Gère le routage initial après le lancement de l'app.
///
/// Affiche un placeholder invisible pendant que le splash natif est visible.
/// Retire le splash natif quand l'état d'auth est résolu ; le `ref.listen` du
/// routeur dans `appRouter` déclenche alors la redirection adaptée.
class SplashPage extends ConsumerWidget {
  /// Crée une page de démarrage.
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Retire le splash natif quand l'auth passe de chargement → résolu.
    ref.listen(authProvider, (previous, next) {
      if (previous?.isLoading == true && !next.isLoading) {
        FlutterNativeSplash.remove();
      }
    });

    // Cas limite : auth déjà résolue au premier build (hot reload, init
    // rapide).
    if (!ref.watch(authProvider).isLoading) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => FlutterNativeSplash.remove(),
      );
    }

    // Le splash natif couvre entièrement cet écran. La couleur reprend celle du
    // splash natif (flutter_native_splash.yaml : color / color_dark) pour
    // éviter un flash sur l'unique frame entre remove() et la redirection.
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.brightness == Brightness.dark
          ? theme.colorScheme.surface
          : AppColors.background,
    );
  }
}
