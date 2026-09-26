// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Gère le scan de codes-barres : dédoublonnage par délai de carence, recherche
/// dans le catalogue, ajout au panier.

@ProviderFor(ScanController)
final scanControllerProvider = ScanControllerProvider._();

/// Gère le scan de codes-barres : dédoublonnage par délai de carence, recherche
/// dans le catalogue, ajout au panier.
final class ScanControllerProvider
    extends $NotifierProvider<ScanController, void> {
  /// Gère le scan de codes-barres : dédoublonnage par délai de carence, recherche
  /// dans le catalogue, ajout au panier.
  ScanControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanControllerHash();

  @$internal
  @override
  ScanController create() => ScanController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$scanControllerHash() => r'28bbb52d82ddbdeb5ac8cd8f59bf92131044a880';

/// Gère le scan de codes-barres : dédoublonnage par délai de carence, recherche
/// dans le catalogue, ajout au panier.

abstract class _$ScanController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
