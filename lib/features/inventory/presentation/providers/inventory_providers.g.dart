// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the paginated stock movement history for a single product.

@ProviderFor(StockHistory)
final stockHistoryProvider = StockHistoryFamily._();

/// Manages the paginated stock movement history for a single product.
final class StockHistoryProvider
    extends $AsyncNotifierProvider<StockHistory, List<StockMovement>> {
  /// Manages the paginated stock movement history for a single product.
  StockHistoryProvider._({
    required StockHistoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stockHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stockHistoryHash();

  @override
  String toString() {
    return r'stockHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  StockHistory create() => StockHistory();

  @override
  bool operator ==(Object other) {
    return other is StockHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stockHistoryHash() => r'799ce627a91527fdaea6d9129cccaab12940a0ca';

/// Manages the paginated stock movement history for a single product.

final class StockHistoryFamily extends $Family
    with
        $ClassFamilyOverride<
          StockHistory,
          AsyncValue<List<StockMovement>>,
          List<StockMovement>,
          FutureOr<List<StockMovement>>,
          String
        > {
  StockHistoryFamily._()
    : super(
        retry: null,
        name: r'stockHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Manages the paginated stock movement history for a single product.

  StockHistoryProvider call(String productId) =>
      StockHistoryProvider._(argument: productId, from: this);

  @override
  String toString() => r'stockHistoryProvider';
}

/// Manages the paginated stock movement history for a single product.

abstract class _$StockHistory extends $AsyncNotifier<List<StockMovement>> {
  late final _$args = ref.$arg as String;
  String get productId => _$args;

  FutureOr<List<StockMovement>> build(String productId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<StockMovement>>, List<StockMovement>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<StockMovement>>, List<StockMovement>>,
              AsyncValue<List<StockMovement>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
