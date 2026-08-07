import 'stock_movement.dart';

/// Stock movement page result with pagination metadata.
class StockMovementPage {
  /// Creates a StockMovementPage.
  const StockMovementPage({
    required this.items,
    required this.nextCursor,
    required this.hasMore,
  });

  /// List of stock movements in this page.
  final List<StockMovement> items;

  /// Cursor for fetching next page. Null if no more pages.
  final String? nextCursor;

  /// Whether more pages exist.
  final bool hasMore;
}
