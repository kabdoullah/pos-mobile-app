// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Streams today's sales summary — re-emits automatically on every new sale.

@ProviderFor(dailySummary)
final dailySummaryProvider = DailySummaryProvider._();

/// Streams today's sales summary — re-emits automatically on every new sale.

final class DailySummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<DailySummary>,
          DailySummary,
          Stream<DailySummary>
        >
    with $FutureModifier<DailySummary>, $StreamProvider<DailySummary> {
  /// Streams today's sales summary — re-emits automatically on every new sale.
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
  $StreamProviderElement<DailySummary> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<DailySummary> create(Ref ref) {
    return dailySummary(ref);
  }
}

String _$dailySummaryHash() => r'38f9816c0a8ab44a6f89b9d17f453a714fccec5f';

/// Streams the most recent sales of the day, newest first — for the home
/// page "recent activity" mini-list.

@ProviderFor(recentSales)
final recentSalesProvider = RecentSalesProvider._();

/// Streams the most recent sales of the day, newest first — for the home
/// page "recent activity" mini-list.

final class RecentSalesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Sale>>,
          List<Sale>,
          Stream<List<Sale>>
        >
    with $FutureModifier<List<Sale>>, $StreamProvider<List<Sale>> {
  /// Streams the most recent sales of the day, newest first — for the home
  /// page "recent activity" mini-list.
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

String _$recentSalesHash() => r'add86df4d1870cad4c910f8c894286095ef7b849';

/// Streams the count of products in rupture or at/below their reorder
/// threshold — drives the home page low-stock banner.

@ProviderFor(lowStockCount)
final lowStockCountProvider = LowStockCountProvider._();

/// Streams the count of products in rupture or at/below their reorder
/// threshold — drives the home page low-stock banner.

final class LowStockCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Streams the count of products in rupture or at/below their reorder
  /// threshold — drives the home page low-stock banner.
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

String _$lowStockCountHash() => r'144ef669259133e3a60560ba23e94949483bef97';
