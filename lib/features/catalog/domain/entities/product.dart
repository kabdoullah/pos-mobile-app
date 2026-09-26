import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

/// Situation du stock d'un produit par rapport à son seuil de réapprovisionnement.
enum StockLevel {
  /// Stock exactement à zéro (rupture).
  outOfStock,

  /// Stock inférieur ou égal au seuil de réapprovisionnement configuré.
  low,

  /// Stock au-dessus du seuil, ou aucun seuil configuré.
  normal,
}

/// Entité produit — modèle de produit immuable.
@freezed
sealed class Product with _$Product {
  /// Crée un [Product].
  const factory Product({
    required String id,
    required String name,

    /// FCFA en Decimal.
    required Decimal unitPrice,
    String? barcode,
    int? currentStock,

    /// Seuil de réapprovisionnement (null = pas d'alerte configurée).
    int? minStock,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _Product;

  const Product._();

  /// Situation du stock par rapport à [minStock] ; `null` si le stock n'est
  /// pas suivi.
  ///
  /// Doit rester alignée sur la requête « stock bas » du repository catalogue.
  StockLevel? get stockLevel {
    final stock = currentStock;
    if (stock == null) return null;
    if (stock == 0) return StockLevel.outOfStock;
    final threshold = minStock;
    if (threshold != null && stock <= threshold) return StockLevel.low;
    return StockLevel.normal;
  }
}
