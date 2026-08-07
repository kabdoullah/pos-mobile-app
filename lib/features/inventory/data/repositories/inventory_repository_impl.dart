import 'package:drift/drift.dart' as drift;

import '../../../../database/app_database.dart';
import '../../domain/entities/stock_movement.dart';
import '../../domain/entities/stock_movement_page.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_remote_datasource.dart';
import '../models/stock_movement_mappers.dart';
import '../../../../core/network/api_models/stock_movement_dto.dart';

/// Concrete implementation of [InventoryRepository].
///
/// Online-only: stock movements are a server-authoritative audit trail
/// (includes entries from other devices and automatic reasons like `sale` or
/// `catalog_update`), so unlike [CatalogRepositoryImpl] there is no local
/// drift mirror table or sync queue for movements themselves. After a manual
/// adjustment succeeds, only the cached `Products.currentStock` value is
/// updated locally from the server-computed result.
class InventoryRepositoryImpl implements InventoryRepository {
  /// Creates an InventoryRepositoryImpl.
  InventoryRepositoryImpl({required this.remoteDataSource, required this.db});

  /// Remote data source for inventory operations.
  final InventoryRemoteDataSource remoteDataSource;

  /// Local drift database instance, used only to refresh the cached
  /// product stock after a successful adjustment.
  final AppDatabase db;

  @override
  Future<StockMovementPage> getMovements({
    String? productId,
    String? cursor,
    int limit = 50,
  }) async {
    final page = await remoteDataSource.listMovements(
      productId: productId,
      cursor: cursor,
      limit: limit,
    );

    return StockMovementPage(
      items: page.items.map((dto) => dto.toDomain()).toList(),
      nextCursor: page.nextCursor,
      hasMore: page.hasMore,
    );
  }

  @override
  Future<StockMovement> createAdjustment({
    required String productId,
    required int quantityDelta,
    String? note,
  }) async {
    final dto = await remoteDataSource.createAdjustment(
      ManualStockAdjustmentCreateDto(
        productId: productId,
        quantityDelta: quantityDelta,
        note: note,
      ),
    );

    final resultingStock = dto.resultingStock;
    if (resultingStock != null) {
      // Refresh the cached stock value only — this reflects a value already
      // applied server-side, so it must not be marked dirty or re-enqueued.
      await (db.update(db.products)..where((p) => p.id.equals(productId)))
          .write(ProductsCompanion(currentStock: drift.Value(resultingStock)));
    }

    return dto.toDomain();
  }
}
