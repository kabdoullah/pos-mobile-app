import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/repositories/profile_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_models.dart';

/// Clés du cache du profil dans flutter_secure_storage.
abstract class _ProfileKeys {
  static const String displayName = 'profile_display_name';

  /// Marque que le profil a été chargé (un nom null est aussi une réponse).
  static const String loaded = 'profile_loaded';
}

/// Implémentation de [ProfileRepository] : cache secure storage devant l'API
/// `/users/me`.
class ProfileRepositoryImpl implements ProfileRepository {
  /// Crée un ProfileRepositoryImpl.
  ProfileRepositoryImpl({
    required this.remoteDataSource,
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  /// Data source distante (API `/users/me`).
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage _storage;

  @override
  Future<String?> getDisplayName() async {
    if (await _storage.read(key: _ProfileKeys.loaded) == 'true') {
      return _storage.read(key: _ProfileKeys.displayName);
    }
    try {
      final me = await remoteDataSource.getMe();
      await _writeLocal(me.displayName);
      return me.displayName;
    } on Exception {
      // Hors ligne au premier lancement : pas de nom, on réessaiera.
      return null;
    }
  }

  @override
  Future<String?> updateDisplayName(String? displayName) async {
    final trimmed = displayName?.trim();
    final me = await remoteDataSource.updateMe(
      UserMeUpdateDto(
        displayName: trimmed == null || trimmed.isEmpty ? null : trimmed,
      ),
    );
    await _writeLocal(me.displayName);
    return me.displayName;
  }

  @override
  Future<void> clearLocal() async {
    await _storage.delete(key: _ProfileKeys.displayName);
    await _storage.delete(key: _ProfileKeys.loaded);
  }

  Future<void> _writeLocal(String? displayName) async {
    await _storage.write(key: _ProfileKeys.displayName, value: displayName);
    await _storage.write(key: _ProfileKeys.loaded, value: 'true');
  }
}
