import 'dart:async';

import 'package:clock/clock.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/providers/catalog_di_providers.dart';
import '../../../sales/domain/entities/margin_summary.dart';
import '../../../sales/domain/entities/sale.dart';
import '../../../sales/domain/repositories/sales_repository.dart';
import '../../../sales/providers/sales_di_providers.dart';

part 'home_providers.g.dart';

/// Nombre de ventes affichées dans la mini-liste « activité récente » de
/// l'accueil.
const _recentSalesLimit = 3;

/// Date du jour (minuit local). Se reconstruit au prochain minuit pour que
/// chaque provider lié à « aujourd'hui » se réabonne au changement de jour —
/// sinon un tableau de bord resté ouvert la nuit continue d'afficher la veille.
@riverpod
DateTime today(Ref ref) {
  final now = clock.now();
  final nextMidnight = DateTime(now.year, now.month, now.day + 1);
  final timer = Timer(nextMidnight.difference(now), ref.invalidateSelf);
  ref.onDispose(timer.cancel);
  return DateTime(now.year, now.month, now.day);
}

/// Diffuse les totaux de ventes du jour — réémet automatiquement à chaque
/// nouvelle vente.
@riverpod
Stream<DailyStats> dailySummary(Ref ref) {
  // watchTodayStats() fige « aujourd'hui » à l'abonnement : se réabonner
  // chaque jour.
  ref.watch(todayProvider);
  return ref.watch(salesRepositoryProvider).watchTodayStats();
}

/// Diffuse chiffre d'affaires, coût d'achat et marge brute du jour (ADR-0009).
///
/// Prêt pour le tableau de bord ; aucun écran ne l'affiche encore.
@riverpod
Stream<MarginSummary> todayMarginSummary(Ref ref) {
  final today = ref.watch(todayProvider);
  return ref.watch(salesRepositoryProvider).watchMarginSummary(today, today);
}

/// Diffuse les ventes les plus récentes du jour, de la plus récente à la plus
/// ancienne — pour la mini-liste « activité récente » de l'accueil.
@riverpod
Stream<List<Sale>> recentSales(Ref ref) {
  final today = ref.watch(todayProvider);
  return ref
      .watch(salesRepositoryProvider)
      .watchSalesByDateRange(today, today)
      .map((sales) => sales.take(_recentSalesLimit).toList());
}

/// Diffuse les produits en rupture ou sous leur seuil, ruptures d'abord —
/// alimente la section « Stock faible » de l'accueil (aperçu + compteur).
@riverpod
Stream<List<Product>> homeLowStock(Ref ref) {
  return ref.watch(catalogRepositoryProvider).watchLowStockProducts();
}

/// Panier moyen du jour, arrondi au franc ; `null` sans vente.
Decimal? averageBasket(DailyStats stats) {
  if (stats.saleCount == 0) return null;
  return Decimal.fromBigInt(
    (stats.totalAmount / Decimal.fromInt(stats.saleCount)).round(),
  );
}

/// Part des espèces dans l'encaissé du jour, en pourcentage entier (0–100) ;
/// `null` si rien n'a été encaissé.
int? cashSharePercent(DailyStats stats) {
  final collected = stats.cashTotal + stats.mobileMoneyTotal;
  if (collected == Decimal.zero) return null;
  return (stats.cashTotal * Decimal.fromInt(100) / collected).round().toInt();
}
