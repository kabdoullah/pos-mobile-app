import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/app/theme/theme_mode_provider.dart';
import 'package:mobile/core/storage/theme_mode_storage.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late _MockSecureStorage secure;
  late ThemeModeStorage storage;

  setUp(() {
    secure = _MockSecureStorage();
    storage = ThemeModeStorage(secureStorage: secure);
  });

  void stubRead(Future<String?> Function() answer) =>
      when(() => secure.read(key: 'theme_mode')).thenAnswer((_) => answer());

  group('ThemeModeStorage.read', () {
    test('rien d\'enregistré : clair par défaut', () async {
      stubRead(() async => null);
      expect(await storage.read(), ThemeMode.light);
    });

    test('mode enregistré : relu tel quel', () async {
      stubRead(() async => 'dark');
      expect(await storage.read(), ThemeMode.dark);
      stubRead(() async => 'system');
      expect(await storage.read(), ThemeMode.system);
    });

    test('valeur illisible ou lecture en échec : clair', () async {
      stubRead(() async => 'bleu');
      expect(await storage.read(), ThemeMode.light);
      stubRead(() async => throw Exception('keystore'));
      expect(await storage.read(), ThemeMode.light);
    });
  });

  test('ThemeModeStorage.write : un échec d\'écriture est ignoré', () async {
    when(
      () => secure.write(key: 'theme_mode', value: 'dark'),
    ).thenThrow(Exception('keystore'));
    await expectLater(storage.write(ThemeMode.dark), completes);
  });

  test('ThemeModeNotifier.setMode : applique puis enregistre', () async {
    when(
      () => secure.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});
    final container = ProviderContainer(
      overrides: [themeModeStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    expect(container.read(themeModeProvider), ThemeMode.light);
    await container.read(themeModeProvider.notifier).setMode(ThemeMode.dark);

    expect(container.read(themeModeProvider), ThemeMode.dark);
    verify(() => secure.write(key: 'theme_mode', value: 'dark')).called(1);
  });
}
