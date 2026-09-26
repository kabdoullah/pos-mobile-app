import 'dart:async';

import 'package:clock/clock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../catalog/providers/catalog_di_providers.dart';
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

/// Diffuse le nombre de produits en rupture ou sous leur seuil de
/// réapprovisionnement — alimente le bandeau stock bas de l'accueil.
@riverpod
Stream<int> lowStockCount(Ref ref) {
  return ref
      .watch(catalogRepositoryProvider)
      .watchLowStockProducts()
      .map((products) => products.length);
}
