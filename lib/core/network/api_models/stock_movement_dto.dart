import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_movement_dto.freezed.dart';
part 'stock_movement_dto.g.dart';

/// Reason a stock movement was recorded.
enum StockMovementReasonDto {
  /// Stock decreased by a sale.
  @JsonValue('sale')
  sale,

  /// Manual adjustment (reception, breakage, inventory correction).
  @JsonValue('manual_adjustment')
  manualAdjustment,

  /// Stock set directly via a catalog update.
  @JsonValue('catalog_update')
  catalogUpdate,
}

/// Stock movement data transfer object from API.
@freezed
sealed class StockMovementDto with _$StockMovementDto {
  /// Creates a [StockMovementDto].
  const factory StockMovementDto({
    required String id,
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'quantity_delta') int? quantityDelta,
    required StockMovementReasonDto reason,
    @JsonKey(name: 'resulting_stock') int? resultingStock,
    @JsonKey(name: 'sale_id') String? saleId,
    @JsonKey(name: 'created_by') String? createdBy,
    String? note,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _StockMovementDto;

  /// Creates a [StockMovementDto] from JSON.
  factory StockMovementDto.fromJson(Map<String, dynamic> json) =>
      _$StockMovementDtoFromJson(json);
}

/// Request to create a manual stock adjustment.
@freezed
sealed class ManualStockAdjustmentCreateDto
    with _$ManualStockAdjustmentCreateDto {
  /// Creates a [ManualStockAdjustmentCreateDto].
  const factory ManualStockAdjustmentCreateDto({
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'quantity_delta') required int quantityDelta,
    String? note,
  }) = _ManualStockAdjustmentCreateDto;

  /// Creates a [ManualStockAdjustmentCreateDto] from JSON.
  factory ManualStockAdjustmentCreateDto.fromJson(Map<String, dynamic> json) =>
      _$ManualStockAdjustmentCreateDtoFromJson(json);
}
