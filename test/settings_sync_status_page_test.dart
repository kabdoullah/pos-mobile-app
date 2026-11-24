import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/providers/connectivity_provider.dart';
import 'package:mobile/core/sync/sync_orchestrator.dart';
import 'package:mobile/core/sync/sync_providers.dart';
import 'package:mobile/core/widgets/index.dart';
import 'package:mobile/features/settings/presentation/pages/sync_status_page.dart';

/// Synchro figée dans [status] ; compte les appels à [syncNow].
class _Sync extends SyncOrchestrator {
  _Sync(this.status);

  final SyncStatus status;
  int calls = 0;

  @override
  SyncStatus build() => status;

  @override
  Future<void> syncNow({bool forceFullPull = false}) async => calls++;
}

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  Future<_Sync> pumpPage(
    WidgetTester tester, {
    SyncStatus status = const SyncStatusIdle(),
    int pending = 0,
    bool online = true,
  }) async {
    final sync = _Sync(status);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          syncOrchestratorProvider.overrideWith(() => sync),
          pendingSyncCountProvider.overrideWith((ref) => Stream.value(pending)),
          isOnlineProvider.overrideWith((ref) => Stream.value(online)),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const SyncStatusPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return sync;
  }

  PrimaryButton sendButton(WidgetTester tester) => tester.widget<PrimaryButton>(
    find.widgetWithText(PrimaryButton, 'Envoyer maintenant'),
  );

  testWidgets('tout est envoyé : dernière synchro du jour', (tester) async {
    final now = DateTime.now();
    await pumpPage(
      tester,
      status: SyncStatusIdle(
        lastSyncAt: DateTime(now.year, now.month, now.day, 11, 35),
      ),
    );

    expect(find.text('Tout est envoyé'), findsOneWidget);
    expect(find.text("Aujourd'hui · 11:35"), findsOneWidget);
    expect(sendButton(tester).onPressed, isNotNull);
  });

  testWidgets('en attente : nombre et message rassurant', (tester) async {
    await pumpPage(tester, pending: 3);

    expect(find.text('3 modifications'), findsOneWidget);
    expect(find.textContaining('rien n’est perdu'), findsOneWidget);
    expect(find.text('Pas encore depuis l’ouverture de l’app'), findsOneWidget);
  });

  testWidgets('hors ligne : pas de réseau, envoi impossible', (tester) async {
    await pumpPage(tester, pending: 1, online: false);

    expect(find.text('1 modification'), findsOneWidget);
    expect(find.text('Pas de réseau'), findsOneWidget);
    expect(sendButton(tester).onPressed, isNull);
  });

  testWidgets('échec : heure de l’échec et dernière synchro réussie', (
    tester,
  ) async {
    await pumpPage(
      tester,
      pending: 2,
      status: SyncStatusError(
        message: 'serveur',
        failedAt: DateTime(2026, 11, 24, 14, 5),
        lastSyncAt: DateTime(2026, 11, 10, 9, 0),
      ),
    );

    expect(find.text('Envoi échoué à 14:05'), findsOneWidget);
    expect(find.text('10 nov. · 09:00'), findsOneWidget);
  });

  testWidgets('« Envoyer maintenant » lance la synchro', (tester) async {
    final sync = await pumpPage(tester, pending: 2);
    await tester.tap(find.text('Envoyer maintenant'));
    await tester.pump();

    expect(sync.calls, 1);
  });
}
