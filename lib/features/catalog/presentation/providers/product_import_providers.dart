import 'dart:io';
import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/sync/sync_orchestrator.dart';
import '../../domain/entities/product_import_result.dart';
import '../../providers/catalog_di_providers.dart';

part 'product_import_providers.g.dart';

/// Imports products in bulk from a CSV or Excel file, then triggers a full
/// sync pull so the newly created products appear in the local catalog.
@riverpod
Future<ProductImportResult> importProductsFromFile(Ref ref, File file) async {
  final result = await ref
      .read(catalogRepositoryProvider)
      .importProductsFromFile(file);
  await ref
      .read(syncOrchestratorProvider.notifier)
      .syncNow(forceFullPull: true);
  return result;
}

/// Downloads a blank product import template (`csv` or `xlsx`).
@riverpod
Future<Uint8List> downloadProductImportTemplate(
  Ref ref, {
  required String format,
}) {
  return ref
      .read(catalogRepositoryProvider)
      .downloadImportTemplate(format: format);
}
