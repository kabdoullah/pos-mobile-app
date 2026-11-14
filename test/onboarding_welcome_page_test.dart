import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/auth/domain/entities/store.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile/features/auth/providers/auth_di_providers.dart';
import 'package:mobile/features/auth/providers/store_provider.dart';
import 'package:mobile/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepo extends Mock implements AuthRepository {}

class _Store extends StoreConfig {
  @override
  Future<Store?> build() async =>
      const Store(name: 'Boutik', isSubjectToVat: false);
}

/// Accueil factice qui ouvre la page, comme `HomePage` après l'inscription.
Future<_MockAuthRepo> _pump(WidgetTester tester) async {
  final repo = _MockAuthRepo();
  when(repo.completeWelcome).thenAnswer((_) async {});
  when(repo.isWelcomePending).thenAnswer((_) async => false);
  final router = GoRouter(
    initialLocation: Routes.home,
    routes: [
      GoRoute(
        path: Routes.home,
        builder: (context, _) => Scaffold(
          body: TextButton(
            onPressed: () => context.push(Routes.welcome),
            child: const Text('accueil'),
          ),
        ),
      ),
      GoRoute(path: Routes.welcome, builder: (_, _) => const WelcomePage()),
      GoRoute(
        path: Routes.tutorial,
        builder: (_, _) => const Scaffold(body: Text('tutoriel')),
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(repo),
        storeConfigProvider.overrideWith(_Store.new),
      ],
      child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('accueil'));
  await tester.pumpAndSettle();
  return repo;
}

void main() {
  testWidgets('nom de la boutique, « Passer » revient à l’accueil', (
    tester,
  ) async {
    final repo = await _pump(tester);
    expect(find.text('Boutik est prête'), findsOneWidget);

    await tester.tap(find.text('Passer, aller à l’accueil'));
    await tester.pumpAndSettle();
    expect(find.text('accueil'), findsOneWidget);
    verify(repo.completeWelcome).called(1);
  });

  testWidgets('« Découvrir » ouvre le tutoriel et ne revient plus', (
    tester,
  ) async {
    final repo = await _pump(tester);
    await tester.tap(find.text('Découvrir'));
    await tester.pumpAndSettle();
    expect(find.text('tutoriel'), findsOneWidget);
    verify(repo.completeWelcome).called(1);
  });
}
