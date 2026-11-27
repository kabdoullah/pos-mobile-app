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
/// Alimente « Bénéfice estimé » et « Marge moyenne » de l'accueil.

@ProviderFor(todayMarginSummary)
final todayMarginSummaryProvider = TodayMarginSummaryProvider._();

/// Diffuse chiffre d'affaires, coût d'achat et marge brute du jour (ADR-0009).
///
/// Alimente « Bénéfice estimé » et « Marge moyenne » de l'accueil.

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
  /// Alimente « Bénéfice estimé » et « Marge moyenne » de l'accueil.
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

/// Diffuse le montant des ventes du jour heure par heure (24 cases, index =
/// heure locale) — donne l'heure de pointe (« Pic ») de l'accueil.

@ProviderFor(todayHourlySales)
final todayHourlySalesProvider = TodayHourlySalesProvider._();

/// Diffuse le montant des ventes du jour heure par heure (24 cases, index =
/// heure locale) — donne l'heure de pointe (« Pic ») de l'accueil.

final class TodayHourlySalesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Decimal>>,
          List<Decimal>,
          Stream<List<Decimal>>
        >
    with $FutureModifier<List<Decimal>>, $StreamProvider<List<Decimal>> {
  /// Diffuse le montant des ventes du jour heure par heure (24 cases, index =
  /// heure locale) — donne l'heure de pointe (« Pic ») de l'accueil.
  TodayHourlySalesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayHourlySalesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayHourlySalesHash();

  @$internal
  @override
  $StreamProviderElement<List<Decimal>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Decimal>> create(Ref ref) {
    return todayHourlySales(ref);
  }
}

String _$todayHourlySalesHash() => r'f21d5e305c74dba9e5ba56e2f01ae8c602487e12';

/// Diffuse les articles des ventes du jour, groupés par id de vente — résumé
/// « Riz ×2, Pain » des dernières ventes de l'accueil.

@ProviderFor(todaySaleItems)
final todaySaleItemsProvider = TodaySaleItemsProvider._();

/// Diffuse les articles des ventes du jour, groupés par id de vente — résumé
/// « Riz ×2, Pain » des dernières ventes de l'accueil.

final class TodaySaleItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, List<SaleItemBrief>>>,
          Map<String, List<SaleItemBrief>>,
          Stream<Map<String, List<SaleItemBrief>>>
        >
    with
        $FutureModifier<Map<String, List<SaleItemBrief>>>,
        $StreamProvider<Map<String, List<SaleItemBrief>>> {
  /// Diffuse les articles des ventes du jour, groupés par id de vente — résumé
  /// « Riz ×2, Pain » des dernières ventes de l'accueil.
  TodaySaleItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todaySaleItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todaySaleItemsHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, List<SaleItemBrief>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, List<SaleItemBrief>>> create(Ref ref) {
    return todaySaleItems(ref);
  }
}

String _$todaySaleItemsHash() => r'b295d97a4187cd6c7d3ae9bb267a15457aaa7e25';

/// Diffuse le montant brut des ventes d'hier jusqu'à l'heure qu'il est —
/// comparer une demi-journée à une journée entière tromperait (« − 70 % » à
/// 10 h). Se recalcule toutes les 5 minutes et au changement de jour.

@ProviderFor(yesterdayAtSameTime)
final yesterdayAtSameTimeProvider = YesterdayAtSameTimeProvider._();

/// Diffuse le montant brut des ventes d'hier jusqu'à l'heure qu'il est —
/// comparer une demi-journée à une journée entière tromperait (« − 70 % » à
/// 10 h). Se recalcule toutes les 5 minutes et au changement de jour.

final class YesterdayAtSameTimeProvider
    extends
        $FunctionalProvider<
          AsyncValue<SameTimeTotal>,
          SameTimeTotal,
          Stream<SameTimeTotal>
        >
    with $FutureModifier<SameTimeTotal>, $StreamProvider<SameTimeTotal> {
  /// Diffuse le montant brut des ventes d'hier jusqu'à l'heure qu'il est —
  /// comparer une demi-journée à une journée entière tromperait (« − 70 % » à
  /// 10 h). Se recalcule toutes les 5 minutes et au changement de jour.
  YesterdayAtSameTimeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'yesterdayAtSameTimeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$yesterdayAtSameTimeHash();

  @$internal
  @override
  $StreamProviderElement<SameTimeTotal> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<SameTimeTotal> create(Ref ref) {
    return yesterdayAtSameTime(ref);
  }
}

String _$yesterdayAtSameTimeHash() =>
    r'9c3d4d8bac11c45bb6c143df6c99e089aa03f1b3';

/// Diffuse le récapitulatif d'hier (journée entière) — bloc « Hier » de
/// l'accueil tant que la caisse est fermée et qu'aucune vente n'est faite.

@ProviderFor(yesterdayRecap)
final yesterdayRecapProvider = YesterdayRecapProvider._();

/// Diffuse le récapitulatif d'hier (journée entière) — bloc « Hier » de
/// l'accueil tant que la caisse est fermée et qu'aucune vente n'est faite.

final class YesterdayRecapProvider
    extends
        $FunctionalProvider<AsyncValue<DayRecap>, DayRecap, Stream<DayRecap>>
    with $FutureModifier<DayRecap>, $StreamProvider<DayRecap> {
  /// Diffuse le récapitulatif d'hier (journée entière) — bloc « Hier » de
  /// l'accueil tant que la caisse est fermée et qu'aucune vente n'est faite.
  YesterdayRecapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'yesterdayRecapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$yesterdayRecapHash();

  @$internal
  @override
  $StreamProviderElement<DayRecap> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<DayRecap> create(Ref ref) {
    return yesterdayRecap(ref);
  }
}

String _$yesterdayRecapHash() => r'533cd10883a3b9419203475aaff892356a976400';

/// Diffuse chiffre d'affaires et marge d'hier (bloc « Hier » de l'accueil).

@ProviderFor(yesterdayMarginSummary)
final yesterdayMarginSummaryProvider = YesterdayMarginSummaryProvider._();

/// Diffuse chiffre d'affaires et marge d'hier (bloc « Hier » de l'accueil).

final class YesterdayMarginSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<MarginSummary>,
          MarginSummary,
          Stream<MarginSummary>
        >
    with $FutureModifier<MarginSummary>, $StreamProvider<MarginSummary> {
  /// Diffuse chiffre d'affaires et marge d'hier (bloc « Hier » de l'accueil).
  YesterdayMarginSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'yesterdayMarginSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$yesterdayMarginSummaryHash();

  @$internal
  @override
  $StreamProviderElement<MarginSummary> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<MarginSummary> create(Ref ref) {
    return yesterdayMarginSummary(ref);
  }
}

String _$yesterdayMarginSummaryHash() =>
    r'f74ef6ff3a7995a48f8a2d9538c331a4da87fbc1';

/// Diffuse s'il existe au moins une vente sur l'appareil — dernière étape
/// des « Premiers pas » de l'accueil.

@ProviderFor(hasAnySale)
final hasAnySaleProvider = HasAnySaleProvider._();

/// Diffuse s'il existe au moins une vente sur l'appareil — dernière étape
/// des « Premiers pas » de l'accueil.

final class HasAnySaleProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Diffuse s'il existe au moins une vente sur l'appareil — dernière étape
  /// des « Premiers pas » de l'accueil.
  HasAnySaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasAnySaleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasAnySaleHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return hasAnySale(ref);
  }
}

String _$hasAnySaleHash() => r'8bedc3957d9aa1991315532bf7f860da2ebed4ff';

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

/// « Premiers pas » masqués par le compte connecté (préférence liée au
/// compte : gardée à la reconnexion, jamais héritée par un autre compte).
/// Écrit par la section qui le regarde : pas de risque de libération pendant
/// l'écriture.

@ProviderFor(FirstStepsHidden)
final firstStepsHiddenProvider = FirstStepsHiddenProvider._();

/// « Premiers pas » masqués par le compte connecté (préférence liée au
/// compte : gardée à la reconnexion, jamais héritée par un autre compte).
/// Écrit par la section qui le regarde : pas de risque de libération pendant
/// l'écriture.
final class FirstStepsHiddenProvider
    extends $AsyncNotifierProvider<FirstStepsHidden, bool> {
  /// « Premiers pas » masqués par le compte connecté (préférence liée au
  /// compte : gardée à la reconnexion, jamais héritée par un autre compte).
  /// Écrit par la section qui le regarde : pas de risque de libération pendant
  /// l'écriture.
  FirstStepsHiddenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firstStepsHiddenProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firstStepsHiddenHash();

  @$internal
  @override
  FirstStepsHidden create() => FirstStepsHidden();
}

String _$firstStepsHiddenHash() => r'1b42d3c6b2c38c1d9b4404d0dbed02439993c213';

/// « Premiers pas » masqués par le compte connecté (préférence liée au
/// compte : gardée à la reconnexion, jamais héritée par un autre compte).
/// Écrit par la section qui le regarde : pas de risque de libération pendant
/// l'écriture.

abstract class _$FirstStepsHidden extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
