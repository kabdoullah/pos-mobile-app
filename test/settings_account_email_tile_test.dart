import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/features/auth/domain/entities/account_email.dart';
import 'package:mobile/features/auth/providers/account_email_provider.dart';
import 'package:mobile/features/settings/presentation/widgets/account_email_tile.dart';

class _FakeStatus extends AccountEmailStatus {
  _FakeStatus(this.account, {this.resendError});

  final AccountEmail account;
  final Object? resendError;
  int resendCalls = 0;

  @override
  Future<AccountEmail> build() async => account;

  @override
  Future<void> resendVerification() async {
    resendCalls++;
    if (resendError case final error?) throw error;
  }
}

Future<_FakeStatus> _pump(WidgetTester tester, _FakeStatus status) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [accountEmailStatusProvider.overrideWith(() => status)],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: AccountEmailTile()),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return status;
}

void main() {
  testWidgets('non confirmée : un appui renvoie le lien', (tester) async {
    final status = await _pump(
      tester,
      _FakeStatus(
        const AccountEmail(email: 'awa@example.com', isVerified: false),
      ),
    );

    expect(find.textContaining('Non confirmée'), findsOneWidget);
    await tester.tap(find.text('Adresse email'));
    await tester.pumpAndSettle();

    expect(status.resendCalls, 1);
    expect(
      find.textContaining('Lien envoyé à awa@example.com'),
      findsOneWidget,
    );
  });

  testWidgets('renvoi limité : message d\'erreur traduit', (tester) async {
    await _pump(
      tester,
      _FakeStatus(
        const AccountEmail(email: 'awa@example.com', isVerified: false),
        resendError: ApiException(
          statusCode: 429,
          code: 'RATE_LIMITED',
          detail: 'Too many requests. Try again later.',
        ),
      ),
    );

    await tester.tap(find.text('Adresse email'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Trop de tentatives'), findsOneWidget);
  });

  testWidgets('confirmée : rien à renvoyer', (tester) async {
    final status = await _pump(
      tester,
      _FakeStatus(
        const AccountEmail(email: 'awa@example.com', isVerified: true),
      ),
    );

    expect(find.text('awa@example.com · Confirmée'), findsOneWidget);
    await tester.tap(find.text('Adresse email'));
    await tester.pumpAndSettle();
    expect(status.resendCalls, 0);
  });

  testWidgets('ancien compte sans email : un appui ouvre l\'ajout', (
    tester,
  ) async {
    await _pump(
      tester,
      _FakeStatus(const AccountEmail(email: null, isVerified: false)),
    );

    expect(find.textContaining('Aucun email'), findsOneWidget);
    await tester.tap(find.text('Adresse email'));
    await tester.pumpAndSettle();
    expect(find.text('Ajouter un email'), findsOneWidget);
  });

  testWidgets('non confirmée : le crayon ouvre la correction pré-remplie', (
    tester,
  ) async {
    final status = await _pump(
      tester,
      _FakeStatus(
        const AccountEmail(email: 'awa@exmaple.com', isVerified: false),
      ),
    );

    await tester.tap(find.byTooltip('Corriger l’adresse'));
    await tester.pumpAndSettle();

    expect(find.text('Corriger mon email'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'awa@exmaple.com'), findsOneWidget);
    expect(status.resendCalls, 0);
  });
}
