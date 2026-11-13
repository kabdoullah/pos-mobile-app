import 'package:flutter/material.dart';

import '../../../../core/widgets/status_indicator.dart';
import '../../domain/entities/product.dart';

/// État du stock (point + mot, v2) : Disponible, Stock faible, Rupture ou
/// Non suivi.
///
/// Avec [showQuantity] (caisse), le badge porte la quantité — « Stock : 24 »,
/// « Faible : 3 », « Rupture » — et disparaît si le stock n'est pas suivi.
class StockStatusBadge extends StatelessWidget {
  /// Crée le badge pour [product].
  const StockStatusBadge({
    required this.product,
    this.showQuantity = false,
    super.key,
  });

  /// Produit dont on affiche l'état.
  final Product product;

  /// Affiche la quantité en stock plutôt qu'un libellé d'état.
  final bool showQuantity;

  @override
  Widget build(BuildContext context) {
    final stock = product.currentStock;
    // En caisse, un stock négatif (écart d'inventaire) se vend comme une
    // rupture : le badge ne doit pas afficher « Stock : -2 ».
    final level = showQuantity && stock != null && stock < 0
        ? StockLevel.outOfStock
        : product.stockLevel;
    if (showQuantity && level == null) return const SizedBox.shrink();

    final (label, tone) = switch (level) {
      StockLevel.outOfStock => ('Rupture', StatusTone.error),
      StockLevel.low => (
        showQuantity ? 'Faible : $stock' : 'Stock faible',
        StatusTone.warning,
      ),
      StockLevel.normal => (
        showQuantity ? 'Stock : $stock' : 'Disponible',
        StatusTone.success,
      ),
      null => ('Non suivi', StatusTone.neutral),
    };
    return StatusIndicator(label: label, tone: tone);
  }
}
