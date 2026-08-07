import '../entities/stock_movement.dart';
import '../entities/stock_movement_page.dart';

/// Abstract repository for inventory (stock movement) operations.
abstract class InventoryRepository {
  /// Get stock movements, optionally filtered by product and paginated by cursor.
  Future<StockMovementPage> getMovements({
    String? productId,
    String? cursor,
    int limit = 50,
  });

  /// Record a manual stock adjustment (reception, breakage, correction).
  Future<StockMovement> createAdjustment({
    required String productId,
    required int quantityDelta,
    String? note,
  });
}
