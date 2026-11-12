import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/widgets/product_thumbnail.dart';
import '../../../catalog/presentation/widgets/stock_status_badge.dart';

/// Ligne produit de la caisse (catalogue et résultats de recherche).
///
/// Toucher la ligne entière ajoute 1 article ; un appui long ouvre le choix
/// de quantité. Une fois au panier, la ligne prend le fond primaryContainer
/// et le « + » devient un stepper (« − » à 1 = retirer). Le stock n'apparaît
/// que s'il est bas ou en rupture. Jamais de prix d'achat (ADR-0009).
///
/// Ne connaît pas les règles de stock : les contrôles (stock restant,
/// message « Stock insuffisant ») restent dans la page, via [onAdd].
class SaleProductRow extends StatelessWidget {
  /// Crée une ligne produit.
  const SaleProductRow({
    required this.product,
    required this.quantityInCart,
    required this.onAdd,
    required this.onDecrease,
    required this.onOpen,
    super.key,
  });

  /// Produit affiché.
  final Product product;

  /// Quantité déjà au panier (0 = absent).
  final int quantityInCart;

  /// Ajoute une unité (ligne, « + », stepper).
  final ValueChanged<Product> onAdd;

  /// Retire une unité (« − » du stepper ; à 1, retire la ligne).
  final ValueChanged<Product> onDecrease;

  /// Ouvre le choix de quantité (appui long).
  final ValueChanged<Product> onOpen;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final stock = product.currentStock;
    final outOfStock = stock != null && stock <= 0;
    final inCart = quantityInCart > 0;
    final atStockLimit = stock != null && quantityInCart >= stock;
    final foreground = inCart ? cs.onPrimaryContainer : cs.onSurface;
    final priceColor = outOfStock
        ? cs.onSurfaceVariant
        : inCart
        ? cs.onPrimaryContainer
        : cs.primary;

    void add() {
      unawaited(HapticFeedback.selectionClick());
      onAdd(product);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      color: inCart ? cs.primaryContainer : cs.surface,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: outOfStock ? null : add,
          onLongPress: outOfStock ? null : () => onOpen(product),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 76),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                10,
                AppSpacing.md,
                10,
              ),
              child: Row(
                children: [
                  Opacity(
                    opacity: outOfStock ? 0.5 : 1,
                    child: ProductThumbnail(product: product),
                  ),
                  const SizedBox(width: AppSpacing.sm + 4),
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
                            color: outOfStock
                                ? cs.onSurfaceVariant
                                : foreground,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          formatFcfa(product.sellingPrice),
                          maxLines: 1,
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            fontFeatures: AppTypography.tabularFigures,
                            color: priceColor,
                          ),
                        ),
                        _StockAlert(product: product),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  if (inCart)
                    QuantityStepper(
                      quantity: quantityInCart,
                      removeTooltip: 'Retirer ${product.name}',
                      onDecrease: () => onDecrease(product),
                      onIncrease: atStockLimit ? null : add,
                    )
                  else
                    IconButton(
                      tooltip: 'Ajouter ${product.name}',
                      onPressed: outOfStock ? null : add,
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: cs.primaryContainer,
                        foregroundColor: cs.onPrimaryContainer,
                        disabledBackgroundColor: cs.surfaceContainerHigh,
                        fixedSize: const Size.square(AppSpacing.iconButtonSize),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Badge « Stock bas : N » ou « Rupture », seulement quand il y a lieu.
class _StockAlert extends StatelessWidget {
  const _StockAlert({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final badge = StockStatusBadge(
      product: product,
      showQuantity: true,
      alertsOnly: true,
    );
    final stock = product.currentStock;
    final level = product.stockLevel;
    final shows =
        (stock != null && stock < 0) ||
        level == StockLevel.low ||
        level == StockLevel.outOfStock;
    if (!shows) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.only(top: 6), child: badge);
  }
}
