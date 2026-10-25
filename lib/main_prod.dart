import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'app/theme/theme_mode_provider.dart';
import 'core/config.dart';
import 'core/network/network_providers.dart';
import 'core/storage/image_file_cache.dart';

/// Point d'entrée production — flavor "prod", API prod.
void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  // Bord à bord aussi avant Android 15 (où il est imposé) : même rendu
  // partout, les encarts système sont gérés par SafeArea.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  AppConfig.setup(
    flavor: AppFlavor.prod,
    apiUrl: 'https://pos-mobile-vkuh.onrender.com',
  );
  await initializeDateFormatting('fr_FR');
  // Nettoyage en tâche de fond, non bloquant : un échec sera retenté au
  // prochain démarrage.
  unawaited(
    ImageFileCache().purgeLegacyProductImages().catchError((Object _) {}),
  );
  // Lu avant runApp : la première frame suit le thème choisi par
  // l'utilisateur, pas celui du système.
  final themeMode = await ThemeModeNotifier.readSaved();
  runApp(
    ProviderScope(
      overrides: [
        themeModeProvider.overrideWith(() => ThemeModeNotifier(themeMode)),
        tokenStorageProvider.overrideWith(
          (ref) => ref.watch(secureTokenStorageProvider),
        ),
      ],
      child: const PosMobileApp(),
    ),
  );
}
