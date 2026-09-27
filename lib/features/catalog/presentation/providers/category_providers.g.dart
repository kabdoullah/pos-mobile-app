// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Diffuse les catégories actives, triées par nom (ADR-0008).

@ProviderFor(categories)
final categoriesProvider = CategoriesProvider._();

/// Diffuse les catégories actives, triées par nom (ADR-0008).

final class CategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          Stream<List<Category>>
        >
    with $FutureModifier<List<Category>>, $StreamProvider<List<Category>> {
  /// Diffuse les catégories actives, triées par nom (ADR-0008).
  CategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesHash();

  @$internal
  @override
  $StreamProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Category>> create(Ref ref) {
    return categories(ref);
  }
}

String _$categoriesHash() => r'5dcd559d44a0e5d391f2b1c6a87ec71171dc4c0a';

/// Nombre de produits actifs par catégorie (tout le catalogue local, pas une
/// page).

@ProviderFor(categoryProductCounts)
final categoryProductCountsProvider = CategoryProductCountsProvider._();

/// Nombre de produits actifs par catégorie (tout le catalogue local, pas une
/// page).

final class CategoryProductCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, int>>,
          Map<String, int>,
          Stream<Map<String, int>>
        >
    with $FutureModifier<Map<String, int>>, $StreamProvider<Map<String, int>> {
  /// Nombre de produits actifs par catégorie (tout le catalogue local, pas une
  /// page).
  CategoryProductCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryProductCountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryProductCountsHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, int>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, int>> create(Ref ref) {
    return categoryProductCounts(ref);
  }
}

String _$categoryProductCountsHash() =>
    r'0240bd2234963e1c169b28884bf59d037262caeb';

/// Écritures sur les catégories et la catégorie des produits.
///
/// keepAlive : appelé depuis des feuilles et dialogues qui ne l'écoutent pas —
/// une instance auto-dispose serait libérée pendant l'écriture.

@ProviderFor(CategoryEditor)
final categoryEditorProvider = CategoryEditorProvider._();

/// Écritures sur les catégories et la catégorie des produits.
///
/// keepAlive : appelé depuis des feuilles et dialogues qui ne l'écoutent pas —
/// une instance auto-dispose serait libérée pendant l'écriture.
final class CategoryEditorProvider
    extends $NotifierProvider<CategoryEditor, void> {
  /// Écritures sur les catégories et la catégorie des produits.
  ///
  /// keepAlive : appelé depuis des feuilles et dialogues qui ne l'écoutent pas —
  /// une instance auto-dispose serait libérée pendant l'écriture.
  CategoryEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryEditorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryEditorHash();

  @$internal
  @override
  CategoryEditor create() => CategoryEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$categoryEditorHash() => r'99fd899e3411a365a6ac01716e5416d3f5a49685';

/// Écritures sur les catégories et la catégorie des produits.
///
/// keepAlive : appelé depuis des feuilles et dialogues qui ne l'écoutent pas —
/// une instance auto-dispose serait libérée pendant l'écriture.

abstract class _$CategoryEditor extends $Notifier<void> {
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
