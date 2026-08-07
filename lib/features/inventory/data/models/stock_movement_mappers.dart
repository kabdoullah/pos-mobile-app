import '../../../../core/network/api_models/stock_movement_dto.dart';
import '../../domain/entities/stock_movement.dart';

/// Maps [StockMovementReasonDto] → [StockMovementReason].
extension StockMovementReasonDtoToDomain on StockMovementReasonDto {
  /// Converts API DTO reason to domain reason.
  StockMovementReason toDomain() => switch (this) {
    StockMovementReasonDto.sale => StockMovementReason.sale,
    StockMovementReasonDto.manualAdjustment =>
      StockMovementReason.manualAdjustment,
    StockMovementReasonDto.catalogUpdate => StockMovementReason.catalogUpdate,
  };
}

/// Maps StockMovementDto (API) → StockMovement (domain).
extension StockMovementDtoToDomain on StockMovementDto {
  /// Converts API DTO to domain entity.
  StockMovement toDomain() => StockMovement(
    id: id,
    productId: productId,
    quantityDelta: quantityDelta,
    reason: reason.toDomain(),
    resultingStock: resultingStock,
    saleId: saleId,
    note: note,
    createdAt: DateTime.parse(createdAt),
  );
}
