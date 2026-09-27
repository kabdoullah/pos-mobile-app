// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_image_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fichier de l'image d'un produit à une version donnée (cache, sinon
/// téléchargement) ; null si indisponible.

@ProviderFor(productImageFile)
final productImageFileProvider = ProductImageFileFamily._();

/// Fichier de l'image d'un produit à une version donnée (cache, sinon
/// téléchargement) ; null si indisponible.

final class ProductImageFileProvider
    extends $FunctionalProvider<AsyncValue<File?>, File?, FutureOr<File?>>
    with $FutureModifier<File?>, $FutureProvider<File?> {
  /// Fichier de l'image d'un produit à une version donnée (cache, sinon
  /// téléchargement) ; null si indisponible.
  ProductImageFileProvider._({
    required ProductImageFileFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'productImageFileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productImageFileHash();

  @override
  String toString() {
    return r'productImageFileProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<File?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<File?> create(Ref ref) {
    final argument = this.argument as (String, String);
    return productImageFile(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductImageFileProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productImageFileHash() => r'224e4869e10c06845d9d113ed3355d503f8bb47d';

/// Fichier de l'image d'un produit à une version donnée (cache, sinon
/// téléchargement) ; null si indisponible.

final class ProductImageFileFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<File?>, (String, String)> {
  ProductImageFileFamily._()
    : super(
        retry: null,
        name: r'productImageFileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fichier de l'image d'un produit à une version donnée (cache, sinon
  /// téléchargement) ; null si indisponible.

  ProductImageFileProvider call(String productId, String version) =>
      ProductImageFileProvider._(argument: (productId, version), from: this);

  @override
  String toString() => r'productImageFileProvider';
}

/// Envoi et retrait des photos produit (en ligne, ADR-0008).
///
/// keepAlive : l'envoi continue si l'écran se ferme pendant le téléversement.

@ProviderFor(ProductImageEditor)
final productImageEditorProvider = ProductImageEditorProvider._();

/// Envoi et retrait des photos produit (en ligne, ADR-0008).
///
/// keepAlive : l'envoi continue si l'écran se ferme pendant le téléversement.
final class ProductImageEditorProvider
    extends $NotifierProvider<ProductImageEditor, void> {
  /// Envoi et retrait des photos produit (en ligne, ADR-0008).
  ///
  /// keepAlive : l'envoi continue si l'écran se ferme pendant le téléversement.
  ProductImageEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productImageEditorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productImageEditorHash();

  @$internal
  @override
  ProductImageEditor create() => ProductImageEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$productImageEditorHash() =>
    r'8e4c8f7179a5c65bed427cec0f002a9c5009dff2';

/// Envoi et retrait des photos produit (en ligne, ADR-0008).
///
/// keepAlive : l'envoi continue si l'écran se ferme pendant le téléversement.

abstract class _$ProductImageEditor extends $Notifier<void> {
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
