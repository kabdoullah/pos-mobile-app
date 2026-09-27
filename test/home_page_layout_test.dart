import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/providers/connectivity_provider.dart';
import 'package:mobile/core/sync/sync_providers.dart';
import 'package:mobile/features/auth/domain/entities/store.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/auth/providers/store_provider.dart';
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
  unitPrice: Decimal.fromInt(500),
  currentStock: stock,
  minStock: min,
  updatedAt: DateTime(2026),
);

Sale sale(int receipt, String total) => Sale(
  id: 'sale-$receipt',
  receiptNumber: receipt,
  totalAmount: Decimal.parse(total),
  vatAmount: Decimal.zero,
  paymentMethod: PaymentMethod.cash,
  createdAt: DateTime(2026, 9, 27, 19, 42),
);

Future<void> pumpHome(
  WidgetTester tester, {
  required ThemeData theme,
  required bool withData,
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
        dailySummaryProvider.overrideWith(
          (ref) => Stream.value((
            saleCount: withData ? 45 : 0,
            totalAmount: Decimal.parse(withData ? '12245000' : '0'),
            cashTotal: Decimal.parse(withData ? '8000000' : '0'),
            mobileMoneyTotal: Decimal.parse(withData ? '4245000' : '0'),
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
    testWidgets('accueil avec données, thème $name, petit écran', (
      tester,
    ) async {
      await pumpHome(tester, theme: theme, withData: true);
      expect(tester.takeException(), isNull);
      expect(find.text("Chiffre d'affaires"), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Rupture'), 200);
      expect(tester.takeException(), isNull);
      // Aperçu limité à 3 produits.
      expect(find.text('Sucre'), findsNothing);
      await tester.scrollUntilVisible(find.text('Reçu #10452'), 200);
      expect(find.text('En attente de synchro'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('accueil vide, thème $name', (tester) async {
      await pumpHome(tester, theme: theme, withData: false);
      await tester.scrollUntilVisible(find.text('Aucune alerte de stock'), 200);
      await tester.scrollUntilVisible(find.text('Faire une vente'), 200);
      expect(tester.takeException(), isNull);
    });
  }
}
