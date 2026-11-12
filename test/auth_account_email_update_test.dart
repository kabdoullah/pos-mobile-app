import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/features/auth/domain/entities/account_email.dart';
import 'package:mobile/features/auth/domain/repositories/profile_repository.dart';
import 'package:mobile/features/auth/presentation/widgets/account_email_sheet.dart';
import 'package:mobile/features/auth/providers/auth_di_providers.dart';
import 'package:mobile/features/home/presentation/widgets/account_email_banner.dart';

/// Profil en mémoire : état de l'email, mot de passe attendu, report du rappel.
class _FakeProfile implements ProfileRepository {
  _FakeProfile(this.account);

  AccountEmail account;
  DateTime? snoozedUntil;
  int resendCalls = 0;
  static const password = 'secret123';

  @override
  Future<AccountEmail> getAccountEmail() async => account;

  @override
  Future<AccountEmail> updateEmail({
    required String email,
    required String password,
  }) async {
    if (password != _FakeProfile.password) {
      throw ApiException(
        statusCode: 403,
        code: 'FORBIDDEN',
        detail: 'Invalid password.',
      );
    }
    return account = AccountEmail(email: email, isVerified: false);
  }

  @override
  Future<void> resendEmailVerification() async => resendCalls++;

  @override
  Future<DateTime?> emailReminderSnoozedUntil() async => snoozedUntil;

  @override
  Future<void> snoozeEmailReminder(DateTime until) async =>
      snoozedUntil = until;

  @override
  Future<String?> getDisplayName() async => null;

  @override
  Future<String?> updateDisplayName(String? displayName) async => displayName;

  @override
  Future<void> clearLocal() async {}
}

Future<void> _pump(WidgetTester tester, _FakeProfile profile, Widget child) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [profileRepositoryProvider.overrideWithValue(profile)],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: ListView(children: [child])),
      ),
    ),
  );
}

const _noEmail = AccountEmail(email: null, isVerified: false);
const _unverified = AccountEmail(email: 'awa@example.com', isVerified: false);

void main() {
  group('rappel de l\'accueil', () {
    testWidgets('compte sans email : ajout depuis la bannière', (tester) async {
      final profile = _FakeProfile(_noEmail);
      await _pump(tester, profile, const AccountEmailBanner());
      await tester.pumpAndSettle();

      expect(find.text('Ajoutez un email de récupération'), findsOneWidget);
      await tester.tap(find.text('Ajouter'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'awa@example.com');
      await tester.enterText(fields.at(1), _FakeProfile.password);
      await tester.tap(find.text('Enregistrer et envoyer le lien'));
      await tester.pumpAndSettle();

      expect(profile.account.email, 'awa@example.com');
      expect(find.textContaining('Lien envoyé à awa@example.com'), findsOne);
      // La bannière passe à l'étape suivante : confirmer l'adresse.
      expect(find.text('Confirmez votre email'), findsOneWidget);
    });

    testWidgets('« Plus tard » masque le rappel 7 jours', (tester) async {
      final profile = _FakeProfile(_unverified);
      await _pump(tester, profile, const AccountEmailBanner());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Plus tard'));
      await tester.pumpAndSettle();

      expect(find.text('Confirmez votre email'), findsNothing);
      final snoozed = profile.snoozedUntil!;
      expect(snoozed.difference(DateTime.now()).inDays, inInclusiveRange(6, 7));
    });

    testWidgets('reporté : rien à l\'ouverture', (tester) async {
      final profile = _FakeProfile(_noEmail)
        ..snoozedUntil = DateTime.now().add(const Duration(days: 3));
      await _pump(tester, profile, const AccountEmailBanner());
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsNothing);
      expect(find.text('Ajoutez un email de récupération'), findsNothing);
    });

    testWidgets('email confirmé : pas de rappel', (tester) async {
      final profile = _FakeProfile(
        const AccountEmail(email: 'awa@example.com', isVerified: true),
      );
      await _pump(tester, profile, const AccountEmailBanner());
      await tester.pumpAndSettle();

      expect(find.textContaining('email'), findsNothing);
    });

    testWidgets('non confirmé : « Renvoyer le lien »', (tester) async {
      final profile = _FakeProfile(_unverified);
      await _pump(tester, profile, const AccountEmailBanner());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Renvoyer le lien'));
      await tester.pumpAndSettle();

      expect(profile.resendCalls, 1);
    });
  });

  group('feuille de saisie', () {
    testWidgets('mot de passe faux : erreur affichée, feuille ouverte', (
      tester,
    ) async {
      final profile = _FakeProfile(_noEmail);
      await _pump(tester, profile, const AccountEmailSheet());

      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'awa@example.com');
      await tester.enterText(fields.at(1), 'faux');
      await tester.tap(find.text('Enregistrer et envoyer le lien'));
      await tester.pumpAndSettle();

      expect(find.text('Mot de passe incorrect.'), findsOneWidget);
      expect(profile.account.email, isNull);
    });

    testWidgets('champs vides : rien n\'est envoyé', (tester) async {
      final profile = _FakeProfile(_noEmail);
      await _pump(tester, profile, const AccountEmailSheet());

      await tester.tap(find.text('Enregistrer et envoyer le lien'));
      await tester.pumpAndSettle();

      expect(find.text('Saisissez votre adresse email.'), findsOneWidget);
      expect(find.text('Saisissez votre mot de passe.'), findsOneWidget);
      expect(profile.account.email, isNull);
    });
  });

  testWidgets('hors ligne : pas de rappel', (tester) async {
    await _pump(tester, _OfflineProfile(), const AccountEmailBanner());
    await tester.pump();

    expect(find.text('Ajoutez un email de récupération'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

class _OfflineProfile extends _FakeProfile {
  _OfflineProfile() : super(_noEmail);

  @override
  Future<AccountEmail> getAccountEmail() async => throw ConnectionException();
}
