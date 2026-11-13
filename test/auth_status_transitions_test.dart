import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/core/config.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/core/network/network_providers.dart';
import 'package:mobile/core/storage/pin_storage.dart';
import 'package:mobile/core/storage/secure_token_storage.dart';
import 'package:mobile/core/storage/store_suspension_storage.dart';
import 'package:mobile/core/sync/sync_orchestrator.dart';
import 'package:mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mobile/features/auth/data/models/auth_models.dart';
import 'package:mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mobile/features/auth/domain/entities/pin_failure.dart';
import 'package:mobile/features/auth/domain/repositories/profile_repository.dart';
import 'package:mobile/features/auth/domain/repositories/store_repository.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/auth/providers/auth_di_providers.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/sales/presentation/providers/cart_provider.dart';

import 'pin_storage_test.dart' show InMemorySecureStorage;
import 'sync_store_suspended_test.dart' show suspendedError;

class _MockRemote extends Mock implements AuthRemoteDataSource {}

class _MockStoreRepo extends Mock implements StoreRepository {}

class _MockProfileRepo extends Mock implements ProfileRepository {}

class _FakeSync extends SyncOrchestrator {
  @override
  SyncStatus build() => const SyncStatusIdle();

  @override
  Future<void> syncNow({bool forceFullPull = false}) async {}
}

/// Access token minimal : seul le claim `sub` est lu côté app.
String _jwt(String userId) {
  final payload = base64Url
      .encode(utf8.encode(jsonEncode({'sub': userId})))
      .replaceAll('=', '');
  return 'header.$payload.signature';
}

TokenResponseDto _tokens(String userId) => TokenResponseDto(
  accessToken: _jwt(userId),
  refreshToken: 'refresh-$userId',
  tokenType: 'bearer',
  expiresIn: 900,
);

/// Un « appareil » : le secure storage survit aux redémarrages de l'app,
/// chaque [launch] recrée un conteneur Riverpod (= relance de l'app).
class _Device {
  _Device() {
    when(() => remote.login(any())).thenAnswer((inv) async {
      final dto = inv.positionalArguments.first as LoginRequestDto;
      if (dto.password != 'secret123') {
        throw DioException(
          requestOptions: RequestOptions(path: '/api/v1/auth/login'),
          response: Response(
            requestOptions: RequestOptions(path: '/api/v1/auth/login'),
            statusCode: 401,
            data: {'detail': 'Invalid phone number or password.'},
          ),
        );
      }
      return _tokens(_userIds[dto.phoneNumber]!);
    });
    when(() => remote.register(any())).thenAnswer((inv) async {
      final dto = inv.positionalArguments.first as RegisterRequestDto;
      return RegisterResponseDto(
        userId: _userIds[dto.phoneNumber]!,
        phoneNumber: dto.phoneNumber,
        message: 'ok',
      );
    });
    when(() => remote.refresh(any())).thenAnswer((_) async => _tokens('u1'));
    when(storeRepo.clearLocal).thenAnswer((_) async {});
    when(profileRepo.clearLocal).thenAnswer((_) async {});
  }

  static const _userIds = {'+2250700000001': 'u1', '+2250700000002': 'u2'};

  final storage = InMemorySecureStorage();
  final remote = _MockRemote();
  final storeRepo = _MockStoreRepo();
  final profileRepo = _MockProfileRepo();

  Future<ProviderContainer> launch() async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          AuthRepositoryImpl(
            dataSource: remote,
            tokenStorage: SecureTokenStorage(secureStorage: storage),
            pinStorage: PinStorage(secureStorage: storage),
          ),
        ),
        storeRepositoryProvider.overrideWithValue(storeRepo),
        profileRepositoryProvider.overrideWithValue(profileRepo),
        syncOrchestratorProvider.overrideWith(_FakeSync.new),
        storeSuspensionStorageProvider.overrideWithValue(
          StoreSuspensionStorage(secureStorage: storage),
        ),
      ],
    );
    addTearDown(container.dispose);
    // authProvider est auto-dispose : on le garde en vie comme le ferait le
    // routeur.
    container.listen(authProvider, (_, _) {});
    await container.read(authProvider.future);
    return container;
  }
}

AuthStatus? _status(ProviderContainer c) => c.read(authProvider).value;

Object? _error(ProviderContainer c) => c.read(authProvider).error;

void main() {
  setUpAll(() {
    registerFallbackValue(const LoginRequestDto(phoneNumber: '', password: ''));
    registerFallbackValue(
      const RegisterRequestDto(phoneNumber: '', password: '', email: ''),
    );
    registerFallbackValue(const RefreshRequestDto(refreshToken: ''));
  });

  const phone = '+2250700000001';

  test('sans token → Unauthenticated', () async {
    final app = await _Device().launch();
    expect(_status(app), isA<AuthUnauthenticated>());
  });

  test('inscription → boutique → PIN → Authenticated', () async {
    final app = await _Device().launch();
    final auth = app.read(authProvider.notifier);

    await auth.register(phone, 'secret123', email: 'awa@example.com');
    expect(_status(app), isA<AuthStoreSetupRequired>());

    await auth.proceedToPinSetup();
    final pinSetup = _status(app);
    expect(pinSetup, isA<AuthPinSetupRequired>());
    expect((pinSetup! as AuthPinSetupRequired).canReturnToStoreSetup, isTrue);

    await auth.setupPin('2580');
    expect(_status(app), isA<AuthAuthenticated>());
  });

  test('app fermée pendant la configuration boutique → boutique au '
      'relancement', () async {
    final device = _Device();
    final first = await device.launch();
    await first
        .read(authProvider.notifier)
        .register(phone, 'secret123', email: 'awa@example.com');
    first.dispose();

    final relaunched = await device.launch();
    expect(_status(relaunched), isA<AuthStoreSetupRequired>());
  });

  test('reconnexion du même compte avant la configuration boutique → '
      'boutique', () async {
    final device = _Device();
    final first = await device.launch();
    await first
        .read(authProvider.notifier)
        .register(phone, 'secret123', email: 'awa@example.com');
    first.dispose();

    final relaunched = await device.launch();
    await relaunched.read(authProvider.notifier).login(phone, 'secret123');
    expect(_status(relaunched), isA<AuthStoreSetupRequired>());
  });

  test('un autre compte n\'hérite pas de la boutique en attente', () async {
    final device = _Device();
    final first = await device.launch();
    await first
        .read(authProvider.notifier)
        .register(phone, 'secret123', email: 'awa@example.com');

    await first
        .read(authProvider.notifier)
        .login('+2250700000002', 'secret123');
    expect(_status(first), isA<AuthPinSetupRequired>());
  });

  test('boutique enregistrée puis app fermée → création du PIN', () async {
    final device = _Device();
    final first = await device.launch();
    final auth = first.read(authProvider.notifier);
    await auth.register(phone, 'secret123', email: 'awa@example.com');
    await auth.proceedToPinSetup();
    first.dispose();

    final relaunched = await device.launch();
    final status = _status(relaunched);
    expect(status, isA<AuthPinSetupRequired>());
    // Hors du parcours d'inscription : pas de retour vers la boutique.
    expect((status! as AuthPinSetupRequired).canReturnToStoreSetup, isFalse);
  });

  test('email déjà utilisé : erreur rattachée au champ email', () async {
    final device = _Device();
    when(() => device.remote.register(any())).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/api/v1/auth/register'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/v1/auth/register'),
          statusCode: 409,
          data: {
            'detail': 'This email is already registered.',
            'code': 'CONFLICT',
            'field': 'email',
          },
        ),
      ),
    );
    final app = await device.launch();

    await app
        .read(authProvider.notifier)
        .register(phone, 'secret123', email: 'awa@example.com');

    final error = _error(app);
    expect(error, isA<RegisterFieldError>());
    expect((error! as RegisterFieldError).field, RegisterField.email);
    expect(error.toString(), 'Cet email est déjà enregistré.');
  });

  test('retour PIN → boutique uniquement pendant l\'inscription', () async {
    final app = await _Device().launch();
    final auth = app.read(authProvider.notifier);
    await auth.register(phone, 'secret123', email: 'awa@example.com');
    await auth.proceedToPinSetup();

    auth.returnToStoreSetup();
    final status = _status(app);
    expect(status, isA<AuthStoreSetupRequired>());
    expect((status! as AuthStoreSetupRequired).isRevisit, isTrue);

    final other = await _Device().launch();
    await other.read(authProvider.notifier).login(phone, 'secret123');
    other.read(authProvider.notifier).returnToStoreSetup();
    expect(_status(other), isA<AuthPinSetupRequired>());
  });

  test('connexion sans PIN → création du PIN → Authenticated', () async {
    final app = await _Device().launch();
    final auth = app.read(authProvider.notifier);

    await auth.login(phone, 'secret123');
    expect(_status(app), isA<AuthPinSetupRequired>());

    await auth.setupPin('2580');
    expect(_status(app), isA<AuthAuthenticated>());
  });

  test('connexion avec PIN existant → saisie du PIN → Authenticated', () async {
    final device = _Device();
    final first = await device.launch();
    await first.read(authProvider.notifier).login(phone, 'secret123');
    await first.read(authProvider.notifier).setupPin('2580');
    first.dispose();

    final relaunched = await device.launch();
    expect(_status(relaunched), isA<AuthPinRequired>());

    await relaunched.read(authProvider.notifier).verifyPin('2580');
    expect(_status(relaunched), isA<AuthAuthenticated>());
  });

  test('identifiants refusés → InvalidCredentials', () async {
    final app = await _Device().launch();
    await app.read(authProvider.notifier).login(phone, 'mauvais');
    expect(_error(app), isA<InvalidCredentials>());
  });

  test('PIN erroné → tentatives restantes, puis blocage au '
      '${AppConfig.maxPinAttempts}e échec', () async {
    final app = await _Device().launch();
    final auth = app.read(authProvider.notifier);
    await auth.login(phone, 'secret123');
    await auth.setupPin('2580');

    for (var i = 1; i < AppConfig.maxPinAttempts; i++) {
      await auth.verifyPin('1111');
      final error = _error(app);
      expect(error, isA<WrongPin>());
      expect(
        (error! as WrongPin).remainingAttempts,
        AppConfig.maxPinAttempts - i,
      );
    }

    await auth.verifyPin('1111');
    expect(_error(app), isA<PinLocked>());
    expect(await auth.pinLockedUntil(), isNotNull);

    // Même le bon PIN est refusé pendant le blocage.
    await auth.verifyPin('2580');
    expect(_error(app), isA<PinLocked>());
  });

  test(
    'session expirée → Unauthenticated(sessionExpired), PIN conservé',
    () async {
      final device = _Device();
      final app = await device.launch();
      final auth = app.read(authProvider.notifier);
      await auth.login(phone, 'secret123');
      await auth.setupPin('2580');

      app.read(authExpiredControllerProvider).add(null);
      await Future<void>.delayed(Duration.zero);

      final status = _status(app);
      expect(status, isA<AuthUnauthenticated>());
      expect((status! as AuthUnauthenticated).sessionExpired, isTrue);

      await auth.login(phone, 'secret123');
      expect(_status(app), isA<AuthPinRequired>());
    },
  );

  test('déconnexion → Unauthenticated, PIN supprimé', () async {
    final device = _Device();
    final app = await device.launch();
    final auth = app.read(authProvider.notifier);
    await auth.login(phone, 'secret123');
    await auth.setupPin('2580');

    await auth.logout();
    final status = _status(app);
    expect(status, isA<AuthUnauthenticated>());
    expect((status! as AuthUnauthenticated).sessionExpired, isFalse);
    verify(device.storeRepo.clearLocal).called(greaterThan(0));

    await auth.login(phone, 'secret123');
    expect(_status(app), isA<AuthPinSetupRequired>());
  });

  test('verrouillage → PIN redemandé, panier conservé jusqu\'à la '
      'déconnexion', () async {
    final app = await _Device().launch();
    final auth = app.read(authProvider.notifier);
    await auth.login(phone, 'secret123');
    await auth.setupPin('2580');
    app
        .read(cartProvider.notifier)
        .addItem(
          Product(
            id: 'p1',
            name: 'Coca-Cola',
            sellingPrice: Decimal.parse('2500'),
            updatedAt: DateTime(2026),
          ),
        );

    auth.lock();
    expect(_status(app), isA<AuthPinRequired>());

    await auth.verifyPin('2580');
    expect(_status(app), isA<AuthAuthenticated>());
    expect(app.read(cartProvider).items, hasLength(1));

    await auth.logout();
    expect(app.read(cartProvider).isEmpty, isTrue);
  });

  test('verrouillage sans effet hors session authentifiée', () async {
    final app = await _Device().launch();
    app.read(authProvider.notifier).lock();
    expect(_status(app), isA<AuthUnauthenticated>());
  });

  group('boutique suspendue', () {
    const contact = 'support@pos.ci';
    const whatsApp = '+2250700000000';

    /// Connecté avec un PIN, puis le serveur signale la suspension.
    Future<(ProviderContainer, _Device)> suspendedSession() async {
      final device = _Device();
      final app = await device.launch();
      final auth = app.read(authProvider.notifier);
      await auth.login(phone, 'secret123');
      await auth.setupPin('2580');
      app
          .read(storeSuspendedControllerProvider)
          .add(
            StoreSuspendedException(
              detail: 'Store is suspended.',
              supportContact: contact,
              supportWhatsApp: whatsApp,
            ),
          );
      await pumpEventQueue();
      return (app, device);
    }

    test('signalée en cours de session → écran de suspension', () async {
      final (app, _) = await suspendedSession();
      final status = _status(app);
      expect(status, isA<AuthStoreSuspended>());
      expect((status! as AuthStoreSuspended).supportContact, contact);
    });

    test('mémorisée : un redémarrage (même hors ligne) reste bloqué', () async {
      final (app, device) = await suspendedSession();
      app.dispose();

      final relaunched = await device.launch();
      final status = _status(relaunched);
      expect(status, isA<AuthStoreSuspended>());
      expect((status! as AuthStoreSuspended).supportContact, contact);
      expect((status as AuthStoreSuspended).supportWhatsApp, whatsApp);
    });

    test('connexion refusée pour suspension → écran de suspension', () async {
      final device = _Device();
      when(() => device.remote.login(any())).thenThrow(suspendedError());
      final app = await device.launch();

      await app.read(authProvider.notifier).login(phone, 'secret123');

      expect(_status(app), isA<AuthStoreSuspended>());
      expect(_error(app), isNull);
    });

    test('réessayer, boutique réactivée → PIN demandé, plus bloquée', () async {
      final (app, device) = await suspendedSession();

      final message = await app
          .read(authProvider.notifier)
          .retryAfterSuspension();

      expect(message, isNull);
      expect(_status(app), isA<AuthPinRequired>());
      app.dispose();
      expect(_status(await device.launch()), isA<AuthPinRequired>());
    });

    test('réessayer, toujours suspendue → reste bloquée, message', () async {
      final (app, device) = await suspendedSession();
      when(() => device.remote.refresh(any())).thenThrow(suspendedError());

      final message = await app
          .read(authProvider.notifier)
          .retryAfterSuspension();

      expect(message, isNotNull);
      expect(_status(app), isA<AuthStoreSuspended>());
    });

    test('réessayer sans session → écran de connexion', () async {
      final device = _Device();
      when(() => device.remote.login(any())).thenThrow(suspendedError());
      final app = await device.launch();
      await app.read(authProvider.notifier).login(phone, 'secret123');

      final message = await app
          .read(authProvider.notifier)
          .retryAfterSuspension();

      expect(message, isNull);
      expect(_status(app), isA<AuthUnauthenticated>());
    });

    test('reconnexion réussie : la suspension mémorisée est oubliée', () async {
      final (app, device) = await suspendedSession();
      app.dispose();
      final relaunched = await device.launch();

      await relaunched.read(authProvider.notifier).login(phone, 'secret123');

      expect(_status(relaunched), isA<AuthPinRequired>());
    });
  });

  group('code PIN oublié', () {
    test('mot de passe vérifié → nouveau PIN, l\'ancien est oublié, '
        'boutique conservée', () async {
      final device = _Device();
      final app = await device.launch();
      final auth = app.read(authProvider.notifier);
      await auth.login(phone, 'secret123');
      await auth.setupPin('2580');
      auth.lock();
      expect(_status(app), isA<AuthPinRequired>());
      clearInteractions(device.storeRepo);

      await auth.recoverPin('secret123');
      final status = _status(app);
      expect(status, isA<AuthPinSetupRequired>());
      // Hors inscription : pas de retour vers la boutique.
      expect((status! as AuthPinSetupRequired).canReturnToStoreSetup, isFalse);
      // Même compte : la boutique en cache n'est pas effacée.
      verifyNever(device.storeRepo.clearLocal);

      await auth.setupPin('1470');
      expect(_status(app), isA<AuthAuthenticated>());

      // L'ancien PIN ne déverrouille plus, le nouveau oui.
      auth.lock();
      await auth.verifyPin('2580');
      expect(_error(app), isA<WrongPin>());
      await auth.verifyPin('1470');
      expect(_status(app), isA<AuthAuthenticated>());
    });

    test('mot de passe faux → InvalidCredentials, rien ne change', () async {
      final app = await _Device().launch();
      final auth = app.read(authProvider.notifier);
      await auth.login(phone, 'secret123');
      await auth.setupPin('2580');
      auth.lock();

      await expectLater(
        auth.recoverPin('mauvais'),
        throwsA(isA<InvalidCredentials>()),
      );
      expect(_status(app), isA<AuthPinRequired>());
      await auth.verifyPin('2580');
      expect(_status(app), isA<AuthAuthenticated>());
    });

    test('possible pendant un blocage du PIN, qui est levé', () async {
      final app = await _Device().launch();
      final auth = app.read(authProvider.notifier);
      await auth.login(phone, 'secret123');
      await auth.setupPin('2580');
      for (var i = 0; i < AppConfig.maxPinAttempts; i++) {
        await auth.verifyPin('1111');
      }
      expect(_error(app), isA<PinLocked>());

      await auth.recoverPin('secret123');
      expect(_status(app), isA<AuthPinSetupRequired>());
      await auth.setupPin('1470');
      expect(_status(app), isA<AuthAuthenticated>());
      expect(await auth.pinLockedUntil(), isNull);
    });
  });
}
