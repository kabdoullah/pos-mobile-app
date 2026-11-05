import '../entities/account_email.dart';

/// Profil de l'utilisateur connecté : nom affiché « Vendeur : … » sur les
/// reçus (ADR-0008), mis en cache pour imprimer hors ligne, et état de
/// vérification de l'email.
abstract interface class ProfileRepository {
  /// Nom du vendeur (cache local, sinon serveur) ; null s'il n'est pas défini
  /// ou inconnu hors ligne.
  Future<String?> getDisplayName();

  /// Enregistre le nom (null ou vide = retiré). Nécessite le réseau.
  Future<String?> updateDisplayName(String? displayName);

  /// Email du compte et son état de vérification, toujours lus sur le serveur
  /// (pas de cache : l'état change hors de l'app). Nécessite le réseau.
  Future<AccountEmail> getAccountEmail();

  /// Renvoie le lien de vérification de l'email. Nécessite le réseau.
  Future<void> resendEmailVerification();

  /// Vide le cache local (changement de compte).
  Future<void> clearLocal();
}
