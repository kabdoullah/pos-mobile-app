import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/widgets/product_thumbnail.dart';

/// Ligne produit de l'onglet Stock : nom et prix à gauche, quantité et état
/// alignés à droite (lecture en colonne), puis l'accès direct à l'ajustement.
class StockProductTile extends StatelessWidget {
  /// Crée la ligne.
  const StockProductTile({
    required this.product,
    required this.onTap,
    required this.onAdjust,
    super.key,
  });

  /// Produit affiché.
  final Product product;

  /// Ouvre le détail du produit.
  final VoidCallback onTap;

  /// Ouvre l'ajustement de stock ; `null` si le stock n'est pas suivi.
  final VoidCallback? onAdjust;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final onAdjust = this.onAdjust;

    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSpacing.buttonHeight),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            onAdjust == null ? AppSpacing.md : AppSpacing.xs,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              ProductThumbnail(product: product),
              const SizedBox(width: AppSpacing.md - AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      formatFcfa(product.sellingPrice),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _StockQuantity(product: product),
              if (onAdjust != null)
                IconButton.filledTonal(
                  tooltip: 'Ajuster le stock de ${product.name}',
                  // ± : ajouter ou retirer du stock (et non un filtre).
                  icon: const Icon(Icons.exposure, size: 20),
                  onPressed: onAdjust,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Quantité en stock (grand chiffre) et son état en dessous. Seuls les stocks
/// faibles et les ruptures sont colorés, pour ressortir dans la liste.
class _StockQuantity extends StatelessWidget {
  const _StockQuantity({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final stock = product.currentStock;
    final (label, color) = switch (product.stockLevel) {
      StockLevel.outOfStock => ('Rupture', cs.error),
      StockLevel.low => ('Faible', cs.tertiary),
      StockLevel.normal => ('En stock', cs.onSurfaceVariant),
      null => ('Non suivi', cs.onSurfaceVariant),
    };
    final quantityColor = product.stockLevel == StockLevel.normal
        ? cs.onSurface
        : color;

    return Semantics(
      label: stock == null ? label : '$label, $stock en stock',
      excludeSemantics: true,
      // Largeur minimale : les chiffres s'alignent en colonne d'une ligne à
      // l'autre.
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              stock == null ? '—' : '$stock',
              style: AppTypography.titleMedium.copyWith(color: quantityColor),
            ),
            if (product.stockLevel == StockLevel.outOfStock)
              // Rupture : pastille, plus marquée que « Faible » (couleurs
              // proches).
              DecoratedBox(
                decoration: BoxDecoration(
                  color: cs.errorContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    label,
                    style: AppTypography.labelSmall.copyWith(
                      color: cs.onErrorContainer,
                    ),
                  ),
                ),
              )
            else
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(color: color),
              ),
          ],
        ),
      ),
    );
  }
}
