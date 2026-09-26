/// Abstraction de la persistance sécurisée des tokens (JWT).
/// Implémentation (SecureTokenStorage) reportée à la phase suivante.
abstract interface class TokenStorage {
  /// Récupère l'access token depuis le secure storage, ou null s'il est absent.
  Future<String?> getAccessToken();

  /// Récupère le refresh token depuis le secure storage, ou null s'il est
  /// absent.
  Future<String?> getRefreshToken();

  /// Enregistre l'access token et le refresh token dans le secure storage.
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  /// Efface tous les tokens enregistrés (déconnexion).
  Future<void> clearTokens();

  /// Récupère l'id de la boutique active, ou null s'il n'est pas défini.
  Future<String?> getStoreId();
}
