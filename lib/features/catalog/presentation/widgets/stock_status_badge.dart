import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/entities/product.dart';

/// Badge d'état du stock : Disponible, Stock faible, Rupture ou Non suivi.
///
/// Avec [showQuantity], le badge porte la quantité — « Stock : 24 »,
/// « Stock bas : 3 », « Rupture » — et disparaît si le stock n'est pas suivi.
/// Avec [alertsOnly] (caisse), seuls « Stock bas » et « Rupture » restent :
/// un stock normal n'ajoute rien à la ligne.
class StockStatusBadge extends StatelessWidget {
  /// Crée le badge pour [product].
  const StockStatusBadge({
    required this.product,
    this.showQuantity = false,
    this.alertsOnly = false,
    super.key,
  });

  /// Produit dont on affiche l'état.
  final Product product;

  /// Affiche la quantité en stock plutôt qu'un libellé d'état.
  final bool showQuantity;

  /// N'affiche rien pour un stock normal (caisse : badge seulement si bas ou
  /// en rupture).
  final bool alertsOnly;

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
    if ((showQuantity || alertsOnly) && level == null) {
      return const SizedBox.shrink();
    }
    if (alertsOnly && level == StockLevel.normal) {
      return const SizedBox.shrink();
    }

    final (label, background, foreground) = switch (level) {
      StockLevel.outOfStock => (
        'Rupture',
        cs.errorContainer,
        cs.onErrorContainer,
      ),
      StockLevel.low => (
        showQuantity ? 'Stock bas : $stock' : 'Stock faible',
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
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 3,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.labelMedium.copyWith(color: foreground),
        ),
      ),
    );
  }
}
