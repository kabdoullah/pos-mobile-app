import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/presentation/providers/product_image_providers.dart';

/// Hauteur de la photo d'une tuile.
const double _photoHeight = 64;

/// Pictogramme « image » d'un produit sans photo, bien lisible au comptoir.
const double _placeholderIconSize = 40;

/// Largeur minimale d'une tuile : 3 colonnes sur un téléphone de 360 dp.
const double _minTileWidth = 104;

/// Colonnes : au moins 3 (téléphone), au plus 8 (tablette).
const int _minColumns = 3;
const int _maxColumns = 8;

// Hauteur des textes d'une tuile à l'échelle de texte 1 (suit la taille de
// police système) : nom sur 2 lignes (14 × 1,25) + prix (16 × 1,4).
const double _tileText = 2 * 14 * 1.25 + 16 * 1.4;

// Marges intérieures (haut + bas) et écart nom / prix.
const double _tilePadding = 6 + 8 + 2;

/// Désature la photo d'un produit en rupture.
const _greyscale = ColorFilter.matrix(<double>[
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0, 0, 0, 1, 0, //
]);

/// Catalogue de l'écran Vendre en grille, sous forme de sliver : 3 colonnes
/// de tuiles sur téléphone, plus sur tablette. Toutes les tuiles ont la même
/// hauteur, ajustée à la taille de texte du système.
class SaleProductGrid extends StatelessWidget {
  /// Crée la grille de [products].
  const SaleProductGrid({
    required this.products,
    required this.cartQuantities,
    required this.onAdd,
    required this.onEditQuantity,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.md,
      AppSpacing.sm + 2,
      AppSpacing.md,
      AppSpacing.md,
    ),
    super.key,
  });

  /// Produits affichés, dans l'ordre.
  final List<Product> products;

  /// Quantité déjà au panier, par id de produit.
  final Map<String, int> cartQuantities;

  /// Ajoute une unité du produit (toucher la tuile).
  final ValueChanged<Product> onAdd;

  /// Ouvre la saisie détaillée de la quantité (pastille, appui long).
  final ValueChanged<Product> onEditQuantity;

  /// Marges autour de la grille.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final extent =
        _photoHeight +
        _tilePadding +
        MediaQuery.textScalerOf(context).scale(_tileText);
    return SliverPadding(
      padding: padding,
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final columns =
              ((constraints.crossAxisExtent + AppSpacing.sm) /
                      (_minTileWidth + AppSpacing.sm))
                  .floor()
                  .clamp(_minColumns, _maxColumns);
          return SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisExtent: extent.ceilToDouble(),
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return SaleProductTile(
                key: ValueKey(product.id),
                product: product,
                inCart: cartQuantities[product.id] ?? 0,
                onAdd: () => onAdd(product),
                onEditQuantity: () => onEditQuantity(product),
              );
            },
          );
        },
      ),
    );
  }
}

/// Tuile produit de l'écran Vendre en grille.
///
/// Photo (pictogramme sur fond neutre si le produit n'en a pas), nom sur 2
/// lignes, prix sans « FCFA » sur une ligne. Toucher la tuile ajoute une
/// unité ; l'appui long ou la pastille de quantité ouvre la saisie détaillée,
/// qui sert aussi à corriger (pas de « − » sur la tuile : trop près de la
/// zone qui ajoute). Au panier : cadre couleur action et pastille. Rupture :
/// photo grisée, « Rupture » à la place du prix, tuile inactive. Stock bas :
/// « Reste N » sur la photo, sans changer la hauteur de la tuile. Le prix
/// d'achat n'est jamais affiché en caisse (ADR-0009).
class SaleProductTile extends StatelessWidget {
  /// Crée une tuile produit.
  const SaleProductTile({
    required this.product,
    required this.inCart,
    required this.onAdd,
    required this.onEditQuantity,
    super.key,
  });

  /// Produit affiché.
  final Product product;

  /// Quantité déjà au panier.
  final int inCart;

  /// Ajoute une unité.
  final VoidCallback onAdd;

  /// Ouvre la saisie détaillée de la quantité.
  final VoidCallback onEditQuantity;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final stock = product.currentStock;
    final outOfStock = stock != null && stock <= 0 && inCart == 0;
    final lowStock = !outOfStock && product.stockLevel == StockLevel.low;
    final radius = BorderRadius.circular(AppSpacing.radiusSurface);

    final semanticsLabel = [
      product.name,
      if (outOfStock) 'en rupture' else formatFcfa(product.sellingPrice),
      if (lowStock) 'reste $stock',
    ].join(', ');

    final price = outOfStock
        ? const StatusIndicator(label: 'Rupture', tone: StatusTone.error)
        : Text(
            formatAmount(product.sellingPrice),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
            style: AppTypography.label.copyWith(
              color: colors.textPrimary,
              fontFeatures: AppTypography.tabularFigures,
            ),
          );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: _photoHeight,
          child: _TilePhoto(product: product, greyed: outOfStock),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              6,
              AppSpacing.sm,
              AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.meta.copyWith(
                    height: 1.25,
                    color: outOfStock
                        ? colors.textSecondary
                        : colors.textPrimary,
                  ),
                ),
                const Spacer(),
                price,
              ],
            ),
          ),
        ),
      ],
    );

    return DecoratedBox(
      position: DecorationPosition.foreground,
      // Bordure dessinée par-dessus : le cadre « au panier », plus épais, ne
      // décale pas le contenu.
      decoration: BoxDecoration(
        borderRadius: radius,
        border: inCart > 0
            ? Border.all(color: colors.action, width: 2)
            : Border.all(color: colors.border),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Material(
          color: colors.surface,
          child: Stack(
            children: [
              Positioned.fill(
                child: Semantics(
                  button: true,
                  enabled: !outOfStock,
                  label: semanticsLabel,
                  hint: outOfStock ? null : 'Ajoute une unité',
                  excludeSemantics: true,
                  child: InkWell(
                    onTap: outOfStock ? null : onAdd,
                    onLongPress: outOfStock ? null : onEditQuantity,
                    child: content,
                  ),
                ),
              ),
              if (lowStock)
                Positioned(
                  left: 6,
                  top: 0,
                  height: _photoHeight - 6,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: _LowStockLabel(stock: stock!),
                  ),
                ),
              if (inCart > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: _QuantityBadge(
                    quantity: inCart,
                    onTap: onEditQuantity,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Photo pleine largeur de la tuile ; pictogramme sur fond neutre si le
/// produit n'a pas de photo ou si elle est indisponible.
class _TilePhoto extends ConsumerWidget {
  const _TilePhoto({required this.product, required this.greyed});

  final Product product;
  final bool greyed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final version = product.imageVersion;
    final image = version == null
        ? null
        : ref.watch(productImageProvider(product.id, version));
    final fallback = ColoredBox(
      color: colors.surfaceSunken,
      child: const Center(
        child: StrokeIcon(DesignIcon.image, size: _placeholderIconSize),
      ),
    );
    if (image == null) return fallback;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Décodage à la taille affichée : pas d'image pleine résolution.
        final cacheWidth =
            (constraints.maxWidth * MediaQuery.devicePixelRatioOf(context))
                .round();
        Widget photo = Image(
          image: ResizeImage(image, width: cacheWidth),
          fit: BoxFit.cover,
          gaplessPlayback: true,
          frameBuilder: (_, child, frame, wasSynchronouslyLoaded) =>
              frame == null && !wasSynchronouslyLoaded ? fallback : child,
          errorBuilder: (_, _, _) => fallback,
        );
        if (greyed) {
          photo = Opacity(
            opacity: 0.45,
            child: ColorFiltered(colorFilter: _greyscale, child: photo),
          );
        }
        return photo;
      },
    );
  }
}

/// « Reste N » posé sur la photo : point d'alerte et mot sur la surface.
class _LowStockLabel extends StatelessWidget {
  const _LowStockLabel({required this.stock});

  final int stock;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusControl),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.warning,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: const SizedBox.square(dimension: 8),
            ),
            const SizedBox(width: 6),
            Text(
              'Reste $stock',
              style: AppTypography.meta.copyWith(
                color: colors.textPrimary,
                fontFeatures: AppTypography.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pastille de quantité : 28 dp visibles dans une zone tactile de 44 dp.
class _QuantityBadge extends StatelessWidget {
  const _QuantityBadge({required this.quantity, required this.onTap});

  final int quantity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Semantics(
      button: true,
      label: '$quantity au panier',
      hint: 'Modifier la quantité',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: AppSpacing.minTapTarget,
            minHeight: AppSpacing.minTapTarget,
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Align(
              alignment: Alignment.topRight,
              widthFactor: 1,
              heightFactor: 1,
              child: Container(
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.action,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  '$quantity',
                  style: AppTypography.meta.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.onAction,
                    fontFeatures: AppTypography.tabularFigures,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
