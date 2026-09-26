import '../entities/stock_movement.dart';
import '../entities/stock_movement_page.dart';

/// Repository abstrait pour les opérations d'inventaire (mouvements de stock).
abstract class InventoryRepository {
  /// Récupère les mouvements de stock, filtrés en option par produit, et
  /// paginés par curseur.
  Future<StockMovementPage> getMovements({
    String? productId,
    String? cursor,
    int limit = 50,
  });

  /// Enregistre un ajustement de stock manuel (réception, casse, correction).
  Future<StockMovement> createAdjustment({
    required String productId,
    required int quantityDelta,
    String? note,
  });
}
