import 'stock_movement.dart';

/// Page de mouvements de stock avec métadonnées de pagination.
class StockMovementPage {
  /// Crée une StockMovementPage.
  const StockMovementPage({
    required this.items,
    required this.nextCursor,
    required this.hasMore,
  });

  /// Liste des mouvements de stock de cette page.
  final List<StockMovement> items;

  /// Curseur pour récupérer la page suivante. Null s'il n'y a plus de page.
  final String? nextCursor;

  /// Indique s'il reste des pages.
  final bool hasMore;
}
