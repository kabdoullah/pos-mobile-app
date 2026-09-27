// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) => _CategoryDto(
  id: json['id'] as String,
  storeId: json['store_id'] as String,
  name: json['name'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  deletedAt: json['deleted_at'] as String?,
);

Map<String, dynamic> _$CategoryDtoToJson(_CategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'store_id': instance.storeId,
      'name': instance.name,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
    };

_CategorySyncItemDto _$CategorySyncItemDtoFromJson(Map<String, dynamic> json) =>
    _CategorySyncItemDto(
      id: json['id'] as String,
      name: json['name'] as String,
      clientUpdatedAt: json['client_updated_at'] as String,
      deleted: json['deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$CategorySyncItemDtoToJson(
  _CategorySyncItemDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'client_updated_at': instance.clientUpdatedAt,
  'deleted': instance.deleted,
};

_CategorySyncResponseDto _$CategorySyncResponseDtoFromJson(
  Map<String, dynamic> json,
) => _CategorySyncResponseDto(
  status: json['status'] as String,
  serverState: json['server_state'] == null
      ? null
      : CategoryDto.fromJson(json['server_state'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CategorySyncResponseDtoToJson(
  _CategorySyncResponseDto instance,
) => <String, dynamic>{
  'status': instance.status,
  'server_state': instance.serverState,
};
