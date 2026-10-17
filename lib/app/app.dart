import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/sync/sync_orchestrator.dart';
import '../features/auth/presentation/providers/session_lock_provider.dart';
import 'theme.dart';
import 'theme/theme_mode_provider.dart';
import '../core/router/app_router.dart';

/// Widget racine de l'application.
class PosMobileApp extends ConsumerWidget {
  /// Constructeur.
  const PosMobileApp({super.key});

  static final ThemeData _lightTheme = AppTheme.light();
  static final ThemeData _darkTheme = AppTheme.dark();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Garde SyncOrchestrator en vie sans reconstruire l'UI à chaque changement
    // d'état de synchro.
    ref.listen(syncOrchestratorProvider, (_, _) {});
    // Idem pour le verrouillage de session après inactivité.
    ref.listen(sessionLockProvider, (_, _) {});

    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'POS Mobile',
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: kDebugMode,
      builder: (context, child) {
        // Chaque toucher, dialogues compris, repousse le verrouillage.
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (_) =>
              ref.read(sessionLockProvider.notifier).recordActivity(),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
