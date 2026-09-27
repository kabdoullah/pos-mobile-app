/// Profil de l'utilisateur connecté : nom affiché « Vendeur : … » sur les
/// reçus (ADR-0008). Mis en cache pour imprimer hors ligne.
abstract interface class ProfileRepository {
  /// Nom du vendeur (cache local, sinon serveur) ; null s'il n'est pas défini
  /// ou inconnu hors ligne.
  Future<String?> getDisplayName();

  /// Enregistre le nom (null ou vide = retiré). Nécessite le réseau.
  Future<String?> updateDisplayName(String? displayName);

  /// Vide le cache local (changement de compte).
  Future<void> clearLocal();
}
