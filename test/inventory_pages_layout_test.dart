import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:mobile/features/catalog/providers/catalog_di_providers.dart';
import 'package:mobile/features/inventory/domain/entities/stock_movement.dart';
import 'package:mobile/features/inventory/domain/entities/stock_movement_page.dart';
import 'package:mobile/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:mobile/features/inventory/presentation/pages/product_detail_page.dart';
import 'package:mobile/features/inventory/presentation/pages/stock_overview_page.dart';
import 'package:mobile/features/inventory/providers/inventory_di_providers.dart';

/// Évite l'initialisation de la vraie authentification (via la synchro).
class _NoAuth extends Auth {
  @override
  Future<AuthStatus> build() async => const AuthUnauthenticated();
}

/// Liste principale de la page (la barre de recherche a aussi un Scrollable).
final _list = find.byType(Scrollable).first;

class _MockCatalog extends Mock implements CatalogRepository {}

class _MockInventory extends Mock implements InventoryRepository {}

Product product(String id, String name, {int? stock, int? min}) => Product(
  id: id,
  name: name,
  unitPrice: Decimal.parse('125000'),
  currentStock: stock,
  minStock: min,
  barcode: '5449000000996',
  updatedAt: DateTime(2026),
);

final products = [
  product('1', 'Riz parfumé Uncle Ben’s sac de 25 kilogrammes', stock: 0),
  product('2', 'Coca-Cola 33cl', stock: 3, min: 10),
  product('3', 'Eau minérale 1,5L', stock: 240, min: 5),
  product('4', 'Pain de mie', stock: null),
];

Future<void> pump(
  WidgetTester tester,
  Widget page, {
  required ThemeData theme,
  List<Product>? catalog,
  bool movementsOffline = false,
}) async {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final catalogRepo = _MockCatalog();
  when(
    catalogRepo.watchProducts,
  ).thenAnswer((_) => Stream.value(catalog ?? products));
  final inventoryRepo = _MockInventory();
  final call = when(
    () => inventoryRepo.getMovements(
      productId: any(named: 'productId'),
      cursor: any(named: 'cursor'),
      limit: any(named: 'limit'),
    ),
  );
  if (movementsOffline) {
    call.thenThrow(Exception('offline'));
  } else {
    call.thenAnswer(
      (_) async => StockMovementPage(
        items: [
          StockMovement(
            id: 'm1',
            productId: '2',
            quantityDelta: -2,
            reason: StockMovementReason.sale,
            resultingStock: 3,
            note: 'Réception fournisseur avec un commentaire assez long',
            createdAt: DateTime(2026, 9, 27, 10, 5),
          ),
        ],
        nextCursor: null,
        hasMore: false,
      ),
    );
  }

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(_NoAuth.new),
        catalogRepositoryProvider.overrideWithValue(catalogRepo),
        inventoryRepositoryProvider.overrideWithValue(inventoryRepo),
      ],
      child: MaterialApp(theme: theme, home: page),
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
    testWidgets('onglet Stock, thème $name', (tester) async {
      await pump(tester, const StockOverviewPage(), theme: theme);
      expect(tester.takeException(), isNull);
      expect(find.text('Valeur du stock'), findsOneWidget);

      // Filtre « Ruptures » depuis la tuile de synthèse.
      await tester.tap(find.text('Ruptures').first);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Rupture'),
        200,
        scrollable: _list,
      );
      expect(find.text('Coca-Cola 33cl'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('onglet Stock vide, thème $name', (tester) async {
      await pump(tester, const StockOverviewPage(), theme: theme, catalog: []);
      expect(tester.takeException(), isNull);
      expect(find.text('Ajouter un produit'), findsOneWidget);
    });

    testWidgets('fiche produit, thème $name', (tester) async {
      await pump(tester, const ProductDetailPage(productId: '2'), theme: theme);
      expect(tester.takeException(), isNull);
      expect(find.text('Stock faible'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Vente'),
        200,
        scrollable: _list,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('fiche produit, mouvements hors ligne, thème $name', (
      tester,
    ) async {
      await pump(
        tester,
        const ProductDetailPage(productId: '1'),
        theme: theme,
        movementsOffline: true,
      );
      await tester.scrollUntilVisible(
        find.text('Réessayer'),
        200,
        scrollable: _list,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
