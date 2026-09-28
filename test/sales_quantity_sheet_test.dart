import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/widgets/index.dart';
import 'package:mobile/features/sales/presentation/widgets/quantity_sheet.dart';

/// Ouvre la feuille et renvoie un accès au résultat une fois fermée.
Future<QuantitySheetResult? Function()> openSheet(
  WidgetTester tester, {
  int? maxQuantity,
  int initialQuantity = 1,
}) async {
  QuantitySheetResult? result;
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await showQuantitySheet(
              context,
              productName: 'Eau 1,5L',
              unitPrice: Decimal.parse('500'),
              confirmLabel: 'Ajouter',
              initialQuantity: initialQuantity,
              maxQuantity: maxQuantity,
              stock: maxQuantity,
            ),
            child: const Text('ouvrir'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('ouvrir'));
  await tester.pumpAndSettle();
  return () => result;
}

/// Texte actuel du champ de quantité.
String fieldText(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).controller!.text;

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  testWidgets('la quantité se tape au clavier', (tester) async {
    final result = await openSheet(tester);
    await tester.enterText(find.byType(TextField), '40');
    await tester.pump();
    expect(
      find.textContaining(formatFcfa(Decimal.parse('20000'))),
      findsOneWidget,
    );

    await tester.tap(find.textContaining('Ajouter · '));
    await tester.pumpAndSettle();
    expect((result() as QuantityChosen?)?.quantity, 40);
  });

  testWidgets('valider au clavier ajoute la quantité', (tester) async {
    final result = await openSheet(tester);
    await tester.enterText(find.byType(TextField), '12');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect((result() as QuantityChosen?)?.quantity, 12);
  });

  testWidgets('au-delà du stock : message et validation bloquée', (
    tester,
  ) async {
    final result = await openSheet(tester, maxQuantity: 8);
    await tester.enterText(find.byType(TextField), '9');
    await tester.pump();
    expect(find.text('Stock disponible : 8'), findsOneWidget);

    await tester.tap(find.textContaining('Ajouter · '));
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsOneWidget);

    // [-] ramène au maximum disponible.
    await tester.tap(find.byTooltip('Diminuer'));
    await tester.pump();
    expect(find.text('Stock disponible atteint'), findsOneWidget);
    await tester.tap(find.textContaining('Ajouter · '));
    await tester.pumpAndSettle();
    expect((result() as QuantityChosen?)?.quantity, 8);
  });

  testWidgets('champ vide ou zéro : validation bloquée', (tester) async {
    await openSheet(tester);
    for (final text in ['', '0']) {
      await tester.enterText(find.byType(TextField), text);
      await tester.pump();
      expect(find.text('Saisissez une quantité'), findsOneWidget);
      await tester.tap(find.textContaining('Ajouter · '));
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsOneWidget);
    }
  });

  testWidgets('seuls les chiffres sont acceptés', (tester) async {
    await openSheet(tester);
    await tester.enterText(find.byType(TextField), '3,5a');
    await tester.pump();
    expect(fieldText(tester), '35');
  });

  testWidgets('les boutons [-]/[+] mettent le champ à jour', (tester) async {
    await openSheet(tester, initialQuantity: 3);
    await tester.tap(find.byTooltip('Augmenter'));
    await tester.pump();
    expect(fieldText(tester), '4');
    await tester.tap(find.byTooltip('Diminuer'));
    await tester.pump();
    await tester.tap(find.byTooltip('Diminuer'));
    await tester.pump();
    expect(fieldText(tester), '2');
  });
}
