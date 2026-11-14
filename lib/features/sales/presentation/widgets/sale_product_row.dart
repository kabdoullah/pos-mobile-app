import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/widgets/product_thumbnail.dart';

/// Côté de la vignette d'une ligne produit.
const double saleProductThumbSize = 40;

/// Ligne produit de l'écran Vendre (catalogue et résultats de recherche).
///
/// Toute la ligne ajoute une unité. Au panier : trait gauche 3 dp couleur
/// action et stepper à droite (toucher le chiffre ouvre la saisie détaillée).
/// Le stock n'est mentionné que s'il est bas ou épuisé. Le prix d'achat n'est
/// jamais affiché en caisse (ADR-0009).
class SaleProductRow extends StatelessWidget {
  /// Crée une ligne produit.
  const SaleProductRow({
    required this.product,
    required this.inCart,
    required this.onAdd,
    required this.onDecrease,
    required this.onEditQuantity,
    super.key,
  });

  /// Produit affiché.
  final Product product;

  /// Quantité déjà au panier.
  final int inCart;

  /// Ajoute une unité (toute la ligne, ou « + »).
  final VoidCallback onAdd;

  /// Retire une unité (à 1 : retire la ligne).
  final VoidCallback onDecrease;

  /// Ouvre la saisie détaillée de la quantité (appui long, chiffre).
  final VoidCallback onEditQuantity;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final stock = product.currentStock;
    final outOfStock = stock != null && stock <= 0 && inCart == 0;
    final atLimit = stock != null && inCart >= stock;

    return Material(
      color: colors.surface,
      child: InkWell(
        onTap: outOfStock ? null : onAdd,
        onLongPress: outOfStock ? null : onEditQuantity,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Row(
                  children: [
                    Opacity(
                      opacity: outOfStock ? 0.5 : 1,
                      child: ProductThumbnail(
                        product: product,
                        size: saleProductThumbSize,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodyStrong.copyWith(
                              height: 1.3,
                              color: outOfStock
                                  ? colors.textSecondary
                                  : colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          _Meta(product: product),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    if (inCart > 0)
                      QuantityStepper(
                        quantity: inCart,
                        removeTooltip: 'Retirer ${product.name}',
                        onDecrease: onDecrease,
                        onIncrease: atLimit ? null : onAdd,
                        onValueTap: onEditQuantity,
                      )
                    else
                      _AddButton(
                        tooltip: 'Ajouter ${product.name}',
                        onPressed: outOfStock ? null : onAdd,
                      ),
                  ],
                ),
              ),
            ),
            // Trait « au panier », apparu en 120 ms.
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                width: inCart > 0 ? 3 : 0,
                color: colors.action,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Prix, puis « Stock bas · N » ou « Rupture » seulement quand c'est utile.
class _Meta extends StatelessWidget {
  const _Meta({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final status = switch (product.stockLevel) {
      StockLevel.outOfStock => ('Rupture', colors.error),
      StockLevel.low => ('Stock bas · ${product.currentStock}', colors.warning),
      _ => null,
    };
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: formatFcfa(product.sellingPrice)),
          if (status != null) ...[
            const TextSpan(text: ' · '),
            TextSpan(
              text: status.$1,
              style: TextStyle(color: status.$2),
            ),
          ],
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTypography.bodySmall.copyWith(
        color: colors.textSecondary,
        fontFeatures: AppTypography.tabularFigures,
      ),
    );
  }
}

/// Bouton « + » carré 48 dp, bordé.
class _AddButton extends StatelessWidget {
  const _AddButton({required this.tooltip, required this.onPressed});

  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: const Icon(Icons.add, size: 20),
      style: IconButton.styleFrom(
        foregroundColor: colors.textPrimary,
        disabledForegroundColor: colors.textDisabled,
        backgroundColor: colors.surface,
        fixedSize: const Size.square(AppSpacing.iconButtonSize),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          side: BorderSide(color: colors.border),
        ),
      ),
    );
  }
}
