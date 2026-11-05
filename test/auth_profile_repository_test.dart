import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mobile/features/auth/data/models/auth_models.dart';
import 'package:mobile/features/auth/data/repositories/profile_repository_impl.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}

class _MockPrefs extends Mock implements SharedPreferencesAsync {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _MockRemote remote;
  late _MockPrefs prefs;
  late ProfileRepositoryImpl repo;

  setUpAll(() {
    registerFallbackValue(const UserMeUpdateDto());
    registerFallbackValue(const UpdateEmailRequestDto(email: '', password: ''));
  });

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    remote = _MockRemote();
    prefs = _MockPrefs();
    when(() => prefs.remove(any())).thenAnswer((_) async {});
    repo = ProfileRepositoryImpl(remoteDataSource: remote, prefs: prefs);
  });

  const me = UserMeDto(id: 'u1', phoneNumber: '+2250700000000');

  test(
    'lit le serveur une fois puis le cache (impression hors ligne)',
    () async {
      when(
        remote.getMe,
      ).thenAnswer((_) async => me.copyWith(displayName: 'Awa'));

      expect(await repo.getDisplayName(), 'Awa');
      when(remote.getMe).thenThrow(Exception('hors ligne'));
      expect(await repo.getDisplayName(), 'Awa');
      verify(remote.getMe).called(1);
    },
  );

  test('un nom vide est envoyé comme null (ligne retirée)', () async {
    when(() => remote.updateMe(any())).thenAnswer((_) async => me);

    expect(await repo.updateDisplayName('   '), isNull);
    final sent =
        verify(() => remote.updateMe(captureAny())).captured.single
            as UserMeUpdateDto;
    expect(sent.displayName, isNull);
  });

  test('clearLocal oublie le nom du compte précédent', () async {
    when(remote.getMe).thenAnswer((_) async => me.copyWith(displayName: 'Awa'));
    await repo.getDisplayName();
    await repo.clearLocal();

    when(
      remote.getMe,
    ).thenAnswer((_) async => me.copyWith(displayName: 'Koffi'));
    expect(await repo.getDisplayName(), 'Koffi');
  });

  group('email du compte', () {
    test('vérifié dès que email_verified_at est renseigné', () async {
      when(remote.getMe).thenAnswer(
        (_) async => me.copyWith(
          email: 'awa@example.com',
          emailVerifiedAt: DateTime.utc(2026, 11, 5),
        ),
      );

      final account = await repo.getAccountEmail();

      expect(account.email, 'awa@example.com');
      expect(account.isVerified, isTrue);
    });

    test('toujours relu sur le serveur (pas de cache)', () async {
      when(
        remote.getMe,
      ).thenAnswer((_) async => me.copyWith(email: 'awa@example.com'));
      expect((await repo.getAccountEmail()).isVerified, isFalse);

      when(remote.getMe).thenAnswer(
        (_) async => me.copyWith(
          email: 'awa@example.com',
          emailVerifiedAt: DateTime.utc(2026, 11, 5),
        ),
      );
      expect((await repo.getAccountEmail()).isVerified, isTrue);
    });

    test('hors ligne : ConnectionException', () async {
      when(remote.getMe).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(repo.getAccountEmail, throwsA(isA<ConnectionException>()));
    });

    test('renvoi du lien : appelle resend-verification', () async {
      when(remote.resendVerification).thenAnswer((_) async {});

      await repo.resendEmailVerification();

      verify(remote.resendVerification).called(1);
    });
  });

  group('ajout / correction de l\'email', () {
    test('envoie l\'email nettoyé et le mot de passe, relit l\'état', () async {
      when(
        () => remote.updateEmail(any()),
      ).thenAnswer((_) async => me.copyWith(email: 'awa@example.com'));

      final account = await repo.updateEmail(
        email: '  awa@example.com ',
        password: 'secret123',
      );

      final sent =
          verify(() => remote.updateEmail(captureAny())).captured.single
              as UpdateEmailRequestDto;
      expect(sent.email, 'awa@example.com');
      expect(sent.password, 'secret123');
      expect(account.email, 'awa@example.com');
      expect(account.isVerified, isFalse);
    });

    test('mot de passe faux : ApiException 403 remontée', () async {
      when(() => remote.updateEmail(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 403,
            data: {'detail': 'Invalid password.', 'code': 'FORBIDDEN'},
          ),
        ),
      );

      expect(
        () => repo.updateEmail(email: 'awa@example.com', password: 'faux'),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 403)),
      );
    });
  });

  group('rappel de l\'accueil', () {
    test('« Plus tard » est mémorisé puis relu', () async {
      final until = DateTime.utc(2026, 11, 12, 10);
      when(() => prefs.setString(any(), any())).thenAnswer((_) async {});
      when(
        () => prefs.getString(any()),
      ).thenAnswer((_) async => until.toIso8601String());

      await repo.snoozeEmailReminder(until);

      verify(
        () => prefs.setString(
          'email_reminder_snoozed_until',
          until.toIso8601String(),
        ),
      ).called(1);
      expect(await repo.emailReminderSnoozedUntil(), until);
    });

    test('changement de compte : le report est oublié', () async {
      await repo.clearLocal();

      verify(() => prefs.remove('email_reminder_snoozed_until')).called(1);
    });
  });
}
