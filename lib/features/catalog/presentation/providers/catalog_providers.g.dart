// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// CatalogListNotifier gère la liste des produits avec pagination et recherche.

@ProviderFor(CatalogList)
final catalogListProvider = CatalogListProvider._();

/// CatalogListNotifier gère la liste des produits avec pagination et recherche.
final class CatalogListProvider
    extends $AsyncNotifierProvider<CatalogList, List<Product>> {
  /// CatalogListNotifier gère la liste des produits avec pagination et recherche.
  CatalogListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogListHash();

  @$internal
  @override
  CatalogList create() => CatalogList();
}

String _$catalogListHash() => r'2c118ecc5d80c4b37ec51199a7f66c93b21f93c0';

/// CatalogListNotifier gère la liste des produits avec pagination et recherche.

abstract class _$CatalogList extends $AsyncNotifier<List<Product>> {
  FutureOr<List<Product>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Product>>, List<Product>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Product>>, List<Product>>,
              AsyncValue<List<Product>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Récupère un produit par ID pour le formulaire d'édition.

@ProviderFor(product)
final productProvider = ProductFamily._();

/// Récupère un produit par ID pour le formulaire d'édition.

final class ProductProvider
    extends
        $FunctionalProvider<AsyncValue<Product?>, Product?, FutureOr<Product?>>
    with $FutureModifier<Product?>, $FutureProvider<Product?> {
  /// Récupère un produit par ID pour le formulaire d'édition.
  ProductProvider._({
    required ProductFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productHash();

  @override
  String toString() {
    return r'productProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Product?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Product?> create(Ref ref) {
    final argument = this.argument as String;
    return product(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productHash() => r'c4b0094f15a99fed91da3547c2a6f45979df978d';

/// Récupère un produit par ID pour le formulaire d'édition.

final class ProductFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Product?>, String> {
  ProductFamily._()
    : super(
        retry: null,
        name: r'productProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Récupère un produit par ID pour le formulaire d'édition.

  ProductProvider call(String id) =>
      ProductProvider._(argument: id, from: this);

  @override
  String toString() => r'productProvider';
}
