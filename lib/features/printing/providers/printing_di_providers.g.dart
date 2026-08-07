// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printing_di_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides a singleton [PrinterRepository] implementation.
///
/// Returns the abstract interface; consumers should not depend on
/// the concrete [PrinterService] implementation.

@ProviderFor(printerRepository)
final printerRepositoryProvider = PrinterRepositoryProvider._();

/// Provides a singleton [PrinterRepository] implementation.
///
/// Returns the abstract interface; consumers should not depend on
/// the concrete [PrinterService] implementation.

final class PrinterRepositoryProvider
    extends
        $FunctionalProvider<
          PrinterRepository,
          PrinterRepository,
          PrinterRepository
        >
    with $Provider<PrinterRepository> {
  /// Provides a singleton [PrinterRepository] implementation.
  ///
  /// Returns the abstract interface; consumers should not depend on
  /// the concrete [PrinterService] implementation.
  PrinterRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'printerRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$printerRepositoryHash();

  @$internal
  @override
  $ProviderElement<PrinterRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PrinterRepository create(Ref ref) {
    return printerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrinterRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrinterRepository>(value),
    );
  }
}

String _$printerRepositoryHash() => r'12dc50495b14aa16f4be73503fba9626d3b6cd7b';
