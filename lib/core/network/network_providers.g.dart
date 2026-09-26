// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fournit l'implémentation de TokenStorage.
/// Doit être surchargé dans ProviderScope avant utilisation.

@ProviderFor(tokenStorage)
final tokenStorageProvider = TokenStorageProvider._();

/// Fournit l'implémentation de TokenStorage.
/// Doit être surchargé dans ProviderScope avant utilisation.

final class TokenStorageProvider
    extends $FunctionalProvider<TokenStorage, TokenStorage, TokenStorage>
    with $Provider<TokenStorage> {
  /// Fournit l'implémentation de TokenStorage.
  /// Doit être surchargé dans ProviderScope avant utilisation.
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

/// Diffuse un événement vide quand l'authentification expire (session
/// invalide).
/// La couche auth écoute ce flux et redirige vers l'écran de connexion.

@ProviderFor(authExpiredController)
final authExpiredControllerProvider = AuthExpiredControllerProvider._();

/// Diffuse un événement vide quand l'authentification expire (session
/// invalide).
/// La couche auth écoute ce flux et redirige vers l'écran de connexion.

final class AuthExpiredControllerProvider
    extends
        $FunctionalProvider<
          Raw<StreamController<void>>,
          Raw<StreamController<void>>,
          Raw<StreamController<void>>
        >
    with $Provider<Raw<StreamController<void>>> {
  /// Diffuse un événement vide quand l'authentification expire (session
  /// invalide).
  /// La couche auth écoute ce flux et redirige vers l'écran de connexion.
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

/// Fournit une instance Dio configurée avec auth JWT, rafraîchissement et
/// gestion des erreurs.

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Fournit une instance Dio configurée avec auth JWT, rafraîchissement et
/// gestion des erreurs.

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Fournit une instance Dio configurée avec auth JWT, rafraîchissement et
  /// gestion des erreurs.
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

/// Fournit l'implémentation concrète SecureTokenStorage.

@ProviderFor(secureTokenStorage)
final secureTokenStorageProvider = SecureTokenStorageProvider._();

/// Fournit l'implémentation concrète SecureTokenStorage.

final class SecureTokenStorageProvider
    extends
        $FunctionalProvider<
          SecureTokenStorage,
          SecureTokenStorage,
          SecureTokenStorage
        >
    with $Provider<SecureTokenStorage> {
  /// Fournit l'implémentation concrète SecureTokenStorage.
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

/// Fournit le stockage du PIN pour sa gestion locale.

@ProviderFor(pinStorage)
final pinStorageProvider = PinStorageProvider._();

/// Fournit le stockage du PIN pour sa gestion locale.

final class PinStorageProvider
    extends $FunctionalProvider<PinStorage, PinStorage, PinStorage>
    with $Provider<PinStorage> {
  /// Fournit le stockage du PIN pour sa gestion locale.
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

/// Fournit la data source distante de synchronisation.

@ProviderFor(syncRemoteDataSource)
final syncRemoteDataSourceProvider = SyncRemoteDataSourceProvider._();

/// Fournit la data source distante de synchronisation.

final class SyncRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          SyncRemoteDataSource,
          SyncRemoteDataSource,
          SyncRemoteDataSource
        >
    with $Provider<SyncRemoteDataSource> {
  /// Fournit la data source distante de synchronisation.
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
