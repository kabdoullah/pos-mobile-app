import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../network/token_storage.dart';

/// Clés de stockage des tokens JWT dans le secure storage.
abstract class _TokenStorageKeys {
  /// Access token (JWT de courte durée).
  static const String accessToken = 'access_token';

  /// Refresh token (JWT de longue durée).
  static const String refreshToken = 'refresh_token';

  /// ID utilisateur extrait du payload JWT.
  static const String userId = 'user_id';

  /// ID de boutique extrait du payload JWT.
  static const String storeId = 'store_id';

  /// Numéro de téléphone enregistré à la connexion (identifiant principal).
  static const String phoneNumber = 'phone_number';

  /// ID du compte inscrit sur cet appareil dont la boutique reste à
  /// configurer. Volontairement conservé par [SecureTokenStorage.clearTokens] :
  /// lié à un compte, il ne vaut que pour lui s'il se reconnecte.
  static const String storeSetupPendingUserId = 'store_setup_pending_user_id';
}

/// Implémentation concrète de TokenStorage avec flutter_secure_storage.
/// Extrait et enregistre aussi user_id et store_id depuis le payload JWT.
class SecureTokenStorage implements TokenStorage {
  /// Crée une instance SecureTokenStorage.
  SecureTokenStorage({FlutterSecureStorage? secureStorage})
    : _storage = secureStorage ?? const FlutterSecureStorage();

  /// Backend de stockage sécurisé sous-jacent.
  final FlutterSecureStorage _storage;

  @override
  Future<String?> getAccessToken() =>
      _storage.read(key: _TokenStorageKeys.accessToken);

  @override
  Future<String?> getRefreshToken() =>
      _storage.read(key: _TokenStorageKeys.refreshToken);

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    // Extrait user_id et store_id du payload de l'access token.
    final (userId: userId, storeId: storeId) = _extractClaimsFromJwt(
      accessToken,
    );

    await Future.wait([
      _storage.write(key: _TokenStorageKeys.accessToken, value: accessToken),
      _storage.write(key: _TokenStorageKeys.refreshToken, value: refreshToken),
      if (userId != null)
        _storage.write(key: _TokenStorageKeys.userId, value: userId),
      if (storeId != null)
        _storage.write(key: _TokenStorageKeys.storeId, value: storeId),
    ]);
  }

  @override
  Future<void> clearTokens() => Future.wait([
    _storage.delete(key: _TokenStorageKeys.accessToken),
    _storage.delete(key: _TokenStorageKeys.refreshToken),
    _storage.delete(key: _TokenStorageKeys.userId),
    _storage.delete(key: _TokenStorageKeys.storeId),
    _storage.delete(key: _TokenStorageKeys.phoneNumber),
    // Nettoyage de l'ancienne clé pour les utilisateurs qui avaient un email
    // enregistré avant la migration vers le téléphone.
    _storage.delete(key: 'email'),
  ]);

  /// Récupère l'ID utilisateur enregistré.
  Future<String?> getUserId() => _storage.read(key: _TokenStorageKeys.userId);

  /// Récupère l'ID de boutique enregistré.
  @override
  Future<String?> getStoreId() => _storage.read(key: _TokenStorageKeys.storeId);

  /// Enregistre le numéro de téléphone de l'utilisateur (appelé après une
  /// connexion/inscription réussie).
  Future<void> savePhone(String phoneNumber) =>
      _storage.write(key: _TokenStorageKeys.phoneNumber, value: phoneNumber);

  /// Récupère le numéro de téléphone enregistré de l'utilisateur.
  Future<String?> getPhone() =>
      _storage.read(key: _TokenStorageKeys.phoneNumber);

  /// Marque la configuration de la boutique comme en attente pour [userId].
  Future<void> saveStoreSetupPending(String userId) => _storage.write(
    key: _TokenStorageKeys.storeSetupPendingUserId,
    value: userId,
  );

  /// ID du compte dont la configuration de la boutique est en attente.
  Future<String?> getStoreSetupPendingUserId() =>
      _storage.read(key: _TokenStorageKeys.storeSetupPendingUserId);

  /// Efface l'indicateur de configuration de la boutique en attente.
  Future<void> clearStoreSetupPending() =>
      _storage.delete(key: _TokenStorageKeys.storeSetupPendingUserId);

  /// Extrait user_id (sub) et store_id d'un access token JWT.
  /// Ne vérifie PAS la signature (responsabilité du serveur).
  ({String? userId, String? storeId}) _extractClaimsFromJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return (userId: null, storeId: null);

      // Décode le payload (partie centrale).
      final payload = parts[1];
      // Ajoute le padding si nécessaire (le base64url peut omettre les =
      // finaux).
      final padded = payload.padRight((payload.length + 3) ~/ 4 * 4, '=');

      final decoded = utf8.decode(base64Url.decode(padded));
      final json = jsonDecode(decoded) as Map<String, dynamic>;

      return (
        userId: json['sub'] as String?,
        storeId: json['store_id'] as String?,
      );
    } catch (_) {
      return (userId: null, storeId: null);
    }
  }
}
