import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/widgets/index.dart';
import 'package:mobile/features/sales/domain/entities/discount.dart';
import 'package:mobile/features/sales/presentation/widgets/discount_sheet.dart';

Decimal d(String value) => Decimal.parse(value);

/// Ouvre la feuille sur [gross] ; la valeur retournée est lue après fermeture.
Future<DiscountSheetResult? Function()> openSheet(
  WidgetTester tester, {
  required String gross,
  Discount? initial,
  ThemeData? theme,
}) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  DiscountSheetResult? result;
  await tester.pumpWidget(
    MaterialApp(
      theme: theme ?? AppTheme.light(),
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await showDiscountSheet(
              context,
              title: 'Remise sur la vente',
              gross: d(gross),
              initial: initial,
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

FilledButton applyButton(WidgetTester tester) =>
    tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Appliquer'));

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  for (final (name, theme) in [
    ('clair', AppTheme.light()),
    ('sombre', AppTheme.dark()),
  ]) {
    testWidgets('pourcentage choisi en un appui, thème $name', (tester) async {
      final result = await openSheet(tester, gross: '10000', theme: theme);
      // Pas de clavier à l'ouverture : aucun champ de saisie.
      expect(find.byType(TextField), findsNothing);
      expect(applyButton(tester).onPressed, isNull);

      await tester.tap(find.text('10 %'));
      await tester.pump();
      expect(find.text('−${formatFcfa(d('1000'))}'), findsOneWidget);
      expect(find.text(formatFcfa(d('9000'))), findsOneWidget);

      await tester.tap(find.text('Appliquer'));
      await tester.pumpAndSettle();
      expect(
        result()?.discount,
        Discount(type: DiscountType.percentage, value: d('10')),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('montants au-delà du total masqués', (tester) async {
    final result = await openSheet(tester, gross: '1500');
    await tester.tap(find.text('Montant'));
    await tester.pump();

    expect(find.text(formatFcfa(d('1000'))), findsOneWidget);
    expect(find.text(formatFcfa(d('2000'))), findsNothing);
    expect(find.text(formatFcfa(d('5000'))), findsNothing);

    await tester.tap(find.text(formatFcfa(d('500'))));
    await tester.pump();
    await tester.tap(find.text('Appliquer'));
    await tester.pumpAndSettle();
    expect(
      result()?.discount,
      Discount(type: DiscountType.amount, value: d('500')),
    );
  });

  testWidgets('« Autre » : saisie libre validée', (tester) async {
    final result = await openSheet(tester, gross: '1500');
    await tester.tap(find.text('Montant'));
    await tester.pump();
    await tester.tap(find.text('Autre'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '2000');
    await tester.pump();
    expect(find.text('La réduction dépasse le montant'), findsOneWidget);
    expect(applyButton(tester).onPressed, isNull);

    await tester.enterText(find.byType(TextField), '350');
    await tester.pump();
    await tester.tap(find.text('Appliquer'));
    await tester.pumpAndSettle();
    expect(
      result()?.discount,
      Discount(type: DiscountType.amount, value: d('350')),
    );
  });

  testWidgets('réduction existante : choix présélectionné', (tester) async {
    await openSheet(
      tester,
      gross: '10000',
      initial: Discount(type: DiscountType.percentage, value: d('15')),
    );
    final chip = tester.widget<ChoiceChip>(
      find.widgetWithText(ChoiceChip, '15 %'),
    );
    expect(chip.selected, isTrue);
    expect(find.byType(TextField), findsNothing);
    expect(applyButton(tester).onPressed, isNotNull);
  });

  testWidgets('réduction existante hors choix : ouverte en saisie libre', (
    tester,
  ) async {
    await openSheet(
      tester,
      gross: '10000',
      initial: Discount(type: DiscountType.percentage, value: d('12.5')),
    );
    expect(find.widgetWithText(TextField, '12.5'), findsOneWidget);
    expect(applyButton(tester).onPressed, isNotNull);
  });

  testWidgets('retirer la réduction', (tester) async {
    final result = await openSheet(
      tester,
      gross: '10000',
      initial: Discount(type: DiscountType.amount, value: d('500')),
    );
    await tester.ensureVisible(find.text('Retirer la réduction'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Retirer la réduction'));
    await tester.pumpAndSettle();
    expect(result(), isNotNull);
    expect(result()!.discount, isNull);
  });
}
