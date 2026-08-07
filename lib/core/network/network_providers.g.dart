// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the TokenStorage implementation.
/// Must be overridden in ProviderScope before use.

@ProviderFor(tokenStorage)
final tokenStorageProvider = TokenStorageProvider._();

/// Provides the TokenStorage implementation.
/// Must be overridden in ProviderScope before use.

final class TokenStorageProvider
    extends $FunctionalProvider<TokenStorage, TokenStorage, TokenStorage>
    with $Provider<TokenStorage> {
  /// Provides the TokenStorage implementation.
  /// Must be overridden in ProviderScope before use.
  TokenStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenStorageHash();

  @$internal
  @override
  $ProviderElement<TokenStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TokenStorage create(Ref ref) {
    return tokenStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TokenStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TokenStorage>(value),
    );
  }
}

String _$tokenStorageHash() => r'933c687bf82b887d80dad2bef492738452d67578';

/// Broadcasts void event when authentication expires (session invalid).
/// Auth layer listens to this stream and routes to login screen.

@ProviderFor(authExpiredController)
final authExpiredControllerProvider = AuthExpiredControllerProvider._();

/// Broadcasts void event when authentication expires (session invalid).
/// Auth layer listens to this stream and routes to login screen.

final class AuthExpiredControllerProvider
    extends
        $FunctionalProvider<
          Raw<StreamController<void>>,
          Raw<StreamController<void>>,
          Raw<StreamController<void>>
        >
    with $Provider<Raw<StreamController<void>>> {
  /// Broadcasts void event when authentication expires (session invalid).
  /// Auth layer listens to this stream and routes to login screen.
  AuthExpiredControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authExpiredControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authExpiredControllerHash();

  @$internal
  @override
  $ProviderElement<Raw<StreamController<void>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Raw<StreamController<void>> create(Ref ref) {
    return authExpiredController(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<StreamController<void>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<StreamController<void>>>(value),
    );
  }
}

String _$authExpiredControllerHash() =>
    r'99918469628d8d39d6994ff072367535f53cea56';

/// Provides a configured Dio instance with JWT auth, refresh, and error handling.

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Provides a configured Dio instance with JWT auth, refresh, and error handling.

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Provides a configured Dio instance with JWT auth, refresh, and error handling.
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'd4f1741bef3519747797b387c42e2c8d698db7ba';

/// Provides the concrete SecureTokenStorage implementation.

@ProviderFor(secureTokenStorage)
final secureTokenStorageProvider = SecureTokenStorageProvider._();

/// Provides the concrete SecureTokenStorage implementation.

final class SecureTokenStorageProvider
    extends
        $FunctionalProvider<
          SecureTokenStorage,
          SecureTokenStorage,
          SecureTokenStorage
        >
    with $Provider<SecureTokenStorage> {
  /// Provides the concrete SecureTokenStorage implementation.
  SecureTokenStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureTokenStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureTokenStorageHash();

  @$internal
  @override
  $ProviderElement<SecureTokenStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SecureTokenStorage create(Ref ref) {
    return secureTokenStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecureTokenStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecureTokenStorage>(value),
    );
  }
}

String _$secureTokenStorageHash() =>
    r'ec2a6ab4973e2476db2619c692e149e324a2cdab';

/// Provides PIN storage for local PIN management.

@ProviderFor(pinStorage)
final pinStorageProvider = PinStorageProvider._();

/// Provides PIN storage for local PIN management.

final class PinStorageProvider
    extends $FunctionalProvider<PinStorage, PinStorage, PinStorage>
    with $Provider<PinStorage> {
  /// Provides PIN storage for local PIN management.
  PinStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinStorageHash();

  @$internal
  @override
  $ProviderElement<PinStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PinStorage create(Ref ref) {
    return pinStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinStorage>(value),
    );
  }
}

String _$pinStorageHash() => r'9f259f5997e15fd7bf1ca60f0c1274d81f375634';

/// Provides the sync remote data source for sync operations.

@ProviderFor(syncRemoteDataSource)
final syncRemoteDataSourceProvider = SyncRemoteDataSourceProvider._();

/// Provides the sync remote data source for sync operations.

final class SyncRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          SyncRemoteDataSource,
          SyncRemoteDataSource,
          SyncRemoteDataSource
        >
    with $Provider<SyncRemoteDataSource> {
  /// Provides the sync remote data source for sync operations.
  SyncRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<SyncRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SyncRemoteDataSource create(Ref ref) {
    return syncRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncRemoteDataSource>(value),
    );
  }
}

String _$syncRemoteDataSourceHash() =>
    r'af7dbac468911e380f9f49ddfd2ceafeb54d1176';
