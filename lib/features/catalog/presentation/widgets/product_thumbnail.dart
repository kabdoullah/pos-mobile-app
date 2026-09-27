import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/index.dart';
import '../../domain/entities/product.dart';
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
    final file = version == null
        ? null
        : ref.watch(productImageFileProvider(product.id, version)).value;
    return AppThumbnail(file: file, size: size);
  }
}
