// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_import_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Imports products in bulk from a CSV or Excel file, then triggers a full
/// sync pull so the newly created products appear in the local catalog.

@ProviderFor(importProductsFromFile)
final importProductsFromFileProvider = ImportProductsFromFileFamily._();

/// Imports products in bulk from a CSV or Excel file, then triggers a full
/// sync pull so the newly created products appear in the local catalog.

final class ImportProductsFromFileProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProductImportResult>,
          ProductImportResult,
          FutureOr<ProductImportResult>
        >
    with
        $FutureModifier<ProductImportResult>,
        $FutureProvider<ProductImportResult> {
  /// Imports products in bulk from a CSV or Excel file, then triggers a full
  /// sync pull so the newly created products appear in the local catalog.
  ImportProductsFromFileProvider._({
    required ImportProductsFromFileFamily super.from,
    required File super.argument,
  }) : super(
         retry: null,
         name: r'importProductsFromFileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$importProductsFromFileHash();

  @override
  String toString() {
    return r'importProductsFromFileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ProductImportResult> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProductImportResult> create(Ref ref) {
    final argument = this.argument as File;
    return importProductsFromFile(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ImportProductsFromFileProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$importProductsFromFileHash() =>
    r'5fd08f7bee862727a43c3feaaac04323eb6905ba';

/// Imports products in bulk from a CSV or Excel file, then triggers a full
/// sync pull so the newly created products appear in the local catalog.

final class ImportProductsFromFileFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ProductImportResult>, File> {
  ImportProductsFromFileFamily._()
    : super(
        retry: null,
        name: r'importProductsFromFileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Imports products in bulk from a CSV or Excel file, then triggers a full
  /// sync pull so the newly created products appear in the local catalog.

  ImportProductsFromFileProvider call(File file) =>
      ImportProductsFromFileProvider._(argument: file, from: this);

  @override
  String toString() => r'importProductsFromFileProvider';
}

/// Downloads a blank product import template (`csv` or `xlsx`).

@ProviderFor(downloadProductImportTemplate)
final downloadProductImportTemplateProvider =
    DownloadProductImportTemplateFamily._();

/// Downloads a blank product import template (`csv` or `xlsx`).

final class DownloadProductImportTemplateProvider
    extends
        $FunctionalProvider<
          AsyncValue<Uint8List>,
          Uint8List,
          FutureOr<Uint8List>
        >
    with $FutureModifier<Uint8List>, $FutureProvider<Uint8List> {
  /// Downloads a blank product import template (`csv` or `xlsx`).
  DownloadProductImportTemplateProvider._({
    required DownloadProductImportTemplateFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'downloadProductImportTemplateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$downloadProductImportTemplateHash();

  @override
  String toString() {
    return r'downloadProductImportTemplateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Uint8List> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Uint8List> create(Ref ref) {
    final argument = this.argument as String;
    return downloadProductImportTemplate(ref, format: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DownloadProductImportTemplateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$downloadProductImportTemplateHash() =>
    r'50afa70112581759aace31a444076a9f80454cc9';

/// Downloads a blank product import template (`csv` or `xlsx`).

final class DownloadProductImportTemplateFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Uint8List>, String> {
  DownloadProductImportTemplateFamily._()
    : super(
        retry: null,
        name: r'downloadProductImportTemplateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Downloads a blank product import template (`csv` or `xlsx`).

  DownloadProductImportTemplateProvider call({required String format}) =>
      DownloadProductImportTemplateProvider._(argument: format, from: this);

  @override
  String toString() => r'downloadProductImportTemplateProvider';
}
