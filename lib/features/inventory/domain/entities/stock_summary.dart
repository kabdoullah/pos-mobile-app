import 'package:decimal/decimal.dart';

import '../../../catalog/domain/entities/product.dart';

/// Synthèse du stock de la boutique (en-tête de l'onglet Stock).
class StockSummary {
  /// Crée une synthèse.
  const StockSummary({
    required this.productCount,
    required this.stockValue,
    required this.lowStockCount,
    required this.outOfStockCount,
  });

  /// Calcule la synthèse à partir des produits non supprimés.
  ///
  /// La valeur du stock ne compte que les produits dont le stock est suivi
  /// (prix de vente × quantité). Stock faible et ruptures suivent la règle de
  /// [Product.stockLevel].
  factory StockSummary.fromProducts(List<Product> products) {
    var value = Decimal.zero;
    var low = 0;
    var out = 0;
    for (final product in products) {
      final stock = product.currentStock;
      if (stock != null && stock > 0) {
        value += product.unitPrice * Decimal.fromInt(stock);
      }
      switch (product.stockLevel) {
        case StockLevel.low:
          low++;
        case StockLevel.outOfStock:
          low++;
          out++;
        case StockLevel.normal || null:
          break;
      }
    }
    return StockSummary(
      productCount: products.length,
      stockValue: value,
      lowStockCount: low,
      outOfStockCount: out,
    );
  }

  /// Nombre de produits.
  final int productCount;

  /// Valeur du stock au prix de vente, en FCFA.
  final Decimal stockValue;

  /// Produits à réapprovisionner : en rupture ou sous leur seuil — même règle
  /// que l'alerte de l'accueil.
  final int lowStockCount;

  /// Produits en rupture (stock à zéro), inclus dans [lowStockCount].
  final int outOfStockCount;
}
