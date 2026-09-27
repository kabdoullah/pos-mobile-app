import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import 'stock_status_badge.dart';

/// Ligne produit de l'onglet Stock : nom, prix, quantité, badge d'état et
/// accès direct à l'ajustement.
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
    final stock = product.currentStock;
    final onAdjust = this.onAdjust;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.xs,
          AppSpacing.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    stock == null
                        ? formatFcfa(product.unitPrice)
                        : '${formatFcfa(product.unitPrice)} · Stock : $stock',
                    style: AppTypography.bodySmall.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  StockStatusBadge(product: product),
                ],
              ),
            ),
            if (onAdjust != null)
              IconButton(
                tooltip: 'Ajuster le stock de ${product.name}',
                icon: const Icon(Icons.tune),
                onPressed: onAdjust,
              ),
          ],
        ),
      ),
    );
  }
}
