import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persiste et expose le [ThemeMode] courant. Clair par défaut : l'app est
/// pensée pour le comptoir en plein jour ; le sombre reste au choix dans
/// Paramètres.
///
/// Persisté dans le secure storage (clé : `theme_mode`). Le mode enregistré
/// est lu avant `runApp` ([ThemeModeNotifier.readSaved]) et injecté via
/// [ThemeModeNotifier.new] : la première frame a déjà le bon thème. Sinon,
/// un téléphone en mode sombre avec l'app réglée en clair afficherait un
/// écran sombre entre le splash et la première page.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  /// Crée le notifier avec le mode [initial] (lu avant `runApp`).
  ThemeModeNotifier([this._initial = ThemeMode.light]);

  static const _key = 'theme_mode';
  static const _storage = FlutterSecureStorage();

  final ThemeMode _initial;

  /// Lit le mode enregistré ; [ThemeMode.light] s'il n'y en a pas ou si la
  /// lecture échoue.
  static Future<ThemeMode> readSaved() async {
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

  @override
  ThemeMode build() => _initial;

  /// Met à jour et persiste [mode].
  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    try {
      await _storage.write(key: _key, value: mode.name);
    } catch (_) {}
  }
}

/// Provider de [ThemeModeNotifier].
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
