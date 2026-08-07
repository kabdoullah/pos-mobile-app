import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_movement.freezed.dart';

/// Reason a stock movement was recorded.
enum StockMovementReason {
  /// Stock decreased by a sale.
  sale,

  /// Manual adjustment (reception, breakage, inventory correction).
  manualAdjustment,

  /// Stock set directly via a catalog update.
  catalogUpdate,
}

/// Stock movement entity — an entry in a product's stock audit trail.
@freezed
sealed class StockMovement with _$StockMovement {
  /// Creates a [StockMovement].
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
