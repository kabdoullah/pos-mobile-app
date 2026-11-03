import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../domain/app_update_repository.dart';
import 'app_update_local_datasource.dart';
import 'app_update_remote_datasource.dart';

/// Implémentation : build installé via `package_info_plus`, minimum via le
/// serveur avec repli sur la dernière valeur mémorisée.
class AppUpdateRepositoryImpl implements AppUpdateRepository {
  /// Crée le repository.
  AppUpdateRepositoryImpl({
    required AppUpdateRemoteDataSource remote,
    required AppUpdateLocalDataSource local,
    Future<String> Function()? readBuildNumber,
  }) : _remote = remote,
       _local = local,
       _readBuildNumber =
           readBuildNumber ??
           (() async => (await PackageInfo.fromPlatform()).buildNumber);

  final AppUpdateRemoteDataSource _remote;
  final AppUpdateLocalDataSource _local;
  final Future<String> Function() _readBuildNumber;
  final _logger = Logger();

  @override
  Future<int?> installedBuild() async {
    try {
      return int.tryParse(await _readBuildNumber());
    } on Exception catch (e) {
      _logger.w('Build installé illisible', error: e);
      return null;
    }
  }

  @override
  Future<int?> cachedMinBuild() async {
    try {
      return await _local.read();
    } on Exception catch (e) {
      _logger.w('Build minimal mémorisé illisible', error: e);
      return null;
    }
  }

  @override
  Future<int?> fetchMinBuild() async {
    final minBuild = await _remote.fetchMinBuild();
    if (minBuild != null) {
      try {
        await _local.save(minBuild);
      } on Exception catch (e) {
        // Le blocage s'applique quand même pour cette session.
        _logger.w('Build minimal non mémorisé', error: e);
      }
    }
    return minBuild;
  }
}
