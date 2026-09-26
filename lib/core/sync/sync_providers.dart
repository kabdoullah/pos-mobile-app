import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../database/database_provider.dart';
import '../network/network_providers.dart';
import 'local_data_reset_service.dart';
import 'pull_service.dart';
import 'push_service.dart';
import 'sync_queue_repository.dart';

part 'sync_providers.g.dart';

/// Fournit le service de remise à zéro des données locales (wipe au changement
/// de store).
@riverpod
LocalDataResetService localDataResetService(Ref ref) {
  return LocalDataResetService(ref.read(databaseProvider));
}

/// Fournit le service de récupération des changements.
@riverpod
PullService pullService(Ref ref) {
  return PullService(
    remoteDataSource: ref.read(syncRemoteDataSourceProvider),
    db: ref.read(databaseProvider),
    logger: Logger(),
  );
}

/// Fournit le repository de la file de synchro pour gérer les synchros en
/// attente.
@riverpod
SyncQueueRepository syncQueueRepository(Ref ref) {
  return SyncQueueRepository(db: ref.read(databaseProvider));
}

/// Fournit le service d'envoi des changements locaux au serveur.
@riverpod
PushService pushService(Ref ref) {
  return PushService(
    remoteDataSource: ref.read(syncRemoteDataSourceProvider),
    queueRepository: ref.read(syncQueueRepositoryProvider),
    db: ref.read(databaseProvider),
    logger: Logger(),
  );
}

/// Nombre en direct des entrées de la file de synchro en attente ou en échec.
@riverpod
Stream<int> pendingSyncCount(Ref ref) {
  return ref.watch(syncQueueRepositoryProvider).watchPendingCount();
}
