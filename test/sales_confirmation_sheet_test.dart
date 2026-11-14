import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/providers/connectivity_provider.dart';
import 'package:mobile/core/widgets/index.dart';
import 'package:mobile/features/printing/domain/repositories/printer_repository.dart';
import 'package:mobile/features/printing/presentation/providers/printer_provider.dart';
import 'package:mobile/features/sales/domain/entities/cart_item.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart';
import 'package:mobile/features/sales/domain/repositories/sales_repository.dart';
import 'package:mobile/features/sales/presentation/widgets/sale_confirmation_sheet.dart';
import 'package:mobile/features/sales/providers/sales_di_providers.dart';

class _MockSales extends Mock implements SalesRepository {}

/// Imprimante simulée : échoue avec [failures] dans l'ordre, puis réussit.
class FakePrinter extends Printer {
  FakePrinter(this.failures);

  final List<PrintFailureReason> failures;
  int calls = 0;

  @override
  PrinterState build() => const PrinterDisconnected();

  @override
  Future<void> print({required Sale sale, List<CartItem>? items}) async {
    calls++;
    if (failures.isNotEmpty) {
      throw PrintException(reason: failures.removeAt(0), details: 'test');
    }
  }
}

Decimal d(String value) => Decimal.parse(value);

Sale sale({int receiptNumber = 19}) => Sale(
  id: 'v1',
  receiptNumber: receiptNumber,
  totalAmount: d('3025'),
  vatAmount: Decimal.zero,
  paymentMethod: PaymentMethod.cash,
  createdAt: DateTime(2026, 11, 13),
  discountAmount: Decimal.zero,
);

Future<FakePrinter> openSheet(
  WidgetTester tester, {
  int receiptNumber = 19,
  String change = '1975',
  List<PrintFailureReason> failures = const [],
}) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final repo = _MockSales();
  when(() => repo.watchSale(any())).thenAnswer((_) => Stream.value(null));
  final printer = FakePrinter([...failures]);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        salesRepositoryProvider.overrideWithValue(repo),
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
        printerProvider.overrideWith(() => printer),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showSaleConfirmationSheet(
                context,
                sale: sale(receiptNumber: receiptNumber),
                items: const [],
                change: d(change),
              ),
              child: const Text('ouvrir'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('ouvrir'));
  await tester.pumpAndSettle();
  return printer;
}

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  testWidgets('vente synchronisée : reçu, monnaie, actions', (tester) async {
    await openSheet(tester);
    expect(find.text('Vente enregistrée'), findsOneWidget);
    expect(
      find.text('Reçu n° 19 · Espèces · ${formatFcfa(d('3025'))}'),
      findsOneWidget,
    );
    expect(find.text('À rendre au client'), findsOneWidget);
    expect(find.text(formatFcfa(d('1975'))), findsOneWidget);
    expect(find.text('Imprimer le reçu'), findsOneWidget);
    expect(
      tester
          .widget<SecondaryButton>(
            find.widgetWithText(SecondaryButton, 'Reçu PDF'),
          )
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.text('Nouvelle vente'));
    await tester.pumpAndSettle();
    expect(find.text('Vente enregistrée'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('pas encore synchronisée : en attente, PDF indisponible', (
    tester,
  ) async {
    await openSheet(tester, receiptNumber: 0, change: '0');
    expect(
      find.text('En attente de synchro · n° de reçu au retour du réseau'),
      findsOneWidget,
    );
    expect(find.text('À rendre au client'), findsNothing);
    expect(
      tester
          .widget<SecondaryButton>(
            find.widgetWithText(SecondaryButton, 'Reçu PDF'),
          )
          .onPressed,
      isNull,
    );
    expect(
      find.text('Le reçu PDF sera disponible une fois la vente synchronisée.'),
      findsOneWidget,
    );
  });

  testWidgets('échec d’impression : 3 choix, Réessayer imprime', (
    tester,
  ) async {
    final printer = await openSheet(
      tester,
      failures: [PrintFailureReason.connectionFailed],
    );
    await tester.tap(find.text('Imprimer le reçu'));
    await tester.pumpAndSettle();

    expect(find.text('Reçu non imprimé'), findsOneWidget);
    expect(find.text('La vente n° 19 est bien enregistrée'), findsOneWidget);
    expect(find.text('Imprimer plus tard'), findsOneWidget);
    expect(find.text('Pas de reçu'), findsOneWidget);

    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();
    expect(printer.calls, 2);
    expect(find.text('Vente enregistrée'), findsOneWidget);
    expect(find.text('Reçu imprimé'), findsOneWidget);
  });

  testWidgets('sans imprimante : configurer, ou « Pas de reçu » ferme', (
    tester,
  ) async {
    await openSheet(tester, failures: [PrintFailureReason.noPrinterConfigured]);
    await tester.tap(find.text('Imprimer le reçu'));
    await tester.pumpAndSettle();

    expect(find.text('Aucune imprimante configurée.'), findsOneWidget);
    expect(find.text('Configurer l’imprimante'), findsOneWidget);
    expect(find.text('Réessayer'), findsNothing);

    await tester.tap(find.text('Pas de reçu'));
    await tester.pumpAndSettle();
    expect(find.text('Reçu non imprimé'), findsNothing);
  });
}
