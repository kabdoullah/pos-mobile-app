// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages Bluetooth printer connection lifecycle and printing.

@ProviderFor(Printer)
final printerProvider = PrinterProvider._();

/// Manages Bluetooth printer connection lifecycle and printing.
final class PrinterProvider extends $NotifierProvider<Printer, PrinterState> {
  /// Manages Bluetooth printer connection lifecycle and printing.
  PrinterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'printerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$printerHash();

  @$internal
  @override
  Printer create() => Printer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrinterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrinterState>(value),
    );
  }
}

String _$printerHash() => r'b052bb4b6bfc82dc4fa78251061fc19586337553';

/// Manages Bluetooth printer connection lifecycle and printing.

abstract class _$Printer extends $Notifier<PrinterState> {
  PrinterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PrinterState, PrinterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PrinterState, PrinterState>,
              PrinterState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
