import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/widgets/index.dart';

void main() {
  testWidgets(
    'écran étroit et libellé long : action pleine largeur, Annuler dessous',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
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

      final confirm = tester.getRect(find.byType(PrimaryButton));
      final cancel = tester.getRect(find.byType(AppDialogTextAction));
      expect(cancel.top, greaterThanOrEqualTo(confirm.bottom));
      expect(cancel.width, confirm.width);
      // Boutons de dialogue en 48 dp (maquette v2), 56 sur les écrans.
      expect(confirm.height, 48);
      expect(cancel.height, 48);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('confirmer retourne true, annuler retourne false', (
    tester,
  ) async {
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await showConfirmDialog(
              context,
              title: 'Vider le panier ?',
              message: 'Le stock n’est pas modifié.',
              confirmLabel: 'Vider le panier',
            ),
            child: const Text('ouvrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('ouvrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vider le panier'));
    await tester.pumpAndSettle();
    expect(result, isTrue);

    await tester.tap(find.text('ouvrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });
}
