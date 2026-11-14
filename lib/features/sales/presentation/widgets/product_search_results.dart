import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../providers/cart_provider.dart';
import '../providers/sales_providers.dart';
import 'sale_product_row.dart';

/// Résultats de recherche de l'écran Vendre, affichés à la place du catalogue
/// pendant la saisie. Mêmes lignes que le catalogue.
class ProductSearchResults extends ConsumerWidget {
  /// Crée la liste de résultats pour [query].
  const ProductSearchResults({
    required this.query,
    required this.onAdd,
    required this.onDecrease,
    required this.onEditQuantity,
    this.onScan,
    super.key,
  });

  /// Texte recherché (nom ou code-barres).
  final String query;

  /// Ajoute une unité du produit.
  final ValueChanged<Product> onAdd;

  /// Retire une unité du produit.
  final ValueChanged<Product> onDecrease;

  /// Ouvre la saisie détaillée de la quantité.
  final ValueChanged<Product> onEditQuantity;

  /// Propose le scanner quand aucun produit ne correspond ; masqué si `null`.
  final VoidCallback? onScan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final results = ref.watch(saleProductSearchProvider(query));
    final inCart = {
      for (final item in ref.watch(cartProvider).items)
        item.productId: item.quantity,
    };

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
        final divider = BorderSide(color: colors.border);
        return ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(border: Border(bottom: divider)),
              child: SaleProductRow(
                key: ValueKey(product.id),
                product: product,
                inCart: inCart[product.id] ?? 0,
                onAdd: () => onAdd(product),
                onDecrease: () => onDecrease(product),
                onEditQuantity: () => onEditQuantity(product),
              ),
            );
          },
        );
      },
    );
  }
}
