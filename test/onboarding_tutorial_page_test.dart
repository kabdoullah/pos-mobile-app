import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/onboarding/presentation/pages/tutorial_page.dart';

/// Monte le tutoriel : poussé depuis un écran (Paramètres) si [pushed], sinon
/// seul à la racine.
Future<GoRouter> pumpTutorial(
  WidgetTester tester, {
  required bool pushed,
}) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: pushed ? Routes.home : Routes.tutorial,
    routes: [
      GoRoute(path: Routes.home, builder: (_, _) => const Text('accueil')),
      GoRoute(path: Routes.tutorial, builder: (_, _) => const TutorialPage()),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
  );
  await tester.pumpAndSettle();
  if (pushed) {
    unawaited(router.push(Routes.tutorial));
    await tester.pumpAndSettle();
  }
  return router;
}

Future<void> tapNext(WidgetTester tester) async {
  await tester.tap(find.text('Suivant'));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  testWidgets('4 écrans, Précédent, puis « Fermer » revient aux Paramètres', (
    tester,
  ) async {
    await pumpTutorial(tester, pushed: true);
    expect(find.text('1 sur 4'), findsOneWidget);
    expect(find.text('Ajoutez vos produits'), findsOneWidget);
    expect(find.text('Précédent'), findsNothing);

    await tapNext(tester);
    expect(find.text('Ouvrez la caisse, puis vendez'), findsOneWidget);
    await tester.tap(find.text('Précédent'));
    await tester.pumpAndSettle();
    expect(find.text('1 sur 4'), findsOneWidget);

    await tapNext(tester);
    await tapNext(tester);
    await tapNext(tester);
    expect(find.text('Suivez vos ventes'), findsOneWidget);
    await tester.tap(find.text('Fermer'));
    await tester.pumpAndSettle();
    expect(find.text('accueil'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('seul : « Passer » et « Terminer » mènent à l’accueil', (
    tester,
  ) async {
    await pumpTutorial(tester, pushed: false);
    await tester.tap(find.text('Passer'));
    await tester.pumpAndSettle();
    expect(find.text('accueil'), findsOneWidget);
  });
}
