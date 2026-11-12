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

/// Diffuse la vente la plus récente du jour, null avant la première —
/// l'heure de la dernière vente s'affiche sur l'accueil.

@ProviderFor(lastSaleToday)
final lastSaleTodayProvider = LastSaleTodayProvider._();

/// Diffuse la vente la plus récente du jour, null avant la première —
/// l'heure de la dernière vente s'affiche sur l'accueil.

final class LastSaleTodayProvider
    extends $FunctionalProvider<AsyncValue<Sale?>, Sale?, Stream<Sale?>>
    with $FutureModifier<Sale?>, $StreamProvider<Sale?> {
  /// Diffuse la vente la plus récente du jour, null avant la première —
  /// l'heure de la dernière vente s'affiche sur l'accueil.
  LastSaleTodayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastSaleTodayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastSaleTodayHash();

  @$internal
  @override
  $StreamProviderElement<Sale?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Sale?> create(Ref ref) {
    return lastSaleToday(ref);
  }
}

String _$lastSaleTodayHash() => r'b39306d40f127bf9c3b9f5d2760626ed8dd315e1';

/// Diffuse les produits en rupture ou sous leur seuil, ruptures d'abord —
/// alimente les « Alertes de stock » de l'accueil.

@ProviderFor(homeLowStock)
final homeLowStockProvider = HomeLowStockProvider._();

/// Diffuse les produits en rupture ou sous leur seuil, ruptures d'abord —
/// alimente les « Alertes de stock » de l'accueil.

final class HomeLowStockProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          Stream<List<Product>>
        >
    with $FutureModifier<List<Product>>, $StreamProvider<List<Product>> {
  /// Diffuse les produits en rupture ou sous leur seuil, ruptures d'abord —
  /// alimente les « Alertes de stock » de l'accueil.
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
