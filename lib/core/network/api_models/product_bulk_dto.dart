import 'package:freezed_annotation/freezed_annotation.dart';

import 'product_dto.dart';

part 'product_bulk_dto.freezed.dart';
part 'product_bulk_dto.g.dart';

/// Outcome of a single row in a bulk product import.
enum ProductBulkItemStatusDto {
  /// The row was successfully created.
  @JsonValue('created')
  created,

  /// The row failed to import.
  @JsonValue('failed')
  failed,
}

/// Result of processing a single row of a bulk product import.
@freezed
sealed class ProductBulkItemResultDto with _$ProductBulkItemResultDto {
  /// Creates a [ProductBulkItemResultDto].
  const factory ProductBulkItemResultDto({
    required int index,
    required ProductBulkItemStatusDto status,
    ProductDto? product,
    String? error,
    String? field,
  }) = _ProductBulkItemResultDto;

  /// Creates a [ProductBulkItemResultDto] from JSON.
  factory ProductBulkItemResultDto.fromJson(Map<String, dynamic> json) =>
      _$ProductBulkItemResultDtoFromJson(json);
}

/// Summary response of a best-effort bulk product import.
@freezed
sealed class ProductBulkCreateResponseDto with _$ProductBulkCreateResponseDto {
  /// Creates a [ProductBulkCreateResponseDto].
  const factory ProductBulkCreateResponseDto({
    required int processed,
    @JsonKey(name: 'created_count') required int createdCount,
    @JsonKey(name: 'failed_count') required int failedCount,
    required List<ProductBulkItemResultDto> results,
  }) = _ProductBulkCreateResponseDto;

  /// Creates a [ProductBulkCreateResponseDto] from JSON.
  factory ProductBulkCreateResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProductBulkCreateResponseDtoFromJson(json);
}
