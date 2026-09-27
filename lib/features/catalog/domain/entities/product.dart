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

    /// Prix de vente normal facturé au client (FCFA).
    required Decimal sellingPrice,

    /// Prix d'achat (coût d'acquisition, FCFA) ; null = non renseigné.
    /// Donnée interne au commerçant, jamais montrée au client (ADR-0009).
    Decimal? purchasePrice,
    String? barcode,
    int? currentStock,

    /// Seuil de réapprovisionnement (null = pas d'alerte configurée).
    int? minStock,

    /// Catégorie (null = sans catégorie).
    String? categoryId,

    /// Version (SHA-256) de l'image serveur ; null = pas d'image.
    String? imageVersion,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _Product;

  const Product._();

  /// Marge unitaire (prix de vente − prix d'achat), négative en cas de vente
  /// à perte ; `null` si le prix d'achat n'est pas renseigné.
  Decimal? get unitMargin {
    final cost = purchasePrice;
    return cost == null ? null : sellingPrice - cost;
  }

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
