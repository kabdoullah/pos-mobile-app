// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_changes_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncChangesDto _$SyncChangesDtoFromJson(Map<String, dynamic> json) =>
    _SyncChangesDto(
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => CategoryDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CategoryDto>[],
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      sales: (json['sales'] as List<dynamic>)
          .map((e) => SaleDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
      hasMore: json['has_more'] as bool,
      serverTime: json['server_time'] as String,
    );

Map<String, dynamic> _$SyncChangesDtoToJson(_SyncChangesDto instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'products': instance.products,
      'sales': instance.sales,
      'next_cursor': instance.nextCursor,
      'has_more': instance.hasMore,
      'server_time': instance.serverTime,
    };

_ProductSyncBatchDto _$ProductSyncBatchDtoFromJson(Map<String, dynamic> json) =>
    _ProductSyncBatchDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => ProductSyncItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductSyncBatchDtoToJson(
  _ProductSyncBatchDto instance,
) => <String, dynamic>{'items': instance.items};

_ProductSyncItemDto _$ProductSyncItemDtoFromJson(Map<String, dynamic> json) =>
    _ProductSyncItemDto(
      id: json['id'] as String,
      name: json['name'] as String,
      barcode: json['barcode'] as String?,
      unitPrice: json['unit_price'] as String,
      currentStock: (json['current_stock'] as num?)?.toInt(),
      minStock: (json['min_stock'] as num?)?.toInt(),
      categoryId: json['category_id'] as String?,
      clientUpdatedAt: json['client_updated_at'] as String,
      deleted: json['deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$ProductSyncItemDtoToJson(_ProductSyncItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'barcode': instance.barcode,
      'unit_price': instance.unitPrice,
      'current_stock': instance.currentStock,
      'min_stock': instance.minStock,
      'category_id': instance.categoryId,
      'client_updated_at': instance.clientUpdatedAt,
      'deleted': instance.deleted,
    };

_SyncResponseDto _$SyncResponseDtoFromJson(Map<String, dynamic> json) =>
    _SyncResponseDto(
      message: json['message'] as String,
      syncedCount: (json['synced_count'] as num).toInt(),
    );

Map<String, dynamic> _$SyncResponseDtoToJson(_SyncResponseDto instance) =>
    <String, dynamic>{
      'message': instance.message,
      'synced_count': instance.syncedCount,
    };
