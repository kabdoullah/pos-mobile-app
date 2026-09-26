import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/network_providers.dart';
import '../data/datasources/inventory_remote_datasource.dart';
import '../data/repositories/inventory_repository_impl.dart';
import '../domain/repositories/inventory_repository.dart';
import '../../../database/database_provider.dart';

part 'inventory_di_providers.g.dart';

/// Fournit l'implémentation du repository d'inventaire (en ligne uniquement).
@riverpod
InventoryRepository inventoryRepository(Ref ref) {
  return InventoryRepositoryImpl(
    remoteDataSource: InventoryRemoteDataSource(ref.watch(dioProvider)),
    db: ref.watch(databaseProvider),
  );
}
