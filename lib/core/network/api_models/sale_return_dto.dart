import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_return_dto.freezed.dart';
part 'sale_return_dto.g.dart';

/// Ligne d'un retour envoyé au serveur (ADR-0010).
@freezed
sealed class SaleReturnItemCreateDto with _$SaleReturnItemCreateDto {
  /// Crée un [SaleReturnItemCreateDto].
  const factory SaleReturnItemCreateDto({
    required String id,
    @JsonKey(name: 'sale_item_id') required String saleItemId,
    required int quantity,
    required String condition,
    @JsonKey(name: 'refund_amount') required String refundAmount,
  }) = _SaleReturnItemCreateDto;

  factory SaleReturnItemCreateDto.fromJson(Map<String, dynamic> json) =>
      _$SaleReturnItemCreateDtoFromJson(json);
}

/// Retour envoyé au serveur par POST /api/v1/sync/returns.
@freezed
sealed class SaleReturnCreateDto with _$SaleReturnCreateDto {
  /// Crée un [SaleReturnCreateDto].
  const factory SaleReturnCreateDto({
    required String id,
    @JsonKey(name: 'sale_id') required String saleId,
    required String reason,
    String? note,
    @JsonKey(name: 'refund_method') required String refundMethod,
    @JsonKey(name: 'refund_amount') required String refundAmount,
    @JsonKey(name: 'created_at') required String createdAt,
    required List<SaleReturnItemCreateDto> items,
  }) = _SaleReturnCreateDto;

  factory SaleReturnCreateDto.fromJson(Map<String, dynamic> json) =>
      _$SaleReturnCreateDtoFromJson(json);
}

/// Ligne d'un retour reçue du serveur.
@freezed
sealed class SaleReturnItemDto with _$SaleReturnItemDto {
  /// Crée un [SaleReturnItemDto].
  const factory SaleReturnItemDto({
    required String id,
    @JsonKey(name: 'sale_return_id') required String saleReturnId,
    @JsonKey(name: 'sale_item_id') required String saleItemId,
    @JsonKey(name: 'product_id') String? productId,
    required int quantity,
    required String condition,
    required bool restocked,
    @JsonKey(name: 'refund_amount') required String refundAmount,
  }) = _SaleReturnItemDto;

  factory SaleReturnItemDto.fromJson(Map<String, dynamic> json) =>
      _$SaleReturnItemDtoFromJson(json);
}

/// Retour reçu du serveur (pull GET /api/v1/sync/changes).
@freezed
sealed class SaleReturnDto with _$SaleReturnDto {
  /// Crée un [SaleReturnDto].
  const factory SaleReturnDto({
    required String id,
    @JsonKey(name: 'sale_id') required String saleId,
    @JsonKey(name: 'return_number') int? returnNumber,
    required String reason,
    String? note,
    @JsonKey(name: 'refund_method') required String refundMethod,
    @JsonKey(name: 'refund_amount') required String refundAmount,
    @JsonKey(name: 'created_at') required String createdAt,
    required List<SaleReturnItemDto> items,
  }) = _SaleReturnDto;

  factory SaleReturnDto.fromJson(Map<String, dynamic> json) =>
      _$SaleReturnDtoFromJson(json);
}

/// Requête POST /api/v1/sync/returns.
@freezed
sealed class ReturnsSyncBatchRequestDto with _$ReturnsSyncBatchRequestDto {
  /// Crée un [ReturnsSyncBatchRequestDto].
  const factory ReturnsSyncBatchRequestDto({
    required List<SaleReturnCreateDto> returns,
  }) = _ReturnsSyncBatchRequestDto;

  factory ReturnsSyncBatchRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ReturnsSyncBatchRequestDtoFromJson(json);
}

/// Résultat d'un retour dans la réponse de POST /api/v1/sync/returns.
@freezed
sealed class ReturnSyncResultDto with _$ReturnSyncResultDto {
  /// Crée un [ReturnSyncResultDto].
  const factory ReturnSyncResultDto({
    required String id,
    // 'created', 'already_exists', 'rejected' (définitif), 'failed'.
    required String status,
    @JsonKey(name: 'return_number') int? returnNumber,
    @JsonKey(name: 'error_code') String? errorCode,
    String? error,
  }) = _ReturnSyncResultDto;

  factory ReturnSyncResultDto.fromJson(Map<String, dynamic> json) =>
      _$ReturnSyncResultDtoFromJson(json);
}

/// Réponse de POST /api/v1/sync/returns.
@freezed
sealed class ReturnsSyncBatchResponseDto with _$ReturnsSyncBatchResponseDto {
  /// Crée un [ReturnsSyncBatchResponseDto].
  const factory ReturnsSyncBatchResponseDto({
    required int processed,
    required List<ReturnSyncResultDto> results,
  }) = _ReturnsSyncBatchResponseDto;

  factory ReturnsSyncBatchResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ReturnsSyncBatchResponseDtoFromJson(json);
}
