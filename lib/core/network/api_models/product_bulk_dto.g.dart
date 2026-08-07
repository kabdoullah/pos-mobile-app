// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_bulk_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductBulkItemResultDto _$ProductBulkItemResultDtoFromJson(
  Map<String, dynamic> json,
) => _ProductBulkItemResultDto(
  index: (json['index'] as num).toInt(),
  status: $enumDecode(_$ProductBulkItemStatusDtoEnumMap, json['status']),
  product: json['product'] == null
      ? null
      : ProductDto.fromJson(json['product'] as Map<String, dynamic>),
  error: json['error'] as String?,
  field: json['field'] as String?,
);

Map<String, dynamic> _$ProductBulkItemResultDtoToJson(
  _ProductBulkItemResultDto instance,
) => <String, dynamic>{
  'index': instance.index,
  'status': _$ProductBulkItemStatusDtoEnumMap[instance.status]!,
  'product': instance.product,
  'error': instance.error,
  'field': instance.field,
};

const _$ProductBulkItemStatusDtoEnumMap = {
  ProductBulkItemStatusDto.created: 'created',
  ProductBulkItemStatusDto.failed: 'failed',
};

_ProductBulkCreateResponseDto _$ProductBulkCreateResponseDtoFromJson(
  Map<String, dynamic> json,
) => _ProductBulkCreateResponseDto(
  processed: (json['processed'] as num).toInt(),
  createdCount: (json['created_count'] as num).toInt(),
  failedCount: (json['failed_count'] as num).toInt(),
  results: (json['results'] as List<dynamic>)
      .map((e) => ProductBulkItemResultDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProductBulkCreateResponseDtoToJson(
  _ProductBulkCreateResponseDto instance,
) => <String, dynamic>{
  'processed': instance.processed,
  'created_count': instance.createdCount,
  'failed_count': instance.failedCount,
  'results': instance.results,
};
