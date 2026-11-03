import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/app_update_local_datasource.dart';
import '../data/app_update_remote_datasource.dart';
import '../data/app_update_repository_impl.dart';
import '../domain/app_update_repository.dart';

part 'app_update_di_providers.g.dart';

/// Fournit le repository de la mise à jour obligatoire.
@Riverpod(keepAlive: true)
AppUpdateRepository appUpdateRepository(Ref ref) {
  return AppUpdateRepositoryImpl(
    remote: AppUpdateRemoteDataSource(),
    local: AppUpdateLocalDataSource(),
  );
}
