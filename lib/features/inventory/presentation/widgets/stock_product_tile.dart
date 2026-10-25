import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/widgets/product_thumbnail.dart';
import '../../../catalog/presentation/widgets/stock_status_badge.dart';

/// Carte produit de l'onglet Stock (même style que les cartes de la caisse) :
/// nom et prix à gauche, badge de stock et accès à l'ajustement à droite.
class StockProductTile extends StatelessWidget {
  /// Crée la carte.
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
    // Le badge affiche « Rupture » pour un stock négatif : l'écart
    // d'inventaire reste lisible sous le prix.
    final price = stock != null && stock < 0
        ? '${formatFcfa(product.sellingPrice)} · Stock : $stock'
        : formatFcfa(product.sellingPrice);

    return Card.filled(
      margin: EdgeInsets.zero,
      color: cs.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm + AppSpacing.xs,
            AppSpacing.sm + AppSpacing.xs,
            AppSpacing.xs,
            AppSpacing.xs,
          ),
          child: Row(
            children: [
              ProductThumbnail(product: product),
              const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      price,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    // Stock suivi : la quantité dans le badge (« Stock : 24 »,
                    // « Faible : 3 », « Rupture ») ; sinon « Non suivi ».
                    child: StockStatusBadge(
                      product: product,
                      showQuantity: stock != null,
                    ),
                  ),
                  if (onAdjust != null)
                    IconButton(
                      tooltip: 'Ajuster le stock de ${product.name}',
                      // Saisie d'une entrée ou d'une sortie : distinct des
                      // filtres et du crayon « Modifier » de la fiche produit.
                      icon: Icon(Icons.edit_note, color: cs.primary),
                      onPressed: onAdjust,
                    )
                  else
                    const SizedBox(height: AppSpacing.sm),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
