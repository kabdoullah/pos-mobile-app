import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/utils/fcfa_amount_input.dart';
import 'package:mobile/features/sales/presentation/widgets/amount_input.dart';

void main() {
  group('parseFcfaAmount', () {
    test('entier', () {
      expect(parseFcfaAmount('1500'), Decimal.parse('1500'));
    });

    test('vide', () {
      expect(parseFcfaAmount(''), isNull);
    });

    test('virgule ou point : invalide, jamais de chiffres recollés', () {
      expect(parseFcfaAmount('5000,5'), isNull);
      expect(parseFcfaAmount('5000.5'), isNull);
      expect(hasDecimalSeparator('5000,5'), isTrue);
      expect(hasDecimalSeparator('5000'), isFalse);
    });
  });

  group('AmountInput', () {
    Future<List<Decimal?>> pump(WidgetTester tester) async {
      final values = <Decimal?>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AmountInput(
              label: 'Montant',
              value: null,
              onChanged: values.add,
            ),
          ),
        ),
      );
      return values;
    }

    testWidgets('« 5000,5 » est refusé au lieu de devenir 50005', (
      tester,
    ) async {
      final values = await pump(tester);
      await tester.enterText(find.byType(TextField), '5000,5');
      await tester.pump();

      expect(values.last, isNull);
      expect(values, isNot(contains(Decimal.parse('50005'))));
      expect(find.text(fcfaWholeAmountError), findsOneWidget);
    });

    testWidgets('« 10 000 » collé donne 10000', (tester) async {
      final values = await pump(tester);
      await tester.enterText(find.byType(TextField), '10 000');
      await tester.pump();

      expect(values.last, Decimal.parse('10000'));
      expect(find.text(fcfaWholeAmountError), findsNothing);
    });

    testWidgets('corriger la saisie efface l’erreur', (tester) async {
      final values = await pump(tester);
      await tester.enterText(find.byType(TextField), '5000,');
      await tester.pump();
      expect(find.text(fcfaWholeAmountError), findsOneWidget);

      await tester.enterText(find.byType(TextField), '5000');
      await tester.pump();
      expect(values.last, Decimal.parse('5000'));
      expect(find.text(fcfaWholeAmountError), findsNothing);
    });
  });
}
