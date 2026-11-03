/// Vrai si le build installé est trop ancien pour la version minimale exigée.
///
/// Un build installé ou un minimum inconnu ne bloque jamais : mieux vaut
/// laisser passer un vieux client que bloquer tout le monde sur une erreur
/// de lecture.
bool isUpdateRequired({required int? installedBuild, required int? minBuild}) {
  if (installedBuild == null || minBuild == null) return false;
  return installedBuild < minBuild;
}

/// Accès aux numéros de build utiles à la mise à jour obligatoire.
///
/// Les numéros de build correspondent au versionCode Android (`+9` dans
/// `1.2.1+9`).
abstract interface class AppUpdateRepository {
  /// Numéro de build de l'app installée, ou null s'il est illisible.
  Future<int?> installedBuild();

  /// Dernier build minimal reçu du serveur, mémorisé sur l'appareil pour que
  /// le blocage tienne aussi hors ligne. Null si jamais reçu.
  Future<int?> cachedMinBuild();

  /// Build minimal exigé par le serveur, mémorisé au passage. Null si le
  /// serveur est injoignable ou ne le fournit pas.
  Future<int?> fetchMinBuild();
}
