import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/sync/sync_providers.dart';
import '../../../database/database_provider.dart';
import '../data/repositories/returns_repository_impl.dart';
import '../domain/repositories/returns_repository.dart';
import '../domain/usecases/create_sale_return_usecase.dart';

part 'returns_di_providers.g.dart';

/// Fournit le repository des retours (local d'abord, via drift).
@riverpod
ReturnsRepository returnsRepository(Ref ref) {
  return ReturnsRepositoryImpl(
    db: ref.read(databaseProvider),
    syncQueue: ref.read(syncQueueRepositoryProvider),
  );
}

/// Fournit le cas d'usage d'enregistrement d'un retour.
@riverpod
CreateSaleReturnUseCase createSaleReturnUseCase(Ref ref) {
  return CreateSaleReturnUseCase(
    repository: ref.read(returnsRepositoryProvider),
  );
}
