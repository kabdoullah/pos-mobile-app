import 'package:freezed_annotation/freezed_annotation.dart';

import 'category_dto.dart';
import 'product_dto.dart';
import 'sale_dto.dart';

part 'sync_changes_dto.freezed.dart';
part 'sync_changes_dto.g.dart';

/// Réponse de GET /api/v1/sync/changes.
@freezed
sealed class SyncChangesDto with _$SyncChangesDto {
  /// Crée un [SyncChangesDto].
  const factory SyncChangesDto({
    // Absent sur un serveur antérieur à l'ADR-0008.
    @Default(<CategoryDto>[]) List<CategoryDto> categories,
    required List<ProductDto> products,
    required List<SaleDto> sales,
    @JsonKey(name: 'next_cursor') String? nextCursor,
    @JsonKey(name: 'has_more') required bool hasMore,
    @JsonKey(name: 'server_time') required String serverTime,
  }) = _SyncChangesDto;

  factory SyncChangesDto.fromJson(Map<String, dynamic> json) =>
      _$SyncChangesDtoFromJson(json);
}

/// Corps de requête de PUT /api/v1/sync/products (synchro par état).
@freezed
sealed class ProductSyncBatchDto with _$ProductSyncBatchDto {
  /// Crée un [ProductSyncBatchDto].
  const factory ProductSyncBatchDto({required List<ProductSyncItemDto> items}) =
      _ProductSyncBatchDto;

  factory ProductSyncBatchDto.fromJson(Map<String, dynamic> json) =>
      _$ProductSyncBatchDtoFromJson(json);
}

/// Produit unique d'un lot de synchro.
@freezed
sealed class ProductSyncItemDto with _$ProductSyncItemDto {
  /// Crée un [ProductSyncItemDto].
  const factory ProductSyncItemDto({
    required String id,
    required String name,
    String? barcode,
    @JsonKey(name: 'selling_price') required String sellingPrice,
    // Toujours envoyé (null = non renseigné) : l'état local fait foi.
    @JsonKey(name: 'purchase_price') String? purchasePrice,
    @JsonKey(name: 'current_stock') int? currentStock,
    @JsonKey(name: 'min_stock') int? minStock,
    // Toujours envoyé (null = sans catégorie) : l'état local fait foi.
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'client_updated_at') required String clientUpdatedAt,
    @Default(false) bool deleted,
  }) = _ProductSyncItemDto;

  factory ProductSyncItemDto.fromJson(Map<String, dynamic> json) =>
      _$ProductSyncItemDtoFromJson(json);
}

/// Réponse des endpoints de synchro.
@freezed
sealed class SyncResponseDto with _$SyncResponseDto {
  /// Crée un [SyncResponseDto].
  const factory SyncResponseDto({
    required String message,
    @JsonKey(name: 'synced_count') required int syncedCount,
  }) = _SyncResponseDto;

  factory SyncResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SyncResponseDtoFromJson(json);
}
