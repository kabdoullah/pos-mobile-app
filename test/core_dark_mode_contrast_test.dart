import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/widgets/index.dart';

/// Ratio de contraste WCAG entre deux couleurs opaques.
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  for (final (name, theme) in [
    ('clair', AppTheme.light()),
    ('sombre', AppTheme.dark()),
  ]) {
    final background = theme.scaffoldBackgroundColor;

    testWidgets('icône d’état vide lisible (≥ 3:1), thème $name', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'Aucun produit',
              message: 'Ajoutez votre premier produit.',
            ),
          ),
        ),
      );
      final icon = tester.widget<Icon>(find.byIcon(Icons.inventory_2_outlined));
      expect(contrast(icon.color!, background), greaterThanOrEqualTo(3));
    });

    testWidgets('indicateur de chargement visible (≥ 3:1), thème $name', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(body: Center(child: AppLoadingIndicator())),
        ),
      );
      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(contrast(indicator.color!, background), greaterThanOrEqualTo(3));
    });

    testWidgets('dialogue de confirmation lisible (≥ 4.5:1), thème $name', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => showConfirmDialog(
                context,
                title: 'Vider le panier ?',
                message: 'Tous les articles seront supprimés.',
                confirmLabel: 'Vider',
                isDangerous: true,
              ),
              child: const Text('ouvrir'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('ouvrir'));
      await tester.pumpAndSettle();

      final dialogSurface =
          theme.dialogTheme.backgroundColor ??
          theme.colorScheme.surfaceContainerHigh;
      final cancel = tester.widget<Text>(find.text('Annuler'));
      expect(
        contrast(cancel.style!.color!, dialogSurface),
        greaterThanOrEqualTo(4.5),
      );

      final confirm = tester.widget<ElevatedButton>(
        find.ancestor(
          of: find.text('Vider'),
          matching: find.byType(ElevatedButton),
        ),
      );
      final bg = confirm.style!.backgroundColor!.resolve({})!;
      final fg = confirm.style!.foregroundColor!.resolve({})!;
      expect(contrast(fg, bg), greaterThanOrEqualTo(4.5));
    });
  }
}
