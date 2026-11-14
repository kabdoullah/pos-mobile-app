import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/core/network/error_mapper.dart';
import 'package:mobile/core/utils/email_validator.dart';
import 'package:mobile/core/widgets/app_dialog.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/widgets/forgot_password_dialog.dart';
import 'package:mobile/features/auth/providers/auth_di_providers.dart';

class _MockRepo extends Mock implements AuthRepository {}

const _email = 'commercant@example.com';

/// Refus Pydantic d'une adresse mal formée (`POST /auth/forgot-password`).
ApiException _invalidEmail() => ApiException(
  statusCode: 422,
  code: 'VALIDATION_ERROR',
  detail:
      'value is not a valid email address: An email address must have '
      'an @-sign.',
  field: 'email',
);

/// Ouvre la boîte de dialogue depuis un écran, comme la page de connexion.
Future<_MockRepo> _open(WidgetTester tester) async {
  final repo = _MockRepo();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showForgotPasswordDialog(context),
              child: const Text('OUVRIR'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('OUVRIR'));
  await tester.pumpAndSettle();
  return repo;
}

Future<void> _send(WidgetTester tester, String email) async {
  await tester.enterText(find.byType(TextField), email);
  await tester.tap(find.text('Envoyer le lien'));
  await tester.pump();
}

void main() {
  group('isValidEmail', () {
    test('accepte une adresse complète, espaces autour ignorés', () {
      expect(isValidEmail(' $_email '), isTrue);
    });

    test('refuse vide, sans @ ou sans domaine', () {
      expect(isValidEmail(''), isFalse);
      expect(isValidEmail('pasunemail'), isFalse);
      expect(isValidEmail('a@b'), isFalse);
    });
  });

  test('errorToFrench : adresse refusée par le serveur', () {
    expect(errorToFrench(_invalidEmail()), 'Adresse email invalide.');
  });

  group('ForgotPasswordDialog', () {
    testWidgets('champ vide : erreur sous le champ, rien n\'est envoyé', (
      tester,
    ) async {
      final repo = await _open(tester);
      await _send(tester, '');

      expect(find.text('Saisissez votre adresse email.'), findsOneWidget);
      expect(find.byType(AppDialog), findsOneWidget);
      verifyNever(() => repo.sendPasswordReset(any()));
    });

    testWidgets('adresse mal formée : erreur sous le champ, rien n\'est '
        'envoyé', (tester) async {
      final repo = await _open(tester);
      await _send(tester, 'pasunemail');

      expect(find.text('Adresse email invalide.'), findsOneWidget);
      verifyNever(() => repo.sendPasswordReset(any()));
    });

    testWidgets('pendant l\'envoi : reste ouverte, boutons désactivés', (
      tester,
    ) async {
      final repo = await _open(tester);
      final pending = Completer<void>();
      when(
        () => repo.sendPasswordReset(any()),
      ).thenAnswer((_) => pending.future);

      await _send(tester, _email);

      expect(find.text('Envoi…'), findsOneWidget);
      expect(find.byType(AppDialog), findsOneWidget);
      final cancel = tester.widget<TextButton>(
        find.widgetWithText(TextButton, 'Annuler'),
      );
      expect(cancel.onPressed, isNull);

      pending.complete();
      await tester.pumpAndSettle();
      expect(find.text('Vérifiez vos e-mails'), findsOneWidget);
    });

    testWidgets('succès : « Vérifiez vos e-mails », puis Fermer', (
      tester,
    ) async {
      final repo = await _open(tester);
      when(() => repo.sendPasswordReset(any())).thenAnswer((_) async {});

      await _send(tester, ' $_email ');
      await tester.pumpAndSettle();

      verify(() => repo.sendPasswordReset(_email)).called(1);
      expect(find.text('Vérifiez vos e-mails'), findsOneWidget);
      expect(
        find.textContaining('Le lien est valable 1 heure'),
        findsOneWidget,
      );

      await tester.tap(find.text('Fermer'));
      await tester.pumpAndSettle();
      expect(find.byType(AppDialog), findsNothing);
    });

    testWidgets('adresse refusée par le serveur : message traduit sous le '
        'champ, reste ouverte', (tester) async {
      final repo = await _open(tester);
      when(() => repo.sendPasswordReset(any())).thenThrow(_invalidEmail());

      await _send(tester, 'x@y.z');
      await tester.pumpAndSettle();

      expect(find.text('Adresse email invalide.'), findsOneWidget);
      expect(find.text('Une erreur est survenue.'), findsNothing);
      expect(find.byType(AppDialog), findsOneWidget);

      // Corriger l'adresse efface le refus.
      await tester.enterText(find.byType(TextField), 'x@y.zz');
      await tester.pump();
      expect(find.text('Adresse email invalide.'), findsNothing);
    });

    testWidgets('hors ligne : message réseau, reste ouverte', (tester) async {
      final repo = await _open(tester);
      when(
        () => repo.sendPasswordReset(any()),
      ).thenThrow(ConnectionException());

      await _send(tester, _email);
      await tester.pumpAndSettle();

      expect(find.text(ConnectionException.offlineMessage), findsOneWidget);
      expect(find.byType(AppDialog), findsOneWidget);
    });
  });
}
