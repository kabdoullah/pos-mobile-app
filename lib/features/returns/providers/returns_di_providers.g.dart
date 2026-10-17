// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'returns_di_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fournit le repository des retours (local d'abord, via drift).

@ProviderFor(returnsRepository)
final returnsRepositoryProvider = ReturnsRepositoryProvider._();

/// Fournit le repository des retours (local d'abord, via drift).

final class ReturnsRepositoryProvider
    extends
        $FunctionalProvider<
          ReturnsRepository,
          ReturnsRepository,
          ReturnsRepository
        >
    with $Provider<ReturnsRepository> {
  /// Fournit le repository des retours (local d'abord, via drift).
  ReturnsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'returnsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$returnsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReturnsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReturnsRepository create(Ref ref) {
    return returnsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReturnsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReturnsRepository>(value),
    );
  }
}

String _$returnsRepositoryHash() => r'53378311d32b11bcfcaa79b57e8479118ad7ebf9';

/// Fournit le cas d'usage d'enregistrement d'un retour.

@ProviderFor(createSaleReturnUseCase)
final createSaleReturnUseCaseProvider = CreateSaleReturnUseCaseProvider._();

/// Fournit le cas d'usage d'enregistrement d'un retour.

final class CreateSaleReturnUseCaseProvider
    extends
        $FunctionalProvider<
          CreateSaleReturnUseCase,
          CreateSaleReturnUseCase,
          CreateSaleReturnUseCase
        >
    with $Provider<CreateSaleReturnUseCase> {
  /// Fournit le cas d'usage d'enregistrement d'un retour.
  CreateSaleReturnUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createSaleReturnUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createSaleReturnUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateSaleReturnUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreateSaleReturnUseCase create(Ref ref) {
    return createSaleReturnUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateSaleReturnUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateSaleReturnUseCase>(value),
    );
  }
}

String _$createSaleReturnUseCaseHash() =>
    r'7df18460bae23e890718bb70c784e26ec2650be3';
