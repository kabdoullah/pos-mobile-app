import 'package:drift/drift.dart' as drift;

import '../../../../database/app_database.dart';
import '../../domain/entities/stock_movement.dart';
import '../../domain/entities/stock_movement_page.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_remote_datasource.dart';
import '../models/stock_movement_mappers.dart';
import '../../../../core/network/api_models/stock_movement_dto.dart';

/// Implémentation concrète de [InventoryRepository].
///
/// En ligne uniquement : les mouvements de stock forment un journal d'audit
/// dont le serveur fait autorité (il inclut les entrées d'autres appareils et
/// les motifs automatiques comme `sale` ou `catalog_update`). Contrairement à
/// [CatalogRepositoryImpl], il n'y a donc ni table miroir drift ni file de
/// synchro pour les mouvements eux-mêmes. Après un ajustement manuel réussi,
/// seule la valeur en cache `Products.currentStock` est mise à jour en local à
/// partir du résultat calculé par le serveur.
class InventoryRepositoryImpl implements InventoryRepository {
  /// Crée un InventoryRepositoryImpl.
  InventoryRepositoryImpl({required this.remoteDataSource, required this.db});

  /// Data source distante pour les opérations d'inventaire.
  final InventoryRemoteDataSource remoteDataSource;

  /// Instance de la base drift locale, utilisée uniquement pour rafraîchir le
  /// stock produit en cache après un ajustement réussi.
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
      // Rafraîchit uniquement la valeur de stock en cache — elle reflète une
      // valeur déjà appliquée côté serveur, elle ne doit donc pas être marquée
      // dirty ni remise en file.
      await (db.update(db.products)..where((p) => p.id.equals(productId)))
          .write(ProductsCompanion(currentStock: drift.Value(resultingStock)));
    }

    return dto.toDomain();
  }
}
