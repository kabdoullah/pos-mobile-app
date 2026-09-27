import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../catalog/domain/entities/product.dart';

/// Badge d'état du stock : Disponible, Stock faible, Rupture ou Non suivi.
class StockStatusBadge extends StatelessWidget {
  /// Crée le badge pour [product].
  const StockStatusBadge({required this.product, super.key});

  /// Produit dont on affiche l'état.
  final Product product;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final (label, background, foreground) = switch (product.stockLevel) {
      StockLevel.outOfStock => (
        'Rupture',
        cs.errorContainer,
        cs.onErrorContainer,
      ),
      StockLevel.low => (
        'Stock faible',
        cs.tertiaryContainer,
        cs.onTertiaryContainer,
      ),
      StockLevel.normal => (
        'Disponible',
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
          style: AppTypography.labelSmall.copyWith(color: foreground),
        ),
      ),
    );
  }
}
