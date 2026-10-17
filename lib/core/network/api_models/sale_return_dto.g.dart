// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_return_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SaleReturnItemCreateDto _$SaleReturnItemCreateDtoFromJson(
  Map<String, dynamic> json,
) => _SaleReturnItemCreateDto(
  id: json['id'] as String,
  saleItemId: json['sale_item_id'] as String,
  quantity: (json['quantity'] as num).toInt(),
  condition: json['condition'] as String,
  refundAmount: json['refund_amount'] as String,
);

Map<String, dynamic> _$SaleReturnItemCreateDtoToJson(
  _SaleReturnItemCreateDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'sale_item_id': instance.saleItemId,
  'quantity': instance.quantity,
  'condition': instance.condition,
  'refund_amount': instance.refundAmount,
};

_SaleReturnCreateDto _$SaleReturnCreateDtoFromJson(Map<String, dynamic> json) =>
    _SaleReturnCreateDto(
      id: json['id'] as String,
      saleId: json['sale_id'] as String,
      reason: json['reason'] as String,
      note: json['note'] as String?,
      refundMethod: json['refund_method'] as String,
      refundAmount: json['refund_amount'] as String,
      createdAt: json['created_at'] as String,
      items: (json['items'] as List<dynamic>)
          .map(
            (e) => SaleReturnItemCreateDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$SaleReturnCreateDtoToJson(
  _SaleReturnCreateDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'sale_id': instance.saleId,
  'reason': instance.reason,
  'note': instance.note,
  'refund_method': instance.refundMethod,
  'refund_amount': instance.refundAmount,
  'created_at': instance.createdAt,
  'items': instance.items,
};

_SaleReturnItemDto _$SaleReturnItemDtoFromJson(Map<String, dynamic> json) =>
    _SaleReturnItemDto(
      id: json['id'] as String,
      saleReturnId: json['sale_return_id'] as String,
      saleItemId: json['sale_item_id'] as String,
      productId: json['product_id'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      condition: json['condition'] as String,
      restocked: json['restocked'] as bool,
      refundAmount: json['refund_amount'] as String,
    );

Map<String, dynamic> _$SaleReturnItemDtoToJson(_SaleReturnItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sale_return_id': instance.saleReturnId,
      'sale_item_id': instance.saleItemId,
      'product_id': instance.productId,
      'quantity': instance.quantity,
      'condition': instance.condition,
      'restocked': instance.restocked,
      'refund_amount': instance.refundAmount,
    };

_SaleReturnDto _$SaleReturnDtoFromJson(Map<String, dynamic> json) =>
    _SaleReturnDto(
      id: json['id'] as String,
      saleId: json['sale_id'] as String,
      returnNumber: (json['return_number'] as num?)?.toInt(),
      reason: json['reason'] as String,
      note: json['note'] as String?,
      refundMethod: json['refund_method'] as String,
      refundAmount: json['refund_amount'] as String,
      createdAt: json['created_at'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => SaleReturnItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SaleReturnDtoToJson(_SaleReturnDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sale_id': instance.saleId,
      'return_number': instance.returnNumber,
      'reason': instance.reason,
      'note': instance.note,
      'refund_method': instance.refundMethod,
      'refund_amount': instance.refundAmount,
      'created_at': instance.createdAt,
      'items': instance.items,
    };

_ReturnsSyncBatchRequestDto _$ReturnsSyncBatchRequestDtoFromJson(
  Map<String, dynamic> json,
) => _ReturnsSyncBatchRequestDto(
  returns: (json['returns'] as List<dynamic>)
      .map((e) => SaleReturnCreateDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ReturnsSyncBatchRequestDtoToJson(
  _ReturnsSyncBatchRequestDto instance,
) => <String, dynamic>{'returns': instance.returns};

_ReturnSyncResultDto _$ReturnSyncResultDtoFromJson(Map<String, dynamic> json) =>
    _ReturnSyncResultDto(
      id: json['id'] as String,
      status: json['status'] as String,
      returnNumber: (json['return_number'] as num?)?.toInt(),
      errorCode: json['error_code'] as String?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$ReturnSyncResultDtoToJson(
  _ReturnSyncResultDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'return_number': instance.returnNumber,
  'error_code': instance.errorCode,
  'error': instance.error,
};

_ReturnsSyncBatchResponseDto _$ReturnsSyncBatchResponseDtoFromJson(
  Map<String, dynamic> json,
) => _ReturnsSyncBatchResponseDto(
  processed: (json['processed'] as num).toInt(),
  results: (json['results'] as List<dynamic>)
      .map((e) => ReturnSyncResultDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ReturnsSyncBatchResponseDtoToJson(
  _ReturnsSyncBatchResponseDto instance,
) => <String, dynamic>{
  'processed': instance.processed,
  'results': instance.results,
};
