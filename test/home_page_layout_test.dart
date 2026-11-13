import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/providers/connectivity_provider.dart';
import 'package:mobile/core/sync/sync_orchestrator.dart';
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
import 'package:mobile/features/home/presentation/widgets/today_summary.dart';
import 'package:mobile/features/sales/domain/entities/margin_summary.dart';
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

Decimal d(String value) => Decimal.parse(value);

final openSession = CashSession(
  id: 's1',
  deviceId: 'device-1',
  status: CashSessionStatus.open,
  openingAmount: d('10000'),
  openedAt: DateTime(2026, 11, 11, 7, 45),
  syncStatus: CashSyncStatus.synced,
  serverRecalculated: false,
);

final closedSession = openSession.copyWith(
  id: 's0',
  status: CashSessionStatus.closed,
  countedAmount: d('47000'),
  closedAt: DateTime.now().subtract(const Duration(days: 1)),
);

/// Sync simulée dans un état figé (erreur pour l'alerte d'envoi).
class _Sync extends SyncOrchestrator {
  _Sync(this.status);

  final SyncStatus status;

  @override
  SyncStatus build() => status;

  @override
  Future<void> syncNow({bool forceFullPull = false}) async {}
}

Future<void> pumpHome(
  WidgetTester tester, {
  required ThemeData theme,
  required bool withData,
  bool registerOpen = true,
  SyncStatus sync = const SyncStatusIdle(),
  int pending = 0,
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
        pendingSyncCountProvider.overrideWith((ref) => Stream.value(pending)),
        syncOrchestratorProvider.overrideWith(() => _Sync(sync)),
        activeCashSessionProvider.overrideWith(
          (ref) => Stream.value(registerOpen ? openSession : null),
        ),
        localCashSessionHistoryProvider.overrideWith(
          (ref) => Stream.value([closedSession]),
        ),
        cashSummaryProvider('s1').overrideWith(
          (ref) => Stream.value(
            CashSummary(
              openingAmount: d('10000'),
              cashSales: d(withData ? '40175' : '0'),
              cashSalesCount: withData ? 3 : 0,
              mobileMoneySales: d(withData ? '1025' : '0'),
              cashIn: Decimal.zero,
              cashOut: Decimal.zero,
              cashRefunds: Decimal.zero,
              rejectedCashRefunds: Decimal.zero,
              expectedAmount: d(withData ? '50175' : '10000'),
            ),
          ),
        ),
        todayMarginSummaryProvider.overrideWith(
          (ref) => Stream.value(
            MarginSummary(
              revenue: d('12245000'),
              coveredRevenue: d('10000000'),
              cost: d('7700000'),
              hasUnknownCost: false,
            ),
          ),
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
        todayHourlySalesProvider.overrideWith(
          (ref) => Stream.value(
            salesByHour(
              withData
                  ? [
                      sale(10452, '1250000'),
                      sale(0, '8000'),
                      sale(10450, '500'),
                    ]
                  : <Sale>[],
            ),
          ),
        ),
        recentSalesProvider.overrideWith(
          (ref) => Stream.value(
            withData
                ? [sale(10452, '1250000'), sale(0, '8000'), sale(10450, '500')]
                : <Sale>[],
          ),
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
    testWidgets('caisse ouverte avec données, thème $name, petit écran', (
      tester,
    ) async {
      await pumpHome(tester, theme: theme, withData: true);
      expect(tester.takeException(), isNull);
      expect(find.text('Caisse ouverte'), findsOneWidget);
      expect(find.text('Espèces dans le tiroir'), findsOneWidget);
      expect(find.text(formatFcfa(d('50175'))), findsOneWidget);
      expect(
        find.text('Mobile money, hors tiroir · ${formatFcfa(d('1025'))}'),
        findsOneWidget,
      );
      expect(find.text('À jour'), findsOneWidget);
      expect(find.text('Nouvelle vente'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Marge moyenne'), 200);
      expect(find.text('Pic : 19 h – 20 h'), findsOneWidget);
      expect(find.text('Chiffre d’affaires'), findsOneWidget);
      expect(find.text(formatFcfa(d('2300000'))), findsOneWidget);
      expect(find.text('23 %'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Rupture'), 200);
      expect(find.text('3 restants'), findsOneWidget);
      // Aperçu limité à 3 produits.
      expect(find.text('Sucre'), findsNothing);
      await tester.scrollUntilVisible(find.text('Vente n° 10452'), 200);
      expect(find.text('En attente de synchro'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('caisse fermée, journée vide, thème $name', (tester) async {
      await pumpHome(
        tester,
        theme: theme,
        withData: false,
        registerOpen: false,
      );
      expect(find.text('Caisse fermée'), findsOneWidget);
      expect(find.textContaining('Dernière clôture : hier à'), findsOneWidget);
      expect(
        find.widgetWithText(PrimaryButton, 'Ouvrir la caisse'),
        findsOneWidget,
      );
      expect(find.text('Nouveau produit'), findsNothing);
      await tester.scrollUntilVisible(
        find.text('Aucun produit en rupture'),
        200,
      );
      expect(find.text('Aucune vente pour l’instant.'), findsOneWidget);
      expect(find.text('Dernières ventes'.toUpperCase()), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('envoi en échec : alerte et réessai', (tester) async {
    await pumpHome(
      tester,
      theme: AppTheme.light(),
      withData: true,
      sync: const SyncStatusError(message: 'serveur'),
      pending: 3,
    );
    expect(find.text('Non envoyé'), findsOneWidget);
    expect(
      find.text(
        '3 envois en échec. Ils sont gardés sur ce téléphone.',
        findRichText: true,
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Réessayer'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  test('libellé de la dernière clôture', () {
    final now = DateTime(2026, 11, 12, 8);
    expect(
      closureLabel(DateTime(2026, 11, 12, 7), now: now),
      'aujourd’hui à 07:00',
    );
    expect(
      closureLabel(DateTime(2026, 11, 11, 19, 30), now: now),
      'hier à 19:30',
    );
    expect(
      closureLabel(DateTime(2026, 11, 3, 19, 30), now: now),
      'le 3 novembre à 19:30',
    );
  });

  test('pic de ventes : heure la plus forte, null sans vente', () {
    expect(peakHour(null), isNull);
    expect(peakHour(List.filled(24, Decimal.zero)), isNull);
    final hourly = List.filled(24, Decimal.zero)
      ..[10] = d('500')
      ..[15] = d('900');
    expect(peakHour(hourly), 15);
  });
}
