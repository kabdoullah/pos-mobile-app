import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

/// Identifiant stable de l'appareil pour les sessions de caisse.
///
/// Stocké dans le stockage sécurisé, hors de Drift : il survit donc à
/// `wipeBusinessData`.
class DeviceIdStorage {
  /// Crée le stockage de l'identifiant d'appareil.
  DeviceIdStorage({FlutterSecureStorage? secureStorage})
    : _storage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _key = 'cash_device_id';

  /// L'identifiant de l'appareil, créé (UUID v4) au premier appel.
  Future<String> getOrCreate() async {
    final existing = await _storage.read(key: _key);
    if (existing != null && existing.isNotEmpty) return existing;
    final id = const Uuid().v4();
    await _storage.write(key: _key, value: id);
    return id;
  }
}
