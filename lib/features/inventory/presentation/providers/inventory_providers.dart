import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/providers/catalog_providers.dart';
import '../../../catalog/providers/catalog_di_providers.dart';
import '../../domain/entities/stock_movement.dart';
import '../../providers/inventory_di_providers.dart';

part 'inventory_providers.g.dart';

/// Diffuse les produits en rupture ou sous leur seuil de réapprovisionnement —
/// alimente le filtre « Stock bas » de l'onglet Stock.
@riverpod
Stream<List<Product>> lowStockProducts(Ref ref) {
  return ref.watch(catalogRepositoryProvider).watchLowStockProducts();
}

/// Gère l'historique paginé des mouvements de stock d'un produit.
@riverpod
class StockHistory extends _$StockHistory {
  String? _nextCursor;
  bool _hasMore = true;
  int _lastLoadMoreListLength = 0;

  @override
  Future<List<StockMovement>> build(String productId) async {
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
      ..invalidate(productProvider(productId))
      ..invalidate(catalogListProvider);
  }
}
