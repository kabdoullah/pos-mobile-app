import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/core/storage/pin_storage.dart';
import 'package:mobile/core/storage/secure_token_storage.dart';
import 'package:mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mobile/features/auth/data/models/auth_models.dart';
import 'package:mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/pages/reset_password_page.dart';
import 'package:mobile/features/auth/providers/auth_di_providers.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}

class _MockRepo extends Mock implements AuthRepository {}

class _MockTokenStorage extends Mock implements SecureTokenStorage {}

class _MockPinStorage extends Mock implements PinStorage {}

const _token = 'tok-123';
const _newPassword = 'nouveau123';

DioException _http(int status, Map<String, Object?> body) => DioException(
  requestOptions: RequestOptions(path: '/api/v1/auth/reset-password'),
  response: Response(
    requestOptions: RequestOptions(path: '/api/v1/auth/reset-password'),
    statusCode: status,
    data: body,
  ),
);

ApiException _invalidToken() => ApiException(
  statusCode: 422,
  code: 'VALIDATION_ERROR',
  detail: 'Invalid or expired token.',
);

/// Monte la page via go_router, comme à l'ouverture du lien de l'email.
Future<_MockRepo> _pump(WidgetTester tester, {String? token = _token}) async {
  final repo = _MockRepo();
  final router = GoRouter(
    initialLocation: token == null
        ? Routes.resetPassword
        : '${Routes.resetPassword}?token=$token',
    routes: [
      GoRoute(
        path: Routes.resetPassword,
        builder: (context, state) =>
            ResetPasswordPage(token: state.uri.queryParameters['token']),
      ),
      GoRoute(
        path: Routes.emailLogin,
        builder: (context, state) => const Scaffold(body: Text('LOGIN')),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return repo;
}

Future<void> _fill(WidgetTester tester, String password, String confirm) async {
  await tester.enterText(find.byType(TextField).at(0), password);
  await tester.enterText(find.byType(TextField).at(1), confirm);
  await tester.pump();
}

Future<void> _submit(WidgetTester tester) => _tapVisible(tester, 'Enregistrer');

/// Fait défiler jusqu'au bouton (formulaire plus haut que l'écran de test).
Future<void> _tapVisible(WidgetTester tester, String label) async {
  final button = find.text(label);
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  await tester.tap(button);
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const ResetPasswordRequestDto(token: '', newPassword: ''),
    );
  });

  group('AuthRepositoryImpl.resetPassword', () {
    late _MockRemote remote;
    late AuthRepositoryImpl repo;

    setUp(() {
      remote = _MockRemote();
      repo = AuthRepositoryImpl(
        dataSource: remote,
        tokenStorage: _MockTokenStorage(),
        pinStorage: _MockPinStorage(),
      );
    });

    test('envoie le token et le nouveau mot de passe', () async {
      when(() => remote.resetPassword(any())).thenAnswer((_) async {});

      await repo.resetPassword(token: _token, newPassword: _newPassword);

      final sent =
          verify(() => remote.resetPassword(captureAny())).captured.single
              as ResetPasswordRequestDto;
      expect(sent.toJson(), {'token': _token, 'new_password': _newPassword});
    });

    test('token refusé → ApiException 422 sans champ', () async {
      when(() => remote.resetPassword(any())).thenThrow(
        _http(422, {
          'detail': 'Invalid or expired token.',
          'code': 'VALIDATION_ERROR',
        }),
      );

      await expectLater(
        repo.resetPassword(token: _token, newPassword: _newPassword),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 422)
              .having((e) => e.field, 'field', isNull),
        ),
      );
    });
  });

  group('ResetPasswordPage', () {
    testWidgets('mots de passe différents : rien n\'est envoyé', (
      tester,
    ) async {
      final repo = await _pump(tester);

      await _fill(tester, _newPassword, 'autre1234');
      await _submit(tester);

      expect(find.text('Les mots de passe ne correspondent pas.'), findsOne);
      verifyNever(
        () => repo.resetPassword(
          token: any(named: 'token'),
          newPassword: any(named: 'newPassword'),
        ),
      );
    });

    testWidgets('mot de passe trop court : rien n\'est envoyé', (tester) async {
      final repo = await _pump(tester);

      await _fill(tester, 'court', 'court');
      await _submit(tester);

      expect(find.text('Au moins 8 caractères.'), findsOne);
      verifyNever(
        () => repo.resetPassword(
          token: any(named: 'token'),
          newPassword: any(named: 'newPassword'),
        ),
      );
    });

    testWidgets('succès : enregistre puis renvoie à la connexion', (
      tester,
    ) async {
      final repo = await _pump(tester);
      when(
        () => repo.resetPassword(token: _token, newPassword: _newPassword),
      ).thenAnswer((_) async {});

      await _fill(tester, _newPassword, _newPassword);
      await _submit(tester);

      verify(
        () => repo.resetPassword(token: _token, newPassword: _newPassword),
      ).called(1);
      expect(find.text('LOGIN'), findsOne);
      expect(find.text('Mot de passe modifié. Connectez-vous.'), findsOne);
    });

    testWidgets('token refusé : affiche « lien invalide »', (tester) async {
      final repo = await _pump(tester);
      when(
        () => repo.resetPassword(
          token: any(named: 'token'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenThrow(_invalidToken());

      await _fill(tester, _newPassword, _newPassword);
      await _submit(tester);

      expect(find.text('Lien invalide ou expiré'), findsOne);
      await _tapVisible(tester, 'Retour à la connexion');
      expect(find.text('LOGIN'), findsOne);
    });

    testWidgets('erreur réseau : reste sur le formulaire avec un bandeau', (
      tester,
    ) async {
      final repo = await _pump(tester);
      when(
        () => repo.resetPassword(
          token: any(named: 'token'),
          newPassword: any(named: 'newPassword'),
        ),
      ).thenThrow(ConnectionException());

      await _fill(tester, _newPassword, _newPassword);
      await _submit(tester);

      expect(find.text('Modification impossible'), findsOne);
      expect(find.text(ConnectionException.offlineMessage), findsOne);
      expect(find.text('Enregistrer'), findsOne);
    });

    testWidgets('lien sans token : affiche « lien invalide »', (tester) async {
      await _pump(tester, token: null);

      expect(find.text('Lien invalide ou expiré'), findsOne);
      expect(find.text('Enregistrer'), findsNothing);
    });
  });
}
