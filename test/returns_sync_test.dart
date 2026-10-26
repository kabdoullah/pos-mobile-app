import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_models/sale_return_dto.dart';
import 'package:mobile/core/network/api_models/stock_movement_dto.dart';
import 'package:mobile/core/network/api_models/sync_changes_dto.dart';
import 'package:mobile/core/sync/pull_service.dart';
import 'package:mobile/core/sync/push_service.dart';
import 'package:mobile/core/sync/sync_queue_repository.dart';
import 'package:mobile/core/sync/sync_remote_datasource.dart';
import 'package:mobile/database/app_database.dart' hide SaleReturn;
import 'package:mobile/features/inventory/data/models/stock_movement_mappers.dart';
import 'package:mobile/features/inventory/domain/entities/stock_movement.dart';
import 'package:mobile/features/returns/data/repositories/returns_repository_impl.dart';
import 'package:mobile/features/returns/domain/entities/sale_return.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart' as domain;
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements SyncRemoteDataSource {}

const _now = '2026-10-17T10:00:00Z';

void main() {
  late AppDatabase db;
  late SyncQueueRepository queue;
  late ReturnsRepositoryImpl repository;
  late _MockRemote remote;
  late PushService push;
  late PullService pull;
  late domain.Sale sale;

  setUpAll(() {
    registerFallbackValue(const ReturnsSyncBatchRequestDto(returns: []));
  });

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    queue = SyncQueueRepository(db: db);
    repository = ReturnsRepositoryImpl(db: db, syncQueue: queue);
    remote = _MockRemote();
    push = PushService(
      remoteDataSource: remote,
      queueRepository: queue,
      db: db,
    );
    pull = PullService(
      remoteDataSource: remote,
      db: db,
      queueRepository: queue,
    );

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
    await db
        .into(db.sales)
        .insert(
          SalesCompanion.insert(
            id: 'sale-1',
            receiptNumber: 7,
            totalAmount: '3000',
            vatAmount: '0',
            paymentMethod: 'cash',
            createdAt: DateTime(2026, 10, 1),
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
            quantity: 3,
            lineTotal: '3000',
          ),
        );
    sale = domain.Sale(
      id: 'sale-1',
      receiptNumber: 7,
      totalAmount: Decimal.fromInt(3000),
      vatAmount: Decimal.zero,
      paymentMethod: domain.PaymentMethod.cash,
      createdAt: DateTime(2026, 10, 1),
      discountAmount: Decimal.zero,
    );
  });

  tearDown(() => db.close());

  Future<void> returnTwoCocas() => repository.createReturn(
    id: 'r1',
    saleId: 'sale-1',
    reason: ReturnReason.defective,
    refundMethod: RefundMethod.cash,
    lines: [
      (
        saleItemId: 'coca',
        productId: 'p1',
        quantity: 2,
        condition: ItemCondition.resellable,
        refundAmount: Decimal.fromInt(2000),
      ),
    ],
  );

  void answer(ReturnSyncResultDto result) {
    when(() => remote.pushReturns(any())).thenAnswer(
      (_) async => ReturnsSyncBatchResponseDto(processed: 1, results: [result]),
    );
  }

  Future<SaleReturn> stored() async =>
      (await repository.watchReturnsForSale('sale-1').first).single;

  Future<int?> stock() async =>
      (await db.select(db.products).getSingle()).currentStock;

  test('accepté : numéro attribué, statut synchronisé', () async {
    await returnTwoCocas();
    answer(
      const ReturnSyncResultDto(id: 'r1', status: 'created', returnNumber: 4),
    );

    await push.pushPendingReturns();

    final r = await stored();
    expect(r.returnNumber, 4);
    expect(r.syncStatus, ReturnSyncStatus.synced);
    expect(await queue.getEntriesByType('sale_return'), isEmpty);
  });

  test('erreur réseau puis nouvel essai : aucun doublon', () async {
    await returnTwoCocas();
    when(() => remote.pushReturns(any())).thenThrow(
      DioException(requestOptions: RequestOptions(path: '/sync/returns')),
    );

    await push.pushPendingReturns();

    expect((await stored()).syncStatus, ReturnSyncStatus.pending);
    final entry = (await queue.getEntriesByType('sale_return')).single;
    expect(entry.retryCount, 1);

    // Le serveur avait reçu le premier envoi : il répond already_exists.
    answer(
      const ReturnSyncResultDto(
        id: 'r1',
        status: 'already_exists',
        returnNumber: 4,
      ),
    );
    await push.pushPendingReturns();

    expect((await stored()).returnNumber, 4);
    expect(await db.select(db.saleReturns).get(), hasLength(1));
    expect(await stock(), 12);
  });

  test('conflit entre appareils : refusé, stock local annulé', () async {
    await returnTwoCocas();
    expect(await stock(), 12);
    answer(
      const ReturnSyncResultDto(
        id: 'r1',
        status: 'rejected',
        errorCode: 'quantity_exceeded',
        error: '2 requested, 1 returnable',
      ),
    );

    await push.pushPendingReturns();

    final r = await stored();
    expect(r.syncStatus, ReturnSyncStatus.rejected);
    expect(r.rejectionCode, 'quantity_exceeded');
    expect(await stock(), 10);
    expect(await queue.getEntriesByType('sale_return'), isEmpty);
    // Les quantités refusées redeviennent retournables.
    final line = (await repository.watchReturnableLines(sale).first).single;
    expect(line.returnableQuantity, 3);
  });

  test('payload refusé (422) : rejeté sans renvoi', () async {
    await returnTwoCocas();
    when(() => remote.pushReturns(any())).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/sync/returns'),
        response: Response(
          requestOptions: RequestOptions(path: '/sync/returns'),
          statusCode: 422,
        ),
      ),
    );

    await push.pushPendingReturns();

    expect((await stored()).rejectionCode, 'invalid_payload');
    expect(await queue.getEntriesByType('sale_return'), isEmpty);
  });

  test('erreur serveur passagère (failed) : réessayé plus tard', () async {
    await returnTwoCocas();
    answer(
      const ReturnSyncResultDto(id: 'r1', status: 'failed', error: 'boom'),
    );

    await push.pushPendingReturns();

    expect((await stored()).syncStatus, ReturnSyncStatus.pending);
    expect(await queue.getEntriesByType('sale_return'), hasLength(1));
  });

  test('pull : retour d’un autre appareil enregistré, rejouable', () async {
    const changes = SyncChangesDto(
      products: [],
      sales: [],
      returns: [
        SaleReturnDto(
          id: 'other-device',
          saleId: 'sale-1',
          returnNumber: 9,
          reason: 'changed_mind',
          refundMethod: 'mobile_money_wave',
          refundAmount: '1000.00',
          createdAt: _now,
          items: [
            SaleReturnItemDto(
              id: 'ri-1',
              saleReturnId: 'other-device',
              saleItemId: 'coca',
              productId: 'p1',
              quantity: 1,
              condition: 'resellable',
              restocked: true,
              refundAmount: '1000.00',
            ),
          ],
        ),
      ],
      hasMore: false,
      serverTime: _now,
    );
    when(
      () => remote.getChanges(
        since: any(named: 'since'),
        limit: any(named: 'limit'),
        cursor: any(named: 'cursor'),
      ),
    ).thenAnswer((_) async => changes);

    await pull.pullChanges();
    await pull.pullChanges();

    final r = await stored();
    expect(r.returnNumber, 9);
    expect(r.refundMethod, RefundMethod.wave);
    expect(r.syncStatus, ReturnSyncStatus.synced);
    expect(r.lines, hasLength(1));
    final line = (await repository.watchReturnableLines(sale).first).single;
    expect(line.returnedQuantity, 1);
  });

  test('historique de stock : le motif customer_return est reconnu', () {
    final dto = StockMovementDto.fromJson(const {
      'id': 'm1',
      'store_id': 's',
      'product_id': 'p1',
      'quantity_delta': 1,
      'reason': 'customer_return',
      'resulting_stock': 11,
      'created_at': _now,
    });
    expect(dto.toDomain().reason, StockMovementReason.customerReturn);
  });
}
