import 'package:freezed_annotation/freezed_annotation.dart';

import 'product_dto.dart';
import 'sale_dto.dart';

part 'sync_responses_dto.freezed.dart';
part 'sync_responses_dto.g.dart';

/// Requête d'envoi d'un lot de ventes.
@freezed
sealed class SalesSyncBatchRequestDto with _$SalesSyncBatchRequestDto {
  /// Crée un [SalesSyncBatchRequestDto].
  const factory SalesSyncBatchRequestDto({required List<SaleCreateDto> sales}) =
      _SalesSyncBatchRequestDto;

  factory SalesSyncBatchRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SalesSyncBatchRequestDtoFromJson(json);
}

/// Résultat d'une vente dans le lot POST /api/v1/sync/sales.
@freezed
sealed class SaleSyncResultDto with _$SaleSyncResultDto {
  /// Crée un [SaleSyncResultDto].
  const factory SaleSyncResultDto({
    required String id,
    required String status, // 'created', 'already_exists', 'failed'
    @JsonKey(name: 'receipt_number') int? receiptNumber,
    String? error,
  }) = _SaleSyncResultDto;

  factory SaleSyncResultDto.fromJson(Map<String, dynamic> json) =>
      _$SaleSyncResultDtoFromJson(json);
}

/// Réponse de POST /api/v1/sync/sales.
@freezed
sealed class SalesSyncBatchResponseDto with _$SalesSyncBatchResponseDto {
  /// Crée un [SalesSyncBatchResponseDto].
  const factory SalesSyncBatchResponseDto({
    required int processed,
    required List<SaleSyncResultDto> results,
  }) = _SalesSyncBatchResponseDto;

  factory SalesSyncBatchResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SalesSyncBatchResponseDtoFromJson(json);
}

/// Réponse de PUT /api/v1/sync/products.
@freezed
sealed class ProductSyncResponseDto with _$ProductSyncResponseDto {
  /// Crée un [ProductSyncResponseDto].
  const factory ProductSyncResponseDto({
    required String
    status, // 'created', 'updated', 'no_change', 'deleted', 'conflict'
    @JsonKey(name: 'server_state') ProductDto? serverState,
  }) = _ProductSyncResponseDto;

  factory ProductSyncResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProductSyncResponseDtoFromJson(json);
}
