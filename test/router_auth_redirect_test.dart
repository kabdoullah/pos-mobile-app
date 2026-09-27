import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';

AsyncValue<AuthStatus> _data(AuthStatus status) => AsyncData(status);

const _user = User(id: 'u1', phoneNumber: '+2250700000001');

void main() {
  test('chargement initial : on reste sur le splash', () {
    expect(authRedirect(const AsyncLoading(), Routes.splash), isNull);
  });

  group('non connecté', () {
    const status = AuthUnauthenticated();

    test('splash → connexion', () {
      expect(authRedirect(_data(status), Routes.splash), Routes.emailLogin);
    });

    test('inscription et connexion restent accessibles', () {
      expect(authRedirect(_data(status), Routes.register), isNull);
      expect(authRedirect(_data(status), Routes.emailLogin), isNull);
    });

    test('une page de l\'app renvoie à la connexion', () {
      expect(authRedirect(_data(status), Routes.home), Routes.emailLogin);
      expect(authRedirect(_data(status), Routes.pinLogin), Routes.emailLogin);
    });

    test('session expirée → connexion', () {
      expect(
        authRedirect(
          _data(const AuthUnauthenticated(sessionExpired: true)),
          Routes.home,
        ),
        Routes.emailLogin,
      );
    });
  });

  test('chaque étape impose sa page, sans boucle', () {
    final cases = <AuthStatus, String>{
      const AuthStoreSetupRequired(): Routes.storeSetup,
      const AuthPinSetupRequired(): Routes.pinSetup,
      const AuthPinRequired(): Routes.pinLogin,
    };
    for (final MapEntry(key: status, value: route) in cases.entries) {
      for (final from in [Routes.splash, Routes.register, Routes.home]) {
        expect(authRedirect(_data(status), from), route);
      }
      // Déjà sur la bonne page : aucune redirection.
      expect(authRedirect(_data(status), route), isNull);
    }
  });

  group('authentifié', () {
    const status = AuthAuthenticated(_user);

    test('une route d\'auth renvoie à l\'accueil', () {
      for (final route in [
        Routes.splash,
        Routes.register,
        Routes.emailLogin,
        Routes.storeSetup,
        Routes.pinSetup,
        Routes.pinLogin,
      ]) {
        expect(authRedirect(_data(status), route), Routes.home, reason: route);
      }
    });

    test('les pages de l\'app restent accessibles', () {
      expect(authRedirect(_data(status), Routes.home), isNull);
      expect(authRedirect(_data(status), Routes.newSale), isNull);
    });
  });

  group('erreur d\'une action', () {
    const error = AsyncValue<AuthStatus>.error('x', StackTrace.empty);

    test('on reste sur la page qui affiche l\'erreur', () {
      expect(authRedirect(error, Routes.emailLogin), isNull);
      expect(authRedirect(error, Routes.register), isNull);
      expect(authRedirect(error, Routes.pinLogin), isNull);
      expect(authRedirect(error, Routes.pinSetup), isNull);
    });

    test('ailleurs → connexion', () {
      expect(authRedirect(error, Routes.home), Routes.emailLogin);
    });
  });
}
