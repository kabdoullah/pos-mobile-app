import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persiste et expose le [ThemeMode] courant.
///
/// Persisté dans le secure storage (clé : `theme_mode`). Revient à
/// [ThemeMode.system] si aucune valeur n'est enregistrée. L'état est synchrone
/// pour que [MaterialApp.themeMode] puisse le consommer directement ; la valeur
/// enregistrée est chargée de façon asynchrone après la première frame.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';
  static const _storage = FlutterSecureStorage();

  @override
  ThemeMode build() {
    unawaited(_load());
    return ThemeMode.system;
  }

  Future<void> _load() async {
    try {
      final value = await _storage.read(key: _key);
      if (value == null) return;
      final loaded = ThemeMode.values.firstWhere(
        (m) => m.name == value,
        orElse: () => ThemeMode.system,
      );
      state = loaded;
    } catch (_) {}
  }

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
