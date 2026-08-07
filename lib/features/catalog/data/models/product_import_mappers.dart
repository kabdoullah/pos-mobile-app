import '../../../../core/network/api_models/product_bulk_dto.dart';
import '../../domain/entities/product_import_result.dart';

/// Maps [ProductBulkItemStatusDto] → [ProductImportItemStatus].
extension ProductBulkItemStatusDtoToDomain on ProductBulkItemStatusDto {
  /// Converts API DTO status to domain status.
  ProductImportItemStatus toDomain() => switch (this) {
    ProductBulkItemStatusDto.created => ProductImportItemStatus.created,
    ProductBulkItemStatusDto.failed => ProductImportItemStatus.failed,
  };
}

/// Maps ProductBulkItemResultDto (API) → ProductImportItemResult (domain).
extension ProductBulkItemResultDtoToDomain on ProductBulkItemResultDto {
  /// Converts API DTO to domain entity.
  ProductImportItemResult toDomain() => ProductImportItemResult(
    index: index,
    status: status.toDomain(),
    error: error,
    field: field,
  );
}

/// Maps ProductBulkCreateResponseDto (API) → ProductImportResult (domain).
extension ProductBulkCreateResponseDtoToDomain on ProductBulkCreateResponseDto {
  /// Converts API DTO to domain entity.
  ProductImportResult toDomain() => ProductImportResult(
    processed: processed,
    createdCount: createdCount,
    failedCount: failedCount,
    items: results.map((r) => r.toDomain()).toList(),
  );
}
