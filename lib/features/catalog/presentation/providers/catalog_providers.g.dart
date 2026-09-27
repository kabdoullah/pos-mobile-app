// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Écritures sur les produits (création, modification, suppression).
///
/// keepAlive : le formulaire produit ne l'écoute pas et attend l'écriture —
/// une instance auto-dispose serait libérée pendant l'`await` et lèverait une
/// erreur après que le produit a bien été enregistré. Les listes (onglet
/// Stock, caisse) se mettent à jour d'elles-mêmes via les flux drift.

@ProviderFor(ProductEditor)
final productEditorProvider = ProductEditorProvider._();

/// Écritures sur les produits (création, modification, suppression).
///
/// keepAlive : le formulaire produit ne l'écoute pas et attend l'écriture —
/// une instance auto-dispose serait libérée pendant l'`await` et lèverait une
/// erreur après que le produit a bien été enregistré. Les listes (onglet
/// Stock, caisse) se mettent à jour d'elles-mêmes via les flux drift.
final class ProductEditorProvider
    extends $NotifierProvider<ProductEditor, void> {
  /// Écritures sur les produits (création, modification, suppression).
  ///
  /// keepAlive : le formulaire produit ne l'écoute pas et attend l'écriture —
  /// une instance auto-dispose serait libérée pendant l'`await` et lèverait une
  /// erreur après que le produit a bien été enregistré. Les listes (onglet
  /// Stock, caisse) se mettent à jour d'elles-mêmes via les flux drift.
  ProductEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productEditorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productEditorHash();

  @$internal
  @override
  ProductEditor create() => ProductEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$productEditorHash() => r'5281f0c80917243ad514367a7517de1f11b6f974';

/// Écritures sur les produits (création, modification, suppression).
///
/// keepAlive : le formulaire produit ne l'écoute pas et attend l'écriture —
/// une instance auto-dispose serait libérée pendant l'`await` et lèverait une
/// erreur après que le produit a bien été enregistré. Les listes (onglet
/// Stock, caisse) se mettent à jour d'elles-mêmes via les flux drift.

abstract class _$ProductEditor extends $Notifier<void> {
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
