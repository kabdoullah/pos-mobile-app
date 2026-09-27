// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Diffuse tous les produits du catalogue local (onglet Stock, détail
/// produit, noms dans l'historique des mouvements).

@ProviderFor(stockProducts)
final stockProductsProvider = StockProductsProvider._();

/// Diffuse tous les produits du catalogue local (onglet Stock, détail
/// produit, noms dans l'historique des mouvements).

final class StockProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          Stream<List<Product>>
        >
    with $FutureModifier<List<Product>>, $StreamProvider<List<Product>> {
  /// Diffuse tous les produits du catalogue local (onglet Stock, détail
  /// produit, noms dans l'historique des mouvements).
  StockProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stockProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockProductsHash();

  @$internal
  @override
  $StreamProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Product>> create(Ref ref) {
    return stockProducts(ref);
  }
}

String _$stockProductsHash() => r'9161682866611f467b2a59beb5f9dfa41a801f3f';

/// Synthèse de l'en-tête de l'onglet Stock, recalculée à chaque changement.

@ProviderFor(stockSummary)
final stockSummaryProvider = StockSummaryProvider._();

/// Synthèse de l'en-tête de l'onglet Stock, recalculée à chaque changement.

final class StockSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<StockSummary>,
          AsyncValue<StockSummary>,
          AsyncValue<StockSummary>
        >
    with $Provider<AsyncValue<StockSummary>> {
  /// Synthèse de l'en-tête de l'onglet Stock, recalculée à chaque changement.
  StockSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stockSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockSummaryHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<StockSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<StockSummary> create(Ref ref) {
    return stockSummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<StockSummary> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<StockSummary>>(value),
    );
  }
}

String _$stockSummaryHash() => r'1a248804acaf0b7efeda18f513c0fc8f283ff13f';

/// Diffuse un produit par id (`null` s'il est supprimé) — le détail se met à
/// jour après un ajustement ou une synchro.

@ProviderFor(stockProduct)
final stockProductProvider = StockProductFamily._();

/// Diffuse un produit par id (`null` s'il est supprimé) — le détail se met à
/// jour après un ajustement ou une synchro.

final class StockProductProvider
    extends
        $FunctionalProvider<AsyncValue<Product?>, Product?, Stream<Product?>>
    with $FutureModifier<Product?>, $StreamProvider<Product?> {
  /// Diffuse un produit par id (`null` s'il est supprimé) — le détail se met à
  /// jour après un ajustement ou une synchro.
  StockProductProvider._({
    required StockProductFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stockProductProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stockProductHash();

  @override
  String toString() {
    return r'stockProductProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Product?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Product?> create(Ref ref) {
    final argument = this.argument as String;
    return stockProduct(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StockProductProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stockProductHash() => r'9a2cec2d875d66fba1244c4f935b26141063aeac';

/// Diffuse un produit par id (`null` s'il est supprimé) — le détail se met à
/// jour après un ajustement ou une synchro.

final class StockProductFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Product?>, String> {
  StockProductFamily._()
    : super(
        retry: null,
        name: r'stockProductProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Diffuse un produit par id (`null` s'il est supprimé) — le détail se met à
  /// jour après un ajustement ou une synchro.

  StockProductProvider call(String id) =>
      StockProductProvider._(argument: id, from: this);

  @override
  String toString() => r'stockProductProvider';
}

/// Gère l'historique paginé des mouvements de stock, d'un produit ou de tous
/// les produits ([productId] `null`). Données serveur uniquement (en ligne).

@ProviderFor(StockHistory)
final stockHistoryProvider = StockHistoryFamily._();

/// Gère l'historique paginé des mouvements de stock, d'un produit ou de tous
/// les produits ([productId] `null`). Données serveur uniquement (en ligne).
final class StockHistoryProvider
    extends $AsyncNotifierProvider<StockHistory, List<StockMovement>> {
  /// Gère l'historique paginé des mouvements de stock, d'un produit ou de tous
  /// les produits ([productId] `null`). Données serveur uniquement (en ligne).
  StockHistoryProvider._({
    required StockHistoryFamily super.from,
    required String? super.argument,
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

String _$stockHistoryHash() => r'3ee5f3bb0ffd1651dc46ba13bb98b60048e4bd48';

/// Gère l'historique paginé des mouvements de stock, d'un produit ou de tous
/// les produits ([productId] `null`). Données serveur uniquement (en ligne).

final class StockHistoryFamily extends $Family
    with
        $ClassFamilyOverride<
          StockHistory,
          AsyncValue<List<StockMovement>>,
          List<StockMovement>,
          FutureOr<List<StockMovement>>,
          String?
        > {
  StockHistoryFamily._()
    : super(
        retry: null,
        name: r'stockHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Gère l'historique paginé des mouvements de stock, d'un produit ou de tous
  /// les produits ([productId] `null`). Données serveur uniquement (en ligne).

  StockHistoryProvider call(String? productId) =>
      StockHistoryProvider._(argument: productId, from: this);

  @override
  String toString() => r'stockHistoryProvider';
}

/// Gère l'historique paginé des mouvements de stock, d'un produit ou de tous
/// les produits ([productId] `null`). Données serveur uniquement (en ligne).

abstract class _$StockHistory extends $AsyncNotifier<List<StockMovement>> {
  late final _$args = ref.$arg as String?;
  String? get productId => _$args;

  FutureOr<List<StockMovement>> build(String? productId);
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

String _$stockAdjustmentHash() => r'1a464f24f4be75b570f3a8a352306bee46ac137a';

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
