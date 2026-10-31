import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/features/auth/presentation/pages/store_suspended_page.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';

class _FakeAuth extends Auth {
  _FakeAuth(this.initial, {this.retryMessage});

  final AuthStatus initial;
  final String? retryMessage;
  int retries = 0;

  @override
  Future<AuthStatus> build() async => initial;

  @override
  Future<String?> retryAfterSuspension() async {
    retries++;
    return retryMessage;
  }
}

Future<_FakeAuth> _pump(
  WidgetTester tester, {
  String? contact,
  String? retryMessage,
  bool dark = false,
}) async {
  tester.view.physicalSize = const Size(320, 568);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final auth = _FakeAuth(
    AuthStoreSuspended(supportContact: contact),
    retryMessage: retryMessage,
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authProvider.overrideWith(() => auth)],
      child: MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: dark ? ThemeMode.dark : ThemeMode.light,
        home: const StoreSuspendedPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return auth;
}

void main() {
  testWidgets('explique la suspension et rassure sur les données', (
    tester,
  ) async {
    await _pump(tester, contact: '+225 07 00 00 00 00');

    expect(find.text('Boutique suspendue'), findsOneWidget);
    expect(find.textContaining('conservées'), findsOneWidget);
    expect(find.text('+225 07 00 00 00 00'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sans contact configuré : pas de bouton de contact', (
    tester,
  ) async {
    await _pump(tester);

    expect(find.text('Boutique suspendue'), findsOneWidget);
    expect(find.byIcon(Icons.call_outlined), findsNothing);
    expect(find.byIcon(Icons.mail_outline), findsNothing);
  });

  testWidgets('contact email : icône mail', (tester) async {
    await _pump(tester, contact: 'support@exemple.ci');

    expect(find.byIcon(Icons.mail_outline), findsOneWidget);
  });

  testWidgets('réessayer : interroge le serveur et affiche le refus', (
    tester,
  ) async {
    final auth = await _pump(
      tester,
      contact: '+2250700000000',
      retryMessage: 'Votre boutique est toujours suspendue.',
    );

    // La police de test (Ahem) grossit les textes : on fait défiler.
    await tester.ensureVisible(find.text('Réessayer'));
    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();

    expect(auth.retries, 1);
    expect(find.text('Votre boutique est toujours suspendue.'), findsOneWidget);
  });

  testWidgets('mode sombre : aucun débordement', (tester) async {
    await _pump(tester, contact: '+2250700000000', dark: true);
    expect(tester.takeException(), isNull);
  });
}
