import 'package:decimal/decimal.dart';

import 'cart_item.dart';
import 'sale.dart';

/// Chiffre d'affaires, coût d'achat et marge brute d'un ensemble de ventes,
/// calculés uniquement sur les valeurs figées à la vente (ADR-0009).
///
/// Les lignes dont le prix d'achat était inconnu sont exclues du coût et de
/// la marge (mais comptées dans [revenue]) ; [hasUnknownCost] le signale.
class MarginSummary {
  /// Crée un résumé de marge.
  const MarginSummary({
    required this.revenue,
    required this.coveredRevenue,
    required this.cost,
    required this.hasUnknownCost,
  });

  /// Calcule le résumé de [sales], chaque vente avec ses lignes enregistrées.
  ///
  /// La remise globale d'une vente est répartie sur ses lignes au prorata de
  /// leur total net, pour que la marge reflète le prix réellement payé.
  factory MarginSummary.fromSales(
    Iterable<({Sale sale, List<CartItem> items})> sales,
  ) {
    var revenue = Decimal.zero;
    var coveredRevenue = Decimal.zero;
    var cost = Decimal.zero;
    var hasUnknownCost = false;

    for (final (:sale, :items) in sales) {
      revenue += sale.totalAmount;
      final subtotal = sale.subtotalAmount;
      for (final item in items) {
        final itemCost = item.purchaseCost;
        if (itemCost == null) {
          hasUnknownCost = true;
          continue;
        }
        cost += itemCost;
        coveredRevenue += subtotal == Decimal.zero
            ? Decimal.zero
            : (item.lineTotal * sale.totalAmount / subtotal).toDecimal(
                scaleOnInfinitePrecision: 2,
              );
      }
      // Vente reçue sans lignes (ancienne synchro) : coût inconnu.
      if (items.isEmpty && sale.totalAmount > Decimal.zero) {
        hasUnknownCost = true;
      }
    }

    return MarginSummary(
      revenue: revenue,
      coveredRevenue: coveredRevenue,
      cost: cost,
      hasUnknownCost: hasUnknownCost,
    );
  }

  /// Résumé vide (aucune vente).
  static final MarginSummary empty = MarginSummary(
    revenue: Decimal.zero,
    coveredRevenue: Decimal.zero,
    cost: Decimal.zero,
    hasUnknownCost: false,
  );

  /// Chiffre d'affaires total encaissé (FCFA).
  final Decimal revenue;

  /// Part du chiffre d'affaires dont le coût d'achat est connu.
  final Decimal coveredRevenue;

  /// Coût d'achat des lignes au coût connu.
  final Decimal cost;

  /// Au moins une ligne vendue sans prix d'achat connu.
  final bool hasUnknownCost;

  /// Marge brute sur la part au coût connu.
  Decimal get margin => coveredRevenue - cost;

  /// Taux de marge (marge / chiffre d'affaires couvert, en %) ; `null` sans
  /// chiffre d'affaires couvert.
  Decimal? get marginRate => coveredRevenue == Decimal.zero
      ? null
      : (margin * Decimal.fromInt(100) / coveredRevenue).toDecimal(
          scaleOnInfinitePrecision: 2,
        );
}
