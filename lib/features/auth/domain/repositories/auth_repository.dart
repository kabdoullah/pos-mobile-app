import '../entities/support_contact.dart';
import '../entities/user.dart';

/// Interface du repository auth. Implémenté dans la couche `data`.
abstract class AuthRepository {
  /// Crée un compte utilisateur. L'email est obligatoire : c'est le seul canal
  /// de réinitialisation du mot de passe.
  ///
  /// Marque aussi la configuration de la boutique comme en attente pour ce
  /// compte (voir [isStoreSetupPending]).
  Future<User> register({
    required String phoneNumber,
    required String password,
    required String email,
  });

  /// Authentifie via numéro de téléphone + mot de passe.
  /// Stocke les tokens en secure storage.
  Future<User> login({required String phoneNumber, required String password});

  /// Définit le PIN local après la première connexion.
  Future<void> setupPin(String pin);

  /// Oublie le PIN de cet appareil (« Code PIN oublié »), sans toucher aux
  /// tokens : l'utilisateur en choisit aussitôt un nouveau.
  Future<void> forgetPin();

  /// Vérifie le PIN saisi par l'utilisateur.
  ///
  /// Se termine normalement si le PIN est correct. Lève `WrongPin` (avec les
  /// tentatives restantes) ou `PinLocked` (avec la fin du blocage) sinon.
  Future<void> verifyPin(String pin);

  /// Fin du blocage du PIN en cours, ou null si le PIN n'est pas bloqué.
  Future<DateTime?> pinLockedUntil();

  /// Demande un email de réinitialisation de mot de passe.
  Future<void> sendPasswordReset(String email);

  /// Choisit un nouveau mot de passe avec le [token] du lien reçu par email.
  ///
  /// Lève une `ApiException` (422) si le lien est invalide, expiré ou déjà
  /// utilisé. Ne connecte pas l'utilisateur.
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Coordonnées du support, lisibles sans être connecté.
  ///
  /// Ne lève jamais : hors ligne ou en cas d'erreur serveur, retourne des
  /// coordonnées vides (l'UI masque alors les boutons de contact).
  Future<SupportContact> getSupportContact();

  /// Déconnecte l'utilisateur (efface tokens et PIN).
  Future<void> logout();

  /// Supprime définitivement le compte côté serveur (mot de passe revérifié),
  /// puis efface tokens, PIN et inscription en attente sur cet appareil.
  ///
  /// En cas d'échec (mot de passe faux, réseau), rien n'est effacé.
  Future<void> deleteAccount(String password);

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
