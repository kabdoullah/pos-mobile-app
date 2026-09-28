import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/widgets/product_thumbnail.dart';
import '../../../catalog/presentation/widgets/stock_status_badge.dart';
import '../providers/sales_providers.dart';

/// Résultats de recherche de la caisse, affichés à la place du panier pendant
/// la saisie.
class ProductSearchResults extends ConsumerWidget {
  /// Crée la liste de résultats pour [query].
  const ProductSearchResults({
    required this.query,
    required this.onQuickAdd,
    required this.onOpen,
    this.onScan,
    super.key,
  });

  /// Texte recherché (nom ou code-barres).
  final String query;

  /// Ajoute une unité du produit.
  final ValueChanged<Product> onQuickAdd;

  /// Ouvre le choix de quantité du produit.
  final ValueChanged<Product> onOpen;

  /// Propose le scanner quand aucun produit ne correspond ; masqué si `null`.
  final VoidCallback? onScan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final results = ref.watch(saleProductSearchProvider(query));

    return results.when(
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (_, _) => const EmptyState(
        icon: Icons.error_outline,
        title: 'Recherche impossible',
        message: 'Réessayez dans un instant',
      ),
      data: (products) {
        if (products.isEmpty) {
          return EmptyState(
            icon: Icons.search_off,
            title: 'Aucun produit trouvé',
            message: 'Essayez un autre nom ou un autre code-barres.',
            actionLabel: onScan == null ? null : 'Scanner un code-barres',
            onAction: onScan,
          );
        }
        return ListView.separated(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: products.length,
          separatorBuilder: (_, _) => Divider(
            height: 1,
            indent: AppSpacing.md,
            endIndent: AppSpacing.md,
            color: cs.outlineVariant,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            final stock = product.currentStock;
            final outOfStock = stock != null && stock <= 0;
            return ListTile(
              enabled: !outOfStock,
              onTap: () => onOpen(product),
              leading: ProductThumbnail(product: product),
              title: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleMedium,
              ),
              subtitle: Row(
                children: [
                  Flexible(
                    child: Text(
                      formatFcfa(product.sellingPrice),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        color: outOfStock ? cs.onSurfaceVariant : cs.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  StockStatusBadge(product: product, showQuantity: true),
                ],
              ),
              trailing: IconButton.filledTonal(
                tooltip: 'Ajouter ${product.name}',
                icon: const Icon(Icons.add),
                onPressed: outOfStock ? null : () => onQuickAdd(product),
              ),
            );
          },
        );
      },
    );
  }
}
