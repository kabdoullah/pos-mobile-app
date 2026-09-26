import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/sync/sync_orchestrator.dart';
import '../../providers/catalog_di_providers.dart';
import '../../domain/entities/product.dart';

part 'catalog_providers.g.dart';

/// CatalogListNotifier gère la liste des produits avec pagination et recherche.
@riverpod
class CatalogList extends _$CatalogList {
  String _searchQuery = '';
  String? _nextCursor;
  bool _hasMore = true;
  int _lastLoadMoreListLength = 0;
  Timer? _debounceTimer;

  @override
  Future<List<Product>> build() async {
    ref.onDispose(() => _debounceTimer?.cancel());

    // Rafraîchit le catalogue à la fin d'un cycle de synchro.
    ref.listen<SyncStatus>(syncOrchestratorProvider, (prev, next) {
      if (next is SyncStatusIdle) {
        ref.invalidateSelf();
      }
    });

    final repo = ref.watch(catalogRepositoryProvider);
    final page = await repo.getProducts();
    _nextCursor = page.nextCursor;
    _hasMore = page.hasMore;
    return page.items;
  }

  /// Point d'entrée de recherche avec anti-rebond, appelé depuis l'UI.
  void setSearchQuery(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      const Duration(milliseconds: 300),
      () => search(query),
    );
  }

  /// Recherche des produits par nom.
  Future<void> search(String query) async {
    _searchQuery = query;
    _nextCursor = null;
    _hasMore = true;
    _lastLoadMoreListLength = 0;
    final repo = ref.read(catalogRepositoryProvider);
    final page = await repo.getProducts(query: query);
    _nextCursor = page.nextCursor;
    _hasMore = page.hasMore;
    state = AsyncData(page.items);
  }

  /// Charge la page suivante de produits.
  /// Évite les requêtes en double en suivant un seuil — ne se déclenche qu'une
  /// fois par nouvelle taille de liste.
  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;

    final currentList = state.whenData((list) => list).value ?? [];

    // Ne déclencher loadMore qu'une fois par augmentation de la taille de la
    // liste
    if (currentList.length <= _lastLoadMoreListLength) return;
    _lastLoadMoreListLength = currentList.length;

    final repo = ref.read(catalogRepositoryProvider);

    state = await AsyncValue.guard(() async {
      final page = await repo.getProducts(
        query: _searchQuery.isEmpty ? null : _searchQuery,
        cursor: _nextCursor,
      );
      _nextCursor = page.nextCursor;
      _hasMore = page.hasMore;
      return [...currentList, ...page.items];
    });
  }

  /// Rafraîchit la liste des produits (efface le curseur, recharge depuis le
  /// début).
  Future<void> refresh() async {
    _nextCursor = null;
    _hasMore = true;
    _lastLoadMoreListLength = 0;
    final repo = ref.read(catalogRepositoryProvider);
    state = await AsyncValue.guard(() async {
      final page = await repo.getProducts(
        query: _searchQuery.isEmpty ? null : _searchQuery,
      );
      _nextCursor = page.nextCursor;
      _hasMore = page.hasMore;
      return page.items;
    });
  }

  /// Crée un nouveau produit.
  Future<void> createProduct({
    required String name,
    required String unitPrice,
    String? barcode,
    int? currentStock,
    int? minStock,
  }) async {
    final repo = ref.read(catalogRepositoryProvider);
    await repo.createProduct(
      name: name,
      unitPrice: unitPrice,
      barcode: barcode,
      currentStock: currentStock,
      minStock: minStock,
    );
    // Rafraîchit la liste après la création
    await refresh();
  }

  /// Met à jour un produit existant.
  Future<void> updateProduct({
    required String id,
    String? name,
    String? unitPrice,
    String? barcode,
    int? currentStock,
    int? minStock,
  }) async {
    final repo = ref.read(catalogRepositoryProvider);
    await repo.updateProduct(
      id: id,
      name: name,
      unitPrice: unitPrice,
      barcode: barcode,
      currentStock: currentStock,
      minStock: minStock,
    );
    // Rafraîchit la liste après la mise à jour
    await refresh();
  }

  /// Supprime un produit par ID.
  Future<void> deleteProduct(String id) async {
    final repo = ref.read(catalogRepositoryProvider);
    await repo.deleteProduct(id);
    // Rafraîchit la liste après la suppression
    await refresh();
  }
}

/// Récupère un produit par ID pour le formulaire d'édition.
@riverpod
Future<Product?> product(Ref ref, String id) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.getProduct(id);
}
