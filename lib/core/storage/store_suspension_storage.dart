import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Mémorise qu'une boutique a été suspendue par la plateforme, pour qu'un
/// redémarrage de l'app (même hors ligne) reste bloqué jusqu'à ce que le
/// serveur confirme la réactivation.
class StoreSuspensionStorage {
  /// Crée le stockage de suspension.
  StoreSuspensionStorage({FlutterSecureStorage? secureStorage})
    : _storage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  /// Valeur : contact du support, chaîne vide s'il n'est pas configuré.
  static const _key = 'store_suspended';

  /// La suspension mémorisée, ou null si la boutique n'est pas suspendue.
  Future<({String? supportContact})?> read() async {
    final value = await _storage.read(key: _key);
    if (value == null) return null;
    return (supportContact: value.isEmpty ? null : value);
  }

  /// Mémorise la suspension avec le contact du support.
  Future<void> save(String? supportContact) =>
      _storage.write(key: _key, value: supportContact ?? '');

  /// Oublie la suspension (boutique réactivée).
  Future<void> clear() => _storage.delete(key: _key);
}
