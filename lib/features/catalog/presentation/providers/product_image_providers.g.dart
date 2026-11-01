// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_image_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Image d'un produit à une version donnée (cache disque, sinon
/// téléchargement). La version dans la clé invalide l'ancienne photo.

@ProviderFor(productImage)
final productImageProvider = ProductImageFamily._();

/// Image d'un produit à une version donnée (cache disque, sinon
/// téléchargement). La version dans la clé invalide l'ancienne photo.

final class ProductImageProvider
    extends
        $FunctionalProvider<
          ImageProvider<Object>,
          ImageProvider<Object>,
          ImageProvider<Object>
        >
    with $Provider<ImageProvider<Object>> {
  /// Image d'un produit à une version donnée (cache disque, sinon
  /// téléchargement). La version dans la clé invalide l'ancienne photo.
  ProductImageProvider._({
    required ProductImageFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'productImageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productImageHash();

  @override
  String toString() {
    return r'productImageProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<ImageProvider<Object>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ImageProvider<Object> create(Ref ref) {
    final argument = this.argument as (String, String);
    return productImage(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageProvider<Object> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageProvider<Object>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProductImageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productImageHash() => r'8eda96443786224f0ae67dcc8f249dd685094d47';

/// Image d'un produit à une version donnée (cache disque, sinon
/// téléchargement). La version dans la clé invalide l'ancienne photo.

final class ProductImageFamily extends $Family
    with $FunctionalFamilyOverride<ImageProvider<Object>, (String, String)> {
  ProductImageFamily._()
    : super(
        retry: null,
        name: r'productImageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Image d'un produit à une version donnée (cache disque, sinon
  /// téléchargement). La version dans la clé invalide l'ancienne photo.

  ProductImageProvider call(String productId, String version) =>
      ProductImageProvider._(argument: (productId, version), from: this);

  @override
  String toString() => r'productImageProvider';
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
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
