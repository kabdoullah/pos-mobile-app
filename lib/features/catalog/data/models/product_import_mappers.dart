import '../../../../core/network/api_models/product_bulk_dto.dart';
import '../../domain/entities/product_import_result.dart';

/// Convertit [ProductBulkItemStatusDto] → [ProductImportItemStatus].
extension ProductBulkItemStatusDtoToDomain on ProductBulkItemStatusDto {
  /// Convertit le statut du DTO de l'API en statut du domaine.
  ProductImportItemStatus toDomain() => switch (this) {
    ProductBulkItemStatusDto.created => ProductImportItemStatus.created,
    ProductBulkItemStatusDto.failed => ProductImportItemStatus.failed,
  };
}

/// Convertit ProductBulkItemResultDto (API) → ProductImportItemResult
/// (domaine).
extension ProductBulkItemResultDtoToDomain on ProductBulkItemResultDto {
  /// Convertit le DTO de l'API en entité du domaine.
  ProductImportItemResult toDomain() => ProductImportItemResult(
    index: index,
    status: status.toDomain(),
    error: error,
    field: field,
  );
}

/// Convertit ProductBulkCreateResponseDto (API) → ProductImportResult
/// (domaine).
extension ProductBulkCreateResponseDtoToDomain on ProductBulkCreateResponseDto {
  /// Convertit le DTO de l'API en entité du domaine.
  ProductImportResult toDomain() => ProductImportResult(
    processed: processed,
    createdCount: createdCount,
    failedCount: failedCount,
    items: results.map((r) => r.toDomain()).toList(),
  );
}
