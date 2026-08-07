/// Outcome of a single row in a bulk product import.
enum ProductImportItemStatus {
  /// The row was successfully created.
  created,

  /// The row failed to import.
  failed,
}

/// Result of processing a single row of a bulk product import.
class ProductImportItemResult {
  /// Creates a ProductImportItemResult.
  const ProductImportItemResult({
    required this.index,
    required this.status,
    this.error,
    this.field,
  });

  /// Row index (0-based) in the imported file.
  final int index;

  /// Whether this row was created or failed.
  final ProductImportItemStatus status;

  /// Error message when [status] is failed.
  final String? error;

  /// Name of the field that caused the failure, if applicable.
  final String? field;
}

/// Summary result of a best-effort bulk product import.
class ProductImportResult {
  /// Creates a ProductImportResult.
  const ProductImportResult({
    required this.processed,
    required this.createdCount,
    required this.failedCount,
    required this.items,
  });

  /// Total number of rows processed.
  final int processed;

  /// Number of rows successfully created.
  final int createdCount;

  /// Number of rows that failed.
  final int failedCount;

  /// Per-row results.
  final List<ProductImportItemResult> items;
}
