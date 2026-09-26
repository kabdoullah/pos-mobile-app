import '../../../../core/network/api_models/stock_movement_dto.dart';
import '../../domain/entities/stock_movement.dart';

/// Convertit [StockMovementReasonDto] → [StockMovementReason].
extension StockMovementReasonDtoToDomain on StockMovementReasonDto {
  /// Convertit le motif du DTO de l'API en motif du domaine.
  StockMovementReason toDomain() => switch (this) {
    StockMovementReasonDto.sale => StockMovementReason.sale,
    StockMovementReasonDto.manualAdjustment =>
      StockMovementReason.manualAdjustment,
    StockMovementReasonDto.catalogUpdate => StockMovementReason.catalogUpdate,
  };
}

/// Convertit StockMovementDto (API) → StockMovement (domaine).
extension StockMovementDtoToDomain on StockMovementDto {
  /// Convertit le DTO de l'API en entité du domaine.
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
