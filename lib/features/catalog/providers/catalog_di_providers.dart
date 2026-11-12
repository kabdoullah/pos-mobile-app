import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/network_providers.dart';
import '../data/repositories/barcode_reference_repository_impl.dart';
import '../data/repositories/catalog_repository_impl.dart';
import '../domain/repositories/barcode_reference_repository.dart';
import '../domain/repositories/catalog_repository.dart';
import '../../../database/database_provider.dart';
import '../../../core/sync/sync_providers.dart';

part 'catalog_di_providers.g.dart';

/// Fournit l'implémentation du repository catalogue (local d'abord, via drift).
@riverpod
CatalogRepository catalogRepository(Ref ref) {
  return CatalogRepositoryImpl(
    db: ref.watch(databaseProvider),
    syncQueue: ref.watch(syncQueueRepositoryProvider),
    dio: ref.watch(dioProvider),
  );
}

/// Fournit le référentiel de codes-barres embarqué. Gardé en vie : le
/// référentiel (~5 000 entrées) n'est décodé qu'une fois par session.
@Riverpod(keepAlive: true)
BarcodeReferenceRepository barcodeReferenceRepository(Ref ref) {
  return BarcodeReferenceRepositoryImpl(
    // cache: false : la Map décodée suffit, inutile de garder aussi la chaîne
    // (~230 Ko) — ni un échec de lecture — dans le cache du bundle.
    loadJson: () => rootBundle.loadString(
      BarcodeReferenceRepositoryImpl.assetPath,
      cache: false,
    ),
  );
}
