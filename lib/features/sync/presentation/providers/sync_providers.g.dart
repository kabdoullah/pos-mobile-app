// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app database instance (singleton, never disposed).

@ProviderFor(database)
final databaseProvider = DatabaseProvider._();

/// Provides the app database instance (singleton, never disposed).

final class DatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// Provides the app database instance (singleton, never disposed).
  DatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$databaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return database(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$databaseHash() => r'e5a1fa0e8ff9aa131f847f28519ec2098e6d0f76';

/// Provides the local data reset service (wipe au changement de store).

@ProviderFor(localDataResetService)
final localDataResetServiceProvider = LocalDataResetServiceProvider._();

/// Provides the local data reset service (wipe au changement de store).

final class LocalDataResetServiceProvider
    extends
        $FunctionalProvider<
          LocalDataResetService,
          LocalDataResetService,
          LocalDataResetService
        >
    with $Provider<LocalDataResetService> {
  /// Provides the local data reset service (wipe au changement de store).
  LocalDataResetServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localDataResetServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localDataResetServiceHash();

  @$internal
  @override
  $ProviderElement<LocalDataResetService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalDataResetService create(Ref ref) {
    return localDataResetService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalDataResetService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalDataResetService>(value),
    );
  }
}

String _$localDataResetServiceHash() =>
    r'a46791d6aec7debe6ec5d769f2dc2fb900781245';

/// Provides the pull service for syncing changes.

@ProviderFor(pullService)
final pullServiceProvider = PullServiceProvider._();

/// Provides the pull service for syncing changes.

final class PullServiceProvider
    extends $FunctionalProvider<PullService, PullService, PullService>
    with $Provider<PullService> {
  /// Provides the pull service for syncing changes.
  PullServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pullServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pullServiceHash();

  @$internal
  @override
  $ProviderElement<PullService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PullService create(Ref ref) {
    return pullService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PullService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PullService>(value),
    );
  }
}

String _$pullServiceHash() => r'7b2e34dc449fd618255374012a4673111fc91eb2';

/// Pulls changes from server and updates local drift.

@ProviderFor(pullChanges)
final pullChangesProvider = PullChangesProvider._();

/// Pulls changes from server and updates local drift.

final class PullChangesProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Pulls changes from server and updates local drift.
  PullChangesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pullChangesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pullChangesHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return pullChanges(ref);
  }
}

String _$pullChangesHash() => r'3b5300bb1e1527e014a62fd48e884e2160ec8c63';

/// Provides the sync queue repository for managing pending syncs.

@ProviderFor(syncQueueRepository)
final syncQueueRepositoryProvider = SyncQueueRepositoryProvider._();

/// Provides the sync queue repository for managing pending syncs.

final class SyncQueueRepositoryProvider
    extends
        $FunctionalProvider<
          SyncQueueRepository,
          SyncQueueRepository,
          SyncQueueRepository
        >
    with $Provider<SyncQueueRepository> {
  /// Provides the sync queue repository for managing pending syncs.
  SyncQueueRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncQueueRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncQueueRepositoryHash();

  @$internal
  @override
  $ProviderElement<SyncQueueRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SyncQueueRepository create(Ref ref) {
    return syncQueueRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncQueueRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncQueueRepository>(value),
    );
  }
}

String _$syncQueueRepositoryHash() =>
    r'e8e8304286f7ae415e0ec063d6be8dcee0e92e36';

/// Provides the push service for syncing local changes to server.

@ProviderFor(pushService)
final pushServiceProvider = PushServiceProvider._();

/// Provides the push service for syncing local changes to server.

final class PushServiceProvider
    extends $FunctionalProvider<PushService, PushService, PushService>
    with $Provider<PushService> {
  /// Provides the push service for syncing local changes to server.
  PushServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushServiceHash();

  @$internal
  @override
  $ProviderElement<PushService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PushService create(Ref ref) {
    return pushService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushService>(value),
    );
  }
}

String _$pushServiceHash() => r'102b902cafbed57811474d6d7f02ff4a3405a4f4';

/// Live count of pending and failed sync queue entries.

@ProviderFor(pendingSyncCount)
final pendingSyncCountProvider = PendingSyncCountProvider._();

/// Live count of pending and failed sync queue entries.

final class PendingSyncCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Live count of pending and failed sync queue entries.
  PendingSyncCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingSyncCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingSyncCountHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return pendingSyncCount(ref);
  }
}

String _$pendingSyncCountHash() => r'206ce5a50c43e76fce0a6132035d6d3cfbd13d4b';
