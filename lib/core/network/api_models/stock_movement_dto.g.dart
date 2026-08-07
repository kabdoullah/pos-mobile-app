// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_movement_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockMovementDto _$StockMovementDtoFromJson(Map<String, dynamic> json) =>
    _StockMovementDto(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      productId: json['product_id'] as String,
      quantityDelta: (json['quantity_delta'] as num?)?.toInt(),
      reason: $enumDecode(_$StockMovementReasonDtoEnumMap, json['reason']),
      resultingStock: (json['resulting_stock'] as num?)?.toInt(),
      saleId: json['sale_id'] as String?,
      createdBy: json['created_by'] as String?,
      note: json['note'] as String?,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$StockMovementDtoToJson(_StockMovementDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'store_id': instance.storeId,
      'product_id': instance.productId,
      'quantity_delta': instance.quantityDelta,
      'reason': _$StockMovementReasonDtoEnumMap[instance.reason]!,
      'resulting_stock': instance.resultingStock,
      'sale_id': instance.saleId,
      'created_by': instance.createdBy,
      'note': instance.note,
      'created_at': instance.createdAt,
    };

const _$StockMovementReasonDtoEnumMap = {
  StockMovementReasonDto.sale: 'sale',
  StockMovementReasonDto.manualAdjustment: 'manual_adjustment',
  StockMovementReasonDto.catalogUpdate: 'catalog_update',
};

_ManualStockAdjustmentCreateDto _$ManualStockAdjustmentCreateDtoFromJson(
  Map<String, dynamic> json,
) => _ManualStockAdjustmentCreateDto(
  productId: json['product_id'] as String,
  quantityDelta: (json['quantity_delta'] as num).toInt(),
  note: json['note'] as String?,
);

Map<String, dynamic> _$ManualStockAdjustmentCreateDtoToJson(
  _ManualStockAdjustmentCreateDto instance,
) => <String, dynamic>{
  'product_id': instance.productId,
  'quantity_delta': instance.quantityDelta,
  'note': instance.note,
};
