import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/utils/whole_number_input.dart';
import 'package:mobile/features/inventory/domain/entities/stock_movement.dart';
import 'package:mobile/features/inventory/domain/entities/stock_movement_page.dart';
import 'package:mobile/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:mobile/features/inventory/presentation/providers/inventory_providers.dart';
import 'package:mobile/features/inventory/presentation/widgets/stock_adjustment_sheet.dart';
import 'package:mobile/features/inventory/providers/inventory_di_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockInventoryRepository extends Mock implements InventoryRepository {}

void main() {
  late _MockInventoryRepository repo;
  late ProviderContainer container;

  setUp(() {
    repo = _MockInventoryRepository();
    when(
      () => repo.getMovements(productId: any(named: 'productId')),
    ).thenAnswer(
      (_) async =>
          const StockMovementPage(items: [], nextCursor: null, hasMore: false),
    );
    when(
      () => repo.createAdjustment(
        productId: any(named: 'productId'),
        quantityDelta: any(named: 'quantityDelta'),
        note: any(named: 'note'),
      ),
    ).thenAnswer((_) async {
      // Aller-retour serveur : assez long pour que les providers non écoutés
      // soient libérés.
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return StockMovement(
        id: 'm1',
        productId: 'p1',
        reason: StockMovementReason.manualAdjustment,
        createdAt: DateTime(2026),
      );
    });
    container = ProviderContainer(
      overrides: [inventoryRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
  });

  test('succeeds when nothing listens to the history (Stock tab)', () async {
    await container
        .read(stockAdjustmentProvider.notifier)
        .submit(productId: 'p1', quantityDelta: 3, note: 'Casse');

    verify(
      () => repo.createAdjustment(
        productId: 'p1',
        quantityDelta: 3,
        note: 'Casse',
      ),
    ).called(1);
    verifyNever(() => repo.getMovements(productId: any(named: 'productId')));
  });

  testWidgets('a comma quantity is refused, never glued (« 2,5 » ≠ 25)', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [inventoryRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: StockAdjustmentSheet(productId: 'p1')),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField).first, '2,5');
    await tester.pump();
    await tester.ensureVisible(find.text('Valider l\'ajustement'));
    await tester.tap(find.text('Valider l\'ajustement'));
    await tester.pump();

    expect(find.text(wholeQuantityError), findsOneWidget);
    verifyNever(
      () => repo.createAdjustment(
        productId: any(named: 'productId'),
        quantityDelta: any(named: 'quantityDelta'),
        note: any(named: 'note'),
      ),
    );
  });

  test('reloads an open history once the adjustment is recorded', () async {
    container.listen(stockHistoryProvider('p1'), (_, _) {});
    await container.read(stockHistoryProvider('p1').future);

    await container
        .read(stockAdjustmentProvider.notifier)
        .submit(productId: 'p1', quantityDelta: -2);
    await container.read(stockHistoryProvider('p1').future);

    verify(() => repo.getMovements(productId: 'p1')).called(2);
  });
}
