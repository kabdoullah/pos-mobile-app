import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/index.dart';
import '../../domain/entities/product.dart';
import '../providers/catalog_providers.dart';
import '../providers/product_image_providers.dart';

/// Vignette de la photo d'un produit (cache disque, téléchargée au besoin) ;
/// pictogramme si le produit n'a pas de photo ou si elle est indisponible.
class ProductThumbnail extends ConsumerWidget {
  /// Crée la vignette de [product], de [size] points de côté.
  const ProductThumbnail({required this.product, this.size = 44, super.key});

  /// Produit dont on affiche la photo.
  final Product product;

  /// Côté de la vignette.
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final version = product.imageVersion;
    final image = version == null
        ? null
        : ref.watch(productImageProvider(product.id, version));
    return AppThumbnail(image: image, size: size);
  }
}

/// Vignette d'un produit connu par son seul identifiant (ligne de panier, de
/// vente, de retour, mouvement de stock) : le produit est lu dans le catalogue
/// local. Pictogramme si le produit est absent (supprimé) ou sans photo.
class ProductThumbnailById extends ConsumerWidget {
  /// Crée la vignette du produit [productId], de [size] points de côté.
  const ProductThumbnailById({
    required this.productId,
    this.size = 40,
    super.key,
  });

  /// Identifiant du produit (null = pictogramme).
  final String? productId;

  /// Côté de la vignette.
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = productId;
    final product = id == null ? null : ref.watch(productProvider(id)).value;
    return product == null
        ? AppThumbnail(image: null, size: size)
        : ProductThumbnail(product: product, size: size);
  }
}
