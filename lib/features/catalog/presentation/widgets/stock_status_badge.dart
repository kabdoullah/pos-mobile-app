import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/entities/product.dart';

/// Badge d'état du stock : Disponible, Stock faible, Rupture ou Non suivi.
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
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final stock = product.currentStock;
    // En caisse, un stock négatif (écart d'inventaire) se vend comme une
    // rupture : le badge ne doit pas afficher « Stock : -2 ».
    final level = showQuantity && stock != null && stock < 0
        ? StockLevel.outOfStock
        : product.stockLevel;
    if (showQuantity && level == null) return const SizedBox.shrink();

    final (label, background, foreground) = switch (level) {
      StockLevel.outOfStock => (
        'Rupture',
        cs.errorContainer,
        cs.onErrorContainer,
      ),
      StockLevel.low => (
        showQuantity ? 'Faible : $stock' : 'Stock faible',
        cs.tertiaryContainer,
        cs.onTertiaryContainer,
      ),
      StockLevel.normal => (
        showQuantity ? 'Stock : $stock' : 'Disponible',
        semantic.successContainer,
        semantic.success,
      ),
      null => ('Non suivi', cs.surfaceContainerHighest, cs.onSurfaceVariant),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 2,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.labelSmall.copyWith(color: foreground),
        ),
      ),
    );
  }
}
