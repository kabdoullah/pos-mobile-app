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

/// Diffuse le nombre de produits en rupture ou sous leur seuil de
/// réapprovisionnement — alimente le bandeau stock bas de l'accueil.

@ProviderFor(lowStockCount)
final lowStockCountProvider = LowStockCountProvider._();

/// Diffuse le nombre de produits en rupture ou sous leur seuil de
/// réapprovisionnement — alimente le bandeau stock bas de l'accueil.

final class LowStockCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Diffuse le nombre de produits en rupture ou sous leur seuil de
  /// réapprovisionnement — alimente le bandeau stock bas de l'accueil.
  LowStockCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lowStockCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lowStockCountHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return lowStockCount(ref);
  }
}

String _$lowStockCountHash() => r'6ec9fe52279937a1a97d19bfbc55c91d761ddb6d';
