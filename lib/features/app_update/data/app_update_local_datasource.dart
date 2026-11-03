import 'package:shared_preferences/shared_preferences.dart';

/// Mémorise sur l'appareil le dernier build minimal reçu du serveur.
///
/// Propre à l'appareil, pas au compte : rien à effacer au changement de
/// compte.
class AppUpdateLocalDataSource {
  /// Crée la source locale.
  AppUpdateLocalDataSource({SharedPreferencesAsync? prefs})
    : _prefs = prefs ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _prefs;

  static const _key = 'min_app_build';

  /// Dernier build minimal mémorisé, ou null.
  Future<int?> read() => _prefs.getInt(_key);

  /// Mémorise [minBuild].
  Future<void> save(int minBuild) => _prefs.setInt(_key, minBuild);
}
