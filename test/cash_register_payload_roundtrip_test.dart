import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_models/cash_session_dto.dart';
import 'package:mobile/core/network/api_models/sale_return_dto.dart';
import 'package:mobile/core/sync/cash_sync_remote_datasource.dart';
import 'package:mobile/core/sync/push_service.dart';
import 'package:mobile/core/sync/sync_queue_repository.dart';
import 'package:mobile/core/sync/sync_remote_datasource.dart';
import 'package:mobile/database/app_database.dart'
    hide CashMovement, SaleReturn;
import 'package:mobile/features/cash_register/data/models/cash_mappers.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_movement.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_session.dart';
import 'package:mobile/features/returns/data/repositories/returns_repository_impl.dart';
import 'package:mobile/features/returns/domain/entities/sale_return.dart';
import 'package:mocktail/mocktail.dart';

class _MockSyncRemote extends Mock implements SyncRemoteDataSource {}

class _MockCashRemote extends Mock implements CashRegisterRemoteDataSource {}

/// Corps tel qu'il part sur le réseau : Retrofit appelle `toJson()` et Dio
/// encode en JSON.
Map<String, dynamic> wire(Object? json) =>
    jsonDecode(jsonEncode(json)) as Map<String, dynamic>;

/// Chaque payload mis en file est construit par son vrai constructeur, relu
/// par le push (DTO `fromJson`, `session_id` retiré des corps de caisse) puis
/// sérialisé : tous les champs attendus par l'API doivent survivre, avec
/// leur valeur.
void main() {
  late AppDatabase db;
  late SyncQueueRepository queue;
  late _MockSyncRemote syncRemote;
  late _MockCashRemote cashRemote;
  late PushService push;

  setUpAll(() {
    registerFallbackValue(const ReturnsSyncBatchRequestDto(returns: []));
    registerFallbackValue(
      const CashSessionOpenRequestDto(
        id: '',
        deviceId: '',
        openingAmount: '0',
        openedAt: '',
      ),
    );
    registerFallbackValue(
      const CashMovementCreateRequestDto(
        id: '',
        type: 'cash_in',
        reason: 'other',
        amount: '0',
        createdAt: '',
      ),
    );
    registerFallbackValue(
      const CashSessionCloseRequestDto(
        countedAmount: '0',
        clientExpectedAmount: '0',
        closedAt: '',
      ),
    );
  });

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    queue = SyncQueueRepository(db: db);
    syncRemote = _MockSyncRemote();
    cashRemote = _MockCashRemote();
    push = PushService(
      remoteDataSource: syncRemote,
      cashRemoteDataSource: cashRemote,
      queueRepository: queue,
      db: db,
    );
  });

  tearDown(() => db.close());

  test('open payload survives the push round trip', () async {
    final payload = cashSessionOpenPayload(
      id: 'session-1',
      deviceId: 'device-1',
      openingAmount: Decimal.parse('25000.50'),
      openingNote: 'Fond du matin',
      openedAt: DateTime.utc(2026, 11, 10, 7, 58, 12),
    );
    await queue.enqueueCashSessionOpen(
      sessionId: 'session-1',
      payload: payload,
    );
    when(() => cashRemote.openSession(any())).thenAnswer(
      (_) async => const CashSessionDto(
        id: 'session-1',
        deviceId: 'device-1',
        status: 'open',
        openingAmount: '25000.50',
        openedAt: '2026-11-10T07:58:12Z',
      ),
    );

    await push.pushPendingCashSessionOpens();

    final body =
        verify(() => cashRemote.openSession(captureAny())).captured.single
            as CashSessionOpenRequestDto;
    expect(wire(body.toJson()), {
      'id': 'session-1',
      'device_id': 'device-1',
      'opening_amount': '25000.5',
      'opening_note': 'Fond du matin',
      'opened_at': '2026-11-10T07:58:12.000Z',
    });
  });

  test('movement payload survives the push round trip', () async {
    final payload = cashMovementPayload(
      CashMovement(
        id: 'movement-1',
        sessionId: 'session-1',
        type: CashMovementType.cashOut,
        reason: CashMovementReason.expense,
        amount: Decimal.parse('3500'),
        note: 'Carburant',
        createdAt: DateTime.utc(2026, 11, 10, 11, 20),
        syncStatus: CashSyncStatus.pending,
      ),
    );
    await queue.enqueueCashMovement(movementId: 'movement-1', payload: payload);
    when(() => cashRemote.createMovement(any(), any())).thenAnswer(
      (_) async => const CashMovementDto(
        id: 'movement-1',
        sessionId: 'session-1',
        type: 'cash_out',
        reason: 'expense',
        amount: '3500.00',
        createdAt: '2026-11-10T11:20:00Z',
        syncedAt: '2026-11-10T11:20:05Z',
      ),
    );

    await push.pushPendingCashMovements();

    final captured = verify(
      () => cashRemote.createMovement(captureAny(), captureAny()),
    ).captured;
    expect(captured[0], 'session-1');
    expect(wire((captured[1] as CashMovementCreateRequestDto).toJson()), {
      'id': 'movement-1',
      'type': 'cash_out',
      'reason': 'expense',
      'amount': '3500',
      'note': 'Carburant',
      'created_at': '2026-11-10T11:20:00.000Z',
    });
  });

  test('close payload survives the push round trip', () async {
    final payload = cashSessionClosePayload(
      sessionId: 'session-1',
      countedAmount: Decimal.parse('24000'),
      clientExpectedAmount: Decimal.parse('-500.25'),
      closingNote: 'Écart compté deux fois',
      closedAt: DateTime.utc(2026, 11, 10, 19, 2, 40),
    );
    await queue.enqueueCashSessionClose(
      sessionId: 'session-1',
      payload: payload,
    );
    when(() => cashRemote.closeSession(any(), any())).thenAnswer(
      (_) async => const CashSessionDetailDto(
        session: CashSessionDto(
          id: 'session-1',
          deviceId: 'device-1',
          status: 'closed',
          openingAmount: '0',
          openedAt: '2026-11-10T07:58:12Z',
          expectedAmount: '-500.25',
          clientExpectedAmount: '-500.25',
          countedAmount: '24000.00',
          discrepancyAmount: '24500.25',
          closedAt: '2026-11-10T19:02:40Z',
        ),
        summary: CashSummaryDto(
          openingAmount: '0',
          cashSales: '0',
          cashSalesCount: 0,
          mobileMoneySales: '0',
          cashIn: '0',
          cashOut: '0',
          cashRefunds: '0',
          expectedAmount: '-500.25',
          lateImpact: '0',
          serverRecalculated: false,
        ),
        movements: [],
      ),
    );

    await push.pushPendingCashSessionCloses();

    final captured = verify(
      () => cashRemote.closeSession(captureAny(), captureAny()),
    ).captured;
    expect(captured[0], 'session-1');
    expect(wire((captured[1] as CashSessionCloseRequestDto).toJson()), {
      'counted_amount': '24000',
      'client_expected_amount': '-500.25',
      'closing_note': 'Écart compté deux fois',
      'closed_at': '2026-11-10T19:02:40.000Z',
    });
  });

  test(
    'return payload (with cash_session_id) survives the push round trip',
    () async {
      await db
          .into(db.sales)
          .insert(
            SalesCompanion.insert(
              id: 'sale-1',
              receiptNumber: 7,
              totalAmount: '5000',
              vatAmount: '0',
              paymentMethod: 'cash',
              createdAt: DateTime.utc(2026, 11, 10, 9),
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
              lineTotal: '5000',
            ),
          );
      await ReturnsRepositoryImpl(db: db, syncQueue: queue).createReturn(
        id: 'r1',
        saleId: 'sale-1',
        reason: ReturnReason.defective,
        note: 'Bouteille fendue',
        refundMethod: RefundMethod.cash,
        cashSessionId: 'session-1',
        lines: [
          (
            saleItemId: 'coca',
            productId: 'p1',
            quantity: 2,
            condition: ItemCondition.defective,
            refundAmount: Decimal.parse('2000'),
          ),
        ],
      );
      when(() => syncRemote.pushReturns(any())).thenAnswer(
        (_) async => const ReturnsSyncBatchResponseDto(
          processed: 1,
          results: [
            ReturnSyncResultDto(id: 'r1', status: 'created', returnNumber: 1),
          ],
        ),
      );

      await push.pushPendingReturns();

      final batch =
          verify(() => syncRemote.pushReturns(captureAny())).captured.single
              as ReturnsSyncBatchRequestDto;
      final sent = (wire(batch.toJson())['returns'] as List).single;
      final itemId = (await (db.select(
        db.saleReturnItems,
      )..where((i) => i.returnId.equals('r1'))).getSingle()).id;
      expect(sent, {
        'id': 'r1',
        'sale_id': 'sale-1',
        'reason': 'defective',
        'note': 'Bouteille fendue',
        'refund_method': 'cash',
        'refund_amount': '2000',
        // Horodatage UTC généré à la création du retour.
        'created_at': predicate<String>(
          (v) => v.endsWith('Z') && DateTime.parse(v).isUtc,
        ),
        'cash_session_id': 'session-1',
        'items': [
          {
            'id': itemId,
            'sale_item_id': 'coca',
            'quantity': 2,
            'condition': 'defective',
            'refund_amount': '2000',
          },
        ],
      });
    },
  );
}
