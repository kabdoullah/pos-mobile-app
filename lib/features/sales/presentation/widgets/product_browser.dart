import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/widgets/product_thumbnail.dart';
import '../../../catalog/presentation/widgets/stock_status_badge.dart';
import '../../../inventory/presentation/providers/inventory_providers.dart';

// Largeur minimale d'une carte en grille : une colonne (liste) sur téléphone,
// jusqu'à 3 sur tablette.
const double _minCardWidth = 320;
const int _maxColumns = 3;
// Hauteur d'une carte en grille à l'échelle de texte 1 (suit la taille de
// police système pour éviter les débordements).
const double _cardHeight = 132;
const double _thumbSize = 48;

/// Catalogue parcourable de la caisse, sous forme de slivers à insérer dans le
/// défilement de la page : en-tête « Produits · N » puis cartes produit
/// (liste sur téléphone, grille sur tablette).
///
/// Ne connaît ni le panier ni les règles de stock : les contrôles d'ajout
/// (stock restant, message « Stock insuffisant ») restent dans la page, via
/// [onQuickAdd] et [onProductTap]. [cartQuantities] ne sert qu'à l'affichage.
class ProductBrowser extends StatelessWidget {
  /// Crée le catalogue de la caisse.
  const ProductBrowser({
    required this.products,
    required this.onProductTap,
    required this.onQuickAdd,
    required this.onRetry,
    required this.onAddProduct,
    this.categoryId,
    this.cartQuantities = const {},
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
          child: EmptyState(
            icon: Icons.inventory_2_outlined,
            title: 'Aucun produit disponible',
            message: 'Ajoutez votre premier produit pour commencer à vendre.',
            actionLabel: 'Ajouter un produit',
            onAction: onAddProduct,
          ),
        );
      }
      final list = filterStockProducts(
        all,
        filter: StockFilter.all,
        categoryId: categoryId,
      );
      return SliverMainAxisGroup(
        slivers: [
          _Header(count: list.length),
          if (list.isEmpty)
            const _Message('Aucun produit dans cette catégorie.')
          else
            _ProductGrid(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final product = list[index];
                return _ProductCard(
                  product: product,
                  inCart: cartQuantities[product.id] ?? 0,
                  onTap: onProductTap,
                  onQuickAdd: onQuickAdd,
                );
              },
            ),
        ],
      );
    }
    if (products.hasError) {
      return SliverFillRemaining(
        child: EmptyState(
          icon: Icons.error_outline,
          title: 'Impossible de charger les produits',
          message: 'Vérifiez votre appareil puis réessayez.',
          actionLabel: 'Réessayer',
          onAction: onRetry,
        ),
      );
    }
    return _ProductGrid(
      itemCount: 6,
      itemBuilder: (_, _) =>
          const SkeletonBox(height: 72, radius: AppSpacing.radiusMd),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      sliver: SliverToBoxAdapter(
        child: SectionHeader(title: 'Produits', count: count),
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
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// Liste (une colonne) ou grille paresseuse selon la largeur disponible.
///
/// Sur téléphone, les produits forment une seule surface à plat, séparée par
/// des filets : l'œil parcourt une liste, pas une pile de cartes.
class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.itemCount, required this.itemBuilder});

  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final height = MediaQuery.textScalerOf(context).scale(_cardHeight);
    final radius = BorderRadius.circular(AppSpacing.radiusMd);
    final surface = BoxDecoration(
      color: cs.surface,
      borderRadius: radius,
      border: Border.all(color: cs.outlineVariant),
    );
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final columns = (constraints.crossAxisExtent / _minCardWidth)
              .floor()
              .clamp(1, _maxColumns);
          if (columns == 1) {
            // Liste : hauteur naturelle, pas de risque de débordement.
            return SliverAppListGroup(
              itemCount: itemCount,
              dividerIndent: AppSpacing.md + _thumbSize + AppSpacing.sm,
              itemBuilder: (context, index) => itemBuilder(context, index)!,
            );
          }
          return SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisExtent: height,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) => DecoratedBox(
              decoration: surface,
              child: ClipRRect(
                borderRadius: radius,
                child: itemBuilder(context, index),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Ligne produit : photo, nom, puis prix, stock et quantité au panier ; un
/// bouton « + » carré ajoute une unité.
///
/// Le prix d'achat n'est jamais affiché en caisse (ADR-0009).
class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.inCart,
    required this.onTap,
    required this.onQuickAdd,
  });

  final Product product;
  final int inCart;
  final ValueChanged<Product> onTap;
  final ValueChanged<Product> onQuickAdd;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final stock = product.currentStock;
    final outOfStock = stock != null && stock <= 0;

    // Material propre : l'encre reste visible au-dessus du fond de la liste.
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: outOfStock ? null : () => onTap(product),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm + AppSpacing.xs,
            AppSpacing.sm,
            AppSpacing.sm + AppSpacing.xs,
          ),
          child: Row(
            children: [
              Opacity(
                opacity: outOfStock ? 0.5 : 1,
                child: ProductThumbnail(product: product, size: _thumbSize),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: outOfStock ? cs.onSurfaceVariant : cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          formatFcfa(product.sellingPrice),
                          maxLines: 1,
                          style: AppTypography.labelLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            fontFeatures: AppTypography.tabularFigures,
                            color: outOfStock
                                ? cs.onSurfaceVariant
                                : cs.primary,
                          ),
                        ),
                        StockStatusBadge(product: product, showQuantity: true),
                        if (inCart > 0) _InCartPill(quantity: inCart),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton.filledTonal(
                tooltip: 'Ajouter ${product.name}',
                onPressed: outOfStock ? null : () => onQuickAdd(product),
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  // secondaryContainer (or très pâle) disparaît sur fond blanc.
                  backgroundColor: cs.primaryContainer,
                  foregroundColor: cs.onPrimaryContainer,
                  minimumSize: const Size.square(AppSpacing.iconButtonSize),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pastille « N au panier » : l'ajout est visible même si le panier est plus
/// bas dans la page.
class _InCartPill extends StatelessWidget {
  const _InCartPill({required this.quantity});

  final int quantity;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 2,
        ),
        child: Text(
          '$quantity au panier',
          style: AppTypography.labelSmall.copyWith(
            color: cs.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}
