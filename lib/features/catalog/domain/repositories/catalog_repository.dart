import 'dart:io';
import 'dart:typed_data';

import '../entities/product.dart';
import '../entities/product_import_result.dart';
import '../entities/product_page.dart';

/// Abstract repository for catalog operations.
abstract class CatalogRepository {
  /// Get products, optionally filtered by search query and paginated by cursor.
  /// Returns a page with pagination metadata.
  Future<ProductPage> getProducts({
    String? query,
    String? cursor,
    int limit = 50,
  });

  /// Create a new product.
  Future<Product> createProduct({
    required String name,
    required String unitPrice,
    String? barcode,
    int? currentStock,
    int? minStock,
  });

  /// Update an existing product.
  Future<Product> updateProduct({
    required String id,
    String? name,
    String? unitPrice,
    String? barcode,
    int? currentStock,
    int? minStock,
  });

  /// Delete (soft delete) a product by ID.
  Future<void> deleteProduct(String id);

  /// Get a single product by ID.
  Future<Product?> getProduct(String id);

  /// Find a product by barcode. Returns null if not found.
  Future<Product?> getByBarcode(String barcode);

  /// Streams the count of products in rupture (stock = 0) or at/below their
  /// reorder threshold — re-emits on every local catalog change.
  Stream<int> watchLowStockCount();

  /// Import products in bulk from a CSV or Excel file (best-effort, row by row).
  Future<ProductImportResult> importProductsFromFile(File file);

  /// Download a blank import template (`csv` or `xlsx`).
  Future<Uint8List> downloadImportTemplate({required String format});
}
