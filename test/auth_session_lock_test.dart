import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/config.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/auth/presentation/providers/session_lock_provider.dart';

const _user = User(id: 'u1', phoneNumber: '+2250700000001');

/// Auth déjà déverrouillé ; [lock] est celui de la vraie implémentation.
class _UnlockedAuth extends Auth {
  _UnlockedAuth(this._initial);

  final AuthStatus _initial;

  @override
  Future<AuthStatus> build() async => _initial;

  void unlock() => state = const AsyncData(AuthAuthenticated(_user));
}

const _timeout = Duration(minutes: AppConfig.sessionLockMinutes);
const _second = Duration(seconds: 1);

/// Lance une session dans [async] (horloge et timers simulés) et retourne le
/// conteneur, l'auth résolue et le verrou armé.
ProviderContainer _start(
  FakeAsync async, {
  AuthStatus initial = const AuthAuthenticated(_user),
}) {
  final container = ProviderContainer(
    overrides: [authProvider.overrideWith(() => _UnlockedAuth(initial))],
  );
  addTearDown(container.dispose);
  container.listen(authProvider, (_, _) {});
  container.listen(sessionLockProvider, (_, _) {});
  async.flushMicrotasks();
  return container;
}

AuthStatus? _status(ProviderContainer c) => c.read(authProvider).value;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  void runFake(void Function(FakeAsync async) body) => fakeAsync(
    (async) => withClock(async.getClock(DateTime(2026)), () {
      body(async);
    }),
  );

  test('verrouille après le délai sans activité', () {
    runFake((async) {
      final app = _start(async);
      async.elapse(_timeout - _second);
      expect(_status(app), isA<AuthAuthenticated>());
      async.elapse(_second);
      expect(_status(app), isA<AuthPinRequired>());
    });
  });

  test('une activité repousse le verrouillage', () {
    runFake((async) {
      final app = _start(async);
      async.elapse(_timeout - _second);
      app.read(sessionLockProvider.notifier).recordActivity();

      async.elapse(_timeout - _second);
      expect(_status(app), isA<AuthAuthenticated>());
      async.elapse(_second);
      expect(_status(app), isA<AuthPinRequired>());
    });
  });

  test('retour d\'arrière-plan après le délai → verrouillé', () {
    runFake((async) {
      final app = _start(async);
      // Timers suspendus en arrière-plan : seule l'horloge avance.
      async.elapse(const Duration(minutes: 1));
      app.read(sessionLockProvider.notifier)
        ..recordActivity()
        ..didChangeAppLifecycleState(AppLifecycleState.paused);
      withClock(Clock.fixed(clock.now().add(_timeout)), () {
        app
            .read(sessionLockProvider.notifier)
            .didChangeAppLifecycleState(AppLifecycleState.resumed);
      });
      expect(_status(app), isA<AuthPinRequired>());
    });
  });

  test('retour d\'arrière-plan avant le délai → reste ouvert', () {
    runFake((async) {
      final app = _start(async);
      withClock(Clock.fixed(clock.now().add(_timeout - _second)), () {
        app
            .read(sessionLockProvider.notifier)
            .didChangeAppLifecycleState(AppLifecycleState.resumed);
      });
      expect(_status(app), isA<AuthAuthenticated>());
    });
  });

  test('aucun verrouillage hors session authentifiée, réarmé au '
      'déverrouillage', () {
    runFake((async) {
      final app = _start(async, initial: const AuthPinRequired());
      app.read(sessionLockProvider.notifier).recordActivity();
      async.elapse(_timeout * 2);
      expect(_status(app), isA<AuthPinRequired>());

      (app.read(authProvider.notifier) as _UnlockedAuth).unlock();
      async.elapse(_timeout);
      expect(_status(app), isA<AuthPinRequired>());
    });
  });
}
