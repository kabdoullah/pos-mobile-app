import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/app/app.dart';
import 'package:mobile/app/theme/theme_mode_provider.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/core/sync/sync_orchestrator.dart';

class _FakeSync extends SyncOrchestrator {
  @override
  SyncStatus build() => const SyncStatusIdle();
}

void main() {
  // Téléphone en mode sombre, app réglée en clair : la première frame doit
  // déjà être claire (sinon écran sombre entre le splash et la page PIN).
  testWidgets('la première frame suit le thème enregistré, pas le système', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    Brightness? firstFrame;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) {
            firstFrame ??= Theme.of(context).brightness;
            return const SizedBox();
          },
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          themeModeProvider.overrideWith(
            () => ThemeModeNotifier(ThemeMode.light),
          ),
          appRouterProvider.overrideWithValue(router),
          syncOrchestratorProvider.overrideWith(_FakeSync.new),
        ],
        child: const PosMobileApp(),
      ),
    );

    expect(firstFrame, Brightness.light);
  });
}
