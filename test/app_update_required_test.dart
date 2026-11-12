import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/features/app_update/data/app_update_local_datasource.dart';
import 'package:mobile/features/app_update/data/app_update_remote_datasource.dart';
import 'package:mobile/features/app_update/data/app_update_repository_impl.dart';
import 'package:mobile/features/app_update/domain/app_update_repository.dart';
import 'package:mobile/features/app_update/presentation/providers/update_required_provider.dart';
import 'package:mobile/features/app_update/presentation/widgets/update_required_gate.dart';
import 'package:mobile/features/app_update/providers/app_update_di_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements AppUpdateRepository {}

class _MockRemote extends Mock implements AppUpdateRemoteDataSource {}

class _MockLocal extends Mock implements AppUpdateLocalDataSource {}

class _MockDio extends Mock implements Dio {}

class _FixedUpdateRequired extends UpdateRequired {
  _FixedUpdateRequired(this.value);

  final bool value;

  @override
  bool build() => value;
}

/// Lance la vérification et attend qu'elle soit terminée.
Future<bool> _checkWith(AppUpdateRepository repository) async {
  final container = ProviderContainer(
    overrides: [appUpdateRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  container.read(updateRequiredProvider);
  await pumpEventQueue();
  return container.read(updateRequiredProvider);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('isUpdateRequired', () {
    test('bloque seulement sous le minimum', () {
      expect(isUpdateRequired(installedBuild: 9, minBuild: 10), isTrue);
      expect(isUpdateRequired(installedBuild: 10, minBuild: 10), isFalse);
      expect(isUpdateRequired(installedBuild: 11, minBuild: 10), isFalse);
    });

    test('ne bloque jamais sur une valeur inconnue', () {
      expect(isUpdateRequired(installedBuild: null, minBuild: 10), isFalse);
      expect(isUpdateRequired(installedBuild: 9, minBuild: null), isFalse);
    });
  });

  group('UpdateRequired', () {
    late _MockRepository repository;

    setUp(() {
      repository = _MockRepository();
      when(() => repository.installedBuild()).thenAnswer((_) async => 9);
      when(() => repository.cachedMinBuild()).thenAnswer((_) async => null);
      when(() => repository.fetchMinBuild()).thenAnswer((_) async => null);
    });

    test('hors ligne, reste bloqué sur le minimum mémorisé', () async {
      when(() => repository.cachedMinBuild()).thenAnswer((_) async => 10);

      expect(await _checkWith(repository), isTrue);
    });

    test('bloque quand le serveur exige un build plus récent', () async {
      when(() => repository.fetchMinBuild()).thenAnswer((_) async => 10);

      expect(await _checkWith(repository), isTrue);
    });

    test('se débloque si le serveur abaisse le minimum', () async {
      when(() => repository.cachedMinBuild()).thenAnswer((_) async => 10);
      when(() => repository.fetchMinBuild()).thenAnswer((_) async => 0);

      expect(await _checkWith(repository), isFalse);
    });

    test('se débloque une fois l’app mise à jour', () async {
      when(() => repository.installedBuild()).thenAnswer((_) async => 10);
      when(() => repository.cachedMinBuild()).thenAnswer((_) async => 10);
      when(() => repository.fetchMinBuild()).thenAnswer((_) async => 10);

      expect(await _checkWith(repository), isFalse);
    });
  });

  group('AppUpdateRepositoryImpl', () {
    late _MockRemote remote;
    late _MockLocal local;

    setUp(() {
      remote = _MockRemote();
      local = _MockLocal();
      when(() => local.save(any())).thenAnswer((_) async {});
    });

    AppUpdateRepositoryImpl repo({String build = '9'}) =>
        AppUpdateRepositoryImpl(
          remote: remote,
          local: local,
          readBuildNumber: () async => build,
        );

    test('mémorise le minimum reçu du serveur', () async {
      when(() => remote.fetchMinBuild()).thenAnswer((_) async => 12);

      expect(await repo().fetchMinBuild(), 12);
      verify(() => local.save(12)).called(1);
    });

    test(
      'ne touche pas au minimum mémorisé si le serveur est injoignable',
      () async {
        when(() => remote.fetchMinBuild()).thenAnswer((_) async => null);

        expect(await repo().fetchMinBuild(), isNull);
        verifyNever(() => local.save(any()));
      },
    );

    test('build installé illisible : null', () async {
      expect(await repo(build: '').installedBuild(), isNull);
      expect(await repo().installedBuild(), 9);
    });
  });

  group('AppUpdateRemoteDataSource', () {
    late _MockDio dio;

    setUp(() => dio = _MockDio());

    void respond(Map<String, dynamic> data) {
      when(() => dio.get<Map<String, dynamic>>('/health')).thenAnswer(
        (_) async => Response(
          data: data,
          requestOptions: RequestOptions(path: '/health'),
        ),
      );
    }

    test('lit min_app_build', () async {
      respond({'status': 'ok', 'min_app_build': 10});

      expect(await AppUpdateRemoteDataSource(dio: dio).fetchMinBuild(), 10);
    });

    test('champ absent (ancien backend) ou invalide : null', () async {
      respond({'status': 'ok'});
      expect(await AppUpdateRemoteDataSource(dio: dio).fetchMinBuild(), isNull);

      respond({'status': 'ok', 'min_app_build': '10'});
      expect(await AppUpdateRemoteDataSource(dio: dio).fetchMinBuild(), isNull);
    });

    test('erreur réseau : null', () async {
      when(() => dio.get<Map<String, dynamic>>('/health')).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/health')),
      );

      expect(await AppUpdateRemoteDataSource(dio: dio).fetchMinBuild(), isNull);
    });
  });

  group('UpdateRequiredGate', () {
    Future<void> pump(WidgetTester tester, {required bool required}) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            updateRequiredProvider.overrideWith(
              () => _FixedUpdateRequired(required),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            builder: (context, child) => UpdateRequiredGate(child: child!),
            home: Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Encaisser'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('laisse l’app accessible sans mise à jour requise', (
      tester,
    ) async {
      await pump(tester, required: false);

      expect(find.text('Mise à jour nécessaire'), findsNothing);
      expect(find.text('Encaisser').hitTestable(), findsOneWidget);
    });

    testWidgets('bloque l’app derrière le dialogue de mise à jour', (
      tester,
    ) async {
      await pump(tester, required: true);

      expect(find.text('Mise à jour nécessaire'), findsOneWidget);
      expect(find.text('Mettre à jour sur le Play Store'), findsOneWidget);
      // L'écran dessous ne reçoit plus les touchers.
      expect(find.text('Encaisser').hitTestable(), findsNothing);
    });
  });
}
