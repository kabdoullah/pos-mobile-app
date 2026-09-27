import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/providers/catalog_providers.dart';
import '../../../catalog/providers/catalog_di_providers.dart';
import '../../domain/entities/stock_movement.dart';
import '../../domain/entities/stock_summary.dart';
import '../../providers/inventory_di_providers.dart';

part 'inventory_providers.g.dart';

/// Filtres de la liste de l'onglet Stock.
enum StockFilter {
  /// Tous les produits.
  all,

  /// En rupture ou sous leur seuil (à réapprovisionner).
  lowStock,

  /// En rupture uniquement.
  outOfStock,
}

/// Diffuse tous les produits du catalogue local (onglet Stock, détail
/// produit, noms dans l'historique des mouvements).
@riverpod
Stream<List<Product>> stockProducts(Ref ref) {
  return ref.watch(catalogRepositoryProvider).watchProducts();
}

/// Synthèse de l'en-tête de l'onglet Stock, recalculée à chaque changement.
@riverpod
AsyncValue<StockSummary> stockSummary(Ref ref) {
  return ref.watch(stockProductsProvider).whenData(StockSummary.fromProducts);
}

/// Diffuse un produit par id (`null` s'il est supprimé) — le détail se met à
/// jour après un ajustement ou une synchro.
@riverpod
Stream<Product?> stockProduct(Ref ref, String id) {
  return ref
      .watch(catalogRepositoryProvider)
      .watchProducts()
      .map((products) => products.where((p) => p.id == id).firstOrNull);
}

/// Filtre et recherche (nom ou code-barres, insensible à la casse).
///
/// Les vues « à réapprovisionner » sont triées par stock croissant pour faire
/// remonter les ruptures ; « tous » garde l'ordre alphabétique.
List<Product> filterStockProducts(
  List<Product> products, {
  required StockFilter filter,
  String query = '',
}) {
  final q = query.trim().toLowerCase();
  final result = products.where((product) {
    final level = product.stockLevel;
    final matchesFilter = switch (filter) {
      StockFilter.all => true,
      StockFilter.lowStock =>
        level == StockLevel.low || level == StockLevel.outOfStock,
      StockFilter.outOfStock => level == StockLevel.outOfStock,
    };
    if (!matchesFilter) return false;
    if (q.isEmpty) return true;
    return product.name.toLowerCase().contains(q) ||
        (product.barcode?.toLowerCase().contains(q) ?? false);
  }).toList();

  if (filter != StockFilter.all) {
    result.sort((a, b) {
      final byStock = (a.currentStock ?? 0).compareTo(b.currentStock ?? 0);
      return byStock != 0 ? byStock : a.name.compareTo(b.name);
    });
  }
  return result;
}

/// Gère l'historique paginé des mouvements de stock, d'un produit ou de tous
/// les produits ([productId] `null`). Données serveur uniquement (en ligne).
@riverpod
class StockHistory extends _$StockHistory {
  String? _nextCursor;
  bool _hasMore = true;
  int _lastLoadMoreListLength = 0;

  @override
  Future<List<StockMovement>> build(String? productId) async {
    _lastLoadMoreListLength = 0;
    final repo = ref.watch(inventoryRepositoryProvider);
    final page = await repo.getMovements(productId: productId);
    _nextCursor = page.nextCursor;
    _hasMore = page.hasMore;
    return page.items;
  }

  /// Charge la page suivante de mouvements.
  /// Évite les requêtes en double en suivant un seuil — ne se déclenche qu'une
  /// fois par nouvelle taille de liste.
  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;

    final currentList = state.whenData((list) => list).value ?? [];

    if (currentList.length <= _lastLoadMoreListLength) return;
    _lastLoadMoreListLength = currentList.length;

    final repo = ref.read(inventoryRepositoryProvider);

    state = await AsyncValue.guard(() async {
      final page = await repo.getMovements(
        productId: productId,
        cursor: _nextCursor,
      );
      _nextCursor = page.nextCursor;
      _hasMore = page.hasMore;
      return [...currentList, ...page.items];
    });
  }

  /// Rafraîchit l'historique des mouvements (efface le curseur, recharge depuis
  /// le début).
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
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
@Riverpod(keepAlive: true)
class StockAdjustment extends _$StockAdjustment {
  @override
  void build() {}

  /// Envoie l'ajustement ; lève une exception en cas d'échec, avant toute
  /// invalidation.
  Future<void> submit({
    required String productId,
    required int quantityDelta,
    String? note,
  }) async {
    await ref
        .read(inventoryRepositoryProvider)
        .createAdjustment(
          productId: productId,
          quantityDelta: quantityDelta,
          note: note,
        );
    ref
      ..invalidate(stockHistoryProvider(productId))
      ..invalidate(stockHistoryProvider(null))
      ..invalidate(productProvider(productId))
      ..invalidate(catalogListProvider);
  }
}
