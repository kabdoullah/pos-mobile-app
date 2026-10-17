import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/widgets/index.dart';

void main() {
  testWidgets(
    'écran étroit et libellé long : Annuler et l\'action sur la même ligne',
    (tester) async {
      // Largeur d'iPhone : avec un OverflowBar, ce libellé long empilait les
      // boutons.
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => showConfirmDialog(
                context,
                title: 'Oublier l\'imprimante ?',
                message: 'Elle devra être reconnectée.',
                confirmLabel: 'Oublier l\'imprimante',
                isDangerous: true,
              ),
              child: const Text('ouvrir'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('ouvrir'));
      await tester.pumpAndSettle();

      final confirm = tester.getRect(find.byType(ElevatedButton));
      final cancel = tester.getRect(
        find.ancestor(
          of: find.text('Annuler'),
          matching: find.byType(TextButton),
        ),
      );
      expect(cancel.top, confirm.top);
      expect(cancel.right, lessThan(confirm.left));
      expect(tester.takeException(), isNull);
    },
  );
}
