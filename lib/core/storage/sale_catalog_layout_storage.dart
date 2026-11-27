import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Mémorise l'affichage du catalogue de l'écran Vendre : liste (par défaut)
/// ou grille. Clé : `sale_catalog_grid`.
///
/// Préférence de l'appareil, gardée au changement de compte. Une préférence
/// perdue n'est pas grave : toute erreur est ignorée et la lecture retombe
/// sur la liste.
class SaleCatalogLayoutStorage {
  /// Crée le stockage de l'affichage du catalogue.
  SaleCatalogLayoutStorage({FlutterSecureStorage? secureStorage})
    : _storage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _key = 'sale_catalog_grid';

  /// Vrai si le catalogue s'affiche en grille.
  Future<bool> readGrid() async {
    try {
      return await _storage.read(key: _key) == 'true';
    } catch (_) {
      return false;
    }
  }

  /// Enregistre l'affichage choisi.
  Future<void> writeGrid(bool grid) async {
    try {
      await _storage.write(key: _key, value: '$grid');
    } catch (_) {
      // Préférence non enregistrée : l'affichage vaut pour cette session.
    }
  }
}
