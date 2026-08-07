// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages barcode scanning: cooldown deduplication, catalog lookup, cart dispatch.

@ProviderFor(ScanController)
final scanControllerProvider = ScanControllerProvider._();

/// Manages barcode scanning: cooldown deduplication, catalog lookup, cart dispatch.
final class ScanControllerProvider
    extends $NotifierProvider<ScanController, void> {
  /// Manages barcode scanning: cooldown deduplication, catalog lookup, cart dispatch.
  ScanControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanControllerHash();

  @$internal
  @override
  ScanController create() => ScanController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$scanControllerHash() => r'7cf9ebe8ae40e742049e469a36d4222f1415cfc0';

/// Manages barcode scanning: cooldown deduplication, catalog lookup, cart dispatch.

abstract class _$ScanController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
