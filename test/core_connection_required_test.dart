import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/providers/connectivity_provider.dart';
import 'package:mobile/core/widgets/index.dart';

/// Monte un bouton qui lance `ensureOnline`, puis l'opération si autorisée.
Future<List<String>> pump(WidgetTester tester, {required bool? online}) async {
  final calls = <String>[];
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        isOnlineProvider.overrideWith(
          (ref) => online == null
              ? const Stream<bool>.empty()
              : Stream.value(online),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Consumer(
            builder: (context, ref, _) {
              // Garde le flux actif, comme l'app (indicateur hors ligne).
              ref.watch(isOnlineProvider);
              return TextButton(
                onPressed: () async {
                  if (await ensureOnline(
                    context,
                    ref,
                    action: 'L’ajustement du stock',
                  )) {
                    calls.add('serveur');
                  }
                },
                child: const Text('Valider'),
              );
            },
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return calls;
}

void main() {
  testWidgets('hors ligne : message clair, le serveur n’est pas appelé', (
    tester,
  ) async {
    final calls = await pump(tester, online: false);
    await tester.tap(find.text('Valider'));
    await tester.pumpAndSettle();

    expect(find.text('Pas de connexion internet'), findsOneWidget);
    expect(
      find.text(
        'L’ajustement du stock demande internet. Activez le Wi-Fi ou les '
        'données mobiles, puis réessayez.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Compris'));
    await tester.pumpAndSettle();
    expect(find.text('Pas de connexion internet'), findsNothing);
    expect(calls, isEmpty);
  });

  testWidgets('en ligne : aucun message, l’opération continue', (tester) async {
    final calls = await pump(tester, online: true);
    await tester.tap(find.text('Valider'));
    await tester.pumpAndSettle();
    expect(find.text('Pas de connexion internet'), findsNothing);
    expect(calls, ['serveur']);
  });

  testWidgets('état inconnu (démarrage) : la requête tranche', (tester) async {
    final calls = await pump(tester, online: null);
    await tester.tap(find.text('Valider'));
    await tester.pumpAndSettle();
    expect(find.text('Pas de connexion internet'), findsNothing);
    expect(calls, ['serveur']);
  });
}
