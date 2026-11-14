import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/theme_mode_storage.dart';

/// Stockage du thème choisi.
final themeModeStorageProvider = Provider<ThemeModeStorage>(
  (ref) => ThemeModeStorage(),
);

/// Expose le [ThemeMode] courant et persiste les changements.
///
/// Le mode enregistré est lu avant `runApp` (`ThemeModeStorage.read`) et
/// injecté via [ThemeModeNotifier.new] : la première frame a déjà le bon
/// thème. Sinon, un téléphone en mode sombre avec l'app réglée en clair
/// afficherait un écran sombre entre le splash et la première page.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  /// Crée le notifier avec le mode [initial] (lu avant `runApp`). Clair par
  /// défaut ; le sombre reste au choix dans Paramètres.
  ThemeModeNotifier([this._initial = ThemeMode.light]);

  final ThemeMode _initial;

  @override
  ThemeMode build() => _initial;

  /// Applique [mode] tout de suite, puis l'enregistre.
  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await ref.read(themeModeStorageProvider).write(mode);
  }
}

/// Provider de [ThemeModeNotifier].
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
