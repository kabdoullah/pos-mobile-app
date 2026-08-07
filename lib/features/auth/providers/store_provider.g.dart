// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides access to the current store configuration.
///
/// Reads from and writes to flutter_secure_storage.
// keepAlive: store config is app-wide and must survive across screens.
// Without it, the provider auto-disposes during store setup (no widget
// watches it there) and `save()` throws setting state on a disposed notifier.

@ProviderFor(StoreConfig)
final storeConfigProvider = StoreConfigProvider._();

/// Provides access to the current store configuration.
///
/// Reads from and writes to flutter_secure_storage.
// keepAlive: store config is app-wide and must survive across screens.
// Without it, the provider auto-disposes during store setup (no widget
// watches it there) and `save()` throws setting state on a disposed notifier.
final class StoreConfigProvider
    extends $AsyncNotifierProvider<StoreConfig, Store?> {
  /// Provides access to the current store configuration.
  ///
  /// Reads from and writes to flutter_secure_storage.
  // keepAlive: store config is app-wide and must survive across screens.
  // Without it, the provider auto-disposes during store setup (no widget
  // watches it there) and `save()` throws setting state on a disposed notifier.
  StoreConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storeConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storeConfigHash();

  @$internal
  @override
  StoreConfig create() => StoreConfig();
}

String _$storeConfigHash() => r'bda47ffe48d56ebeacb8e744757a057648600bca';

/// Provides access to the current store configuration.
///
/// Reads from and writes to flutter_secure_storage.
// keepAlive: store config is app-wide and must survive across screens.
// Without it, the provider auto-disposes during store setup (no widget
// watches it there) and `save()` throws setting state on a disposed notifier.

abstract class _$StoreConfig extends $AsyncNotifier<Store?> {
  FutureOr<Store?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Store?>, Store?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Store?>, Store?>,
              AsyncValue<Store?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
