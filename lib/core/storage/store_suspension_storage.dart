import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Contacts du support mémorisés avec la suspension.
typedef StoredSuspension = ({String? supportContact, String? supportWhatsApp});

/// Mémorise qu'une boutique a été suspendue par la plateforme, pour qu'un
/// redémarrage de l'app (même hors ligne) reste bloqué jusqu'à ce que le
/// serveur confirme la réactivation.
class StoreSuspensionStorage {
  /// Crée le stockage de suspension.
  StoreSuspensionStorage({FlutterSecureStorage? secureStorage})
    : _storage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  /// Valeur : JSON `{"contact": …, "whatsapp": …}`.
  static const _key = 'store_suspended';

  /// La suspension mémorisée, ou null si la boutique n'est pas suspendue.
  Future<StoredSuspension?> read() async {
    final value = await _storage.read(key: _key);
    if (value == null) return null;
    try {
      final data = jsonDecode(value) as Map<String, dynamic>;
      return (
        supportContact: data['contact'] as String?,
        supportWhatsApp: data['whatsapp'] as String?,
      );
    } catch (_) {
      // Valeur illisible : la suspension reste mémorisée, sans contact.
      return (supportContact: null, supportWhatsApp: null);
    }
  }

  /// Mémorise la suspension avec les contacts du support.
  Future<void> save({String? supportContact, String? supportWhatsApp}) =>
      _storage.write(
        key: _key,
        value: jsonEncode({
          'contact': supportContact,
          'whatsapp': supportWhatsApp,
        }),
      );

  /// Oublie la suspension (boutique réactivée).
  Future<void> clear() => _storage.delete(key: _key);
}
