import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_movement_dto.freezed.dart';
part 'stock_movement_dto.g.dart';

/// Motif d'enregistrement d'un mouvement de stock.
enum StockMovementReasonDto {
  /// Stock diminué par une vente.
  @JsonValue('sale')
  sale,

  /// Ajustement manuel (réception, casse, correction d'inventaire).
  @JsonValue('manual_adjustment')
  manualAdjustment,

  /// Stock fixé directement via une mise à jour du catalogue.
  @JsonValue('catalog_update')
  catalogUpdate,
}

/// Objet de transfert mouvement de stock reçu de l'API.
@freezed
sealed class StockMovementDto with _$StockMovementDto {
  /// Crée un [StockMovementDto].
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

  /// Crée un [StockMovementDto] depuis du JSON.
  factory StockMovementDto.fromJson(Map<String, dynamic> json) =>
      _$StockMovementDtoFromJson(json);
}

/// Requête de création d'un ajustement de stock manuel.
@freezed
sealed class ManualStockAdjustmentCreateDto
    with _$ManualStockAdjustmentCreateDto {
  /// Crée un [ManualStockAdjustmentCreateDto].
  const factory ManualStockAdjustmentCreateDto({
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'quantity_delta') required int quantityDelta,
    String? note,
  }) = _ManualStockAdjustmentCreateDto;

  /// Crée un [ManualStockAdjustmentCreateDto] depuis du JSON.
  factory ManualStockAdjustmentCreateDto.fromJson(Map<String, dynamic> json) =>
      _$ManualStockAdjustmentCreateDtoFromJson(json);
}
