import 'dart:io';
import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/sync/sync_orchestrator.dart';
import '../../domain/entities/product_import_result.dart';
import '../../providers/catalog_di_providers.dart';

part 'product_import_providers.g.dart';

/// Importe des produits en masse depuis un fichier CSV ou Excel, puis déclenche
/// un pull de synchro complet pour que les nouveaux produits apparaissent dans
/// le catalogue local.
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

/// Télécharge un modèle d'import produits vierge (`csv` ou `xlsx`).
@riverpod
Future<Uint8List> downloadProductImportTemplate(
  Ref ref, {
  required String format,
}) {
  return ref
      .read(catalogRepositoryProvider)
      .downloadImportTemplate(format: format);
}
