import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/core/network/network_providers.dart';
import 'package:mobile/core/network/token_storage.dart';
import 'package:mobile/core/sync/pull_service.dart';
import 'package:mobile/core/sync/push_service.dart';
import 'package:mobile/core/sync/sync_orchestrator.dart';
import 'package:mobile/database/app_database.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/core/providers/connectivity_provider.dart';
import 'package:mobile/database/database_provider.dart';
import 'package:mobile/core/sync/sync_providers.dart';

class MockPushService extends Mock implements PushService {}

class MockPullService extends Mock implements PullService {}

class MockTokenStorage extends Mock implements TokenStorage {}

/// syncNow() ne s'exécute que pour une session authentifiée.
class _AuthenticatedAuth extends Auth {
  @override
  Future<AuthStatus> build() async =>
      const AuthAuthenticated(User(id: 'u1', phoneNumber: '+2250700000000'));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SyncOrchestrator', () {
    late MockPushService mockPushService;
    late MockPullService mockPullService;

    setUp(() {
      mockPushService = MockPushService();
      mockPullService = MockPullService();

      when(
        () => mockPushService.pushPendingSales(),
      ).thenAnswer((_) async => {});
      when(
        () => mockPushService.pushPendingCategoryChanges(),
      ).thenAnswer((_) async => {});
      when(
        () => mockPushService.pushPendingProductChanges(),
      ).thenAnswer((_) async => {});
      when(
        () => mockPullService.pullChanges(
          forceFullPull: any(named: 'forceFullPull'),
        ),
      ).thenAnswer((_) async => true);
    });

    /// Container authentifié ; pas de store id dans le token, donc la garde
    /// de changement de boutique ne fait rien.
    Future<ProviderContainer> makeContainer({PushService? push}) async {
      final tokenStorage = MockTokenStorage();
      when(tokenStorage.getStoreId).thenAnswer((_) async => null);
      final db = AppDatabase.forTesting(NativeDatabase.memory());

      final container = ProviderContainer(
        overrides: [
          pushServiceProvider.overrideWithValue(push ?? mockPushService),
          pullServiceProvider.overrideWithValue(mockPullService),
          isOnlineProvider.overrideWith(
            (_) => Stream.value(true).asBroadcastStream(),
          ),
          authProvider.overrideWith(_AuthenticatedAuth.new),
          tokenStorageProvider.overrideWithValue(tokenStorage),
          databaseProvider.overrideWithValue(db),
        ],
      );
      addTearDown(() async {
        container.dispose();
        await db.close();
      });
      await container.read(authProvider.future);
      return container;
    }

    test(
      'syncNow when called twice concurrently ignores second call',
      () async {
        when(() => mockPushService.pushPendingSales()).thenAnswer(
          (_) => Future<void>.delayed(const Duration(milliseconds: 100)),
        );
        final container = await makeContainer();
        final orchestrator = container.read(syncOrchestratorProvider.notifier);

        // Appelle syncNow deux fois sans attendre
        unawaited(orchestrator.syncNow());
        unawaited(orchestrator.syncNow());

        // Attend la fin de la première synchro
        await Future<void>.delayed(const Duration(milliseconds: 200));

        // Vérifie que pushPendingSales n'a été appelé qu'une fois (le second
        // appel a été ignoré)
        verify(() => mockPushService.pushPendingSales()).called(1);
      },
    );

    test(
      'syncNow calls push before pull (sales, categories, products, then pull)',
      () async {
        final callOrder = <String>[];

        when(() => mockPushService.pushPendingSales()).thenAnswer((_) async {
          callOrder.add('pushSales');
        });
        when(() => mockPushService.pushPendingCategoryChanges()).thenAnswer((
          _,
        ) async {
          callOrder.add('pushCategories');
        });
        when(() => mockPushService.pushPendingProductChanges()).thenAnswer((
          _,
        ) async {
          callOrder.add('pushProducts');
        });
        when(
          () => mockPullService.pullChanges(
            forceFullPull: any(named: 'forceFullPull'),
          ),
        ).thenAnswer((_) async {
          callOrder.add('pull');
          return true;
        });

        final container = await makeContainer();
        await container.read(syncOrchestratorProvider.notifier).syncNow();

        // Catégories avant produits : le serveur refuse un produit dont la
        // catégorie lui est inconnue.
        expect(
          callOrder,
          equals(['pushSales', 'pushCategories', 'pushProducts', 'pull']),
        );
      },
    );

    // Le test de synchro déclenchée par la connectivité est omis à cause du
    // timing complexe de ref.listen dans build(). Les tests manuels confirment
    // que l'anti-rebond fonctionne comme prévu (voir adr/0005-sync-hybrid.md).

    test(
      'syncNow updates state to SyncStatusSyncing then SyncStatusIdle',
      () async {
        // Surcharge les mocks avec un délai pour être sûr de voir l'état de
        // synchro
        when(() => mockPushService.pushPendingSales()).thenAnswer(
          (_) => Future<void>.delayed(const Duration(milliseconds: 300)),
        );
        final container = await makeContainer();
        final orchestrator = container.read(syncOrchestratorProvider.notifier);

        // Inactif au départ
        expect(container.read(syncOrchestratorProvider), isA<SyncStatusIdle>());

        // Appelle syncNow (sans attendre tout de suite)
        final syncFuture = orchestrator.syncNow();
        await Future<void>.delayed(const Duration(milliseconds: 50));

        // Doit être en cours de synchro
        expect(
          container.read(syncOrchestratorProvider),
          isA<SyncStatusSyncing>(),
        );

        // Attend la fin
        await syncFuture;

        // Doit être de nouveau inactif avec lastSyncAt renseigné
        final finalState = container.read(syncOrchestratorProvider);
        expect(finalState, isA<SyncStatusIdle>());
        expect((finalState as SyncStatusIdle).lastSyncAt, isNotNull);
      },
    );

    test('syncNow on error sets SyncStatusError', () async {
      final errorMockPushService = MockPushService();
      when(
        errorMockPushService.pushPendingSales,
      ).thenThrow(Exception('Network error'));
      when(
        errorMockPushService.pushPendingCategoryChanges,
      ).thenAnswer((_) async => {});
      when(
        errorMockPushService.pushPendingProductChanges,
      ).thenAnswer((_) async => {});

      final container = await makeContainer(push: errorMockPushService);
      await container.read(syncOrchestratorProvider.notifier).syncNow();

      expect(container.read(syncOrchestratorProvider), isA<SyncStatusError>());
    });

    test('syncNow is skipped while not authenticated', () async {
      final container = await makeContainer();
      container.read(authProvider.notifier).state = const AsyncData(
        AuthPinRequired(),
      );

      await container.read(syncOrchestratorProvider.notifier).syncNow();

      verifyNever(() => mockPushService.pushPendingSales());
    });
  });
}
