import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/cart_item.dart';

/// Ligne du panier : nom, « quantité × prix », remise ; à droite le total de
/// ligne et le stepper (« − » à 1 = retirer). Un glissement vers la gauche
/// retire aussi la ligne. Jamais de prix d'achat : l'écran est visible du
/// client.
class CartItemTile extends StatelessWidget {
  /// Crée une ligne de panier.
  const CartItemTile({
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.onTap,
    required this.onDiscount,
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

  /// Ouvre la remise de la ligne.
  final VoidCallback onDiscount;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final stock = item.availableStock;
    final atStockLimit = stock != null && item.quantity >= stock;
    final muted = AppTypography.bodyMedium.copyWith(
      color: cs.onSurfaceVariant,
      fontFeatures: AppTypography.tabularFigures,
    );

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
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${item.quantity} × '
                                '${formatFcfa(item.unitPrice)}',
                          ),
                          if (atStockLimit)
                            TextSpan(
                              text: ' · stock max',
                              style: TextStyle(color: cs.tertiary),
                            ),
                        ],
                      ),
                      style: muted,
                    ),
                    TextButton.icon(
                      onPressed: onDiscount,
                      icon: const Icon(Icons.local_offer_outlined, size: 20),
                      label: Text(
                        item.discount == null
                            ? 'Remise'
                            : 'Remise −${formatFcfa(item.discountAmount)}',
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 40),
                        tapTargetSize: MaterialTapTargetSize.padded,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatFcfa(item.lineTotal),
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      fontFeatures: AppTypography.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: 6),
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
          ),
        ),
      ),
    );
  }
}
