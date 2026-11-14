import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Mémorise le thème choisi dans Paramètres (clé : `theme_mode`).
///
/// Clair par défaut : l'app est pensée pour le comptoir en plein jour.
/// Une préférence perdue n'est pas grave : toute erreur de lecture ou
/// d'écriture est ignorée et la lecture retombe sur [ThemeMode.light].
class ThemeModeStorage {
  /// Crée le stockage du thème.
  ThemeModeStorage({FlutterSecureStorage? secureStorage})
    : _storage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _key = 'theme_mode';

  /// Le mode enregistré ; [ThemeMode.light] s'il n'y en a pas, s'il est
  /// illisible ou si la lecture échoue.
  Future<ThemeMode> read() async {
    try {
      final value = await _storage.read(key: _key);
      return ThemeMode.values.firstWhere(
        (m) => m.name == value,
        orElse: () => ThemeMode.light,
      );
    } catch (_) {
      return ThemeMode.light;
    }
  }

  /// Enregistre [mode].
  Future<void> write(ThemeMode mode) async {
    try {
      await _storage.write(key: _key, value: mode.name);
    } catch (_) {
      // Préférence non enregistrée : le mode s'applique pour cette session.
    }
  }
}
