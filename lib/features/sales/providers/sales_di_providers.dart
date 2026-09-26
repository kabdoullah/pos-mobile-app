import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/network_providers.dart';
import '../data/repositories/sales_repository_impl.dart';
import '../domain/repositories/sales_repository.dart';
import '../domain/usecases/create_sale_usecase.dart';
import '../../../database/database_provider.dart';
import '../../../core/sync/sync_providers.dart';

part 'sales_di_providers.g.dart';

/// Fournit l'implémentation du repository des ventes (local d'abord, via
/// drift).
@riverpod
SalesRepository salesRepository(Ref ref) {
  return SalesRepositoryImpl(
    db: ref.read(databaseProvider),
    syncQueue: ref.read(syncQueueRepositoryProvider),
    dio: ref.read(dioProvider),
  );
}

/// Fournit le cas d'usage de création de vente (logique métier).
@riverpod
CreateSaleUseCase createSaleUseCase(Ref ref) {
  return CreateSaleUseCase(repository: ref.read(salesRepositoryProvider));
}
