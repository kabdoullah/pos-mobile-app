import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart' as drift;

import '../../../../core/network/api_models/product_dto.dart';
import '../../../../database/app_database.dart' as drift_db;
import '../../domain/entities/product.dart' as domain;

/// Convertit ProductDto (API) → domain.Product (domaine).
extension ProductDtoToDomain on ProductDto {
  /// Convertit le DTO de l'API en entité du domaine.
  domain.Product toDomain() => domain.Product(
    id: id,
    name: name,
    unitPrice: Decimal.parse(unitPrice),
    barcode: barcode,
    currentStock: currentStock,
    minStock: minStock,
    updatedAt: DateTime.parse(updatedAt),
    deletedAt: deletedAt != null ? DateTime.parse(deletedAt!) : null,
  );
}

/// Convertit domain.Product → ProductsCompanion (drift).
extension DomainProductToDrift on domain.Product {
  /// Convertit l'entité du domaine en companion drift.
  drift_db.ProductsCompanion toDriftCompanion() => drift_db.ProductsCompanion(
    id: drift.Value(id),
    name: drift.Value(name),
    barcode: barcode != null
        ? drift.Value(barcode)
        : const drift.Value.absent(),
    unitPrice: drift.Value(unitPrice.toString()),
    currentStock: currentStock != null
        ? drift.Value(currentStock)
        : const drift.Value.absent(),
    minStock: minStock != null
        ? drift.Value(minStock)
        : const drift.Value.absent(),
    dirty: const drift.Value(false),
    updatedAt: drift.Value(updatedAt),
    deletedAt: deletedAt != null
        ? drift.Value(deletedAt)
        : const drift.Value.absent(),
  );
}

/// Convertit une ligne Product drift → domain.Product.
extension DriftProductToDomain on drift_db.Product {
  /// Convertit la ligne drift en entité du domaine.
  domain.Product toDomain() => domain.Product(
    id: id,
    name: name,
    unitPrice: Decimal.parse(unitPrice),
    barcode: barcode,
    currentStock: currentStock,
    minStock: minStock,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
  );
}

/// Convertit domain.Product → ProductCreateDto (requête API).
extension DomainProductCreateDtoMapper on domain.Product {
  /// Convertit l'entité du domaine en DTO de requête de création.
  ProductCreateDto toCreateDto() => ProductCreateDto(
    name: name,
    barcode: barcode,
    unitPrice: unitPrice.toString(),
    currentStock: currentStock,
    minStock: minStock,
  );
}

/// Convertit domain.Product → ProductUpdateDto (requête API).
extension DomainProductUpdateDtoMapper on domain.Product {
  /// Convertit l'entité du domaine en DTO de requête de mise à jour.
  ProductUpdateDto toUpdateDto() => ProductUpdateDto(
    name: name,
    barcode: barcode,
    unitPrice: unitPrice.toString(),
    currentStock: currentStock,
    minStock: minStock,
  );
}
