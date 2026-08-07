import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../catalog/presentation/providers/catalog_providers.dart';
import '../../domain/entities/stock_movement.dart';
import '../../providers/inventory_di_providers.dart';

part 'inventory_providers.g.dart';

/// Manages the paginated stock movement history for a single product.
@riverpod
class StockHistory extends _$StockHistory {
  String? _nextCursor;
  bool _hasMore = true;
  int _lastLoadMoreListLength = 0;

  @override
  Future<List<StockMovement>> build(String productId) async {
    final repo = ref.watch(inventoryRepositoryProvider);
    final page = await repo.getMovements(productId: productId);
    _nextCursor = page.nextCursor;
    _hasMore = page.hasMore;
    return page.items;
  }

  /// Load next page of movements.
  /// Prevents duplicate requests via threshold tracking - only triggers once per new list size.
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

  /// Refresh movement history (clear cursor, reload from start).
  Future<void> refresh() async {
    _nextCursor = null;
    _hasMore = true;
    _lastLoadMoreListLength = 0;
    final repo = ref.read(inventoryRepositoryProvider);
    state = await AsyncValue.guard(() async {
      final page = await repo.getMovements(productId: productId);
      _nextCursor = page.nextCursor;
      _hasMore = page.hasMore;
      return page.items;
    });
  }

  /// Record a manual stock adjustment, then refresh the history and the
  /// product's cached stock everywhere it is displayed.
  Future<void> createAdjustment({
    required int quantityDelta,
    String? note,
  }) async {
    final repo = ref.read(inventoryRepositoryProvider);
    await repo.createAdjustment(
      productId: productId,
      quantityDelta: quantityDelta,
      note: note,
    );
    await refresh();
    ref.invalidate(productProvider(productId));
    ref.invalidate(catalogListProvider);
  }
}
