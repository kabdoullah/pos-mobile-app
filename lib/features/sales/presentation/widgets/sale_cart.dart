import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/cart_item.dart';
import 'cart_item_tile.dart';

/// Section « Panier en cours » de la caisse, sous forme de slivers à insérer
/// sous le catalogue : en-tête avec « Vider », puis lignes du panier, ou
/// invitation à ajouter un produit.
class SaleCart extends StatelessWidget {
  /// Crée le panier.
  const SaleCart({
    required this.items,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.onItemTap,
    required this.onClear,
    this.headerKey,
    super.key,
  });

  /// Lignes du panier.
  final List<CartItem> items;

  /// Nouvelle quantité pour un produit (0 retire la ligne).
  final void Function(String productId, int quantity) onQuantityChanged;

  /// Retire un produit.
  final ValueChanged<String> onRemove;

  /// Ouvre le choix de quantité d'une ligne.
  final ValueChanged<CartItem> onItemTap;

  /// Vide le panier (après confirmation, gérée par la page).
  final VoidCallback onClear;

  /// Clé de l'en-tête, pour que la page puisse y faire défiler.
  final Key? headerKey;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final units = items.fold(0, (sum, item) => sum + item.quantity);

    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            0,
          ),
          sliver: SliverToBoxAdapter(
            child: SectionHeader(
              key: headerKey,
              title: 'Panier en cours',
              count: items.isEmpty ? null : units,
              actionLabel: items.isEmpty ? null : 'Vider',
              onAction: onClear,
            ),
          ),
        ),
        if (items.isEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            sliver: SliverToBoxAdapter(child: _EmptyCart(color: cs)),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            sliver: SliverList.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => Divider(
                height: 1,
                indent: AppSpacing.md,
                endIndent: AppSpacing.md,
                color: cs.outlineVariant,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return CartItemTile(
                  key: ValueKey(item.productId),
                  item: item,
                  onQuantityChanged: (qty) =>
                      onQuantityChanged(item.productId, qty),
                  onRemove: () => onRemove(item.productId),
                  onTap: () => onItemTap(item),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({required this.color});

  final ColorScheme color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(Icons.shopping_basket_outlined, color: color.onSurfaceVariant),
            const SizedBox(width: AppSpacing.md - AppSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Votre panier est vide',
                    style: AppTypography.titleMedium,
                  ),
                  Text(
                    'Appuyez sur « Ajouter » ou scannez un produit.',
                    style: AppTypography.bodySmall.copyWith(
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
