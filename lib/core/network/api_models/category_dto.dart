import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_dto.freezed.dart';
part 'category_dto.g.dart';

/// Catégorie telle que renvoyée par l'API (ADR-0008).
@freezed
sealed class CategoryDto with _$CategoryDto {
  /// Crée un [CategoryDto].
  const factory CategoryDto({
    required String id,
    @JsonKey(name: 'store_id') required String storeId,
    required String name,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
  }) = _CategoryDto;

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);
}

/// État complet d'une catégorie envoyé à PUT /api/v1/sync/categories.
@freezed
sealed class CategorySyncItemDto with _$CategorySyncItemDto {
  /// Crée un [CategorySyncItemDto].
  const factory CategorySyncItemDto({
    required String id,
    required String name,
    @JsonKey(name: 'client_updated_at') required String clientUpdatedAt,
    @Default(false) bool deleted,
  }) = _CategorySyncItemDto;

  factory CategorySyncItemDto.fromJson(Map<String, dynamic> json) =>
      _$CategorySyncItemDtoFromJson(json);
}

/// Réponse de PUT /api/v1/sync/categories.
@freezed
sealed class CategorySyncResponseDto with _$CategorySyncResponseDto {
  /// Crée un [CategorySyncResponseDto].
  const factory CategorySyncResponseDto({
    required String
    status, // 'created', 'updated', 'no_change', 'deleted', 'conflict'
    @JsonKey(name: 'server_state') CategoryDto? serverState,
  }) = _CategorySyncResponseDto;

  factory CategorySyncResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CategorySyncResponseDtoFromJson(json);
}
