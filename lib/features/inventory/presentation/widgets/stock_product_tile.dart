import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/widgets/product_thumbnail.dart';
import '../../../catalog/presentation/widgets/stock_status_badge.dart';

/// Ligne produit de l'onglet Stock (même schéma que la caisse) : nom, puis
/// prix et badge de stock ; bouton « Ajuster » à droite.
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

    // Material propre : l'encre reste visible au-dessus du fond de la liste.
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm + 2,
            AppSpacing.xs,
            AppSpacing.sm + 2,
          ),
          child: Row(
            children: [
              ProductThumbnail(product: product, size: 44),
              const SizedBox(width: AppSpacing.sm),
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
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          price,
                          style: AppTypography.bodyMedium.copyWith(
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                            fontFeatures: AppTypography.tabularFigures,
                          ),
                        ),
                        // Stock suivi : la quantité dans le badge
                        // (« Stock : 24 », « Stock bas : 3 », « Rupture ») ;
                        // sinon « Non suivi ».
                        StockStatusBadge(
                          product: product,
                          showQuantity: stock != null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (onAdjust != null) ...[
                const SizedBox(width: AppSpacing.sm),
                // Libellé en toutes lettres : distinct du crayon « Modifier »
                // de la fiche produit.
                Semantics(
                  button: true,
                  label: 'Ajuster le stock de ${product.name}',
                  excludeSemantics: true,
                  child: OutlinedButton(
                    onPressed: onAdjust,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, AppSpacing.buttonHeightSm),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                    ),
                    child: const Text('Ajuster'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ] else
                const SizedBox(width: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}
