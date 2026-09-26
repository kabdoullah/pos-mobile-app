import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_movement.freezed.dart';

/// Motif d'enregistrement d'un mouvement de stock.
enum StockMovementReason {
  /// Stock diminué par une vente.
  sale,

  /// Ajustement manuel (réception, casse, correction d'inventaire).
  manualAdjustment,

  /// Stock fixé directement via une mise à jour du catalogue.
  catalogUpdate,
}

/// Entité mouvement de stock — une entrée du journal d'audit du stock d'un
/// produit.
@freezed
sealed class StockMovement with _$StockMovement {
  /// Crée un [StockMovement].
  const factory StockMovement({
    required String id,
    required String productId,
    int? quantityDelta,
    required StockMovementReason reason,
    int? resultingStock,
    String? saleId,
    String? note,
    required DateTime createdAt,
  }) = _StockMovement;
}
