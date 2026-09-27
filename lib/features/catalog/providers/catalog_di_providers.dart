import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/network_providers.dart';
import '../data/repositories/catalog_repository_impl.dart';
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
    imageCache: ref.watch(imageFileCacheProvider),
  );
}
