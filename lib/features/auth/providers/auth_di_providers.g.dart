// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_di_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the remote data source for auth API calls.

@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider = AuthRemoteDataSourceProvider._();

/// Provides the remote data source for auth API calls.

final class AuthRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AuthRemoteDataSource,
          AuthRemoteDataSource,
          AuthRemoteDataSource
        >
    with $Provider<AuthRemoteDataSource> {
  /// Provides the remote data source for auth API calls.
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

/// Provides the remote data source for store API calls.

@ProviderFor(storesRemoteDataSource)
final storesRemoteDataSourceProvider = StoresRemoteDataSourceProvider._();

/// Provides the remote data source for store API calls.

final class StoresRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          StoresRemoteDataSource,
          StoresRemoteDataSource,
          StoresRemoteDataSource
        >
    with $Provider<StoresRemoteDataSource> {
  /// Provides the remote data source for store API calls.
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

/// Provides the auth repository implementation.

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

/// Provides the auth repository implementation.

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// Provides the auth repository implementation.
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
