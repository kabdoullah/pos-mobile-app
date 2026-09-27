// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_di_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fournit la data source distante pour les appels API d'auth.

@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider = AuthRemoteDataSourceProvider._();

/// Fournit la data source distante pour les appels API d'auth.

final class AuthRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AuthRemoteDataSource,
          AuthRemoteDataSource,
          AuthRemoteDataSource
        >
    with $Provider<AuthRemoteDataSource> {
  /// Fournit la data source distante pour les appels API d'auth.
  AuthRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AuthRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthRemoteDataSource create(Ref ref) {
    return authRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRemoteDataSource>(value),
    );
  }
}

String _$authRemoteDataSourceHash() =>
    r'b75e3f967c2880ad7b794f6ec502786be39f16ed';

/// Fournit la data source distante pour les appels API boutique.

@ProviderFor(storesRemoteDataSource)
final storesRemoteDataSourceProvider = StoresRemoteDataSourceProvider._();

/// Fournit la data source distante pour les appels API boutique.

final class StoresRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          StoresRemoteDataSource,
          StoresRemoteDataSource,
          StoresRemoteDataSource
        >
    with $Provider<StoresRemoteDataSource> {
  /// Fournit la data source distante pour les appels API boutique.
  StoresRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storesRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storesRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<StoresRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StoresRemoteDataSource create(Ref ref) {
    return storesRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoresRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoresRemoteDataSource>(value),
    );
  }
}

String _$storesRemoteDataSourceHash() =>
    r'e702a98344a9da3d439d413bf416fd8b874dddf4';

/// Fournit l'implémentation du repository d'auth.

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

/// Fournit l'implémentation du repository d'auth.

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// Fournit l'implémentation du repository d'auth.
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'0da870bc4ca82306657c28fd6b74cd7518609c06';

/// Fournit le repository boutique (cache secure storage + `/stores/me`).

@ProviderFor(storeRepository)
final storeRepositoryProvider = StoreRepositoryProvider._();

/// Fournit le repository boutique (cache secure storage + `/stores/me`).

final class StoreRepositoryProvider
    extends
        $FunctionalProvider<StoreRepository, StoreRepository, StoreRepository>
    with $Provider<StoreRepository> {
  /// Fournit le repository boutique (cache secure storage + `/stores/me`).
  StoreRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storeRepositoryHash();

  @$internal
  @override
  $ProviderElement<StoreRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StoreRepository create(Ref ref) {
    return storeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoreRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoreRepository>(value),
    );
  }
}

String _$storeRepositoryHash() => r'9ffdd3e9e8c31e0ae8cc92402f76328e934c4ad9';

/// Fournit le repository du profil (nom du vendeur, cache + `/users/me`).

@ProviderFor(profileRepository)
final profileRepositoryProvider = ProfileRepositoryProvider._();

/// Fournit le repository du profil (nom du vendeur, cache + `/users/me`).

final class ProfileRepositoryProvider
    extends
        $FunctionalProvider<
          ProfileRepository,
          ProfileRepository,
          ProfileRepository
        >
    with $Provider<ProfileRepository> {
  /// Fournit le repository du profil (nom du vendeur, cache + `/users/me`).
  ProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileRepository create(Ref ref) {
    return profileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRepository>(value),
    );
  }
}

String _$profileRepositoryHash() => r'7e0a6d0b0e0b42bc5dba113b131435654ceda531';
