import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination.freezed.dart';
part 'pagination.g.dart';

/// Generic cursor-based pagination response.
@Freezed(genericArgumentFactories: true)
sealed class CursorPageDto<T> with _$CursorPageDto<T> {
  /// Creates a [CursorPageDto].
  const factory CursorPageDto({
    required List<T> items,
    @JsonKey(name: 'next_cursor') String? nextCursor,
    @JsonKey(name: 'has_more') required bool hasMore,
  }) = _CursorPageDto<T>;

  /// Creates a [CursorPageDto] from JSON, using [fromJsonT] to decode each
  /// item of type [T].
  factory CursorPageDto.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$CursorPageDtoFromJson(json, fromJsonT);
}
