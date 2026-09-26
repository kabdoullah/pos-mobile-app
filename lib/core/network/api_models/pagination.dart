import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination.freezed.dart';
part 'pagination.g.dart';

/// Réponse paginée générique par curseur.
@Freezed(genericArgumentFactories: true)
sealed class CursorPageDto<T> with _$CursorPageDto<T> {
  /// Crée un [CursorPageDto].
  const factory CursorPageDto({
    required List<T> items,
    @JsonKey(name: 'next_cursor') String? nextCursor,
    @JsonKey(name: 'has_more') required bool hasMore,
  }) = _CursorPageDto<T>;

  /// Crée un [CursorPageDto] depuis du JSON, en décodant chaque élément de type
  /// [T] avec [fromJsonT].
  factory CursorPageDto.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$CursorPageDtoFromJson(json, fromJsonT);
}
