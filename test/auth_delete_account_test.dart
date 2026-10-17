import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/core/network/error_mapper.dart';
import 'package:mobile/core/storage/pin_storage.dart';
import 'package:mobile/core/storage/secure_token_storage.dart';
import 'package:mobile/core/sync/local_data_reset_service.dart';
import 'package:mobile/core/sync/sync_orchestrator.dart';
import 'package:mobile/core/sync/sync_providers.dart';
import 'package:mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mobile/features/auth/data/models/auth_models.dart';
import 'package:mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mobile/features/auth/domain/repositories/profile_repository.dart';
import 'package:mobile/features/auth/domain/repositories/store_repository.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/auth/providers/auth_di_providers.dart';

import 'pin_storage_test.dart' show InMemorySecureStorage;

class _MockRemote extends Mock implements AuthRemoteDataSource {}

class _MockStoreRepo extends Mock implements StoreRepository {}

class _MockProfileRepo extends Mock implements ProfileRepository {}

class _MockReset extends Mock implements LocalDataResetService {}

class _FakeSync extends SyncOrchestrator {
  @override
  SyncStatus build() => const SyncStatusIdle();

  @override
  Future<void> syncNow({bool forceFullPull = false}) async {}
}

const _phone = '+2250700000001';
const _password = 'secret123';

/// Access token minimal : seul le claim `sub` est lu côté app.
String _jwt(String userId) {
  final payload = base64Url
      .encode(utf8.encode(jsonEncode({'sub': userId})))
      .replaceAll('=', '');
  return 'header.$payload.signature';
}

DioException _http(int status, String detail) => DioException(
  requestOptions: RequestOptions(path: '/api/v1/users/me'),
  response: Response(
    requestOptions: RequestOptions(path: '/api/v1/users/me'),
    statusCode: status,
    data: {'detail': detail},
  ),
);

/// Appareil connecté (inscription → boutique → PIN) avec un compte `u1`.
class _Device {
  _Device() {
    when(() => remote.register(any())).thenAnswer(
      (_) async => const RegisterResponseDto(
        userId: 'u1',
        phoneNumber: _phone,
        message: 'ok',
      ),
    );
    when(() => remote.login(any())).thenAnswer(
      (_) async => TokenResponseDto(
        accessToken: _jwt('u1'),
        refreshToken: 'refresh-u1',
        tokenType: 'bearer',
        expiresIn: 900,
      ),
    );
    when(storeRepo.clearLocal).thenAnswer((_) async {});
    when(profileRepo.clearLocal).thenAnswer((_) async {});
    when(reset.wipeBusinessData).thenAnswer((_) async {});
  }

  final storage = InMemorySecureStorage();
  final remote = _MockRemote();
  final storeRepo = _MockStoreRepo();
  final profileRepo = _MockProfileRepo();
  final reset = _MockReset();

  late final tokens = SecureTokenStorage(secureStorage: storage);
  late final pins = PinStorage(secureStorage: storage);

  Future<ProviderContainer> launch() async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          AuthRepositoryImpl(
            dataSource: remote,
            tokenStorage: tokens,
            pinStorage: pins,
          ),
        ),
        storeRepositoryProvider.overrideWithValue(storeRepo),
        profileRepositoryProvider.overrideWithValue(profileRepo),
        localDataResetServiceProvider.overrideWithValue(reset),
        syncOrchestratorProvider.overrideWith(_FakeSync.new),
      ],
    );
    addTearDown(container.dispose);
    // authProvider est auto-dispose : on le garde en vie comme le routeur.
    container.listen(authProvider, (_, _) {});
    await container.read(authProvider.future);
    return container;
  }

  /// Lance l'app et connecte le compte jusqu'à `Authenticated`.
  Future<ProviderContainer> signedIn() async {
    final app = await launch();
    final auth = app.read(authProvider.notifier);
    await auth.register(_phone, _password);
    await auth.proceedToPinSetup();
    await auth.setupPin('2580');
    expect(app.read(authProvider).value, isA<AuthAuthenticated>());
    return app;
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(const LoginRequestDto(phoneNumber: '', password: ''));
    registerFallbackValue(
      const RegisterRequestDto(phoneNumber: '', password: ''),
    );
    registerFallbackValue(const DeleteAccountRequestDto(password: ''));
  });

  test('suppression réussie → serveur appelé, tout est effacé, '
      'Unauthenticated', () async {
    final device = _Device();
    when(() => device.remote.deleteMe(any())).thenAnswer((_) async {});
    final app = await device.signedIn();

    await app.read(authProvider.notifier).deleteAccount(_password);

    final sent =
        verify(() => device.remote.deleteMe(captureAny())).captured.single
            as DeleteAccountRequestDto;
    expect(sent.password, _password);
    expect(app.read(authProvider).value, isA<AuthUnauthenticated>());
    expect(await device.tokens.getAccessToken(), isNull);
    expect(await device.pins.hasPinConfigured(), isFalse);
    expect(await device.tokens.getStoreSetupPendingUserId(), isNull);
    verify(device.reset.wipeBusinessData).called(1);
    verify(device.storeRepo.clearLocal).called(greaterThan(0));

    // Relance de l'app : plus aucune session.
    final relaunched = await device.launch();
    expect(relaunched.read(authProvider).value, isA<AuthUnauthenticated>());
  });

  test('mot de passe faux (403) → erreur en français, rien n\'est effacé, '
      'reste connecté', () async {
    final device = _Device();
    when(
      () => device.remote.deleteMe(any()),
    ).thenThrow(_http(403, 'Invalid password.'));
    final app = await device.signedIn();

    final error = await app
        .read(authProvider.notifier)
        .deleteAccount('mauvais')
        .then<Object?>((_) => null, onError: (Object e) => e);

    expect(error, isNotNull);
    expect(errorToFrench(error!), 'Mot de passe incorrect.');
    expect(app.read(authProvider).value, isA<AuthAuthenticated>());
    expect(await device.tokens.getAccessToken(), isNotNull);
    expect(await device.pins.hasPinConfigured(), isTrue);
    verifyNever(device.reset.wipeBusinessData);
  });

  test('erreur réseau → rien n\'est effacé, reste connecté', () async {
    final device = _Device();
    when(() => device.remote.deleteMe(any())).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/api/v1/users/me'),
        type: DioExceptionType.connectionError,
      ),
    );
    final app = await device.signedIn();

    await expectLater(
      app.read(authProvider.notifier).deleteAccount(_password),
      throwsA(anything),
    );

    expect(app.read(authProvider).value, isA<AuthAuthenticated>());
    expect(await device.tokens.getAccessToken(), isNotNull);
    verifyNever(device.reset.wipeBusinessData);
  });
}
