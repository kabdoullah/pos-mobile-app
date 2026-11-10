// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_register_di_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fournit l'identifiant stable de l'appareil (stockage sécurisé).

@ProviderFor(deviceIdStorage)
final deviceIdStorageProvider = DeviceIdStorageProvider._();

/// Fournit l'identifiant stable de l'appareil (stockage sécurisé).

final class DeviceIdStorageProvider
    extends
        $FunctionalProvider<DeviceIdStorage, DeviceIdStorage, DeviceIdStorage>
    with $Provider<DeviceIdStorage> {
  /// Fournit l'identifiant stable de l'appareil (stockage sécurisé).
  DeviceIdStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceIdStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceIdStorageHash();

  @$internal
  @override
  $ProviderElement<DeviceIdStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeviceIdStorage create(Ref ref) {
    return deviceIdStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceIdStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceIdStorage>(value),
    );
  }
}

String _$deviceIdStorageHash() => r'e1118167a51c486c9e335d0c4d9f81ec91007f4a';

/// Fournit la data source distante des sessions de caisse.

@ProviderFor(cashRegisterRemoteDataSource)
final cashRegisterRemoteDataSourceProvider =
    CashRegisterRemoteDataSourceProvider._();

/// Fournit la data source distante des sessions de caisse.

final class CashRegisterRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          CashRegisterRemoteDataSource,
          CashRegisterRemoteDataSource,
          CashRegisterRemoteDataSource
        >
    with $Provider<CashRegisterRemoteDataSource> {
  /// Fournit la data source distante des sessions de caisse.
  CashRegisterRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cashRegisterRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cashRegisterRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<CashRegisterRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CashRegisterRemoteDataSource create(Ref ref) {
    return cashRegisterRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CashRegisterRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CashRegisterRemoteDataSource>(value),
    );
  }
}

String _$cashRegisterRemoteDataSourceHash() =>
    r'5e046c76e42eb417ee7a05e0c13ebbbd4b3d7ab3';

/// Fournit le repository des sessions de caisse (local d'abord, via drift).

@ProviderFor(cashRegisterRepository)
final cashRegisterRepositoryProvider = CashRegisterRepositoryProvider._();

/// Fournit le repository des sessions de caisse (local d'abord, via drift).

final class CashRegisterRepositoryProvider
    extends
        $FunctionalProvider<
          CashRegisterRepository,
          CashRegisterRepository,
          CashRegisterRepository
        >
    with $Provider<CashRegisterRepository> {
  /// Fournit le repository des sessions de caisse (local d'abord, via drift).
  CashRegisterRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cashRegisterRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cashRegisterRepositoryHash();

  @$internal
  @override
  $ProviderElement<CashRegisterRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CashRegisterRepository create(Ref ref) {
    return cashRegisterRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CashRegisterRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CashRegisterRepository>(value),
    );
  }
}

String _$cashRegisterRepositoryHash() =>
    r'7680718b01966f106a3b8a13ffcb64aa6d94f3be';

/// Fournit le cas d'usage d'ouverture de session.

@ProviderFor(openCashSessionUseCase)
final openCashSessionUseCaseProvider = OpenCashSessionUseCaseProvider._();

/// Fournit le cas d'usage d'ouverture de session.

final class OpenCashSessionUseCaseProvider
    extends
        $FunctionalProvider<
          OpenCashSessionUseCase,
          OpenCashSessionUseCase,
          OpenCashSessionUseCase
        >
    with $Provider<OpenCashSessionUseCase> {
  /// Fournit le cas d'usage d'ouverture de session.
  OpenCashSessionUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openCashSessionUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openCashSessionUseCaseHash();

  @$internal
  @override
  $ProviderElement<OpenCashSessionUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OpenCashSessionUseCase create(Ref ref) {
    return openCashSessionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OpenCashSessionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OpenCashSessionUseCase>(value),
    );
  }
}

String _$openCashSessionUseCaseHash() =>
    r'30cd042867535cc8f386a2f7ab72c323ab31e266';

/// Fournit le cas d'usage d'enregistrement d'un mouvement d'espèces.

@ProviderFor(recordCashMovementUseCase)
final recordCashMovementUseCaseProvider = RecordCashMovementUseCaseProvider._();

/// Fournit le cas d'usage d'enregistrement d'un mouvement d'espèces.

final class RecordCashMovementUseCaseProvider
    extends
        $FunctionalProvider<
          RecordCashMovementUseCase,
          RecordCashMovementUseCase,
          RecordCashMovementUseCase
        >
    with $Provider<RecordCashMovementUseCase> {
  /// Fournit le cas d'usage d'enregistrement d'un mouvement d'espèces.
  RecordCashMovementUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordCashMovementUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordCashMovementUseCaseHash();

  @$internal
  @override
  $ProviderElement<RecordCashMovementUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecordCashMovementUseCase create(Ref ref) {
    return recordCashMovementUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordCashMovementUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordCashMovementUseCase>(value),
    );
  }
}

String _$recordCashMovementUseCaseHash() =>
    r'e5434fab1dd29c21f100d4535a02f223d6d52ece';

/// Fournit le cas d'usage de clôture de session.

@ProviderFor(closeCashSessionUseCase)
final closeCashSessionUseCaseProvider = CloseCashSessionUseCaseProvider._();

/// Fournit le cas d'usage de clôture de session.

final class CloseCashSessionUseCaseProvider
    extends
        $FunctionalProvider<
          CloseCashSessionUseCase,
          CloseCashSessionUseCase,
          CloseCashSessionUseCase
        >
    with $Provider<CloseCashSessionUseCase> {
  /// Fournit le cas d'usage de clôture de session.
  CloseCashSessionUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'closeCashSessionUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$closeCashSessionUseCaseHash();

  @$internal
  @override
  $ProviderElement<CloseCashSessionUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CloseCashSessionUseCase create(Ref ref) {
    return closeCashSessionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CloseCashSessionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CloseCashSessionUseCase>(value),
    );
  }
}

String _$closeCashSessionUseCaseHash() =>
    r'496daa70f1442c0cddcb5cb8813e72d3e5d202a2';
