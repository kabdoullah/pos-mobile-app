// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Diffuse les produits en rupture ou sous leur seuil de réapprovisionnement —
/// alimente le filtre « Stock bas » de l'onglet Stock.

@ProviderFor(lowStockProducts)
final lowStockProductsProvider = LowStockProductsProvider._();

/// Diffuse les produits en rupture ou sous leur seuil de réapprovisionnement —
/// alimente le filtre « Stock bas » de l'onglet Stock.

final class LowStockProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          Stream<List<Product>>
        >
    with $FutureModifier<List<Product>>, $StreamProvider<List<Product>> {
  /// Diffuse les produits en rupture ou sous leur seuil de réapprovisionnement —
  /// alimente le filtre « Stock bas » de l'onglet Stock.
  LowStockProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lowStockProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lowStockProductsHash();

  @$internal
  @override
  $StreamProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Product>> create(Ref ref) {
    return lowStockProducts(ref);
  }
}

String _$lowStockProductsHash() => r'ed6906d8407f6cb382e73d75bcced4589f18bace';

/// Gère l'historique paginé des mouvements de stock d'un produit.

@ProviderFor(StockHistory)
final stockHistoryProvider = StockHistoryFamily._();

/// Gère l'historique paginé des mouvements de stock d'un produit.
final class StockHistoryProvider
    extends $AsyncNotifierProvider<StockHistory, List<StockMovement>> {
  /// Gère l'historique paginé des mouvements de stock d'un produit.
  StockHistoryProvider._({
    required StockHistoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stockHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stockHistoryHash();

  @override
  String toString() {
    return r'stockHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  StockHistory create() => StockHistory();

  @override
  bool operator ==(Object other) {
    return other is StockHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stockHistoryHash() => r'27f9cccdc58c7e5867ce05b9ba6024b3bd62cfed';

/// Gère l'historique paginé des mouvements de stock d'un produit.

final class StockHistoryFamily extends $Family
    with
        $ClassFamilyOverride<
          StockHistory,
          AsyncValue<List<StockMovement>>,
          List<StockMovement>,
          FutureOr<List<StockMovement>>,
          String
        > {
  StockHistoryFamily._()
    : super(
        retry: null,
        name: r'stockHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Gère l'historique paginé des mouvements de stock d'un produit.

  StockHistoryProvider call(String productId) =>
      StockHistoryProvider._(argument: productId, from: this);

  @override
  String toString() => r'stockHistoryProvider';
}

/// Gère l'historique paginé des mouvements de stock d'un produit.

abstract class _$StockHistory extends $AsyncNotifier<List<StockMovement>> {
  late final _$args = ref.$arg as String;
  String get productId => _$args;

  FutureOr<List<StockMovement>> build(String productId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<StockMovement>>, List<StockMovement>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<StockMovement>>, List<StockMovement>>,
              AsyncValue<List<StockMovement>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

/// Enregistre les ajustements de stock manuels, puis marque comme périmées
/// toutes les vues du stock du produit (historique, fiche produit, liste du
/// catalogue).
///
/// Séparé de [StockHistory] et maintenu en vie volontairement : la feuille
/// d'ajustement s'ouvre aussi depuis l'onglet Stock, où personne n'écoute
/// l'historique du produit — un notifier auto-dispose serait libéré en pleine
/// écriture et signalerait un échec pour un ajustement déjà enregistré côté
/// serveur.

@ProviderFor(StockAdjustment)
final stockAdjustmentProvider = StockAdjustmentProvider._();

/// Enregistre les ajustements de stock manuels, puis marque comme périmées
/// toutes les vues du stock du produit (historique, fiche produit, liste du
/// catalogue).
///
/// Séparé de [StockHistory] et maintenu en vie volontairement : la feuille
/// d'ajustement s'ouvre aussi depuis l'onglet Stock, où personne n'écoute
/// l'historique du produit — un notifier auto-dispose serait libéré en pleine
/// écriture et signalerait un échec pour un ajustement déjà enregistré côté
/// serveur.
final class StockAdjustmentProvider
    extends $NotifierProvider<StockAdjustment, void> {
  /// Enregistre les ajustements de stock manuels, puis marque comme périmées
  /// toutes les vues du stock du produit (historique, fiche produit, liste du
  /// catalogue).
  ///
  /// Séparé de [StockHistory] et maintenu en vie volontairement : la feuille
  /// d'ajustement s'ouvre aussi depuis l'onglet Stock, où personne n'écoute
  /// l'historique du produit — un notifier auto-dispose serait libéré en pleine
  /// écriture et signalerait un échec pour un ajustement déjà enregistré côté
  /// serveur.
  StockAdjustmentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stockAdjustmentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockAdjustmentHash();

  @$internal
  @override
  StockAdjustment create() => StockAdjustment();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$stockAdjustmentHash() => r'ab3018cafcfb786e586d4f190272a7f87debbc21';

/// Enregistre les ajustements de stock manuels, puis marque comme périmées
/// toutes les vues du stock du produit (historique, fiche produit, liste du
/// catalogue).
///
/// Séparé de [StockHistory] et maintenu en vie volontairement : la feuille
/// d'ajustement s'ouvre aussi depuis l'onglet Stock, où personne n'écoute
/// l'historique du produit — un notifier auto-dispose serait libéré en pleine
/// écriture et signalerait un échec pour un ajustement déjà enregistré côté
/// serveur.

abstract class _$StockAdjustment extends $Notifier<void> {
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
