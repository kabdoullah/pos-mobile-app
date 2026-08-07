// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_di_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the sales repository implementation (local-first via drift).

@ProviderFor(salesRepository)
final salesRepositoryProvider = SalesRepositoryProvider._();

/// Provides the sales repository implementation (local-first via drift).

final class SalesRepositoryProvider
    extends
        $FunctionalProvider<SalesRepository, SalesRepository, SalesRepository>
    with $Provider<SalesRepository> {
  /// Provides the sales repository implementation (local-first via drift).
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

String _$salesRepositoryHash() => r'bf7a91f07eb2fc840f19c6ca719ea9c3b29515bf';

/// Provides the create sale use case (business logic).

@ProviderFor(createSaleUseCase)
final createSaleUseCaseProvider = CreateSaleUseCaseProvider._();

/// Provides the create sale use case (business logic).

final class CreateSaleUseCaseProvider
    extends
        $FunctionalProvider<
          CreateSaleUseCase,
          CreateSaleUseCase,
          CreateSaleUseCase
        >
    with $Provider<CreateSaleUseCase> {
  /// Provides the create sale use case (business logic).
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
