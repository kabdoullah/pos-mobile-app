import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Mémorise le mode de comptage de la caisse (ADR-0016) : billets et pièces
/// (par défaut) ou total seulement. Clé : `cash_count_by_denomination`.
///
/// Préférence de l'appareil, gardée au changement de compte. Une préférence
/// perdue n'est pas grave : toute erreur est ignorée et la lecture retombe
/// sur le comptage par coupure.
class CashCountModeStorage {
  /// Crée le stockage du mode de comptage.
  CashCountModeStorage({FlutterSecureStorage? secureStorage})
    : _storage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _key = 'cash_count_by_denomination';

  /// Vrai pour le comptage billets et pièces (défaut), faux pour « Total
  /// seulement ».
  Future<bool> readByDenomination() async {
    try {
      return await _storage.read(key: _key) != 'false';
    } catch (_) {
      return true;
    }
  }

  /// Enregistre le mode choisi.
  Future<void> writeByDenomination(bool byDenomination) async {
    try {
      await _storage.write(key: _key, value: '$byDenomination');
    } catch (_) {
      // Préférence non enregistrée : le mode s'applique pour cette session.
    }
  }
}
