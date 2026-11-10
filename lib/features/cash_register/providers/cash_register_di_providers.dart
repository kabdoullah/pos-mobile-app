import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/storage/device_id_storage.dart';
import '../../../core/sync/sync_providers.dart';
import '../../../database/database_provider.dart';
import '../data/repositories/cash_register_repository_impl.dart';
import '../domain/repositories/cash_register_repository.dart';
import '../domain/usecases/close_cash_session_usecase.dart';
import '../domain/usecases/open_cash_session_usecase.dart';
import '../domain/usecases/record_cash_movement_usecase.dart';

part 'cash_register_di_providers.g.dart';

/// Fournit l'identifiant stable de l'appareil (stockage sécurisé).
@Riverpod(keepAlive: true)
DeviceIdStorage deviceIdStorage(Ref ref) => DeviceIdStorage();

/// Fournit le repository des sessions de caisse (local d'abord, via drift).
@riverpod
CashRegisterRepository cashRegisterRepository(Ref ref) {
  return CashRegisterRepositoryImpl(
    db: ref.read(databaseProvider),
    syncQueue: ref.read(syncQueueRepositoryProvider),
    deviceIdStorage: ref.read(deviceIdStorageProvider),
    remote: ref.read(cashRegisterRemoteDataSourceProvider),
  );
}

/// Fournit le cas d'usage d'ouverture de session.
@riverpod
OpenCashSessionUseCase openCashSessionUseCase(Ref ref) =>
    OpenCashSessionUseCase(
      repository: ref.read(cashRegisterRepositoryProvider),
    );

/// Fournit le cas d'usage d'enregistrement d'un mouvement d'espèces.
@riverpod
RecordCashMovementUseCase recordCashMovementUseCase(Ref ref) =>
    RecordCashMovementUseCase(
      repository: ref.read(cashRegisterRepositoryProvider),
    );

/// Fournit le cas d'usage de clôture de session.
@riverpod
CloseCashSessionUseCase closeCashSessionUseCase(Ref ref) =>
    CloseCashSessionUseCase(
      repository: ref.read(cashRegisterRepositoryProvider),
    );
