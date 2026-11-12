import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/widgets/index.dart';
import 'package:mobile/core/providers/connectivity_provider.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/returns/domain/repositories/returns_repository.dart';
import 'package:mobile/features/returns/providers/returns_di_providers.dart';
import 'package:mobile/features/sales/domain/entities/cart_item.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart';
import 'package:mobile/features/sales/domain/repositories/sales_repository.dart';
import 'package:mobile/features/sales/presentation/pages/sale_detail_page.dart';
import 'package:mobile/features/sales/presentation/pages/sales_history_page.dart';
import 'package:mobile/features/sales/providers/sales_di_providers.dart';

/// Évite l'initialisation de la vraie authentification (via la synchro).
class _NoAuth extends Auth {
  @override
  Future<AuthStatus> build() async => const AuthUnauthenticated();
}

class _MockSales extends Mock implements SalesRepository {}

class _MockReturns extends Mock implements ReturnsRepository {}

Sale sale(int receipt, String total, PaymentMethod method) => Sale(
  discountAmount: Decimal.zero,
  id: 's$receipt',
  receiptNumber: receipt,
  totalAmount: Decimal.parse(total),
  vatAmount: Decimal.zero,
  paymentMethod: method,
  createdAt: DateTime(2026, 9, 27, 19, 42),
);

final sales = [
  sale(10452, '12500000', PaymentMethod.orangeMoney),
  sale(0, '8000', PaymentMethod.mixed),
  sale(10450, '500', PaymentMethod.cash),
];

final items = [
  CartItem(
    productId: 'p1',
    productName: 'Riz parfumé Uncle Ben’s sac de 25 kilogrammes',
    unitPrice: Decimal.parse('125000'),
    quantity: 100,
  ),
  CartItem(
    productId: 'p2',
    productName: 'Coca-Cola 33cl',
    unitPrice: Decimal.parse('500'),
    quantity: 2,
  ),
];

Future<void> pump(
  WidgetTester tester,
  Widget page, {
  required ThemeData theme,
  List<Sale> history = const [],
  List<CartItem> lines = const [],
  bool online = true,
}) async {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final repo = _MockSales();
  when(
    () => repo.watchSalesByDateRange(any(), any()),
  ).thenAnswer((_) => Stream.value(history));
  when(() => repo.watchSaleLinesByDateRange(any(), any())).thenAnswer(
    (_) => Stream.value({
      's10452': [
        for (final item in items)
          (productName: item.productName, quantity: item.quantity),
      ],
    }),
  );
  when(() => repo.watchSale(any())).thenAnswer((_) => Stream.value(null));
  when(() => repo.watchSaleItems(any())).thenAnswer((_) => Stream.value(lines));
  final returns = _MockReturns();
  when(
    () => returns.watchReturnableLines(any()),
  ).thenAnswer((_) => Stream.value(const []));
  when(
    () => returns.watchReturnsForSale(any()),
  ).thenAnswer((_) => Stream.value(const []));

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(_NoAuth.new),
        salesRepositoryProvider.overrideWithValue(repo),
        returnsRepositoryProvider.overrideWithValue(returns),
        isOnlineProvider.overrideWith((ref) => Stream.value(online)),
      ],
      child: MaterialApp(theme: theme, home: page),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() {
    registerFallbackValue(DateTime(2026));
    registerFallbackValue(sales.first);
    return initializeDateFormatting('fr_FR');
  });

  for (final (name, theme) in [
    ('clair', AppTheme.light()),
    ('sombre', AppTheme.dark()),
  ]) {
    testWidgets('onglet Ventes, thème $name', (tester) async {
      await pump(
        tester,
        const SalesHistoryPage(),
        theme: theme,
        history: sales,
      );
      expect(tester.takeException(), isNull);
      expect(find.text('3 ventes'), findsOneWidget);
      expect(find.text("En attente d'envoi"), findsOneWidget);
      expect(find.text('19:42 · n° 10452'), findsOneWidget);
      expect(
        find.text(
          'Riz parfumé Uncle Ben’s sac de 25 kilogrammes ×100, '
          'Coca-Cola 33cl ×2',
        ),
        findsOneWidget,
      );

      await tester.enterText(find.byType(TextField), '10452');
      await tester.pumpAndSettle();
      expect(find.text('19:42 · n° 10450'), findsNothing);
      expect(find.text('19:42 · n° 10452'), findsOneWidget);

      // Recherche par produit vendu.
      await tester.enterText(find.byType(TextField), 'coca');
      await tester.pumpAndSettle();
      expect(find.text('19:42 · n° 10452'), findsOneWidget);
      expect(find.text('1 vente'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('onglet Ventes vide, thème $name', (tester) async {
      await pump(tester, const SalesHistoryPage(), theme: theme);
      expect(tester.takeException(), isNull);
      expect(find.text('Faire une vente'), findsOneWidget);
    });

    testWidgets('ticket avec lignes, thème $name', (tester) async {
      await pump(
        tester,
        SaleDetailPage(sale: sales.first),
        theme: theme,
        lines: items,
      );
      expect(tester.takeException(), isNull);
      expect(find.textContaining('100 × 125'), findsOneWidget);
      expect(find.text('Envoyée'), findsOneWidget);
      expect(find.widgetWithText(PrimaryButton, 'Imprimer'), findsOneWidget);
    });

    testWidgets('ticket sans lignes, hors ligne, thème $name', (tester) async {
      await pump(
        tester,
        SaleDetailPage(sale: sales[1]),
        theme: theme,
        online: false,
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Reçu en attente d’envoi'), findsOneWidget);
      expect(find.text("Vente en attente d'envoi"), findsOneWidget);
      // Retour et PDF attendent l'envoi de la vente.
      for (final label in ['Partager PDF', 'Retour']) {
        final button = tester.widget<SecondaryButton>(
          find.widgetWithText(SecondaryButton, label),
        );
        expect(button.onPressed, isNull, reason: label);
      }
      expect(tester.takeException(), isNull);
    });
  }
}
