import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/widgets/app_search_bar.dart';

void main() {
  testWidgets('« Effacer » apparaît après saisie, vide et notifie', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final changes = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppSearchBar(
            controller: controller,
            hintText: 'Rechercher',
            onChanged: changes.add,
          ),
        ),
      ),
    );
    expect(find.byTooltip('Effacer'), findsNothing);

    await tester.enterText(find.byType(TextField), 'coca');
    await tester.pump();
    expect(find.byTooltip('Effacer'), findsOneWidget);

    await tester.tap(find.byTooltip('Effacer'));
    await tester.pump();
    expect(controller.text, isEmpty);
    expect(changes.last, '');
    expect(find.byTooltip('Effacer'), findsNothing);
  });
}
