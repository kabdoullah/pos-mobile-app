import 'dart:async';

import 'package:clock/clock.dart';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/providers/catalog_di_providers.dart';
import '../../../sales/domain/entities/margin_summary.dart';
import '../../../sales/domain/entities/sale.dart';
import '../../../sales/domain/entities/sale_item_brief.dart';
import '../../../sales/domain/repositories/sales_repository.dart';
import '../../../auth/providers/auth_di_providers.dart';
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
/// Alimente « Bénéfice estimé » et « Marge moyenne » de l'accueil.
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

/// Diffuse le montant des ventes du jour heure par heure (24 cases, index =
/// heure locale) — donne l'heure de pointe (« Pic ») de l'accueil.
@riverpod
Stream<List<Decimal>> todayHourlySales(Ref ref) {
  final today = ref.watch(todayProvider);
  return ref
      .watch(salesRepositoryProvider)
      .watchSalesByDateRange(today, today)
      .map(salesByHour);
}

/// Diffuse les articles des ventes du jour, groupés par id de vente — résumé
/// « Riz ×2, Pain » des dernières ventes de l'accueil.
@riverpod
Stream<Map<String, List<SaleItemBrief>>> todaySaleItems(Ref ref) {
  final today = ref.watch(todayProvider);
  return ref
      .watch(salesRepositoryProvider)
      .watchSaleItemsByDateRange(today, today);
}

/// Ventes brutes d'hier jusqu'à l'heure de [at] (comparaison « à la même
/// heure ») : montant et nombre de ventes.
typedef SameTimeTotal = ({Decimal amount, int count, DateTime at});

/// Intervalle de rafraîchissement de la comparaison avec hier : sans nouvelle
/// vente, l'heure de référence avance quand même.
const _sameTimeRefresh = Duration(minutes: 5);

/// Diffuse le montant brut des ventes d'hier jusqu'à l'heure qu'il est —
/// comparer une demi-journée à une journée entière tromperait (« − 70 % » à
/// 10 h). Se recalcule toutes les 5 minutes et au changement de jour.
@riverpod
Stream<SameTimeTotal> yesterdayAtSameTime(Ref ref) {
  final today = ref.watch(todayProvider);
  final timer = Timer(_sameTimeRefresh, ref.invalidateSelf);
  ref.onDispose(timer.cancel);
  final now = clock.now();
  final yesterday = DateTime(today.year, today.month, today.day - 1);
  final cutoff = now.difference(today);
  return ref
      .watch(salesRepositoryProvider)
      .watchSalesByDateRange(yesterday, yesterday)
      .map((sales) {
        final before = salesUpTo(sales, cutoff);
        return (amount: grossTotal(before), count: before.length, at: now);
      });
}

/// Récapitulatif d'une journée passée : nombre de ventes et montant brut.
typedef DayRecap = ({int count, Decimal gross});

/// Diffuse le récapitulatif d'hier (journée entière) — bloc « Hier » de
/// l'accueil tant que la caisse est fermée et qu'aucune vente n'est faite.
@riverpod
Stream<DayRecap> yesterdayRecap(Ref ref) {
  final yesterday = _yesterday(ref.watch(todayProvider));
  return ref
      .watch(salesRepositoryProvider)
      .watchSalesByDateRange(yesterday, yesterday)
      .map((sales) => (count: sales.length, gross: grossTotal(sales)));
}

/// Diffuse chiffre d'affaires et marge d'hier (bloc « Hier » de l'accueil).
@riverpod
Stream<MarginSummary> yesterdayMarginSummary(Ref ref) {
  final yesterday = _yesterday(ref.watch(todayProvider));
  return ref
      .watch(salesRepositoryProvider)
      .watchMarginSummary(yesterday, yesterday);
}

DateTime _yesterday(DateTime today) =>
    DateTime(today.year, today.month, today.day - 1);

/// Les [sales] passées avant [timeOfDay] (heure locale depuis minuit, bornes
/// incluses).
List<Sale> salesUpTo(Iterable<Sale> sales, Duration timeOfDay) => [
  for (final sale in sales)
    if (_timeOfDay(sale.createdAt.toLocal()) <= timeOfDay) sale,
];

Duration _timeOfDay(DateTime at) =>
    Duration(hours: at.hour, minutes: at.minute, seconds: at.second);

/// Somme brute des [sales] (les retours n'y figurent pas).
Decimal grossTotal(Iterable<Sale> sales) =>
    sales.fold(Decimal.zero, (sum, sale) => sum + sale.totalAmount);

/// Montant moyen d'une vente, arrondi au franc ; `null` sans vente.
Decimal? averageOf(Decimal gross, int count) => count == 0
    ? null
    : Decimal.fromBigInt((gross / Decimal.fromInt(count)).round());

/// Écart de [current] par rapport à [reference], en pourcentage arrondi à
/// l'entier ; `null` si [reference] est nul (pas de base de comparaison).
int? percentChange(Decimal current, Decimal reference) {
  if (reference == Decimal.zero) return null;
  final ratio = (current - reference) * Decimal.fromInt(100) / reference;
  return ratio.round().toInt();
}

/// Totaux des [sales] par heure locale de création : liste de 24 montants
/// (montant brut des ventes ; les retours n'y figurent pas).
List<Decimal> salesByHour(Iterable<Sale> sales) {
  final totals = List<Decimal>.filled(24, Decimal.zero);
  for (final sale in sales) {
    final hour = sale.createdAt.toLocal().hour;
    totals[hour] += sale.totalAmount;
  }
  return totals;
}

/// Diffuse s'il existe au moins une vente sur l'appareil — dernière étape
/// des « Premiers pas » de l'accueil.
@riverpod
Stream<bool> hasAnySale(Ref ref) =>
    ref.watch(salesRepositoryProvider).watchHasSales();

/// Diffuse les produits en rupture ou sous leur seuil, ruptures d'abord —
/// alimente la section « Stock faible » de l'accueil (aperçu + compteur).
@riverpod
Stream<List<Product>> homeLowStock(Ref ref) {
  return ref.watch(catalogRepositoryProvider).watchLowStockProducts();
}

/// Panier moyen du jour, arrondi au franc ; `null` sans vente. Calculé sur
/// les ventes brutes : un retour ne change pas le montant des paniers vendus.
Decimal? averageBasket(DailyStats stats) =>
    averageOf(stats.totalAmount + stats.refundTotal, stats.saleCount);

/// Part des espèces dans l'encaissé du jour, en pourcentage entier (0–100) ;
/// `null` si rien n'a été encaissé.
int? cashSharePercent(DailyStats stats) {
  final collected = stats.cashTotal + stats.mobileMoneyTotal;
  if (collected == Decimal.zero) return null;
  return (stats.cashTotal * Decimal.fromInt(100) / collected).round().toInt();
}

/// « Premiers pas » masqués par le compte connecté (préférence liée au
/// compte : gardée à la reconnexion, jamais héritée par un autre compte).
/// Écrit par la section qui le regarde : pas de risque de libération pendant
/// l'écriture.
@riverpod
class FirstStepsHidden extends _$FirstStepsHidden {
  @override
  Future<bool> build() =>
      ref.read(profileRepositoryProvider).firstStepsHidden();

  /// Masque la section, tout de suite à l'écran puis sur l'appareil.
  Future<void> hide() async {
    final repository = ref.read(profileRepositoryProvider);
    state = const AsyncData(true);
    await repository.hideFirstSteps();
  }
}
