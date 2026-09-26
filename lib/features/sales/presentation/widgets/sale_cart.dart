import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/entities/cart_item.dart';
import 'cart_item_tile.dart';

/// Panier de la caisse : liste des lignes, ou état vide.
class SaleCart extends StatelessWidget {
  /// Crée le panier.
  const SaleCart({
    required this.items,
    required this.onQuantityChanged,
    required this.onRemove,
    required this.onItemTap,
    required this.onClear,
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_basket_outlined,
                size: 40,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Votre panier est vide',
                style: AppTypography.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Scannez un produit ou recherchez-le',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.md),
          child: Row(
            children: [
              Text(
                'Panier',
                style: AppTypography.labelMedium.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onClear,
                icon: const Icon(Icons.delete_sweep_outlined, size: 18),
                label: const Text('Vider'),
                style: TextButton.styleFrom(foregroundColor: cs.error),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
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
