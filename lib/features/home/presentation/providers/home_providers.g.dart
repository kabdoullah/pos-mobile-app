// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Date du jour (minuit local). Se reconstruit au prochain minuit pour que
/// chaque provider lié à « aujourd'hui » se réabonne au changement de jour —
/// sinon un tableau de bord resté ouvert la nuit continue d'afficher la veille.

@ProviderFor(today)
final todayProvider = TodayProvider._();

/// Date du jour (minuit local). Se reconstruit au prochain minuit pour que
/// chaque provider lié à « aujourd'hui » se réabonne au changement de jour —
/// sinon un tableau de bord resté ouvert la nuit continue d'afficher la veille.

final class TodayProvider
    extends $FunctionalProvider<DateTime, DateTime, DateTime>
    with $Provider<DateTime> {
  /// Date du jour (minuit local). Se reconstruit au prochain minuit pour que
  /// chaque provider lié à « aujourd'hui » se réabonne au changement de jour —
  /// sinon un tableau de bord resté ouvert la nuit continue d'afficher la veille.
  TodayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayHash();

  @$internal
  @override
  $ProviderElement<DateTime> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DateTime create(Ref ref) {
    return today(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$todayHash() => r'312ff09771b21954125112cb793c2c1bad578aeb';

/// Diffuse les totaux de ventes du jour — réémet automatiquement à chaque
/// nouvelle vente.

@ProviderFor(dailySummary)
final dailySummaryProvider = DailySummaryProvider._();

/// Diffuse les totaux de ventes du jour — réémet automatiquement à chaque
/// nouvelle vente.

final class DailySummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<DailyStats>,
          DailyStats,
          Stream<DailyStats>
        >
    with $FutureModifier<DailyStats>, $StreamProvider<DailyStats> {
  /// Diffuse les totaux de ventes du jour — réémet automatiquement à chaque
  /// nouvelle vente.
  DailySummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailySummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailySummaryHash();

  @$internal
  @override
  $StreamProviderElement<DailyStats> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<DailyStats> create(Ref ref) {
    return dailySummary(ref);
  }
}

String _$dailySummaryHash() => r'6ae9c0c466860e62c16e2e937e07c97bc371d7cb';

/// Diffuse chiffre d'affaires, coût d'achat et marge brute du jour (ADR-0009).
///
/// Prêt pour le tableau de bord ; aucun écran ne l'affiche encore.

@ProviderFor(todayMarginSummary)
final todayMarginSummaryProvider = TodayMarginSummaryProvider._();

/// Diffuse chiffre d'affaires, coût d'achat et marge brute du jour (ADR-0009).
///
/// Prêt pour le tableau de bord ; aucun écran ne l'affiche encore.

final class TodayMarginSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<MarginSummary>,
          MarginSummary,
          Stream<MarginSummary>
        >
    with $FutureModifier<MarginSummary>, $StreamProvider<MarginSummary> {
  /// Diffuse chiffre d'affaires, coût d'achat et marge brute du jour (ADR-0009).
  ///
  /// Prêt pour le tableau de bord ; aucun écran ne l'affiche encore.
  TodayMarginSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayMarginSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayMarginSummaryHash();

  @$internal
  @override
  $StreamProviderElement<MarginSummary> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<MarginSummary> create(Ref ref) {
    return todayMarginSummary(ref);
  }
}

String _$todayMarginSummaryHash() =>
    r'd78c80db9ed3d54371eab8ada6b3ed5924486e44';

/// Diffuse les ventes les plus récentes du jour, de la plus récente à la plus
/// ancienne — pour la mini-liste « activité récente » de l'accueil.

@ProviderFor(recentSales)
final recentSalesProvider = RecentSalesProvider._();

/// Diffuse les ventes les plus récentes du jour, de la plus récente à la plus
/// ancienne — pour la mini-liste « activité récente » de l'accueil.

final class RecentSalesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Sale>>,
          List<Sale>,
          Stream<List<Sale>>
        >
    with $FutureModifier<List<Sale>>, $StreamProvider<List<Sale>> {
  /// Diffuse les ventes les plus récentes du jour, de la plus récente à la plus
  /// ancienne — pour la mini-liste « activité récente » de l'accueil.
  RecentSalesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentSalesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentSalesHash();

  @$internal
  @override
  $StreamProviderElement<List<Sale>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Sale>> create(Ref ref) {
    return recentSales(ref);
  }
}

String _$recentSalesHash() => r'873d362435a91ec85a763315a8a91ba61d9da61d';

/// Diffuse les produits en rupture ou sous leur seuil, ruptures d'abord —
/// alimente la section « Stock faible » de l'accueil (aperçu + compteur).

@ProviderFor(homeLowStock)
final homeLowStockProvider = HomeLowStockProvider._();

/// Diffuse les produits en rupture ou sous leur seuil, ruptures d'abord —
/// alimente la section « Stock faible » de l'accueil (aperçu + compteur).

final class HomeLowStockProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          Stream<List<Product>>
        >
    with $FutureModifier<List<Product>>, $StreamProvider<List<Product>> {
  /// Diffuse les produits en rupture ou sous leur seuil, ruptures d'abord —
  /// alimente la section « Stock faible » de l'accueil (aperçu + compteur).
  HomeLowStockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeLowStockProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeLowStockHash();

  @$internal
  @override
  $StreamProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Product>> create(Ref ref) {
    return homeLowStock(ref);
  }
}

String _$homeLowStockHash() => r'1db951c11e8a82bf9e60705f2cd256bc42f231d1';
