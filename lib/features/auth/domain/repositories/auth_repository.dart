import '../entities/user.dart';

/// Interface du repository auth. Implémenté dans la couche `data`.
abstract class AuthRepository {
  /// Crée un compte utilisateur. Email optionnel (récupération de compte uniquement).
  ///
  /// Marque aussi la configuration de la boutique comme en attente pour ce
  /// compte (voir [isStoreSetupPending]).
  Future<User> register({
    required String phoneNumber,
    required String password,
    String? email,
  });

  /// Authentifie via numéro de téléphone + mot de passe.
  /// Stocke les tokens en secure storage.
  Future<User> login({required String phoneNumber, required String password});

  /// Définit le PIN local après la première connexion.
  Future<void> setupPin(String pin);

  /// Vérifie le PIN saisi par l'utilisateur.
  ///
  /// Se termine normalement si le PIN est correct. Lève `WrongPin` (avec les
  /// tentatives restantes) ou `PinLocked` (avec la fin du blocage) sinon.
  Future<void> verifyPin(String pin);

  /// Fin du blocage du PIN en cours, ou null si le PIN n'est pas bloqué.
  Future<DateTime?> pinLockedUntil();

  /// Demande un email de réinitialisation de mot de passe.
  Future<void> sendPasswordReset(String email);

  /// Déconnecte l'utilisateur (efface tokens et PIN).
  Future<void> logout();

  /// Récupère l'utilisateur courant si authentifié.
  Future<User?> getCurrentUser();

  /// True si un PIN est défini sur cet appareil.
  Future<bool> hasPinSetup();

  /// True si le compte connecté s'est inscrit sur cet appareil sans avoir
  /// encore configuré sa boutique (app fermée pendant cette étape).
  Future<bool> isStoreSetupPending();

  /// Marque la configuration de la boutique comme terminée.
  Future<void> completeStoreSetup();

  /// Rafraîchit l'access token via le refresh token stocké.
  /// Nécessaire après création de boutique pour obtenir un token avec store_id.
  Future<void> refreshTokens();
}
