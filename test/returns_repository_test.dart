import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/sync/sync_queue_repository.dart';
import 'package:mobile/database/app_database.dart' hide SaleReturn;
import 'package:mobile/features/returns/data/repositories/returns_repository_impl.dart';
import 'package:mobile/features/returns/domain/entities/returnable_line.dart';
import 'package:mobile/features/returns/domain/entities/sale_return.dart';
import 'package:mobile/features/returns/domain/usecases/create_sale_return_usecase.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart' as domain;

/// File de synchro qui échoue : simule une erreur au milieu de la transaction.
class _FailingQueue extends SyncQueueRepository {
  _FailingQueue({required super.db});

  @override
  Future<int> enqueueReturn({
    required String returnId,
    required Map<String, dynamic> returnPayload,
  }) => throw StateError('disque plein');
}

void main() {
  late AppDatabase db;
  late SyncQueueRepository queue;
  late ReturnsRepositoryImpl repository;
  late CreateSaleReturnUseCase createReturn;

  Decimal d(String v) => Decimal.parse(v);

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    queue = SyncQueueRepository(db: db);
    repository = ReturnsRepositoryImpl(db: db, syncQueue: queue);
    createReturn = CreateSaleReturnUseCase(repository: repository);
    await db
        .into(db.products)
        .insert(
          ProductsCompanion.insert(
            id: 'p1',
            name: 'Coca 33cl',
            sellingPrice: '1000',
            currentStock: const drift.Value(10),
            updatedAt: DateTime(2026),
          ),
        );
  });

  tearDown(() => db.close());

  /// Vente synchronisée : Coca 5 × 1000 (ligne `coca`) et Pain 2 × 250, avec
  /// une réduction de ligne et une remise globale facultatives.
  Future<domain.Sale> seedSale({
    String cocaDiscount = '0',
    String globalDiscount = '0',
    int receiptNumber = 7,
  }) async {
    final cocaTotal = d('5000') - d(cocaDiscount);
    final subtotal = cocaTotal + d('500');
    final total = subtotal - d(globalDiscount);
    await db
        .into(db.sales)
        .insert(
          SalesCompanion.insert(
            id: 'sale-1',
            receiptNumber: receiptNumber,
            totalAmount: total.toString(),
            vatAmount: '0',
            paymentMethod: 'cash',
            createdAt: DateTime(2026, 10, 1),
            discountAmount: drift.Value(globalDiscount),
          ),
        );
    await db
        .into(db.saleItems)
        .insert(
          SaleItemsCompanion.insert(
            id: 'coca',
            saleId: 'sale-1',
            productId: 'p1',
            productName: 'Coca 33cl',
            unitPrice: '1000',
            quantity: 5,
            lineTotal: cocaTotal.toString(),
            discountAmount: drift.Value(cocaDiscount),
          ),
        );
    await db
        .into(db.saleItems)
        .insert(
          SaleItemsCompanion.insert(
            id: 'pain',
            saleId: 'sale-1',
            productId: 'p2',
            productName: 'Pain',
            unitPrice: '250',
            quantity: 2,
            lineTotal: '500',
          ),
        );
    return domain.Sale(
      id: 'sale-1',
      receiptNumber: receiptNumber,
      totalAmount: total,
      vatAmount: Decimal.zero,
      paymentMethod: domain.PaymentMethod.cash,
      createdAt: DateTime(2026, 10, 1),
      discountAmount: d(globalDiscount),
    );
  }

  Future<List<ReturnableLine>> lines(domain.Sale sale) =>
      repository.watchReturnableLines(sale).first;

  ReturnableLine line(List<ReturnableLine> all, String id) =>
      all.singleWhere((l) => l.saleItemId == id);

  Future<SaleReturn> returnCoca(
    domain.Sale sale,
    int quantity, {
    ItemCondition condition = ItemCondition.resellable,
    String id = 'r1',
  }) async {
    final coca = line(await lines(sale), 'coca');
    return createReturn(
      returnId: id,
      sale: sale,
      selections: [(line: coca, quantity: quantity, condition: condition)],
      reason: ReturnReason.defective,
      refundMethod: RefundMethod.cash,
    );
  }

  Future<int?> stock() async =>
      (await db.select(db.products).getSingle()).currentStock;

  group('lignes retournables', () {
    test('montants payés avec réduction de ligne et remise globale', () async {
      // Coca net 4500, Pain 500, remise 500 → encaissé 4500 : 4050 + 450.
      final sale = await seedSale(cocaDiscount: '500', globalDiscount: '500');
      final all = await lines(sale);
      expect(line(all, 'coca').paidAmount, d('4050'));
      expect(line(all, 'pain').paidAmount, d('450'));
      expect(line(all, 'coca').returnableQuantity, 5);
    });

    test('ancienne vente : le prix catalogue actuel est ignoré', () async {
      final sale = await seedSale();
      await (db.update(db.products)..where((p) => p.id.equals('p1'))).write(
        const ProductsCompanion(sellingPrice: drift.Value('1500')),
      );
      expect(line(await lines(sale), 'coca').refundFor(1), d('1000'));
    });
  });

  group('enregistrement', () {
    test(
      'un article sur plusieurs : retour, stock et file en une fois',
      () async {
        final sale = await seedSale();
        final result = await returnCoca(sale, 1);

        expect(result.refundAmount, d('1000'));
        expect(result.syncStatus, ReturnSyncStatus.pending);
        expect(result.lines.single.restocked, isTrue);
        expect(await stock(), 11);
        final entry = (await queue.getEntriesByType('sale_return')).single;
        final payload = jsonDecode(entry.payload) as Map<String, dynamic>;
        expect(payload['sale_id'], 'sale-1');
        expect(payload['refund_amount'], '1000');
        final item = (payload['items'] as List<dynamic>).single as Map;
        expect(item['sale_item_id'], 'coca');
        expect(item['id'], result.lines.single.id);
        expect(line(await lines(sale), 'coca').returnedQuantity, 1);
        expect(line(await lines(sale), 'pain').returnedQuantity, 0);
      },
    );

    test('non revendable : tracé sans remise en stock', () async {
      final sale = await seedSale();
      final result = await returnCoca(
        sale,
        2,
        condition: ItemCondition.unsellable,
      );
      expect(result.lines.single.restocked, isFalse);
      expect(await stock(), 10);
    });

    test('produit supprimé : pas de remise en stock', () async {
      final sale = await seedSale();
      await (db.update(db.products)..where((p) => p.id.equals('p1'))).write(
        ProductsCompanion(deletedAt: drift.Value(DateTime(2026, 10, 2))),
      );
      final result = await returnCoca(sale, 1);
      expect(result.lines.single.restocked, isFalse);
      expect(await stock(), 10);
    });

    test('double appui : un seul retour, une seule remise en stock', () async {
      final sale = await seedSale();
      await returnCoca(sale, 1);
      await returnCoca(sale, 1);
      expect(await db.select(db.saleReturns).get(), hasLength(1));
      expect(await queue.getEntriesByType('sale_return'), hasLength(1));
      expect(await stock(), 11);
    });

    test('échec local : rien n’est enregistré', () async {
      final sale = await seedSale();
      final failing = CreateSaleReturnUseCase(
        repository: ReturnsRepositoryImpl(
          db: db,
          syncQueue: _FailingQueue(db: db),
        ),
      );
      final coca = line(await lines(sale), 'coca');
      await expectLater(
        failing(
          returnId: 'r1',
          sale: sale,
          selections: [
            (line: coca, quantity: 1, condition: ItemCondition.resellable),
          ],
          reason: ReturnReason.defective,
          refundMethod: RefundMethod.cash,
        ),
        throwsStateError,
      );
      expect(await db.select(db.saleReturns).get(), isEmpty);
      expect(await db.select(db.saleReturnItems).get(), isEmpty);
      expect(await stock(), 10);
    });
  });

  group('règles', () {
    test('2 sur 5, puis les 3 restantes, puis une de trop', () async {
      final sale = await seedSale();
      final first = await returnCoca(sale, 2, id: 'r1');
      final second = await returnCoca(sale, 3, id: 'r2');
      expect(first.refundAmount + second.refundAmount, d('5000'));
      expect(line(await lines(sale), 'coca').returnableQuantity, 0);
      await expectLater(
        returnCoca(sale, 1, id: 'r3'),
        throwsA(isA<CreateSaleReturnException>()),
      );
    });

    test(
      'remise globale : le retour complet rend exactement l’encaissé',
      () async {
        final sale = await seedSale(globalDiscount: '100');
        final all = await lines(sale);
        final result = await createReturn(
          returnId: 'r1',
          sale: sale,
          selections: [
            for (final l in all)
              (
                line: l,
                quantity: l.soldQuantity,
                condition: ItemCondition.damaged,
              ),
          ],
          reason: ReturnReason.saleError,
          refundMethod: RefundMethod.cash,
        );
        expect(result.refundAmount, sale.totalAmount);
      },
    );

    test('vente non synchronisée refusée', () async {
      final sale = await seedSale(receiptNumber: 0);
      await expectLater(
        returnCoca(sale, 1),
        throwsA(isA<CreateSaleReturnException>()),
      );
    });

    test('motif « autre » sans commentaire refusé', () async {
      final sale = await seedSale();
      final coca = line(await lines(sale), 'coca');
      await expectLater(
        createReturn(
          returnId: 'r1',
          sale: sale,
          selections: [
            (line: coca, quantity: 1, condition: ItemCondition.resellable),
          ],
          reason: ReturnReason.other,
          note: '  ',
          refundMethod: RefundMethod.cash,
        ),
        throwsA(isA<CreateSaleReturnException>()),
      );
    });

    test('aucun article choisi refusé', () async {
      final sale = await seedSale();
      await expectLater(
        returnCoca(sale, 0),
        throwsA(isA<CreateSaleReturnException>()),
      );
    });

    test('un retour refusé par le serveur ne compte plus', () async {
      final sale = await seedSale();
      await returnCoca(sale, 5);
      await (db.update(db.saleReturns)..where((r) => r.id.equals('r1'))).write(
        const SaleReturnsCompanion(syncStatus: drift.Value('rejected')),
      );
      expect(line(await lines(sale), 'coca').returnableQuantity, 5);
    });
  });
}
