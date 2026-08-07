// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) => _ProductDto(
  id: json['id'] as String,
  storeId: json['store_id'] as String,
  name: json['name'] as String,
  barcode: json['barcode'] as String?,
  unitPrice: json['unit_price'] as String,
  currentStock: (json['current_stock'] as num?)?.toInt(),
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  deletedAt: json['deleted_at'] as String?,
);

Map<String, dynamic> _$ProductDtoToJson(_ProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'store_id': instance.storeId,
      'name': instance.name,
      'barcode': instance.barcode,
      'unit_price': instance.unitPrice,
      'current_stock': instance.currentStock,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
    };

_ProductCreateDto _$ProductCreateDtoFromJson(Map<String, dynamic> json) =>
    _ProductCreateDto(
      name: json['name'] as String,
      barcode: json['barcode'] as String?,
      unitPrice: json['unit_price'] as String,
      currentStock: (json['current_stock'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductCreateDtoToJson(_ProductCreateDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'barcode': instance.barcode,
      'unit_price': instance.unitPrice,
      'current_stock': instance.currentStock,
    };

_ProductUpdateDto _$ProductUpdateDtoFromJson(Map<String, dynamic> json) =>
    _ProductUpdateDto(
      name: json['name'] as String?,
      barcode: json['barcode'] as String?,
      unitPrice: json['unit_price'] as String?,
      currentStock: (json['current_stock'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductUpdateDtoToJson(_ProductUpdateDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'barcode': instance.barcode,
      'unit_price': instance.unitPrice,
      'current_stock': instance.currentStock,
    };
