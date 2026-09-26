import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/inventory/domain/entities/stock_movement.dart';
import 'package:mobile/features/inventory/domain/entities/stock_movement_page.dart';
import 'package:mobile/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:mobile/features/inventory/presentation/providers/inventory_providers.dart';
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
