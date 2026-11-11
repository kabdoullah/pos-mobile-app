import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../inventory/presentation/providers/inventory_providers.dart';
import 'sale_product_row.dart';

// Largeur minimale d'une colonne : une seule (liste) sur téléphone, jusqu'à 3
// sur tablette.
const double _minColumnWidth = 320;
const int _maxColumns = 3;

/// Catalogue parcourable de la caisse, sous forme de sliver : lignes produit
/// à plat sur toute la largeur, séparées par des filets (colonnes sur
/// tablette).
///
/// Ne connaît ni le panier ni les règles de stock : les contrôles d'ajout
/// restent dans la page, via [onAdd], [onDecrease] et [onOpen].
/// [cartQuantities] ne sert qu'à l'affichage.
class ProductBrowser extends StatelessWidget {
  /// Crée le catalogue de la caisse.
  const ProductBrowser({
    required this.products,
    required this.onAdd,
    required this.onDecrease,
    required this.onOpen,
    required this.onRetry,
    required this.onAddProduct,
    required this.onScanProduct,
    required this.onImportProducts,
    this.categoryId,
    this.cartQuantities = const {},
    super.key,
  });

  /// Produits du catalogue local (flux drift).
  final AsyncValue<List<Product>> products;

  /// Ajoute une unité du produit (ligne, « + »).
  final ValueChanged<Product> onAdd;

  /// Retire une unité du produit (stepper).
  final ValueChanged<Product> onDecrease;

  /// Ouvre le choix de quantité du produit (appui long).
  final ValueChanged<Product> onOpen;

  /// Relance le chargement après une erreur.
  final VoidCallback onRetry;

  /// Ouvre le formulaire de création de produit (catalogue vide).
  final VoidCallback onAddProduct;

  /// Ouvre le scanner pour créer un produit (catalogue vide).
  final VoidCallback onScanProduct;

  /// Ouvre l'import d'une liste de produits (catalogue vide).
  final VoidCallback onImportProducts;

  /// Catégorie filtrée ; `null` = tous les produits.
  final String? categoryId;

  /// Quantité déjà au panier, par id de produit.
  final Map<String, int> cartQuantities;

  @override
  Widget build(BuildContext context) {
    // Des produits déjà chargés restent affichés malgré une erreur ultérieure :
    // la caisse ne se bloque pas.
    if (products.hasValue) {
      final all = products.requireValue;
      if (all.isEmpty) {
        return SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyState(
            icon: Icons.inventory_2_outlined,
            title: 'Aucun produit pour l’instant',
            message:
                'Ajoutez vos produits une fois : ensuite, un geste suffit '
                'pour vendre.',
            actionLabel: 'Créer un produit',
            actionIcon: Icons.add,
            onAction: onAddProduct,
            secondaryActions: [
              SecondaryButton(
                label: 'Scanner un produit',
                icon: Icons.qr_code_scanner,
                onPressed: onScanProduct,
              ),
              TextButton(
                onPressed: onImportProducts,
                child: const Text('Importer une liste'),
              ),
            ],
          ),
        );
      }
      final list = filterStockProducts(
        all,
        filter: StockFilter.all,
        categoryId: categoryId,
      );
      if (list.isEmpty) {
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyState(
            icon: Icons.category_outlined,
            tone: EmptyStateTone.neutral,
            title: 'Aucun produit dans cette catégorie',
            message: 'Choisissez « Tous » pour voir tout le catalogue.',
          ),
        );
      }
      return _ProductList(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final product = list[index];
          return SaleProductRow(
            key: ValueKey(product.id),
            product: product,
            quantityInCart: cartQuantities[product.id] ?? 0,
            onAdd: onAdd,
            onDecrease: onDecrease,
            onOpen: onOpen,
          );
        },
      );
    }
    if (products.hasError) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyState(
          icon: Icons.warning_amber_rounded,
          tone: EmptyStateTone.error,
          title: 'Le catalogue ne s’affiche pas',
          message:
              'Vos ventes déjà faites ne sont pas perdues. Réessayez ; si le '
              'problème continue, fermez puis rouvrez l’application.',
          actionLabel: 'Réessayer',
          actionIcon: Icons.refresh,
          onAction: onRetry,
        ),
      );
    }
    return _ProductList(
      itemCount: 6,
      itemBuilder: (_, index) =>
          _SkeletonRow(widthFactor: _skeletonWidths[index]),
    );
  }
}

const _skeletonWidths = [0.7, 0.55, 0.8, 0.45, 0.65, 0.5];

/// Liste à plat sur toute la largeur (téléphone) ou colonnes (tablette),
/// séparées par des filets.
class _ProductList extends StatelessWidget {
  const _ProductList({required this.itemCount, required this.itemBuilder});

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final divider = BorderSide(
      color: Theme.of(context).colorScheme.outlineVariant,
    );
    Widget cell(BuildContext context, int index) => DecoratedBox(
      decoration: BoxDecoration(border: Border(bottom: divider)),
      child: itemBuilder(context, index),
    );
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.crossAxisExtent / _minColumnWidth)
            .floor()
            .clamp(1, _maxColumns);
        if (columns == 1) {
          return SliverList.builder(itemCount: itemCount, itemBuilder: cell);
        }
        // Tablette : lignes de hauteur naturelle, regroupées par rangée.
        final rows = (itemCount / columns).ceil();
        return SliverList.builder(
          itemCount: rows,
          itemBuilder: (context, row) => IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var column = 0; column < columns; column++)
                  Expanded(
                    child: row * columns + column < itemCount
                        ? cell(context, row * columns + column)
                        : const SizedBox.shrink(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Squelette à la forme d'une ligne produit.
class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 14,
        ),
        child: Row(
          children: [
            const SkeletonBox(
              width: 44,
              height: 44,
              radius: AppSpacing.radiusSm,
            ),
            const SizedBox(width: AppSpacing.sm + 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FractionallySizedBox(
                    widthFactor: widthFactor,
                    child: const SkeletonBox(
                      height: 16,
                      radius: AppSpacing.radiusSm,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const SkeletonBox(
                    width: 80,
                    height: 16,
                    radius: AppSpacing.radiusSm,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const SkeletonBox(width: 48, height: 48),
          ],
        ),
      ),
    );
  }
}
