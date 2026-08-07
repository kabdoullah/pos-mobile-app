// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_responses_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SalesSyncBatchRequestDto _$SalesSyncBatchRequestDtoFromJson(
  Map<String, dynamic> json,
) => _SalesSyncBatchRequestDto(
  sales: (json['sales'] as List<dynamic>)
      .map((e) => SaleCreateDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SalesSyncBatchRequestDtoToJson(
  _SalesSyncBatchRequestDto instance,
) => <String, dynamic>{'sales': instance.sales};

_SaleSyncResultDto _$SaleSyncResultDtoFromJson(Map<String, dynamic> json) =>
    _SaleSyncResultDto(
      id: json['id'] as String,
      status: json['status'] as String,
      receiptNumber: (json['receipt_number'] as num?)?.toInt(),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$SaleSyncResultDtoToJson(_SaleSyncResultDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'receipt_number': instance.receiptNumber,
      'error': instance.error,
    };

_SalesSyncBatchResponseDto _$SalesSyncBatchResponseDtoFromJson(
  Map<String, dynamic> json,
) => _SalesSyncBatchResponseDto(
  processed: (json['processed'] as num).toInt(),
  results: (json['results'] as List<dynamic>)
      .map((e) => SaleSyncResultDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SalesSyncBatchResponseDtoToJson(
  _SalesSyncBatchResponseDto instance,
) => <String, dynamic>{
  'processed': instance.processed,
  'results': instance.results,
};

_ProductSyncResponseDto _$ProductSyncResponseDtoFromJson(
  Map<String, dynamic> json,
) => _ProductSyncResponseDto(
  status: json['status'] as String,
  serverState: json['server_state'] == null
      ? null
      : ProductDto.fromJson(json['server_state'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProductSyncResponseDtoToJson(
  _ProductSyncResponseDto instance,
) => <String, dynamic>{
  'status': instance.status,
  'server_state': instance.serverState,
};
