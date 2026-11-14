import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/providers/connectivity_provider.dart';
import 'package:mobile/core/storage/cash_count_mode_storage.dart';
import 'package:mobile/core/widgets/index.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_count.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_session.dart';
import 'package:mobile/features/cash_register/domain/entities/denomination.dart';
import 'package:mobile/features/cash_register/domain/repositories/cash_register_repository.dart';
import 'package:mobile/features/cash_register/presentation/pages/open_cash_session_page.dart';
import 'package:mobile/features/cash_register/presentation/widgets/cash_count_form.dart';
import 'package:mobile/features/cash_register/providers/cash_register_di_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockCashRegister extends Mock implements CashRegisterRepository {}

/// Mode de comptage en mémoire (le stockage sécurisé n'existe pas en test).
class _MemoryCountMode extends Fake implements CashCountModeStorage {
  _MemoryCountMode({required this.byDenomination});

  bool byDenomination;

  @override
  Future<bool> readByDenomination() async => byDenomination;

  @override
  Future<void> writeByDenomination(bool value) async => byDenomination = value;
}

Decimal d(String v) => Decimal.parse(v);

const bill10000 = Denomination(DenominationType.bill, 10000);
const bill5000 = Denomination(DenominationType.bill, 5000);
const coin250 = Denomination(DenominationType.coin, 250);

void main() {
  group('CashCountForm', () {
    Future<ValueNotifier<CashCount>> pumpForm(
      WidgetTester tester, {
      ThemeData? theme,
    }) async {
      final count = ValueNotifier(CashCount.empty());
      addTearDown(count.dispose);
      tester.view.physicalSize = const Size(360, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          theme: theme ?? AppTheme.light(),
          home: Scaffold(
            body: ValueListenableBuilder<CashCount>(
              valueListenable: count,
              builder: (_, value, _) => SingleChildScrollView(
                child: CashCountForm(
                  count: value,
                  onChanged: (next) => count.value = next,
                ),
              ),
            ),
          ),
        ),
      );
      return count;
    }

    testWidgets('boutons + et − et saisie au clavier', (tester) async {
      final count = await pumpForm(tester);

      // Une ligne par coupure proposée.
      expect(find.byType(TextField), findsNWidgets(fcfaDenominations.length));

      await tester.tap(find.byTooltip('Augmenter').first); // 10 000
      await tester.pump();
      await tester.tap(find.byTooltip('Augmenter').first);
      await tester.pump();
      expect(count.value.quantityOf(bill10000), 2);
      expect(find.text(formatAmount(d('20000'))), findsOneWidget);

      await tester.tap(find.byTooltip('Diminuer').first);
      await tester.pump();
      expect(count.value.quantityOf(bill10000), 1);

      // Pièces de 250 (7e ligne) saisies au clavier.
      await tester.enterText(find.byType(TextField).at(6), '4');
      await tester.pump();
      expect(count.value.quantityOf(coin250), 4);
      expect(count.value.billsTotal, d('10000'));
      expect(count.value.coinsTotal, d('1000'));
      expect(find.text(formatFcfa(d('1000'))), findsOneWidget);
    });

    testWidgets('« − » désactivé à zéro : jamais de quantité négative', (
      tester,
    ) async {
      final count = await pumpForm(tester);
      final minus = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.remove).first,
      );
      expect(minus.onPressed, isNull);
      expect(count.value.quantityOf(bill10000), 0);
    });

    testWidgets('quantité inhabituelle : avertie, non bloquante', (
      tester,
    ) async {
      final count = await pumpForm(tester);
      await tester.enterText(find.byType(TextField).first, '250');
      await tester.pump();

      expect(count.value.quantityOf(bill10000), 250);
      expect(
        find.textContaining('Vérifiez la quantité', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('quantité trop grande : refusée, valeur précédente gardée', (
      tester,
    ) async {
      final count = await pumpForm(tester);
      await tester.enterText(find.byType(TextField).at(1), '3');
      await tester.pump();
      await tester.enterText(find.byType(TextField).at(1), '999999');
      await tester.pump();

      expect(count.value.quantityOf(bill5000), 3);
      expect(find.textContaining('Quantité invalide'), findsOneWidget);
    });

    testWidgets('thème sombre sans débordement', (tester) async {
      await pumpForm(tester, theme: AppTheme.dark());
      expect(tester.takeException(), isNull);
    });
  });

  group('ouverture par billets et pièces', () {
    late _MockCashRegister cash;

    final openSession = CashSession(
      id: 'session-1',
      deviceId: 'device-1',
      status: CashSessionStatus.open,
      openingAmount: d('25000'),
      openedAt: DateTime.utc(2026, 11, 14, 7, 45),
      syncStatus: CashSyncStatus.pending,
      serverRecalculated: false,
    );

    setUpAll(() {
      registerFallbackValue(Decimal.zero);
      registerFallbackValue(CashCount.empty());
    });

    setUp(() {
      cash = _MockCashRegister();
      when(cash.getActiveSession).thenAnswer((_) async => null);
      when(cash.watchLocalHistory).thenAnswer((_) => Stream.value(const []));
      when(
        () => cash.openSession(
          openingAmount: any(named: 'openingAmount'),
          openingCount: any(named: 'openingCount'),
          note: any(named: 'note'),
        ),
      ).thenAnswer((_) async => openSession);
    });

    Future<void> pumpPage(WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            cashRegisterRepositoryProvider.overrideWithValue(cash),
            isOnlineProvider.overrideWith((ref) => Stream.value(false)),
            cashCountModeStorageProvider.overrideWithValue(
              _MemoryCountMode(byDenomination: true),
            ),
          ],
          retry: (_, _) => null,
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const OpenCashSessionPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets("reprendre le comptage d'hier soir puis ouvrir", (
      tester,
    ) async {
      final yesterday = CashCount.empty()
          .withQuantity(bill10000, 2)
          .withQuantity(bill5000, 1);
      when(cash.lastClosingCount).thenAnswer((_) async => yesterday);
      await pumpPage(tester);

      await tester.tap(find.textContaining("Reprendre le comptage d'hier"));
      await tester.pumpAndSettle();
      expect(find.text('Fond de caisse · 3 billets'), findsOneWidget);

      await tester.tap(
        find.widgetWithText(
          PrimaryButton,
          'Ouvrir avec ${formatFcfa(d('25000'))}',
        ),
      );
      await tester.pumpAndSettle();

      // Le fond de caisse est calculé, jamais saisi séparément.
      verify(
        () => cash.openSession(
          openingAmount: d('25000'),
          openingCount: yesterday,
        ),
      ).called(1);
    });

    testWidgets('sans comptage précédent : pas de reprise proposée', (
      tester,
    ) async {
      when(cash.lastClosingCount).thenAnswer((_) async => null);
      await pumpPage(tester);
      expect(find.textContaining('Reprendre'), findsNothing);
      expect(find.text('Billets et pièces'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
