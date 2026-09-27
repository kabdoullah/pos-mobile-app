// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages Bluetooth printer connection lifecycle and printing.
///
/// keepAlive : un seul lien BT pour toute l'app. Les pages de reçu appellent
/// [print] sans écouter ce provider — une instance auto-dispose serait
/// recréée (puis libérée) à chaque impression.

@ProviderFor(Printer)
final printerProvider = PrinterProvider._();

/// Manages Bluetooth printer connection lifecycle and printing.
///
/// keepAlive : un seul lien BT pour toute l'app. Les pages de reçu appellent
/// [print] sans écouter ce provider — une instance auto-dispose serait
/// recréée (puis libérée) à chaque impression.
final class PrinterProvider extends $NotifierProvider<Printer, PrinterState> {
  /// Manages Bluetooth printer connection lifecycle and printing.
  ///
  /// keepAlive : un seul lien BT pour toute l'app. Les pages de reçu appellent
  /// [print] sans écouter ce provider — une instance auto-dispose serait
  /// recréée (puis libérée) à chaque impression.
  PrinterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'printerProvider',
        isAutoDispose: false,
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

String _$printerHash() => r'dbc4604156c154b89a20f33e93b918892e771fb1';

/// Manages Bluetooth printer connection lifecycle and printing.
///
/// keepAlive : un seul lien BT pour toute l'app. Les pages de reçu appellent
/// [print] sans écouter ce provider — une instance auto-dispose serait
/// recréée (puis libérée) à chaque impression.

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
