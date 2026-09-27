import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers/connectivity_provider.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../network/network_providers.dart';
import 'pull_service.dart';
import '../../database/database_provider.dart';
import 'sync_providers.dart';

part 'sync_orchestrator.g.dart';

/// Classe scellée représentant les états de l'orchestration de synchro.
sealed class SyncStatus {
  const SyncStatus();
}

/// État inactif après une synchro terminée. Conserve éventuellement
/// [lastSyncAt].
class SyncStatusIdle extends SyncStatus {
  /// Crée l'état inactif avec l'horodatage optionnel de la dernière synchro.
  const SyncStatusIdle({this.lastSyncAt});

  /// Horodatage de la dernière synchro réussie, s'il y en a une.
  final DateTime? lastSyncAt;
}

/// État de synchro pendant les opérations d'envoi/récupération.
class SyncStatusSyncing extends SyncStatus {
  /// Crée l'état de synchro en cours.
  const SyncStatusSyncing();
}

/// État d'erreur quand la synchro échoue.
class SyncStatusError extends SyncStatus {
  /// Crée l'état d'erreur avec [message].
  const SyncStatusError({required this.message});

  /// Message d'erreur destiné à l'utilisateur.
  final String message;
}

/// Orchestre la synchro bidirectionnelle : surveille la connectivité, déclenche
/// des synchros périodiques et enchaîne l'envoi avant la récupération pour
/// éviter les pertes de données.
@Riverpod(keepAlive: true)
class SyncOrchestrator extends _$SyncOrchestrator with WidgetsBindingObserver {
  bool _isSyncing = false;
  Timer? _periodicTimer;
  Timer? _debounceTimer;
  Timer? _startupTimer;
  final _logger = Logger();

  /// Initialise l'orchestrateur de synchro avec la surveillance réseau et la
  /// synchro périodique.
  @override
  SyncStatus build() {
    WidgetsBinding.instance.addObserver(this);

    ref.listen<AsyncValue<bool>>(isOnlineProvider, (previous, next) {
      final wasOnline = previous?.value ?? true;
      final isNowOnline = next.value ?? false;

      if (!wasOnline && isNowOnline) {
        _logger.d('Network restored, scheduling sync with 2s debounce');
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(seconds: 2), syncNow);
      }
    });

    // Synchronise juste après la vérification du PIN ou toute transition vers
    // Authenticated.
    // Le timer de démarrage se déclenche avant la saisie du PIN, donc la
    // synchro est alors ignorée ; cet écouteur capte le moment où
    // l'authentification réussit vraiment.
    ref.listen<AsyncValue<AuthStatus>>(authProvider, (previous, next) {
      final wasAuthenticated = previous?.value is AuthAuthenticated;
      final isNowAuthenticated = next.value is AuthAuthenticated;
      if (!wasAuthenticated && isNowAuthenticated) {
        _logger.d('User authenticated, scheduling post-auth sync');
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(seconds: 1), syncNow);
      }
    });

    _startPeriodicSync();

    // Remet les entrées en échec en attente au démarrage pour les réessayer
    // (erreurs récupérables comme les bugs de fuseau horaire).
    _resetFailedEntries();

    // Synchro initiale au démarrage de l'app (après 3 s pour laisser l'app se
    // stabiliser).
    // Ne s'exécute que si l'utilisateur est déjà authentifié (ex. réouverture
    // de l'app avec une session valide et sans PIN requis).
    _startupTimer = Timer(const Duration(seconds: 3), () {
      final isOnlineAsync = ref.read(isOnlineProvider);
      final isOnline = isOnlineAsync.value ?? false;
      if (isOnline && !_isSyncing) {
        _logger.d('Initial sync triggered on app startup');
        unawaited(syncNow());
      }
    });

    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _periodicTimer?.cancel();
      _debounceTimer?.cancel();
      _startupTimer?.cancel();
    });

    return const SyncStatusIdle();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _periodicTimer?.cancel();
        _periodicTimer = null;
        _logger.d('Periodic sync paused (app in background)');
      case AppLifecycleState.resumed:
        if (_periodicTimer == null) {
          _startPeriodicSync();
          final isOnline = ref.read(isOnlineProvider).value ?? false;
          if (isOnline && !_isSyncing) unawaited(syncNow());
          _logger.d('Periodic sync resumed (app in foreground)');
        }
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        break;
    }
  }

  /// Remet les entrées en échec de la file de synchro en attente pour qu'elles
  /// soient réessayées.
  /// Aide à se remettre d'erreurs passagères, comme les bugs de fuseau horaire
  /// corrigés depuis dans le code.
  void _resetFailedEntries() {
    unawaited(() async {
      try {
        final syncQueue = ref.read(syncQueueRepositoryProvider);
        final resetCount = await syncQueue.resetFailedEntries();
        if (resetCount > 0) {
          _logger.i('Reset $resetCount failed sync entries to pending');
        }
      } catch (e) {
        _logger.w('Failed to reset sync queue: $e');
      }
    }());
  }

  /// Lance le timer de synchro périodique (5 minutes) quand l'app est en ligne.
  void _startPeriodicSync() {
    _periodicTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      final isOnlineAsync = ref.read(isOnlineProvider);
      final isOnline = isOnlineAsync.value ?? false;
      if (isOnline && !_isSyncing) {
        _logger.d('Periodic sync triggered');
        unawaited(syncNow());
      }
    });
  }

  /// Orchestre une synchro complète : envoi des ventes, envoi des produits,
  /// puis récupération.
  /// Protégé contre les synchros concurrentes (une seule à la fois). L'envoi
  /// passe en premier pour que les changements locaux non envoyés soient
  /// remontés avant la récupération.
  ///
  /// Quand [forceFullPull] vaut true, la récupération ignore [last_pull_at] et
  /// récupère tout le catalogue. À utiliser quand l'utilisateur déclenche un
  /// rafraîchissement manuel.
  Future<void> syncNow({bool forceFullPull = false}) async {
    final authState = ref.read(authProvider);
    if (authState.value is! AuthAuthenticated) {
      _logger.d('Sync skipped: not authenticated');
      return;
    }

    if (_isSyncing) {
      _logger.d('Sync already in progress, ignoring concurrent request');
      return;
    }

    _isSyncing = true;
    state = const SyncStatusSyncing();

    // Garde changement de store : éviter la fuite cross-tenant.
    // Si le store_id du token diffère du store actif local, wiper la DB
    // métier AVANT de push (sinon on pousserait les données dirty de
    // l'ancien store vers le nouveau), puis forcer un full pull.
    var effectiveFullPull = forceFullPull;
    try {
      final db = ref.read(databaseProvider);
      final tokenStorage = ref.read(tokenStorageProvider);
      final currentStoreId = await tokenStorage.getStoreId();
      if (currentStoreId != null) {
        final metaStorage = SyncMetadataStorage(db);
        final activeStoreId = await metaStorage.getActiveStoreId();
        if (activeStoreId != currentStoreId) {
          _logger.w(
            'Store changed ($activeStoreId -> $currentStoreId): wiping local data',
          );
          await ref.read(localDataResetServiceProvider).wipeBusinessData();
          await metaStorage.setActiveStoreId(currentStoreId);
          effectiveFullPull = true;
        }
      }
    } catch (e, st) {
      _logger.e('Store-change guard failed', error: e, stackTrace: st);
    }

    try {
      final pushService = ref.read(pushServiceProvider);
      final pullService = ref.read(pullServiceProvider);

      _logger.d('Starting sync: push sales');
      await pushService.pushPendingSales();

      // Catégories avant produits : le serveur refuse un produit dont la
      // catégorie lui est inconnue.
      _logger.d('Sync step: push categories');
      await pushService.pushPendingCategoryChanges();

      _logger.d('Sync step: push products');
      await pushService.pushPendingProductChanges();

      _logger.d('Sync step: pull changes');
      await pullService.pullChanges(forceFullPull: effectiveFullPull);

      _logger.d('Sync completed successfully');
      state = SyncStatusIdle(lastSyncAt: DateTime.now());
    } catch (e, st) {
      _logger.e('Sync failed', error: e, stackTrace: st);
      state = const SyncStatusError(message: 'Erreur de sauvegarde');
    } finally {
      _isSyncing = false;
    }
  }
}
