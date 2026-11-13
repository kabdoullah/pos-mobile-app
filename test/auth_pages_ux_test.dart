import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/sync/sync_providers.dart';
import 'package:mobile/features/auth/domain/entities/pin_failure.dart';
import 'package:mobile/features/auth/domain/entities/store.dart';
import 'package:mobile/features/auth/presentation/pages/phone_login_page.dart';
import 'package:mobile/features/auth/presentation/pages/pin_login_page.dart';
import 'package:mobile/features/auth/presentation/pages/pin_setup_page.dart';
import 'package:mobile/features/auth/presentation/pages/register_page.dart';
import 'package:mobile/features/auth/presentation/pages/store_setup_page.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/auth/providers/store_provider.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_session.dart';
import 'package:mobile/features/cash_register/domain/repositories/cash_register_repository.dart';
import 'package:mobile/features/cash_register/providers/cash_register_di_providers.dart';

/// Auth pilotable : état initial fixé, erreurs de connexion / PIN simulées.
class _FakeAuth extends Auth {
  _FakeAuth(this.initial, {this.pinFailures = const [], this.registerError});

  final AuthStatus initial;

  /// Erreur renvoyée par [register] (null : inscription acceptée).
  final Object? registerError;

  /// Erreurs renvoyées successivement par [verifyPin].
  final List<PinFailure> pinFailures;
  int _pinCalls = 0;
  bool loggedOut = false;

  @override
  Future<AuthStatus> build() async => initial;

  @override
  Future<void> login(String phoneNumber, String password) async {
    state = const AsyncError(InvalidCredentials(), StackTrace.empty);
  }

  /// Email transmis au dernier appel de [register] (null si jamais appelé).
  String? registeredEmail;

  @override
  Future<void> register(
    String phoneNumber,
    String password, {
    required String email,
  }) async {
    registeredEmail = email;
    if (registerError != null) {
      state = AsyncError(registerError!, StackTrace.empty);
    }
  }

  @override
  Future<void> verifyPin(String pin) async {
    state = AsyncError(pinFailures[_pinCalls++], StackTrace.empty);
  }

  @override
  Future<DateTime?> pinLockedUntil() async => null;

  /// Mots de passe transmis à [recoverPin].
  final recoverAttempts = <String>[];

  @override
  Future<void> recoverPin(String password) async {
    recoverAttempts.add(password);
    if (password != 'secret123') throw const InvalidCredentials();
    state = const AsyncData(AuthPinSetupRequired());
  }

  @override
  Future<void> logout() async {
    loggedOut = true;
    state = const AsyncData(AuthUnauthenticated());
  }

  @override
  void clearError() {}
}

class _MockCashRegister extends Mock implements CashRegisterRepository {}

class _Store extends StoreConfig {
  @override
  Future<Store?> build() async =>
      const Store(name: 'Boutique Awa', isSubjectToVat: false);
}

Future<_FakeAuth> _pump(
  WidgetTester tester,
  Widget page, {
  AuthStatus status = const AuthUnauthenticated(),
  List<PinFailure> pinFailures = const [],
  Object? registerError,
  Size size = const Size(360, 740),
  bool dark = false,
  double keyboard = 0,
  int pendingSales = 0,
  CashSession? cashSession,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.view.viewInsets = FakeViewPadding(bottom: keyboard);
  addTearDown(tester.view.reset);

  final cash = _MockCashRegister();
  when(cash.getActiveSession).thenAnswer((_) async => cashSession);
  when(cash.hasPendingCashOperations).thenAnswer((_) async => false);
  when(cash.hasCloseAwaitingNote).thenAnswer((_) async => false);
  final auth = _FakeAuth(
    status,
    pinFailures: pinFailures,
    registerError: registerError,
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(() => auth),
        storeConfigProvider.overrideWith(_Store.new),
        cashRegisterRepositoryProvider.overrideWithValue(cash),
        pendingSyncCountProvider.overrideWith(
          (ref) => Stream.value(pendingSales),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: dark ? ThemeMode.dark : ThemeMode.light,
        home: page,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return auth;
}

Future<void> _tapDigits(WidgetTester tester, String digits) async {
  for (final d in digits.split('')) {
    await tester.tap(find.bySemanticsLabel(d).last);
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

void main() {
  group('mise en page sans débordement', () {
    final pages = <String, (Widget, AuthStatus)>{
      'connexion': (const PhoneLoginPage(), const AuthUnauthenticated()),
      'inscription': (const RegisterPage(), const AuthUnauthenticated()),
      'boutique': (const StoreSetupPage(), const AuthStoreSetupRequired()),
      'création du PIN': (
        const PinSetupPage(),
        const AuthPinSetupRequired(canReturnToStoreSetup: true),
      ),
      'saisie du PIN': (const PinLoginPage(), const AuthPinRequired()),
    };

    for (final MapEntry(key: name, value: (page, status)) in pages.entries) {
      testWidgets('$name : petit écran, sombre, clavier ouvert', (
        tester,
      ) async {
        await _pump(
          tester,
          page,
          status: status,
          size: const Size(320, 568),
          dark: true,
          keyboard: 260,
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('$name : tablette', (tester) async {
        await _pump(tester, page, status: status, size: const Size(1024, 768));
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('connexion', () {
    testWidgets('identifiants refusés : message sous le mot de passe, '
        'téléphone conservé', (tester) async {
      await _pump(tester, const PhoneLoginPage());

      await tester.enterText(
        find.widgetWithText(TextField, '07 00 00 00 00'),
        '0700000001',
      );
      await tester.enterText(find.byType(TextField).last, 'mauvais');
      await tester.tap(find.text('Se connecter'));
      await tester.pumpAndSettle();

      expect(find.text('Téléphone ou mot de passe incorrect.'), findsOneWidget);
      expect(find.text('Connexion impossible'), findsNothing);
      expect(find.text('07 00 00 00 01'), findsOneWidget);
    });

    testWidgets('session expirée : bandeau explicatif', (tester) async {
      await _pump(
        tester,
        const PhoneLoginPage(),
        status: const AuthUnauthenticated(sessionExpired: true),
      );
      expect(find.text('Votre session a expiré'), findsOneWidget);
    });

    testWidgets('champs vides : erreurs inline, pas de SnackBar', (
      tester,
    ) async {
      await _pump(tester, const PhoneLoginPage());
      await tester.tap(find.text('Se connecter'));
      await tester.pumpAndSettle();

      expect(find.text('Saisissez votre numéro de téléphone.'), findsOneWidget);
      expect(find.text('Saisissez votre mot de passe.'), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
    });
  });

  group('inscription', () {
    testWidgets('validation inline des mots de passe', (tester) async {
      await _pump(tester, const RegisterPage());
      final fields = find.byType(TextField);

      await tester.enterText(fields.at(0), '0700000001');
      await tester.pump();
      expect(find.text('Numéro valide'), findsOneWidget);

      await tester.enterText(fields.at(2), 'secret123');
      await tester.enterText(fields.at(3), 'secret124');
      await tester.pump();
      expect(
        find.text('Les mots de passe ne correspondent pas.'),
        findsOneWidget,
      );

      await tester.enterText(fields.at(3), 'secret123');
      await tester.pump();
      expect(find.text('Les mots de passe correspondent'), findsOneWidget);
    });

    testWidgets('email obligatoire : pas d\'inscription sans adresse', (
      tester,
    ) async {
      final auth = await _pump(tester, const RegisterPage());
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), '0700000001');
      await tester.enterText(fields.at(2), 'secret123');
      await tester.enterText(fields.at(3), 'secret123');

      final submit = find.text('Continuer');
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pump();
      expect(find.text('Saisissez votre adresse email.'), findsOneWidget);
      expect(auth.registeredEmail, isNull);

      await tester.enterText(fields.at(1), 'awa@example.com');
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pump();
      expect(auth.registeredEmail, 'awa@example.com');
    });

    testWidgets('email refusé par le serveur : message sous le champ email, '
        'pas de bandeau', (tester) async {
      await _pump(
        tester,
        const RegisterPage(),
        registerError: const RegisterFieldError(
          field: RegisterField.email,
          message: 'Cet email est déjà enregistré.',
        ),
      );
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), '0700000001');
      await tester.enterText(fields.at(1), 'awa@example.com');
      await tester.enterText(fields.at(2), 'secret123');
      await tester.enterText(fields.at(3), 'secret123');

      final submit = find.text('Continuer');
      await tester.ensureVisible(submit);
      await tester.tap(submit);
      await tester.pumpAndSettle();

      expect(find.text('Cet email est déjà enregistré.'), findsOneWidget);
      expect(find.text('Inscription impossible'), findsNothing);
    });
  });

  group('boutique', () {
    testWidgets('informations fiscales repliées jusqu\'à la demande', (
      tester,
    ) async {
      await _pump(
        tester,
        const StoreSetupPage(),
        status: const AuthStoreSetupRequired(),
      );
      expect(find.text('Assujetti à la TVA'), findsNothing);
      // Première visite : pas de pré-remplissage avec la boutique par défaut.
      expect(find.text('Boutique Awa'), findsNothing);

      final toggle = find.text('Ajouter mes informations fiscales');
      await tester.ensureVisible(toggle);
      await tester.tap(toggle);
      await tester.pumpAndSettle();
      expect(find.text('Assujetti à la TVA'), findsOneWidget);
    });

    testWidgets('retour depuis l\'étape PIN : formulaire pré-rempli', (
      tester,
    ) async {
      await _pump(
        tester,
        const StoreSetupPage(),
        status: const AuthStoreSetupRequired(isRevisit: true),
      );
      expect(find.text('Boutique Awa'), findsOneWidget);
    });
  });

  group('création du PIN', () {
    testWidgets('PIN trop simple refusé', (tester) async {
      await _pump(
        tester,
        const PinSetupPage(),
        status: const AuthPinSetupRequired(),
      );
      await _tapDigits(tester, '1234');
      expect(find.text('Choisissez un PIN plus sécurisé.'), findsOneWidget);
      expect(find.text('Créez un code PIN'), findsOneWidget);
    });

    testWidgets('hors inscription : ni étapes ni retour', (tester) async {
      await _pump(
        tester,
        const PinSetupPage(),
        status: const AuthPinSetupRequired(),
      );
      expect(find.byTooltip('Retour à la boutique'), findsNothing);
    });

    testWidgets('inscription : retour vers la boutique', (tester) async {
      await _pump(
        tester,
        const PinSetupPage(),
        status: const AuthPinSetupRequired(canReturnToStoreSetup: true),
      );
      expect(find.byTooltip('Retour à la boutique'), findsOneWidget);
    });
  });

  group('saisie du PIN', () {
    testWidgets('tentatives restantes, dernière tentative, puis blocage', (
      tester,
    ) async {
      await _pump(
        tester,
        const PinLoginPage(),
        status: const AuthPinRequired(),
        pinFailures: [
          const WrongPin(remainingAttempts: 2),
          const WrongPin(remainingAttempts: 1),
          PinLocked(until: DateTime.now().add(const Duration(minutes: 5))),
        ],
      );
      expect(find.text('Boutique Awa'), findsOneWidget);

      await _tapDigits(tester, '1111');
      expect(find.text('Il vous reste 2 tentatives.'), findsOneWidget);

      await _tapDigits(tester, '1111');
      expect(find.text('Dernière tentative'), findsOneWidget);

      await _tapDigits(tester, '1111');
      expect(find.text('PIN temporairement bloqué'), findsOneWidget);
      expect(find.textContaining('Réessayez dans 4 min'), findsOneWidget);

      // Pavé désactivé pendant le blocage : la saisie est ignorée.
      await _tapDigits(tester, '1');
      expect(find.bySemanticsLabel('0 chiffre saisi sur 4'), findsOneWidget);
    });

    testWidgets('code PIN oublié : mot de passe vérifié, sinon refusé', (
      tester,
    ) async {
      final auth = await _pump(
        tester,
        const PinLoginPage(),
        status: const AuthPinRequired(),
      );

      await tester.tap(find.text('Code PIN oublié ?'));
      await tester.pumpAndSettle();
      expect(find.text('Code PIN oublié'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'mauvais');
      await tester.tap(find.text('Vérifier et choisir un nouveau PIN'));
      await tester.pumpAndSettle();
      expect(find.text('Mot de passe incorrect.'), findsOneWidget);
      expect(auth.state.value, isA<AuthPinRequired>());

      await tester.enterText(find.byType(TextField), 'secret123');
      await tester.tap(find.text('Vérifier et choisir un nouveau PIN'));
      await tester.pumpAndSettle();
      expect(auth.recoverAttempts, ['mauvais', 'secret123']);
      expect(auth.state.value, isA<AuthPinSetupRequired>());
      expect(find.text('Code PIN oublié'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('changer de compte : confirmation puis déconnexion', (
      tester,
    ) async {
      final auth = await _pump(
        tester,
        const PinLoginPage(),
        status: const AuthPinRequired(),
        pendingSales: 2,
      );

      await tester.tap(find.text('Changer de compte'));
      await tester.pumpAndSettle();
      expect(find.text('Changer de compte ?'), findsOneWidget);
      expect(find.textContaining('2 modifications pas encore'), findsOneWidget);

      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();
      expect(auth.loggedOut, isFalse);

      await tester.tap(find.text('Changer de compte'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.widgetWithText(ElevatedButton, 'Changer de compte'),
      );
      await tester.pumpAndSettle();
      expect(auth.loggedOut, isTrue);
    });

    testWidgets('changer de compte : refusé tant que la caisse est ouverte', (
      tester,
    ) async {
      final auth = await _pump(
        tester,
        const PinLoginPage(),
        status: const AuthPinRequired(),
        cashSession: CashSession(
          id: 'session-1',
          deviceId: 'device-1',
          status: CashSessionStatus.open,
          openingAmount: Decimal.zero,
          openedAt: DateTime.utc(2026),
          syncStatus: CashSyncStatus.synced,
          serverRecalculated: false,
        ),
      );

      await tester.tap(find.text('Changer de compte'));
      await tester.pumpAndSettle();

      expect(
        find.text('Clôturez la caisse avant de vous déconnecter.'),
        findsOneWidget,
      );
      expect(find.text('Changer de compte ?'), findsNothing);
      expect(auth.loggedOut, isFalse);
    });
  });
}
