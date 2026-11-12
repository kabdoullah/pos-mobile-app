import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/providers/connectivity_provider.dart';
import 'package:mobile/core/sync/sync_providers.dart';
import 'package:mobile/core/widgets/index.dart';
import 'package:mobile/features/auth/domain/entities/store.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/auth/providers/store_provider.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_session.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_summary.dart';
import 'package:mobile/features/cash_register/presentation/providers/cash_register_providers.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/home/presentation/pages/home_page.dart';
import 'package:mobile/features/home/presentation/providers/home_providers.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart';

/// Évite que l'orchestrateur de synchro (écouté par la pastille réseau)
/// initialise la vraie authentification.
class _NoAuth extends Auth {
  @override
  Future<AuthStatus> build() async => const AuthUnauthenticated();
}

class _Store extends StoreConfig {
  @override
  Future<Store?> build() async => const Store(
    name: 'Boutique Chez Awa — Cocody Angré 8e tranche',
    isSubjectToVat: false,
  );
}

Product product(String name, int stock, {int? min}) => Product(
  id: name,
  name: name,
  sellingPrice: Decimal.fromInt(500),
  currentStock: stock,
  minStock: min,
  updatedAt: DateTime(2026),
);

Sale sale(int receipt, String total) => Sale(
  discountAmount: Decimal.zero,
  id: 'sale-$receipt',
  receiptNumber: receipt,
  totalAmount: Decimal.parse(total),
  vatAmount: Decimal.zero,
  paymentMethod: PaymentMethod.cash,
  createdAt: DateTime(2026, 9, 27, 19, 42),
);

final _session = CashSession(
  id: 's1',
  deviceId: 'device-1',
  status: CashSessionStatus.open,
  openingAmount: Decimal.fromInt(10000),
  openedAt: DateTime(2026, 9, 27, 7, 45),
  syncStatus: CashSyncStatus.synced,
  serverRecalculated: false,
);

CashSummary _summary({required bool withSales}) => CashSummary(
  openingAmount: Decimal.fromInt(10000),
  cashSales: Decimal.fromInt(withSales ? 40175 : 0),
  cashSalesCount: withSales ? 3 : 0,
  mobileMoneySales: Decimal.fromInt(withSales ? 1025 : 0),
  cashIn: Decimal.zero,
  cashOut: Decimal.fromInt(withSales ? 2000 : 0),
  cashRefunds: Decimal.zero,
  rejectedCashRefunds: Decimal.zero,
  expectedAmount: Decimal.fromInt(withSales ? 48175 : 10000),
);

Future<void> pumpHome(
  WidgetTester tester, {
  required ThemeData theme,
  required bool withData,
  bool cashOpen = false,
}) async {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(_NoAuth.new),
        storeConfigProvider.overrideWith(_Store.new),
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
        pendingSyncCountProvider.overrideWith((ref) => Stream.value(0)),
        activeCashSessionProvider.overrideWith(
          (ref) => Stream.value(cashOpen ? _session : null),
        ),
        cashSummaryProvider(
          's1',
        ).overrideWith((ref) => Stream.value(_summary(withSales: withData))),
        localCashSessionHistoryProvider.overrideWith(
          (ref) => Stream.value([
            _session.copyWith(
              status: CashSessionStatus.closed,
              countedAmount: Decimal.fromInt(47000),
              closedAt: DateTime(2026, 9, 26, 19, 30),
            ),
          ]),
        ),
        dailySummaryProvider.overrideWith(
          (ref) => Stream.value((
            saleCount: withData ? 45 : 0,
            totalAmount: Decimal.parse(withData ? '12245000' : '0'),
            cashTotal: Decimal.parse(withData ? '8000000' : '0'),
            mobileMoneyTotal: Decimal.parse(withData ? '4245000' : '0'),
            refundTotal: Decimal.parse(withData ? '15000' : '0'),
          )),
        ),
        homeLowStockProvider.overrideWith(
          (ref) => Stream.value(
            withData
                ? [
                    product('Riz parfumé Uncle Ben’s sac de 25 kilogrammes', 0),
                    product('Coca-Cola 33cl', 3, min: 10),
                    product('Eau minérale 1,5L', 1, min: 5),
                    product('Sucre', 2, min: 5),
                  ]
                : <Product>[],
          ),
        ),
        lastSaleTodayProvider.overrideWith(
          (ref) => Stream.value(withData ? sale(10452, '1250000') : null),
        ),
      ],
      child: MaterialApp(theme: theme, home: const HomePage()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  for (final (name, theme) in [
    ('clair', AppTheme.light()),
    ('sombre', AppTheme.dark()),
  ]) {
    testWidgets('caisse ouverte avec ventes, thème $name, petit écran', (
      tester,
    ) async {
      await pumpHome(tester, theme: theme, withData: true, cashOpen: true);
      expect(tester.takeException(), isNull);
      expect(find.text('Caisse ouverte'), findsOneWidget);
      expect(find.text('depuis 07:45'), findsOneWidget);
      expect(find.text(formatFcfa(Decimal.fromInt(48175))), findsOneWidget);
      expect(find.text('Mobile money (hors tiroir)'), findsOneWidget);
      expect(find.text('Entrée / sortie'), findsOneWidget);
      expect(find.text('Clôturer'), findsOneWidget);
      expect(find.text('Fond de caisse du matin'), findsNothing);
      // Action principale fixée en bas.
      expect(find.widgetWithText(PrimaryButton, 'Nouvelle vente'), findsOne);

      await tester.scrollUntilVisible(find.text('Ventes du jour'), 200);
      expect(find.text('45 ventes · dernière à 19:42'), findsOneWidget);
      expect(
        find.text('net de ${formatFcfa(Decimal.fromInt(15000))} remboursés'),
        findsOneWidget,
      );
      await tester.scrollUntilVisible(find.text('Rupture'), 200);
      expect(find.text('Stock bas : 3'), findsOneWidget);
      // Aperçu limité à 3 produits.
      expect(find.text('Sucre'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('caisse fermée et aucune vente, thème $name', (tester) async {
      await pumpHome(tester, theme: theme, withData: false);
      expect(find.text('Caisse fermée'), findsOneWidget);
      expect(
        find.textContaining('avec ${formatFcfa(Decimal.fromInt(47000))}'),
        findsOneWidget,
      );
      expect(find.widgetWithText(PrimaryButton, 'Ouvrir la caisse'), findsOne);
      expect(find.text('Nouvelle vente'), findsNothing);
      await tester.scrollUntilVisible(
        find.text("Aucune vente aujourd'hui"),
        200,
      );
      await tester.scrollUntilVisible(
        find.text('Aucun produit en rupture'),
        200,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('caisse ouverte sans mouvement : fond de caisse du matin', (
    tester,
  ) async {
    await pumpHome(
      tester,
      theme: AppTheme.light(),
      withData: false,
      cashOpen: true,
    );
    expect(find.text('Fond de caisse du matin'), findsOneWidget);
    expect(find.text('Mobile money (hors tiroir)'), findsNothing);
  });

  test('closedDayLabel', () {
    final now = DateTime(2026, 11, 12, 8);
    expect(
      closedDayLabel(DateTime(2026, 11, 12, 7, 5), now),
      "aujourd'hui à 07:05",
    );
    expect(closedDayLabel(DateTime(2026, 11, 11, 19, 30), now), 'hier à 19:30');
    expect(
      closedDayLabel(DateTime(2026, 11, 7, 20, 5), now),
      'le 7 nov. à 20:05',
    );
  });
}
