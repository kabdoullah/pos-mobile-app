import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/storage/device_id_storage.dart';
import 'package:mobile/core/sync/sync_queue_repository.dart';
import 'package:mobile/database/app_database.dart'
    hide CashMovement, CashSession, SaleReturn;
import 'package:mobile/features/cash_register/data/models/cash_mappers.dart';
import 'package:mobile/features/cash_register/data/repositories/cash_register_repository_impl.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_movement.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_session.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_summary.dart';
import 'package:mobile/features/cash_register/domain/repositories/cash_register_repository.dart';
import 'package:mobile/features/returns/data/repositories/returns_repository_impl.dart';
import 'package:mobile/features/returns/domain/entities/sale_return.dart';
import 'package:mobile/features/sales/data/repositories/sales_repository_impl.dart';
import 'package:mobile/features/sales/domain/entities/cart_item.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart' as domain;
import 'package:mobile/features/sales/domain/usecases/create_sale_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockDeviceIdStorage extends Mock implements DeviceIdStorage {}

void main() {
  late AppDatabase db;
  late SyncQueueRepository queue;
  late CashRegisterRepositoryImpl repository;

  Decimal d(String v) => Decimal.parse(v);

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    queue = SyncQueueRepository(db: db);
    final deviceId = _MockDeviceIdStorage();
    when(deviceId.getOrCreate).thenAnswer((_) async => 'device-1');
    repository = CashRegisterRepositoryImpl(
      db: db,
      syncQueue: queue,
      deviceIdStorage: deviceId,
    );
  });

  tearDown(() => db.close());

  Future<List<SyncQueueData>> queueOf(String entityType) => (db.select(
    db.syncQueue,
  )..where((q) => q.entityType.equals(entityType))).get();

  Future<CashSummary> summaryOf(String sessionId) =>
      repository.watchSummary(sessionId).first;

  test(
    'open then watchActiveSession emits it and enqueues cash_session_open',
    () async {
      expect(await repository.watchActiveSession().first, isNull);

      final session = await repository.openSession(
        openingAmount: d('25000'),
        note: 'Fond de caisse lundi',
      );

      final active = await repository.watchActiveSession().first;
      expect(active, session);
      expect(active!.status, CashSessionStatus.open);
      expect(active.syncStatus, CashSyncStatus.pending);
      expect(active.deviceId, 'device-1');
      expect(active.openedAt.isUtc, isTrue);

      final entries = await queueOf('cash_session_open');
      expect(entries, hasLength(1));
      expect(entries.single.entityId, session.id);
      expect(jsonDecode(entries.single.payload), {
        'id': session.id,
        'device_id': 'device-1',
        'opening_amount': '25000',
        'opening_note': 'Fond de caisse lundi',
        'opened_at': session.openedAt.toIso8601String(),
      });
    },
  );

  test('second open on device refused by the repository', () async {
    await repository.openSession(openingAmount: d('1000'));

    await expectLater(
      repository.openSession(openingAmount: d('2000')),
      throwsA(
        isA<CashRegisterException>().having(
          (e) => e.code,
          'code',
          CashRegisterException.sessionAlreadyOpen,
        ),
      ),
    );
    expect(await db.select(db.cashSessions).get(), hasLength(1));
    expect(await queueOf('cash_session_open'), hasLength(1));
  });

  test('movement is persisted pending and queued with session_id', () async {
    final session = await repository.openSession(openingAmount: d('5000'));

    final movement = await repository.recordMovement(
      sessionId: session.id,
      type: CashMovementType.cashOut,
      reason: CashMovementReason.supplies,
      amount: d('3500'),
      note: 'Sachets',
    );

    final row = await db.select(db.cashMovements).getSingle();
    expect(row.syncStatus, 'pending');
    final entry = (await queueOf('cash_movement')).single;
    expect(entry.entityId, movement.id);
    expect(jsonDecode(entry.payload), {
      'session_id': session.id,
      'id': movement.id,
      'type': 'cash_out',
      'reason': 'supplies',
      'amount': '3500',
      'note': 'Sachets',
      'created_at': movement.createdAt.toIso8601String(),
    });
    expect((await summaryOf(session.id)).expectedAmount, d('1500'));
  });

  test('watchMovements lists newest first', () async {
    final session = await repository.openSession(openingAmount: d('0'));
    for (final (id, at) in [
      ('m-old', DateTime.utc(2026, 11, 10, 8)),
      ('m-new', DateTime.utc(2026, 11, 10, 9)),
    ]) {
      await db
          .into(db.cashMovements)
          .insert(
            CashMovementsCompanion.insert(
              id: id,
              sessionId: session.id,
              type: 'cash_in',
              reason: 'top_up',
              amount: '100',
              createdAt: at,
              syncStatus: 'synced',
            ),
          );
    }

    final movements = await repository.watchMovements(session.id).first;
    expect(movements.map((m) => m.id), ['m-new', 'm-old']);
  });

  test('rejected movements are counted nowhere in the summary', () async {
    final session = await repository.openSession(openingAmount: d('10000'));
    await db
        .into(db.cashMovements)
        .insert(
          CashMovementsCompanion.insert(
            id: 'refused',
            sessionId: session.id,
            type: 'cash_out',
            reason: 'withdrawal',
            amount: '4000',
            createdAt: DateTime.utc(2026, 11, 10, 9),
            syncStatus: 'rejected',
          ),
        );
    await repository.recordMovement(
      sessionId: session.id,
      type: CashMovementType.cashIn,
      reason: CashMovementReason.topUp,
      amount: d('500'),
    );

    final summary = await summaryOf(session.id);
    expect(summary.cashOut, Decimal.zero);
    expect(summary.cashIn, d('500'));
    expect(summary.expectedAmount, d('10500'));
  });

  test(
    'close computes discrepancy and stores client_expected_amount and closed_at',
    () async {
      final session = await repository.openSession(openingAmount: d('25000'));
      // Sortie acceptée par le serveur sur un solde que l'appareil ne voyait
      // pas encore (seul un remboursement en espèces passe sous zéro en
      // usage normal) : solde local négatif, -1000.
      await db
          .into(db.cashMovements)
          .insert(
            CashMovementsCompanion.insert(
              id: 'm1',
              sessionId: session.id,
              type: 'cash_out',
              reason: 'expense',
              amount: '26000',
              createdAt: DateTime.utc(2026, 11, 10, 9),
              syncStatus: 'synced',
            ),
          );

      final closed = await repository.closeSession(
        sessionId: session.id,
        countedAmount: d('0'),
        note: 'Avance non rendue',
      );

      expect(closed.status, CashSessionStatus.closed);
      expect(closed.countedAmount, d('0'));
      expect(closed.clientExpectedAmount, d('-1000'));
      expect(closed.discrepancyAmount, d('1000'));
      expect(closed.closingNote, 'Avance non rendue');
      expect(closed.closedAt, isNotNull);
      expect(closed.closedAt!.isUtc, isTrue);
      expect(await repository.watchActiveSession().first, isNull);

      final entry = (await queueOf('cash_session_close')).single;
      expect(entry.entityId, session.id);
      expect(jsonDecode(entry.payload), {
        'session_id': session.id,
        'counted_amount': '0',
        'client_expected_amount': '-1000',
        'closing_note': 'Avance non rendue',
        'closed_at': closed.closedAt!.toIso8601String(),
      });
    },
  );

  test(
    'closeSession with a gap and no note throws and writes nothing',
    () async {
      final session = await repository.openSession(openingAmount: d('5000'));

      for (final note in [null, '   ']) {
        await expectLater(
          repository.closeSession(
            sessionId: session.id,
            countedAmount: d('4500'),
            note: note,
          ),
          throwsA(
            isA<CashRegisterException>().having(
              (e) => e.code,
              'code',
              CashRegisterException.noteRequired,
            ),
          ),
        );
      }

      final active = await repository.getActiveSession();
      expect(active?.id, session.id);
      expect(active!.closedAt, isNull);
      expect(active.countedAmount, isNull);
      expect(await queueOf('cash_session_close'), isEmpty);
    },
  );

  test('recordMovement re-checks the balance for cash_out', () async {
    final session = await repository.openSession(openingAmount: d('3000'));

    await expectLater(
      repository.recordMovement(
        sessionId: session.id,
        type: CashMovementType.cashOut,
        reason: CashMovementReason.withdrawal,
        amount: d('3000.01'),
      ),
      throwsA(
        isA<CashRegisterException>().having(
          (e) => e.code,
          'code',
          CashRegisterException.insufficientCash,
        ),
      ),
    );
    expect(await db.select(db.cashMovements).get(), isEmpty);
    expect(await queueOf('cash_movement'), isEmpty);

    await repository.recordMovement(
      sessionId: session.id,
      type: CashMovementType.cashOut,
      reason: CashMovementReason.withdrawal,
      amount: d('3000'),
    );
    expect(await queueOf('cash_movement'), hasLength(1));
  });

  test('close payload re-read from queue is byte-identical', () async {
    final session = await repository.openSession(openingAmount: d('5000'));
    final closed = await repository.closeSession(
      sessionId: session.id,
      countedAmount: d('5000'),
    );
    final first = (await queueOf('cash_session_close')).single;

    // Échec réseau puis nouvel essai : la file garde le payload d'origine.
    await queue.markSyncing(first.id);
    await queue.incrementRetry(first.id, 'timeout');
    // Un second appel (double appui) ne réécrit ni ne remet rien en file.
    final again = await repository.closeSession(
      sessionId: session.id,
      countedAmount: d('5000'),
    );

    final entries = await queueOf('cash_session_close');
    expect(entries, hasLength(1));
    expect(entries.single.payload, first.payload);
    expect(again.closedAt, closed.closedAt);

    // Le payload relu correspond octet pour octet aux valeurs persistées.
    final row = await (db.select(
      db.cashSessions,
    )..where((s) => s.id.equals(session.id))).getSingle();
    expect(
      entries.single.payload,
      jsonEncode(
        cashSessionClosePayload(
          sessionId: row.id,
          countedAmount: d(row.countedAmount!),
          clientExpectedAmount: d(row.clientExpectedAmount!),
          closingNote: row.closingNote,
          closedAt: row.closedAt!,
        ),
      ),
    );
  });

  group('rattachement des ventes et retours', () {
    late SalesRepositoryImpl salesRepository;
    late CreateSaleUseCase createSale;
    late ReturnsRepositoryImpl returnsRepository;

    setUp(() {
      salesRepository = SalesRepositoryImpl(
        db: db,
        syncQueue: queue,
        dio: Dio(),
      );
      createSale = CreateSaleUseCase(repository: salesRepository);
      returnsRepository = ReturnsRepositoryImpl(db: db, syncQueue: queue);
    });

    List<CartItem> cart(String price) => [
      CartItem(
        productId: 'p1',
        productName: 'Riz 5 kg',
        unitPrice: d(price),
        quantity: 1,
      ),
    ];

    test('createSale with session persists cashSessionId and mixed cash part; '
        'summary counts only the cash part', () async {
      final session = await repository.openSession(openingAmount: d('1000'));

      final mixed = await createSale(
        items: cart('10000'),
        totalAmount: d('10000'),
        vatAmount: Decimal.zero,
        paymentMethod: domain.PaymentMethod.mixed,
        cashAmount: d('4000'),
        mobileMoneyAmount: d('6000'),
        cashSessionId: session.id,
      );
      await createSale(
        items: cart('2500'),
        totalAmount: d('2500'),
        vatAmount: Decimal.zero,
        paymentMethod: domain.PaymentMethod.cash,
        cashSessionId: session.id,
      );
      await createSale(
        items: cart('3000'),
        totalAmount: d('3000'),
        vatAmount: Decimal.zero,
        paymentMethod: domain.PaymentMethod.wave,
        cashSessionId: session.id,
      );
      // Vente hors session : jamais comptée.
      await createSale(
        items: cart('9999'),
        totalAmount: d('9999'),
        vatAmount: Decimal.zero,
        paymentMethod: domain.PaymentMethod.cash,
      );

      final row = await (db.select(
        db.sales,
      )..where((s) => s.id.equals(mixed.id))).getSingle();
      expect(row.cashSessionId, session.id);
      expect(row.cashAmount, '4000');
      expect(row.mobileMoneyAmount, '6000');

      final payloads = [
        for (final e in await queueOf('sale'))
          jsonDecode(e.payload) as Map<String, dynamic>,
      ];
      final mixedPayload = payloads.singleWhere((p) => p['id'] == mixed.id);
      expect(mixedPayload['cash_session_id'], session.id);
      expect(mixedPayload['cash_amount'], '4000');
      expect(
        payloads.where((p) => !p.containsKey('cash_session_id')),
        hasLength(1),
      );

      final summary = await summaryOf(session.id);
      expect(summary.cashSales, d('6500'));
      expect(summary.cashSalesCount, 2);
      expect(summary.mobileMoneySales, d('9000'));
      expect(summary.expectedAmount, d('7500'));
    });

    test('cash return attached to active session decreases balance; '
        'mobile return does not', () async {
      final session = await repository.openSession(openingAmount: d('5000'));
      await db
          .into(db.sales)
          .insert(
            SalesCompanion.insert(
              id: 'sale-1',
              receiptNumber: 3,
              totalAmount: '3000',
              vatAmount: '0',
              paymentMethod: 'cash',
              createdAt: DateTime.utc(2026, 11, 9),
            ),
          );
      await db
          .into(db.saleItems)
          .insert(
            SaleItemsCompanion.insert(
              id: 'it1',
              saleId: 'sale-1',
              productId: 'p1',
              productName: 'Riz',
              unitPrice: '1000',
              quantity: 3,
              lineTotal: '3000',
            ),
          );

      final emissions = <CashSummary>[];
      final sub = repository.watchSummary(session.id).listen(emissions.add);
      await pumpEventQueue();
      expect(emissions.last.expectedAmount, d('5000'));

      Future<void> returnOne(String id, RefundMethod method) =>
          returnsRepository.createReturn(
            id: id,
            saleId: 'sale-1',
            reason: ReturnReason.defective,
            refundMethod: method,
            lines: [
              (
                saleItemId: 'it1',
                productId: 'p1',
                quantity: 1,
                condition: ItemCondition.unsellable,
                refundAmount: d('1000'),
              ),
            ],
            cashSessionId: session.id,
          );

      await returnOne('r-cash', RefundMethod.cash);
      await pumpEventQueue();
      expect(emissions.last.cashRefunds, d('1000'));
      expect(emissions.last.expectedAmount, d('4000'));

      await returnOne('r-wave', RefundMethod.wave);
      await pumpEventQueue();
      expect(emissions.last.expectedAmount, d('4000'));

      final stored = await (db.select(
        db.saleReturns,
      )..where((r) => r.id.equals('r-cash'))).getSingle();
      expect(stored.cashSessionId, session.id);
      final payload =
          jsonDecode(
                (await queueOf(
                  'sale_return',
                )).firstWhere((e) => e.entityId == 'r-cash').payload,
              )
              as Map<String, dynamic>;
      expect(payload['cash_session_id'], session.id);

      // Retour refusé par le serveur : sorti du solde, signalé à part.
      await (db.update(
        db.saleReturns,
      )..where((r) => r.id.equals('r-cash'))).write(
        const SaleReturnsCompanion(syncStatus: drift.Value('rejected')),
      );
      await pumpEventQueue();
      expect(emissions.last.cashRefunds, Decimal.zero);
      expect(emissions.last.rejectedCashRefunds, d('1000'));
      expect(emissions.last.expectedAmount, d('5000'));

      await sub.cancel();
    });
  });

  test('watchLocalHistory lists sessions newest first', () async {
    final first = await repository.openSession(openingAmount: d('100'));
    await repository.closeSession(sessionId: first.id, countedAmount: d('100'));
    await db
        .into(db.cashSessions)
        .insert(
          CashSessionsCompanion.insert(
            id: 'older',
            deviceId: 'device-1',
            status: 'closed',
            openingAmount: '0',
            openedAt: DateTime.utc(2020),
          ),
        );

    final history = await repository.watchLocalHistory().first;
    expect(history.map((s) => s.id), [first.id, 'older']);
  });
}
