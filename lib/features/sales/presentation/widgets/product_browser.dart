import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../inventory/presentation/providers/inventory_providers.dart';
import 'sale_product_row.dart';

// Largeur minimale d'une cellule en grille : une colonne (liste) sur
// téléphone, jusqu'à 3 sur tablette.
const double _minCellWidth = 320;
const int _maxColumns = 3;
// Hauteur d'une cellule en grille à l'échelle de texte 1 (suit la taille de
// police système pour éviter les débordements).
const double _cellHeight = 88;

/// Catalogue de l'écran Vendre, sous forme de sliver : une liste à plat de
/// lignes produit (grille sur tablette).
///
/// Ne connaît ni le panier ni les règles de stock : les contrôles d'ajout
/// (stock restant, message « Stock insuffisant ») restent dans la page.
/// [cartQuantities] ne sert qu'à l'affichage.
class ProductBrowser extends StatelessWidget {
  /// Crée le catalogue de l'écran Vendre.
  const ProductBrowser({
    required this.products,
    required this.onAdd,
    required this.onDecrease,
    required this.onEditQuantity,
    required this.onRetry,
    required this.onAddProduct,
    this.categoryId,
    this.cartQuantities = const {},
    super.key,
  });

  /// Produits du catalogue local (flux drift).
  final AsyncValue<List<Product>> products;

  /// Ajoute une unité du produit (toucher la ligne).
  final ValueChanged<Product> onAdd;

  /// Retire une unité du produit (stepper).
  final ValueChanged<Product> onDecrease;

  /// Ouvre la saisie détaillée de la quantité.
  final ValueChanged<Product> onEditQuantity;

  /// Relance le chargement après une erreur.
  final VoidCallback onRetry;

  /// Ouvre le formulaire de création de produit (catalogue vide).
  final VoidCallback onAddProduct;

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
                'Ajoutez vos produits une fois ; ensuite, un toucher suffit '
                'pour vendre.',
            actionLabel: 'Créer un produit',
            onAction: onAddProduct,
          ),
        );
      }
      final list = filterStockProducts(
        all,
        filter: StockFilter.all,
        categoryId: categoryId,
      );
      if (list.isEmpty) {
        return const _Message('Aucun produit dans cette catégorie.');
      }
      return _ProductList(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final product = list[index];
          return SaleProductRow(
            key: ValueKey(product.id),
            product: product,
            inCart: cartQuantities[product.id] ?? 0,
            onAdd: () => onAdd(product),
            onDecrease: () => onDecrease(product),
            onEditQuantity: () => onEditQuantity(product),
          );
        },
      );
    }
    if (products.hasError) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyState(
          icon: Icons.error_outline,
          title: 'Impossible de charger les produits',
          message: 'Vérifiez votre appareil puis réessayez.',
          actionLabel: 'Réessayer',
          onAction: onRetry,
        ),
      );
    }
    return _ProductList(
      itemCount: 6,
      itemBuilder: (_, _) => const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: SkeletonBox(height: 48, radius: AppSpacing.radiusSm),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.of(context).textSecondary,
          ),
        ),
      ),
    );
  }
}

/// Liste pleine largeur séparée par des filets, ou grille selon la largeur.
class _ProductList extends StatelessWidget {
  const _ProductList({required this.itemCount, required this.itemBuilder});

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final divider = BorderSide(color: colors.border);
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.crossAxisExtent / _minCellWidth)
            .floor()
            .clamp(1, _maxColumns);
        if (columns == 1) {
          // Liste : hauteur naturelle, pas de risque de débordement.
          return SliverList.builder(
            itemCount: itemCount,
            itemBuilder: (context, index) => DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(border: Border(bottom: divider)),
              child: itemBuilder(context, index),
            ),
          );
        }
        final height = MediaQuery.textScalerOf(context).scale(_cellHeight);
        return SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.md),
          sliver: SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisExtent: height,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) => DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                border: Border.fromBorderSide(divider),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                child: Center(child: itemBuilder(context, index)),
              ),
            ),
          ),
        );
      },
    );
  }
}
