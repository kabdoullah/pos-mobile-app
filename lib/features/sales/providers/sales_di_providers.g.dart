// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_di_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fournit l'implémentation du repository des ventes (local d'abord, via
/// drift).

@ProviderFor(salesRepository)
final salesRepositoryProvider = SalesRepositoryProvider._();

/// Fournit l'implémentation du repository des ventes (local d'abord, via
/// drift).

final class SalesRepositoryProvider
    extends
        $FunctionalProvider<SalesRepository, SalesRepository, SalesRepository>
    with $Provider<SalesRepository> {
  /// Fournit l'implémentation du repository des ventes (local d'abord, via
  /// drift).
  SalesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salesRepositoryHash();

  @$internal
  @override
  $ProviderElement<SalesRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SalesRepository create(Ref ref) {
    return salesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SalesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SalesRepository>(value),
    );
  }
}

String _$salesRepositoryHash() => r'dd95c0d3baeee77cdc2bc036cc08dd2d53dea5a2';

/// Fournit le cas d'usage de création de vente (logique métier).

@ProviderFor(createSaleUseCase)
final createSaleUseCaseProvider = CreateSaleUseCaseProvider._();

/// Fournit le cas d'usage de création de vente (logique métier).

final class CreateSaleUseCaseProvider
    extends
        $FunctionalProvider<
          CreateSaleUseCase,
          CreateSaleUseCase,
          CreateSaleUseCase
        >
    with $Provider<CreateSaleUseCase> {
  /// Fournit le cas d'usage de création de vente (logique métier).
  CreateSaleUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createSaleUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createSaleUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateSaleUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreateSaleUseCase create(Ref ref) {
    return createSaleUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateSaleUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateSaleUseCase>(value),
    );
  }
}

String _$createSaleUseCaseHash() => r'e99978e77fbad231923ed863e304fff92dbe7f81';
