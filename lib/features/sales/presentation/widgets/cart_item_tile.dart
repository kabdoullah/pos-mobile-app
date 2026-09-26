import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/cart_item.dart';
import 'quantity_stepper.dart';

/// Ligne compacte du panier : nom et total de ligne, prix unitaire et
/// quantité. Glisser vers la gauche supprime la ligne.
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

  /// Supprime la ligne (glissement).
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
              AppSpacing.sm,
              AppSpacing.sm,
              AppSpacing.sm,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.productName,
                        style: AppTypography.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: AmountDisplay(amount: item.lineTotal),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        atStockLimit
                            ? '${formatFcfa(item.unitPrice)} · stock max'
                            : formatFcfa(item.unitPrice),
                        style: AppTypography.bodySmall.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                    QuantityStepper(
                      quantity: item.quantity,
                      onDecrease: () => onQuantityChanged(item.quantity - 1),
                      onIncrease: atStockLimit
                          ? null
                          : () => onQuantityChanged(item.quantity + 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
