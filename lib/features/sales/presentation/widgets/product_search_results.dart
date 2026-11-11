import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../providers/sales_providers.dart';
import 'sale_product_row.dart';

/// Résultats de recherche de la caisse, affichés à la place du catalogue
/// pendant la saisie : mêmes lignes que le catalogue (toucher = +1).
class ProductSearchResults extends ConsumerWidget {
  /// Crée la liste de résultats pour [query].
  const ProductSearchResults({
    required this.query,
    required this.onAdd,
    required this.onDecrease,
    required this.onOpen,
    required this.onCreate,
    this.cartQuantities = const {},
    super.key,
  });

  /// Texte recherché (nom ou code-barres).
  final String query;

  /// Ajoute une unité du produit.
  final ValueChanged<Product> onAdd;

  /// Retire une unité du produit (stepper).
  final ValueChanged<Product> onDecrease;

  /// Ouvre le choix de quantité du produit (appui long).
  final ValueChanged<Product> onOpen;

  /// Crée un produit à partir du texte recherché, sans quitter la vente.
  final ValueChanged<String> onCreate;

  /// Quantité déjà au panier, par id de produit.
  final Map<String, int> cartQuantities;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final results = ref.watch(saleProductSearchProvider(query));

    return results.when(
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (_, _) => const EmptyState(
        icon: Icons.warning_amber_rounded,
        tone: EmptyStateTone.error,
        title: 'Recherche impossible',
        message: 'Réessayez dans un instant.',
      ),
      data: (products) {
        if (products.isEmpty) {
          return EmptyState(
            icon: Icons.search,
            tone: EmptyStateTone.neutral,
            title: 'Aucun produit « $query »',
            message:
                'Vérifiez l’orthographe ou créez-le maintenant, sans quitter '
                'la vente.',
            secondaryActions: [
              SecondaryButton(
                label: 'Créer « $query »',
                icon: Icons.add,
                onPressed: () => onCreate(query),
              ),
            ],
          );
        }
        return ColoredBox(
          color: cs.surface,
          child: ListView.separated(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: products.length,
            separatorBuilder: (_, _) =>
                Divider(height: 1, thickness: 1, color: cs.outlineVariant),
            itemBuilder: (context, index) {
              final product = products[index];
              return SaleProductRow(
                key: ValueKey(product.id),
                product: product,
                quantityInCart: cartQuantities[product.id] ?? 0,
                onAdd: onAdd,
                onDecrease: onDecrease,
                onOpen: onOpen,
              );
            },
          ),
        );
      },
    );
  }
}
