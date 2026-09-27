import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/widgets/product_thumbnail.dart';

// Largeur minimale d'une carte : 2 colonnes sur téléphone, jusqu'à 4 sur
// tablette.
const double _minCardWidth = 160;
const int _minColumns = 2;
const int _maxColumns = 4;
// Hauteur d'une carte à l'échelle de texte 1 (suit la taille de police
// système pour éviter les débordements).
const double _cardHeight = 164;
const double _thumbSize = 40;

/// Catalogue parcourable de la caisse : grille des produits locaux, affichée
/// quand aucune recherche n'est en cours.
///
/// Ne connaît ni le panier ni les règles de stock : les contrôles d'ajout
/// (stock restant, message « Stock insuffisant ») restent dans la page, via
/// [onQuickAdd] et [onProductTap].
class ProductBrowser extends StatelessWidget {
  /// Crée le catalogue de la caisse.
  const ProductBrowser({
    required this.products,
    required this.onProductTap,
    required this.onQuickAdd,
    required this.onRetry,
    required this.onAddProduct,
    super.key,
  });

  /// Produits du catalogue local (flux drift).
  final AsyncValue<List<Product>> products;

  /// Ouvre le choix de quantité du produit.
  final ValueChanged<Product> onProductTap;

  /// Ajoute une unité du produit.
  final ValueChanged<Product> onQuickAdd;

  /// Relance le chargement après une erreur.
  final VoidCallback onRetry;

  /// Ouvre le formulaire de création de produit (catalogue vide).
  final VoidCallback onAddProduct;

  @override
  Widget build(BuildContext context) {
    // Des produits déjà chargés restent affichés malgré une erreur ultérieure :
    // la caisse ne se bloque pas.
    if (products.hasValue) {
      final list = products.requireValue;
      if (list.isEmpty) {
        return EmptyState(
          icon: Icons.inventory_2_outlined,
          title: 'Aucun produit',
          message:
              'Ajoutez des produits à votre catalogue pour commencer à vendre.',
          actionLabel: 'Ajouter un produit',
          onAction: onAddProduct,
        );
      }
      return _ProductGrid(
        itemCount: list.length,
        itemBuilder: (context, index) => _ProductCard(
          product: list[index],
          onTap: onProductTap,
          onQuickAdd: onQuickAdd,
        ),
      );
    }
    if (products.hasError) {
      return EmptyState(
        icon: Icons.error_outline,
        title: 'Impossible de charger les produits',
        message: 'Vérifiez votre appareil puis réessayez.',
        actionLabel: 'Réessayer',
        onAction: onRetry,
      );
    }
    return _ProductGrid(
      itemCount: 6,
      scrollable: false,
      itemBuilder: (_, _) => const SkeletonBox(
        height: double.infinity,
        radius: AppSpacing.radiusMd,
      ),
    );
  }
}

/// Grille paresseuse dont le nombre de colonnes suit la largeur disponible.
class _ProductGrid extends StatelessWidget {
  const _ProductGrid({
    required this.itemCount,
    required this.itemBuilder,
    this.scrollable = true,
  });

  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.textScalerOf(context).scale(_cardHeight);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth - 2 * AppSpacing.md;
        final columns = (width / _minCardWidth).floor().clamp(
          _minColumns,
          _maxColumns,
        );
        return GridView.builder(
          physics: scrollable ? null : const NeverScrollableScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.xs,
            AppSpacing.md,
            AppSpacing.md,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisExtent: height,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
          ),
          itemCount: itemCount,
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}

/// Carte produit : photo, nom, prix de vente, stock et bouton d'ajout rapide.
///
/// Le prix d'achat n'est jamais affiché en caisse (ADR-0009).
class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.onQuickAdd,
  });

  final Product product;
  final ValueChanged<Product> onTap;
  final ValueChanged<Product> onQuickAdd;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final stock = product.currentStock;
    final outOfStock = stock != null && stock <= 0;

    return Card.outlined(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: outOfStock ? null : () => onTap(product),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Opacity(
                    opacity: outOfStock ? 0.5 : 1,
                    child: ProductThumbnail(product: product, size: _thumbSize),
                  ),
                  const Spacer(),
                  IconButton.filledTonal(
                    tooltip: 'Ajouter ${product.name}',
                    icon: const Icon(Icons.add),
                    onPressed: outOfStock ? null : () => onQuickAdd(product),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelLarge.copyWith(
                  color: outOfStock ? cs.onSurfaceVariant : cs.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                formatFcfa(product.sellingPrice),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleMedium.copyWith(
                  color: outOfStock ? cs.onSurfaceVariant : cs.primary,
                ),
              ),
              if (stock != null)
                Text(
                  outOfStock ? 'Rupture de stock' : 'Stock : $stock',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(
                    color: outOfStock ? cs.error : cs.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
