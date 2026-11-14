import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/widgets/stock_status_badge.dart';

/// Ligne produit de l'onglet Stock (liste à plat) : nom, prix de vente et
/// d'achat, état ; quantité à droite et action rapide « Ajuster ».
///
/// Le prix d'achat s'affiche ici (écran de gestion), jamais en caisse
/// (ADR-0009).
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
    final colors = AppColors.of(context);
    final stock = product.currentStock;
    final onAdjust = this.onAdjust;
    final purchase = product.purchasePrice;
    final meta = AppTypography.bodySmall.copyWith(
      color: colors.textSecondary,
      fontFeatures: AppTypography.tabularFigures,
    );
    final prices = purchase == null
        ? 'Vente ${formatFcfa(product.sellingPrice)}'
        : 'Vente ${formatAmount(product.sellingPrice)} · achat '
              '${formatFcfa(purchase)}';

    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 64),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyStrong.copyWith(height: 1.3),
                    ),
                    Text(prices, style: meta),
                    StockStatusBadge(product: product),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    stock == null ? '—' : '$stock',
                    style: AppTypography.bodyStrong.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFeatures: AppTypography.tabularFigures,
                      color: stock != null && stock < 0 ? colors.error : null,
                    ),
                  ),
                  if (stock != null) Text('en stock', style: meta),
                ],
              ),
              if (onAdjust != null)
                Semantics(
                  label: 'Ajuster le stock de ${product.name}',
                  button: true,
                  excludeSemantics: true,
                  child: TextButton(
                    onPressed: onAdjust,
                    child: const Text('Ajuster'),
                  ),
                )
              else
                const SizedBox(width: 84),
            ],
          ),
        ),
      ),
    );
  }
}
