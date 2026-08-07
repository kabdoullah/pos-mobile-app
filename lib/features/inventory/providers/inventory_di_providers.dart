import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/network_providers.dart';
import '../../sync/presentation/providers/sync_providers.dart';
import '../data/datasources/inventory_remote_datasource.dart';
import '../data/repositories/inventory_repository_impl.dart';
import '../domain/repositories/inventory_repository.dart';

part 'inventory_di_providers.g.dart';

/// Provides the inventory repository implementation (online-only).
@riverpod
InventoryRepository inventoryRepository(Ref ref) {
  return InventoryRepositoryImpl(
    remoteDataSource: InventoryRemoteDataSource(ref.watch(dioProvider)),
    db: ref.watch(databaseProvider),
  );
}
