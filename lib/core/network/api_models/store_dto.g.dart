// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoreDto _$StoreDtoFromJson(Map<String, dynamic> json) => _StoreDto(
  id: json['id'] as String,
  ownerId: json['owner_id'] as String,
  name: json['name'] as String,
  address: json['address'] as String?,
  ncc: json['ncc'] as String?,
  vatSubject: json['vat_subject'] as bool,
  receiptFooterText: json['receipt_footer_text'] as String?,
  nextReceiptNumber: (json['next_receipt_number'] as num).toInt(),
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$StoreDtoToJson(_StoreDto instance) => <String, dynamic>{
  'id': instance.id,
  'owner_id': instance.ownerId,
  'name': instance.name,
  'address': instance.address,
  'ncc': instance.ncc,
  'vat_subject': instance.vatSubject,
  'receipt_footer_text': instance.receiptFooterText,
  'next_receipt_number': instance.nextReceiptNumber,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

_StoreCreateDto _$StoreCreateDtoFromJson(Map<String, dynamic> json) =>
    _StoreCreateDto(
      name: json['name'] as String,
      address: json['address'] as String?,
      ncc: json['ncc'] as String?,
      vatSubject: json['vat_subject'] as bool?,
      receiptFooterText: json['receipt_footer_text'] as String?,
    );

Map<String, dynamic> _$StoreCreateDtoToJson(_StoreCreateDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'ncc': instance.ncc,
      'vat_subject': instance.vatSubject,
      'receipt_footer_text': instance.receiptFooterText,
    };

_StoreUpdateDto _$StoreUpdateDtoFromJson(Map<String, dynamic> json) =>
    _StoreUpdateDto(
      name: json['name'] as String?,
      address: json['address'] as String?,
      ncc: json['ncc'] as String?,
      vatSubject: json['vat_subject'] as bool?,
      receiptFooterText: json['receipt_footer_text'] as String?,
    );

Map<String, dynamic> _$StoreUpdateDtoToJson(_StoreUpdateDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'ncc': instance.ncc,
      'vat_subject': instance.vatSubject,
      'receipt_footer_text': instance.receiptFooterText,
    };
