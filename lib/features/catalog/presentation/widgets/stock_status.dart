import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';

/// Affichage du stock d'un produit : seule l'exception (rupture, stock bas)
/// est colorée — un stock normal reste neutre pour que les listes fassent
/// ressortir ce qui demande vraiment attention. Retourne `null` si le stock
/// n'est pas suivi.
({String label, Color color, bool emphasize})? stockStatus(
  ColorScheme cs,
  Product product,
) {
  final stock = product.currentStock;
  return switch (product.stockLevel) {
    null => null,
    StockLevel.outOfStock => (
      label: 'Rupture de stock',
      color: cs.error,
      emphasize: true,
    ),
    StockLevel.low => (
      label: 'Stock bas: $stock',
      color: cs.tertiary,
      emphasize: true,
    ),
    StockLevel.normal => (
      label: 'Stock: $stock',
      color: cs.onSurfaceVariant,
      emphasize: false,
    ),
  };
}
