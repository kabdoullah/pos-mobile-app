import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/cart_item.dart';
import '../../../catalog/presentation/widgets/product_thumbnail.dart';

/// Ligne du panier : nom et total de ligne, puis prix unitaire et quantité,
/// réduction éventuelle. À 1, « − » devient une corbeille ; un glissement vers
/// la gauche retire aussi la ligne.
/// Jamais de prix d'achat : l'écran est visible du client.
class CartItemTile extends StatelessWidget {
  /// Crée une ligne de panier.
  const CartItemTile({
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.onTap,
    super.key,
  });

  /// Article affiché.
  final CartItem item;

  /// Nouvelle quantité demandée (0 retire la ligne).
  final ValueChanged<int> onQuantityChanged;

  /// Supprime la ligne (corbeille à 1 ou glissement).
  final VoidCallback onRemove;

  /// Ouvre le choix de quantité détaillé.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final stock = item.availableStock;
    final atStockLimit = stock != null && item.quantity >= stock;

    return Dismissible(
      key: ValueKey(item.productId),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: ColoredBox(
        color: cs.errorContainer,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: Icon(Icons.delete_outline, color: cs.onErrorContainer),
          ),
        ),
      ),
      // Apparition rapide des nouvelles lignes.
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        builder: (context, t, child) => Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 8),
            child: child,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm + AppSpacing.xs,
              AppSpacing.sm,
              AppSpacing.sm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductThumbnailById(productId: item.productId),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _details(cs, atStockLimit)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _details(ColorScheme cs, bool atStockLimit) {
    final muted = AppTypography.bodySmall.copyWith(
      color: cs.onSurfaceVariant,
      fontFeatures: AppTypography.tabularFigures,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                item.productName,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // Sans « FCFA », comme sur le ticket : le total en bas le porte.
            Text(
              formatAmount(item.lineTotal),
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.3,
                fontFeatures: AppTypography.tabularFigures,
              ),
            ),
          ],
        ),
        if (item.discount != null)
          Text(
            'Réduction −${formatAmount(item.discountAmount)} '
            'sur ${formatAmount(item.grossTotal)}',
            style: muted.copyWith(color: cs.primary),
          ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: "${formatAmount(item.unitPrice)} l'unité"),
                    if (atStockLimit)
                      TextSpan(
                        text: ' · stock max',
                        style: TextStyle(color: cs.tertiary),
                      ),
                  ],
                ),
                style: muted,
              ),
            ),
            QuantityStepper(
              quantity: item.quantity,
              removeTooltip: 'Retirer ${item.productName}',
              onDecrease: () => onQuantityChanged(item.quantity - 1),
              onIncrease: atStockLimit
                  ? null
                  : () => onQuantityChanged(item.quantity + 1),
            ),
          ],
        ),
      ],
    );
  }
}
