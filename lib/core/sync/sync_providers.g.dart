// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fournit le service de remise à zéro des données locales (wipe au changement
/// de store).

@ProviderFor(localDataResetService)
final localDataResetServiceProvider = LocalDataResetServiceProvider._();

/// Fournit le service de remise à zéro des données locales (wipe au changement
/// de store).

final class LocalDataResetServiceProvider
    extends
        $FunctionalProvider<
          LocalDataResetService,
          LocalDataResetService,
          LocalDataResetService
        >
    with $Provider<LocalDataResetService> {
  /// Fournit le service de remise à zéro des données locales (wipe au changement
  /// de store).
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

/// Fournit le service de récupération des changements.

@ProviderFor(pullService)
final pullServiceProvider = PullServiceProvider._();

/// Fournit le service de récupération des changements.

final class PullServiceProvider
    extends $FunctionalProvider<PullService, PullService, PullService>
    with $Provider<PullService> {
  /// Fournit le service de récupération des changements.
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

String _$pullServiceHash() => r'd323e78fd07a6329b9265c7e527fbee4c7bee7a7';

/// Fournit le repository de la file de synchro pour gérer les synchros en
/// attente.

@ProviderFor(syncQueueRepository)
final syncQueueRepositoryProvider = SyncQueueRepositoryProvider._();

/// Fournit le repository de la file de synchro pour gérer les synchros en
/// attente.

final class SyncQueueRepositoryProvider
    extends
        $FunctionalProvider<
          SyncQueueRepository,
          SyncQueueRepository,
          SyncQueueRepository
        >
    with $Provider<SyncQueueRepository> {
  /// Fournit le repository de la file de synchro pour gérer les synchros en
  /// attente.
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

/// Fournit le service d'envoi des changements locaux au serveur.

@ProviderFor(pushService)
final pushServiceProvider = PushServiceProvider._();

/// Fournit le service d'envoi des changements locaux au serveur.

final class PushServiceProvider
    extends $FunctionalProvider<PushService, PushService, PushService>
    with $Provider<PushService> {
  /// Fournit le service d'envoi des changements locaux au serveur.
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

/// Nombre en direct des entrées de la file de synchro en attente ou en échec.

@ProviderFor(pendingSyncCount)
final pendingSyncCountProvider = PendingSyncCountProvider._();

/// Nombre en direct des entrées de la file de synchro en attente ou en échec.

final class PendingSyncCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Nombre en direct des entrées de la file de synchro en attente ou en échec.
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

String _$pendingSyncCountHash() => r'a6617ec5e24f5f95dc116e73f4ab768576e2c0f8';
