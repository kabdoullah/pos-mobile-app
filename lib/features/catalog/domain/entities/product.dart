import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

/// Product entity — immutable product model.
@freezed
sealed class Product with _$Product {
  /// Creates a [Product].
  const factory Product({
    required String id,
    required String name,

    /// FCFA as Decimal.
    required Decimal unitPrice,
    String? barcode,
    int? currentStock,

    /// Seuil de réapprovisionnement (null = pas d'alerte configurée).
    int? minStock,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _Product;
}
