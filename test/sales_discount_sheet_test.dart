import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/utils/fcfa_amount_input.dart';
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

PrimaryButton applyButton(WidgetTester tester) => tester.widget<PrimaryButton>(
  find.widgetWithText(PrimaryButton, 'Appliquer'),
);

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  for (final (name, theme) in [
    ('clair', AppTheme.light()),
    ('sombre', AppTheme.dark()),
  ]) {
    testWidgets('pourcentage choisi en un appui, thème $name', (tester) async {
      final result = await openSheet(tester, gross: '10000', theme: theme);
      expect(applyButton(tester).onPressed, isNull);

      await tester.tap(find.text('10 %'));
      await tester.pump();
      expect(find.text('−${formatFcfa(d('1000'))}'), findsOneWidget);
      expect(find.text(formatFcfa(d('9000'))), findsOneWidget);
      expect(find.text('Nouveau total'), findsOneWidget);

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

    expect(find.text(formatAmount(d('1000'))), findsOneWidget);
    expect(find.text(formatAmount(d('2000'))), findsNothing);
    expect(find.text(formatAmount(d('5000'))), findsNothing);

    await tester.tap(find.text(formatAmount(d('500'))));
    await tester.pump();
    await tester.tap(find.text('Appliquer'));
    await tester.pumpAndSettle();
    expect(
      result()?.discount,
      Discount(type: DiscountType.amount, value: d('500')),
    );
  });

  testWidgets('saisie libre validée', (tester) async {
    final result = await openSheet(tester, gross: '1500');
    await tester.tap(find.text('Montant'));
    await tester.pump();

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

  testWidgets('montant : une virgule est refusée, pas recollée', (
    tester,
  ) async {
    await openSheet(tester, gross: '10000');
    await tester.tap(find.text('Montant'));
    await tester.pump();

    await tester.enterText(find.byType(TextField), '50,5');
    await tester.pump();
    expect(find.text(fcfaWholeAmountError), findsOneWidget);
    expect(applyButton(tester).onPressed, isNull);
    // Jamais « 505 » : la remise n'est pas appliquée à l'aperçu.
    expect(find.text('−${formatFcfa(d('505'))}'), findsNothing);
  });

  testWidgets('réduction existante : valeur reprise, applicable', (
    tester,
  ) async {
    await openSheet(
      tester,
      gross: '10000',
      initial: Discount(type: DiscountType.percentage, value: d('12.5')),
    );
    expect(find.widgetWithText(TextField, '12.5'), findsOneWidget);
    expect(find.text('−${formatFcfa(d('1250'))}'), findsOneWidget);
    expect(applyButton(tester).onPressed, isNotNull);
  });

  testWidgets('retirer la remise', (tester) async {
    final result = await openSheet(
      tester,
      gross: '10000',
      initial: Discount(type: DiscountType.amount, value: d('500')),
    );
    await tester.ensureVisible(find.text('Retirer la remise'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Retirer la remise'));
    await tester.pumpAndSettle();
    expect(result(), isNotNull);
    expect(result()!.discount, isNull);
  });
}
