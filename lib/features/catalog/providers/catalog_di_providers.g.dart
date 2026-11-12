// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_di_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fournit l'implémentation du repository catalogue (local d'abord, via drift).

@ProviderFor(catalogRepository)
final catalogRepositoryProvider = CatalogRepositoryProvider._();

/// Fournit l'implémentation du repository catalogue (local d'abord, via drift).

final class CatalogRepositoryProvider
    extends
        $FunctionalProvider<
          CatalogRepository,
          CatalogRepository,
          CatalogRepository
        >
    with $Provider<CatalogRepository> {
  /// Fournit l'implémentation du repository catalogue (local d'abord, via drift).
  CatalogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogRepositoryHash();

  @$internal
  @override
  $ProviderElement<CatalogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CatalogRepository create(Ref ref) {
    return catalogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogRepository>(value),
    );
  }
}

String _$catalogRepositoryHash() => r'bf20f53760fe9a376d3ecb87eb1b1edfbb956e54';

/// Fournit le référentiel de codes-barres embarqué. Gardé en vie : le
/// référentiel (~5 000 entrées) n'est décodé qu'une fois par session.

@ProviderFor(barcodeReferenceRepository)
final barcodeReferenceRepositoryProvider =
    BarcodeReferenceRepositoryProvider._();

/// Fournit le référentiel de codes-barres embarqué. Gardé en vie : le
/// référentiel (~5 000 entrées) n'est décodé qu'une fois par session.

final class BarcodeReferenceRepositoryProvider
    extends
        $FunctionalProvider<
          BarcodeReferenceRepository,
          BarcodeReferenceRepository,
          BarcodeReferenceRepository
        >
    with $Provider<BarcodeReferenceRepository> {
  /// Fournit le référentiel de codes-barres embarqué. Gardé en vie : le
  /// référentiel (~5 000 entrées) n'est décodé qu'une fois par session.
  BarcodeReferenceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'barcodeReferenceRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$barcodeReferenceRepositoryHash();

  @$internal
  @override
  $ProviderElement<BarcodeReferenceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BarcodeReferenceRepository create(Ref ref) {
    return barcodeReferenceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BarcodeReferenceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BarcodeReferenceRepository>(value),
    );
  }
}

String _$barcodeReferenceRepositoryHash() =>
    r'0b7fef8c1481e5cc00abc0fffcec220de0c66d11';
