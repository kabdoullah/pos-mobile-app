import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/cart_item.dart';

/// Ligne d'article de l'écran Encaisser, modifiable en place.
///
/// Repliée : nom, « 2 × 1 000 FCFA », total de ligne. Toucher la déplie
/// ([isExpanded]) : stepper de quantité (chiffre = saisie détaillée), remise
/// sur la ligne et « Retirer ». Un glissement vers la gauche retire aussi la
/// ligne. Jamais de prix d'achat : l'écran est visible du client.
class CartItemTile extends StatelessWidget {
  /// Crée une ligne d'article.
  const CartItemTile({
    required this.item,
    required this.isExpanded,
    required this.onTap,
    required this.onQuantityChanged,
    required this.onEditQuantity,
    required this.onEditDiscount,
    required this.onRemove,
    super.key,
  });

  /// Article affiché.
  final CartItem item;

  /// Ligne dépliée (édition en place).
  final bool isExpanded;

  /// Déplie ou replie la ligne.
  final VoidCallback onTap;

  /// Nouvelle quantité demandée (0 retire la ligne).
  final ValueChanged<int> onQuantityChanged;

  /// Ouvre la saisie détaillée de la quantité.
  final VoidCallback onEditQuantity;

  /// Ouvre la remise sur la ligne.
  final VoidCallback onEditDiscount;

  /// Retire la ligne.
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final stock = item.availableStock;
    final atStockLimit = stock != null && item.quantity >= stock;
    final meta = AppTypography.bodySmall.copyWith(
      color: colors.textSecondary,
      fontFeatures: AppTypography.tabularFigures,
    );
    final value = AppTypography.bodyStrong.copyWith(
      fontFeatures: AppTypography.tabularFigures,
    );

    return Dismissible(
      key: ValueKey(item.productId),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: ColoredBox(
        color: colors.errorSubtle,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: Icon(Icons.delete_outline, color: colors.onErrorSubtle),
          ),
        ),
      ),
      child: Material(
        color: colors.surface,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + AppSpacing.xs,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
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
                                style: AppTypography.bodyStrong.copyWith(
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isExpanded
                                    ? '${formatFcfa(item.unitPrice)} l’unité'
                                    : '${item.quantity} × '
                                          '${formatFcfa(item.unitPrice)}',
                                style: meta,
                              ),
                              if (item.discount != null && !isExpanded)
                                Text(
                                  'Remise −${formatFcfa(item.discountAmount)}',
                                  style: meta,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(formatFcfa(item.lineTotal), style: value),
                      ],
                    ),
                    if (isExpanded) ...[
                      const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                      Row(
                        children: [
                          QuantityStepper(
                            quantity: item.quantity,
                            removeTooltip: 'Retirer ${item.productName}',
                            onDecrease: () =>
                                onQuantityChanged(item.quantity - 1),
                            onIncrease: atStockLimit
                                ? null
                                : () => onQuantityChanged(item.quantity + 1),
                            onValueTap: onEditQuantity,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: onRemove,
                            child: const Text('Retirer'),
                          ),
                        ],
                      ),
                      if (atStockLimit)
                        const Padding(
                          padding: EdgeInsets.only(top: AppSpacing.xs),
                          child: StatusIndicator(
                            label: 'Stock maximum atteint',
                            tone: StatusTone.warning,
                          ),
                        ),
                      _LineDiscount(item: item, onTap: onEditDiscount),
                    ],
                  ],
                ),
              ),
              // Ligne en cours d'édition : trait gauche couleur action.
              if (isExpanded)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: SizedBox(
                    width: 3,
                    child: ColoredBox(color: colors.action),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// « Remise sur la ligne » : montant en cours, ou invitation à en ajouter.
class _LineDiscount extends StatelessWidget {
  const _LineDiscount({required this.item, required this.onTap});

  final CartItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final discount = item.discount;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSpacing.minTapTarget),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Remise sur la ligne',
                style: AppTypography.bodyStrong.copyWith(fontSize: 15),
              ),
            ),
            Text(
              discount == null
                  ? 'Ajouter'
                  : '−${formatFcfa(item.discountAmount)}',
              style: AppTypography.labelLarge.copyWith(
                color: colors.action,
                fontFeatures: AppTypography.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
