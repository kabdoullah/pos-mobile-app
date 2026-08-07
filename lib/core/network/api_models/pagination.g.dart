// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CursorPageDto<T> _$CursorPageDtoFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _CursorPageDto<T>(
  items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
  nextCursor: json['next_cursor'] as String?,
  hasMore: json['has_more'] as bool,
);

Map<String, dynamic> _$CursorPageDtoToJson<T>(
  _CursorPageDto<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'items': instance.items.map(toJsonT).toList(),
  'next_cursor': instance.nextCursor,
  'has_more': instance.hasMore,
};
