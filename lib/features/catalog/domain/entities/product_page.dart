import 'product.dart';

/// Page de produits avec métadonnées de pagination.
class ProductPage {
  /// Crée une ProductPage.
  const ProductPage({
    required this.items,
    required this.nextCursor,
    required this.hasMore,
  });

  /// Liste des produits de cette page.
  final List<Product> items;

  /// Curseur pour récupérer la page suivante. Null s'il n'y a plus de page.
  final String? nextCursor;

  /// Indique s'il reste des pages.
  final bool hasMore;
}
