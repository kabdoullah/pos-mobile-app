import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_models/cash_session_dto.dart';
import 'package:mobile/core/network/api_models/sync_responses_dto.dart';
import 'package:mobile/core/storage/device_id_storage.dart';
import 'package:mobile/core/sync/cash_sync_closure.dart';
import 'package:mobile/core/sync/push_service.dart';
import 'package:mobile/core/sync/sync_queue_repository.dart';
import 'package:mobile/core/sync/sync_remote_datasource.dart';
import 'package:mobile/database/app_database.dart'
    hide CashMovement, CashSession;
import 'package:mobile/core/sync/cash_sync_remote_datasource.dart';
import 'package:mobile/features/cash_register/data/repositories/cash_register_repository_impl.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_movement.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_session.dart';
import 'package:mobile/features/cash_register/domain/repositories/cash_register_repository.dart';
import 'package:mobile/features/sales/data/repositories/sales_repository_impl.dart';
import 'package:mobile/features/sales/domain/entities/cart_item.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart' as sale_entity;
import 'package:mocktail/mocktail.dart';

class _MockDeviceIdStorage extends Mock implements DeviceIdStorage {}

class _MockSyncRemote extends Mock implements SyncRemoteDataSource {}

class _MockCashRemote extends Mock implements CashRegisterRemoteDataSource {}

/// Réponse d'erreur HTTP au format de l'API (`code`, `detail`, `field`).
DioException apiError(int status, String code, {String? field}) => DioException(
  requestOptions: RequestOptions(path: '/api/v1/cash-sessions'),
  type: DioExceptionType.badResponse,
  response: Response<Map<String, dynamic>>(
    requestOptions: RequestOptions(path: '/api/v1/cash-sessions'),
    statusCode: status,
    data: {'code': code, 'detail': code, 'field': field},
  ),
);

/// Pas de réseau.
DioException networkError() => DioException(
  requestOptions: RequestOptions(path: '/api/v1/cash-sessions'),
  type: DioExceptionType.connectionError,
);

CashSessionDto sessionDto({
  required String id,
  String status = 'closed',
  String? expected,
  String? clientExpected,
  String? counted,
  String? discrepancy,
  String? closedAt = '2026-11-10T19:02:40Z',
}) => CashSessionDto(
  id: id,
  deviceId: 'device-1',
  status: status,
  openingAmount: '25000.00',
  openedAt: '2026-11-10T07:58:12Z',
  expectedAmount: expected,
  clientExpectedAmount: clientExpected,
  countedAmount: counted,
  discrepancyAmount: discrepancy,
  closedAt: closedAt,
);

CashSessionDetailDto detailDto(
  CashSessionDto session, {
  required String expected,
  bool serverRecalculated = false,
}) => CashSessionDetailDto(
  session: session,
  summary: CashSummaryDto(
    openingAmount: '25000.00',
    cashSales: '0',
    cashSalesCount: 0,
    mobileMoneySales: '0',
    cashIn: '0',
    cashOut: '0',
    cashRefunds: '0',
    expectedAmount: expected,
    lateImpact: '0',
    serverRecalculated: serverRecalculated,
  ),
  movements: const [],
);

void main() {
  late AppDatabase db;
  late SyncQueueRepository queue;
  late _MockCashRemote cashRemote;
  late _MockSyncRemote syncRemote;
  late CashRegisterRepository repository;
  late PushService push;

  Decimal d(String v) => Decimal.parse(v);

  setUpAll(() {
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
    registerFallbackValue(const SalesSyncBatchRequestDto(sales: []));
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
    cashRemote = _MockCashRemote();
    final deviceId = _MockDeviceIdStorage();
    when(deviceId.getOrCreate).thenAnswer((_) async => 'device-1');
    repository = CashRegisterRepositoryImpl(
      db: db,
      syncQueue: queue,
      deviceIdStorage: deviceId,
      remote: cashRemote,
    );
    syncRemote = _MockSyncRemote();
    push = PushService(
      remoteDataSource: syncRemote,
      cashRemoteDataSource: cashRemote,
      queueRepository: queue,
      db: db,
    );
  });

  tearDown(() => db.close());

  Future<SyncQueueData> entryOf(String entityType, String entityId) =>
      (db.select(db.syncQueue)
            ..where((q) => q.entityType.equals(entityType))
            ..where((q) => q.entityId.equals(entityId)))
          .getSingle();

  Future<CashSession> sessionOf(String id) async =>
      (await repository.watchLocalHistory().first).singleWhere(
        (s) => s.id == id,
      );

  Future<CashMovement> movementOf(String sessionId) async =>
      (await repository.watchMovements(sessionId).first).single;

  /// Ouvre une session et simule son ouverture acceptée par le serveur.
  Future<CashSession> openSynced() async {
    final session = await repository.openSession(openingAmount: d('25000'));
    when(() => cashRemote.openSession(any())).thenAnswer(
      (_) async => sessionDto(id: session.id, status: 'open', closedAt: null),
    );
    await push.pushPendingCashSessionOpens();
    return session;
  }

  group('ouverture', () {
    test(
      'accepted open marks session and entry synced, body as api.md',
      () async {
        final session = await openSynced();

        final body =
            verify(() => cashRemote.openSession(captureAny())).captured.single
                as CashSessionOpenRequestDto;
        expect(body.id, session.id);
        expect(body.deviceId, 'device-1');
        expect(body.openingAmount, '25000');
        expect((await sessionOf(session.id)).syncStatus, CashSyncStatus.synced);
        expect(
          (await entryOf('cash_session_open', session.id)).status,
          'synced',
        );
      },
    );

    test('CASH_SESSION_ALREADY_OPEN rejects the session', () async {
      final session = await repository.openSession(openingAmount: d('0'));
      when(
        () => cashRemote.openSession(any()),
      ).thenThrow(apiError(409, 'CASH_SESSION_ALREADY_OPEN'));

      await push.pushPendingCashSessionOpens();

      final local = await sessionOf(session.id);
      expect(local.syncStatus, CashSyncStatus.rejected);
      expect(local.rejectionCode, 'CASH_SESSION_ALREADY_OPEN');
      expect(
        (await entryOf('cash_session_open', session.id)).status,
        'rejected',
      );
    });

    test('network error on open is retried', () async {
      final session = await repository.openSession(openingAmount: d('0'));
      when(() => cashRemote.openSession(any())).thenThrow(networkError());

      await push.pushPendingCashSessionOpens();

      final entry = await entryOf('cash_session_open', session.id);
      expect(entry.status, 'pending');
      expect(entry.retryCount, 1);
      expect((await sessionOf(session.id)).syncStatus, CashSyncStatus.pending);
    });
  });

  group('mouvements', () {
    test('accepted movement synced, session_id only in the URL', () async {
      final session = await openSynced();
      final movement = await repository.recordMovement(
        sessionId: session.id,
        type: CashMovementType.cashIn,
        reason: CashMovementReason.topUp,
        amount: d('5000'),
      );
      when(() => cashRemote.createMovement(any(), any())).thenAnswer(
        (_) async => CashMovementDto(
          id: movement.id,
          sessionId: session.id,
          type: 'cash_in',
          reason: 'top_up',
          amount: '5000.00',
          createdAt: '2026-11-10T11:20:00Z',
          syncedAt: '2026-11-10T11:20:05Z',
        ),
      );

      await push.pushPendingCashMovements();

      final captured = verify(
        () => cashRemote.createMovement(captureAny(), captureAny()),
      ).captured;
      expect(captured[0], session.id);
      final body = captured[1] as CashMovementCreateRequestDto;
      expect(body.toJson().containsKey('session_id'), isFalse);
      expect(body.id, movement.id);
      expect(body.amount, '5000');
      expect((await movementOf(session.id)).syncStatus, CashSyncStatus.synced);
      expect((await entryOf('cash_movement', movement.id)).status, 'synced');
    });

    test('INSUFFICIENT_CASH marks movement rejected', () async {
      final session = await openSynced();
      final movement = await repository.recordMovement(
        sessionId: session.id,
        type: CashMovementType.cashOut,
        reason: CashMovementReason.expense,
        amount: d('3500'),
      );
      when(
        () => cashRemote.createMovement(any(), any()),
      ).thenThrow(apiError(422, 'INSUFFICIENT_CASH'));

      await push.pushPendingCashMovements();

      final local = await movementOf(session.id);
      expect(local.syncStatus, CashSyncStatus.rejected);
      expect(local.rejectionCode, 'INSUFFICIENT_CASH');
      expect((await entryOf('cash_movement', movement.id)).status, 'rejected');
      // Un mouvement refusé n'entre plus dans le solde théorique.
      expect(
        (await repository.watchSummary(session.id).first).expectedAmount,
        d('25000'),
      );
    });

    test('movement 404 is retried', () async {
      final session = await repository.openSession(openingAmount: d('1000'));
      final movement = await repository.recordMovement(
        sessionId: session.id,
        type: CashMovementType.cashIn,
        reason: CashMovementReason.topUp,
        amount: d('500'),
      );
      when(
        () => cashRemote.createMovement(any(), any()),
      ).thenThrow(apiError(404, 'NOT_FOUND'));

      await push.pushPendingCashMovements();

      final entry = await entryOf('cash_movement', movement.id);
      expect(entry.status, 'pending');
      expect(entry.retryCount, 1);
      expect((await movementOf(session.id)).syncStatus, CashSyncStatus.pending);
    });
  });

  group('clôture', () {
    test(
      'close held while a session sale is pending, sent once it is synced',
      () async {
        final session = await openSynced();
        await db
            .into(db.sales)
            .insert(
              SalesCompanion.insert(
                id: 'sale-1',
                receiptNumber: 0,
                totalAmount: '2000',
                vatAmount: '0',
                paymentMethod: 'cash',
                createdAt: DateTime.utc(2026, 11, 10, 9),
                cashSessionId: drift.Value(session.id),
              ),
            );
        final saleEntryId = await queue.enqueueSale(
          saleId: 'sale-1',
          salePayload: {'id': 'sale-1'},
        );
        await repository.closeSession(
          sessionId: session.id,
          countedAmount: d('27000'),
        );
        when(() => cashRemote.closeSession(any(), any())).thenAnswer(
          (_) async => detailDto(
            sessionDto(
              id: session.id,
              expected: '27000.00',
              clientExpected: '27000.00',
              counted: '27000.00',
              discrepancy: '0.00',
            ),
            expected: '27000.00',
          ),
        );

        await push.pushPendingCashSessionCloses();

        verifyNever(() => cashRemote.closeSession(any(), any()));
        final held = await entryOf('cash_session_close', session.id);
        expect(held.status, 'pending');
        expect(held.retryCount, 0);

        await queue.markSynced(saleEntryId);
        await push.pushPendingCashSessionCloses();

        verify(() => cashRemote.closeSession(session.id, any())).called(1);
        expect(
          (await entryOf('cash_session_close', session.id)).status,
          'synced',
        );
        expect((await sessionOf(session.id)).syncStatus, CashSyncStatus.synced);
      },
    );

    test('close held while the open is pending', () async {
      final session = await repository.openSession(openingAmount: d('1000'));
      await repository.closeSession(
        sessionId: session.id,
        countedAmount: d('1000'),
      );

      await push.pushPendingCashSessionCloses();

      verifyNever(() => cashRemote.closeSession(any(), any()));
      expect(
        (await entryOf('cash_session_close', session.id)).status,
        'pending',
      );
    });

    test('close retry resends identical closed_at', () async {
      final session = await openSynced();
      final closed = await repository.closeSession(
        sessionId: session.id,
        countedAmount: d('25000'),
      );
      var calls = 0;
      when(() => cashRemote.closeSession(any(), any())).thenAnswer((_) async {
        calls++;
        if (calls == 1) throw networkError();
        return detailDto(
          sessionDto(
            id: session.id,
            expected: '25000.00',
            clientExpected: '25000.00',
            counted: '25000.00',
            discrepancy: '0.00',
          ),
          expected: '25000.00',
        );
      });

      await push.pushPendingCashSessionCloses();
      final afterFailure = await entryOf('cash_session_close', session.id);
      expect(afterFailure.status, 'pending');
      expect(afterFailure.retryCount, 1);

      await push.pushPendingCashSessionCloses();

      final bodies = verify(
        () => cashRemote.closeSession(session.id, captureAny()),
      ).captured.cast<CashSessionCloseRequestDto>();
      expect(bodies, hasLength(2));
      expect(bodies[0].closedAt, bodies[1].closedAt);
      expect(bodies[0].closedAt, closed.closedAt!.toIso8601String());
      expect(bodies[0], bodies[1]);
      expect(bodies[0].toJson().containsKey('session_id'), isFalse);
      expect(
        (await entryOf('cash_session_close', session.id)).status,
        'synced',
      );
    });

    test(
      'server close with different expected updates local session and flags serverRecalculated',
      () async {
        final session = await openSynced();
        await repository.closeSession(
          sessionId: session.id,
          countedAmount: d('26000'),
          note: 'Billet en trop',
        );
        // Le serveur connaît une vente de 2000 que l'appareil n'a pas.
        when(() => cashRemote.closeSession(any(), any())).thenAnswer(
          (_) async => detailDto(
            sessionDto(
              id: session.id,
              expected: '27000.00',
              clientExpected: '25000.00',
              counted: '26000.00',
              discrepancy: '-1000.00',
            ),
            expected: '27000.00',
            serverRecalculated: true,
          ),
        );

        await push.pushPendingCashSessionCloses();

        final local = await sessionOf(session.id);
        expect(local.expectedAmount, d('27000'));
        expect(local.discrepancyAmount, d('-1000'));
        expect(local.serverRecalculated, isTrue);
        expect(local.syncStatus, CashSyncStatus.synced);
        // Valeurs locales conservées.
        expect(local.countedAmount, d('26000'));
        expect(local.clientExpectedAmount, d('25000'));
        expect(local.closingNote, 'Billet en trop');
      },
    );

    test(
      'CASH_SESSION_CLOSED on close aligns local session from GET',
      () async {
        final session = await openSynced();
        final closed = await repository.closeSession(
          sessionId: session.id,
          countedAmount: d('25000'),
        );
        when(
          () => cashRemote.closeSession(any(), any()),
        ).thenThrow(apiError(409, 'CASH_SESSION_CLOSED'));
        when(() => cashRemote.getSession(session.id)).thenAnswer(
          (_) async => detailDto(
            sessionDto(
              id: session.id,
              expected: '25500.00',
              clientExpected: '25500.00',
              counted: '25500.00',
              discrepancy: '0.00',
            ),
            expected: '25500.00',
            serverRecalculated: true,
          ),
        );

        await push.pushPendingCashSessionCloses();

        verify(() => cashRemote.getSession(session.id)).called(1);
        final local = await sessionOf(session.id);
        expect(local.expectedAmount, d('25500'));
        expect(local.discrepancyAmount, d('0'));
        expect(local.serverRecalculated, isTrue);
        expect(local.syncStatus, CashSyncStatus.rejected);
        expect(local.rejectionCode, 'CASH_SESSION_CLOSED');
        expect(local.countedAmount, d('25000'));
        expect(local.closedAt, closed.closedAt);
        final entry = await entryOf('cash_session_close', session.id);
        expect(entry.status, 'rejected');
      },
    );

    test(
      'closing_note VALIDATION_ERROR rejects the close definitively',
      () async {
        final session = await openSynced();
        await repository.closeSession(
          sessionId: session.id,
          countedAmount: d('25000'),
        );
        when(
          () => cashRemote.closeSession(any(), any()),
        ).thenThrow(apiError(422, 'VALIDATION_ERROR', field: 'closing_note'));

        await push.pushPendingCashSessionCloses();
        await push.pushPendingCashSessionCloses();

        verify(() => cashRemote.closeSession(any(), any())).called(1);
        final local = await sessionOf(session.id);
        expect(local.status, CashSessionStatus.closed);
        expect(local.syncStatus, CashSyncStatus.rejected);
        expect(local.rejectionCode, CashRegisterException.closingNoteRequired);
        expect(
          (await entryOf('cash_session_close', session.id)).status,
          'rejected',
        );
      },
    );

    test('close 404 is retried', () async {
      final session = await openSynced();
      await repository.closeSession(
        sessionId: session.id,
        countedAmount: d('25000'),
      );
      when(
        () => cashRemote.closeSession(any(), any()),
      ).thenThrow(apiError(404, 'NOT_FOUND'));

      await push.pushPendingCashSessionCloses();

      final entry = await entryOf('cash_session_close', session.id);
      expect(entry.status, 'pending');
      expect(entry.retryCount, 1);
    });
  });

  group('lecture distante', () {
    test(
      'history and detail are online reads, nothing written to drift',
      () async {
        when(
          () => cashRemote.listSessions(
            cursor: any(named: 'cursor'),
            limit: any(named: 'limit'),
            deviceId: any(named: 'deviceId'),
          ),
        ).thenAnswer(
          (_) async => CashSessionPageDto(
            items: [sessionDto(id: 'other-device')],
            nextCursor: 'next',
            hasMore: true,
          ),
        );
        when(() => cashRemote.getSession('other-device')).thenAnswer(
          (_) async => detailDto(
            sessionDto(id: 'other-device', expected: '25000.00'),
            expected: '25000.00',
          ),
        );

        final page = await repository.fetchRemoteHistory(cursor: 'c1');
        final detail = await repository.fetchRemoteDetail('other-device');

        verify(
          () => cashRemote.listSessions(
            cursor: 'c1',
            limit: any(named: 'limit'),
            deviceId: any(named: 'deviceId'),
          ),
        ).called(1);
        expect(page.items.single.id, 'other-device');
        expect(page.nextCursor, 'next');
        expect(page.hasMore, isTrue);
        expect(detail.session.id, 'other-device');
        expect(await db.select(db.cashSessions).get(), isEmpty);
        expect(await db.select(db.cashMovements).get(), isEmpty);
      },
    );
  });

  /// Réponse 200 de la clôture, solde figé égal au compté.
  void closeAccepted(String sessionId, String amount) {
    when(() => cashRemote.closeSession(any(), any())).thenAnswer(
      (_) async => detailDto(
        sessionDto(
          id: sessionId,
          expected: amount,
          clientExpected: amount,
          counted: amount,
          discrepancy: '0.00',
        ),
        expected: amount,
      ),
    );
  }

  group('statut de la session pendant la clôture', () {
    test(
      'offline open + close: pending after the open push, synced after close 200',
      () async {
        final session = await repository.openSession(openingAmount: d('1000'));
        await repository.closeSession(
          sessionId: session.id,
          countedAmount: d('1000'),
        );
        when(() => cashRemote.openSession(any())).thenAnswer(
          (_) async =>
              sessionDto(id: session.id, status: 'open', closedAt: null),
        );

        await push.pushPendingCashSessionOpens();

        expect(
          (await entryOf('cash_session_open', session.id)).status,
          'synced',
        );
        expect(
          (await sessionOf(session.id)).syncStatus,
          CashSyncStatus.pending,
        );

        closeAccepted(session.id, '1000.00');
        await push.pushPendingCashSessionCloses();

        expect((await sessionOf(session.id)).syncStatus, CashSyncStatus.synced);
      },
    );

    test('local close of a synced session sets it back to pending', () async {
      final session = await openSynced();
      expect((await sessionOf(session.id)).syncStatus, CashSyncStatus.synced);

      await repository.closeSession(
        sessionId: session.id,
        countedAmount: d('25000'),
      );

      final local = await sessionOf(session.id);
      expect(local.syncStatus, CashSyncStatus.pending);
      expect(local.rejectionCode, isNull);
    });
  });

  test(
    'open rejected: movement and close rejected without calling the server',
    () async {
      final session = await repository.openSession(openingAmount: d('1000'));
      final movement = await repository.recordMovement(
        sessionId: session.id,
        type: CashMovementType.cashIn,
        reason: CashMovementReason.topUp,
        amount: d('500'),
      );
      // Une vente de la session reste en échec (session inconnue du serveur) :
      // elle ne doit pas retenir la clôture.
      await db
          .into(db.sales)
          .insert(
            SalesCompanion.insert(
              id: 'sale-1',
              receiptNumber: 0,
              totalAmount: '2000',
              vatAmount: '0',
              paymentMethod: 'cash',
              createdAt: DateTime.utc(2026, 11, 10, 9),
              cashSessionId: drift.Value(session.id),
            ),
          );
      await queue.enqueueSale(saleId: 'sale-1', salePayload: {'id': 'sale-1'});
      await repository.closeSession(
        sessionId: session.id,
        countedAmount: d('3500'),
      );
      when(
        () => cashRemote.openSession(any()),
      ).thenThrow(apiError(409, 'CASH_SESSION_ALREADY_OPEN'));

      await push.pushPendingCashSessionOpens();
      await push.pushPendingCashMovements();
      await push.pushPendingCashSessionCloses();

      verifyNever(() => cashRemote.createMovement(any(), any()));
      verifyNever(() => cashRemote.closeSession(any(), any()));
      final local = await movementOf(session.id);
      expect(local.syncStatus, CashSyncStatus.rejected);
      expect(local.rejectionCode, cashSessionOpenRejectedCode);
      final movementEntry = await entryOf('cash_movement', movement.id);
      expect(movementEntry.status, 'rejected');
      final closeEntry = await entryOf('cash_session_close', session.id);
      expect(closeEntry.status, 'rejected');
      final localSession = await sessionOf(session.id);
      expect(localSession.syncStatus, CashSyncStatus.rejected);
      expect(localSession.rejectionCode, cashSessionOpenRejectedCode);
    },
  );

  group('renvoi de la clôture avec un commentaire', () {
    test(
      'resubmitCloseWithNote resends the same close with the note',
      () async {
        final session = await openSynced();
        final closed = await repository.closeSession(
          sessionId: session.id,
          countedAmount: d('25000'),
        );
        when(
          () => cashRemote.closeSession(any(), any()),
        ).thenThrow(apiError(422, 'VALIDATION_ERROR', field: 'closing_note'));
        await push.pushPendingCashSessionCloses();
        final firstBody =
            verify(
                  () => cashRemote.closeSession(session.id, captureAny()),
                ).captured.single
                as CashSessionCloseRequestDto;

        await repository.resubmitCloseWithNote(session.id, '  Vente oubliée  ');

        final local = await sessionOf(session.id);
        expect(local.status, CashSessionStatus.closed);
        expect(local.syncStatus, CashSyncStatus.pending);
        expect(local.rejectionCode, isNull);
        expect(local.closingNote, 'Vente oubliée');
        expect(local.closedAt, closed.closedAt);
        final entries = await (db.select(
          db.syncQueue,
        )..where((q) => q.entityType.equals('cash_session_close'))).get();
        // Entrée refusée remise en attente (resetWithPayload), pas de doublon.
        expect(entries, hasLength(1));
        expect(entries.single.status, 'pending');

        closeAccepted(session.id, '25000.00');
        await push.pushPendingCashSessionCloses();

        final resent =
            verify(
                  () => cashRemote.closeSession(session.id, captureAny()),
                ).captured.single
                as CashSessionCloseRequestDto;
        expect(resent.closingNote, 'Vente oubliée');
        expect(resent.closedAt, firstBody.closedAt);
        expect(resent.countedAmount, firstBody.countedAmount);
        expect(resent.clientExpectedAmount, firstBody.clientExpectedAmount);
        expect((await sessionOf(session.id)).syncStatus, CashSyncStatus.synced);
      },
    );

    test(
      'resubmit refused unless the close was rejected for its note',
      () async {
        final session = await openSynced();
        await repository.closeSession(
          sessionId: session.id,
          countedAmount: d('25000'),
        );

        await expectLater(
          repository.resubmitCloseWithNote(session.id, 'Commentaire'),
          throwsA(
            isA<CashRegisterException>().having(
              (e) => e.code,
              'code',
              CashRegisterException.closeNotResubmittable,
            ),
          ),
        );
        await expectLater(
          repository.resubmitCloseWithNote(session.id, '   '),
          throwsA(
            isA<CashRegisterException>().having(
              (e) => e.code,
              'code',
              CashRegisterException.noteRequired,
            ),
          ),
        );
      },
    );

    test('domain codes match the core sync codes', () {
      expect(
        CashRegisterException.closingNoteRequired,
        cashClosingNoteRequiredCode,
      );
      expect(
        CashRegisterException.sessionOpenRejected,
        cashSessionOpenRejectedCode,
      );
    });
  });

  group('attente de la clôture', () {
    /// Session ouverte (synchronisée) puis clôturée sur l'appareil.
    Future<CashSession> closedSession() async {
      final session = await openSynced();
      await repository.closeSession(
        sessionId: session.id,
        countedAmount: d('25000'),
      );
      closeAccepted(session.id, '25000.00');
      return session;
    }

    Future<int> enqueueSessionSale(String sessionId) async {
      await db
          .into(db.sales)
          .insert(
            SalesCompanion.insert(
              id: 'sale-1',
              receiptNumber: 0,
              totalAmount: '0',
              vatAmount: '0',
              paymentMethod: 'mobile_money_wave',
              createdAt: DateTime.utc(2026, 11, 10, 9),
              cashSessionId: drift.Value(sessionId),
            ),
          );
      return queue.enqueueSale(saleId: 'sale-1', salePayload: {'id': 'sale-1'});
    }

    test('a pending movement holds the close', () async {
      final session = await openSynced();
      await repository.recordMovement(
        sessionId: session.id,
        type: CashMovementType.cashIn,
        reason: CashMovementReason.topUp,
        amount: d('500'),
      );
      await repository.closeSession(
        sessionId: session.id,
        countedAmount: d('25500'),
      );

      await push.pushPendingCashSessionCloses();

      verifyNever(() => cashRemote.closeSession(any(), any()));
    });

    test('a pending sale_return holds the close', () async {
      final session = await closedSession();
      await db
          .into(db.saleReturns)
          .insert(
            SaleReturnsCompanion.insert(
              id: 'r1',
              saleId: 'sale-0',
              reason: 'defective',
              refundMethod: 'mobile_money_wave',
              refundAmount: '1000',
              createdAt: DateTime.utc(2026, 11, 10, 10),
              cashSessionId: drift.Value(session.id),
            ),
          );
      await queue.enqueueReturn(returnId: 'r1', returnPayload: {'id': 'r1'});

      await push.pushPendingCashSessionCloses();

      verifyNever(() => cashRemote.closeSession(any(), any()));
    });

    test('a failed sale holds the close', () async {
      final session = await closedSession();
      final saleEntry = await enqueueSessionSale(session.id);
      for (var i = 0; i < 5; i++) {
        await queue.incrementRetry(saleEntry, 'cash session not found');
      }
      expect((await entryOf('sale', 'sale-1')).status, 'failed');

      await push.pushPendingCashSessionCloses();

      verifyNever(() => cashRemote.closeSession(any(), any()));
    });

    test('a rejected sale does not hold the close', () async {
      final session = await closedSession();
      final saleEntry = await enqueueSessionSale(session.id);
      await queue.markRejected(saleEntry, 'invalid');

      await push.pushPendingCashSessionCloses();

      verify(() => cashRemote.closeSession(session.id, any())).called(1);
    });
  });

  group('sortie retenue tant que le solde serveur est incomplet', () {
    /// Vente en espèces de la session, créée par le vrai repository (payload
    /// de file complet).
    Future<String> sessionSale(String sessionId) async {
      final sale =
          await SalesRepositoryImpl(
            db: db,
            syncQueue: queue,
            dio: Dio(),
          ).createSale(
            items: [
              CartItem(
                productId: 'p1',
                productName: 'Riz 5kg',
                unitPrice: d('5000'),
                quantity: 1,
              ),
            ],
            totalAmount: d('5000'),
            vatAmount: Decimal.zero,
            paymentMethod: sale_entity.PaymentMethod.cash,
            cashSessionId: sessionId,
          );
      return sale.id;
    }

    void movementAccepted() {
      when(() => cashRemote.createMovement(any(), any())).thenAnswer((
        inv,
      ) async {
        final body = inv.positionalArguments[1] as CashMovementCreateRequestDto;
        return CashMovementDto(
          id: body.id,
          sessionId: inv.positionalArguments[0] as String,
          type: body.type,
          reason: body.reason,
          amount: body.amount,
          createdAt: body.createdAt,
          syncedAt: body.createdAt,
        );
      });
    }

    test(
      'cash_out held while a session sale fails to sync, sent once synced',
      () async {
        final session = await openSynced();
        final saleId = await sessionSale(session.id);
        final cashOut = await repository.recordMovement(
          sessionId: session.id,
          type: CashMovementType.cashOut,
          reason: CashMovementReason.expense,
          amount: d('28000'),
        );
        when(() => syncRemote.pushSales(any())).thenThrow(networkError());
        movementAccepted();

        await push.pushPendingSales();
        await push.pushPendingCashMovements();

        verifyNever(() => cashRemote.createMovement(any(), any()));
        final held = await entryOf('cash_movement', cashOut.id);
        expect(held.status, 'pending');
        expect(held.retryCount, 0);
        expect(
          (await movementOf(session.id)).syncStatus,
          CashSyncStatus.pending,
        );

        when(() => syncRemote.pushSales(any())).thenAnswer(
          (_) async => SalesSyncBatchResponseDto(
            processed: 1,
            results: [
              SaleSyncResultDto(
                id: saleId,
                status: 'created',
                receiptNumber: 1,
              ),
            ],
          ),
        );
        await push.pushPendingSales();
        await push.pushPendingCashMovements();

        verify(() => cashRemote.createMovement(session.id, any())).called(1);
        expect((await entryOf('cash_movement', cashOut.id)).status, 'synced');
        expect(
          (await movementOf(session.id)).syncStatus,
          CashSyncStatus.synced,
        );
      },
    );

    test('cash_out held while an earlier movement is queued', () async {
      final session = await openSynced();
      final cashIn = await repository.recordMovement(
        sessionId: session.id,
        type: CashMovementType.cashIn,
        reason: CashMovementReason.topUp,
        amount: d('5000'),
      );
      final cashOut = await repository.recordMovement(
        sessionId: session.id,
        type: CashMovementType.cashOut,
        reason: CashMovementReason.expense,
        amount: d('28000'),
      );
      when(
        () => cashRemote.createMovement(any(), any()),
      ).thenThrow(networkError());

      await push.pushPendingCashMovements();

      final sent = verify(
        () => cashRemote.createMovement(any(), captureAny()),
      ).captured.cast<CashMovementCreateRequestDto>();
      expect(sent.map((b) => b.id), [cashIn.id]);
      final held = await entryOf('cash_movement', cashOut.id);
      expect(held.status, 'pending');
      expect(held.retryCount, 0);
    });

    test('cash_in is not held by a pending session sale', () async {
      final session = await openSynced();
      await sessionSale(session.id);
      final cashIn = await repository.recordMovement(
        sessionId: session.id,
        type: CashMovementType.cashIn,
        reason: CashMovementReason.topUp,
        amount: d('5000'),
      );
      movementAccepted();

      await push.pushPendingCashMovements();

      expect((await entryOf('cash_movement', cashIn.id)).status, 'synced');
    });
  });

  group('horloge de l\'appareil en avance', () {
    test(
      'open: VALIDATION_ERROR on opened_at is retried, not rejected',
      () async {
        final session = await repository.openSession(openingAmount: d('1000'));
        when(
          () => cashRemote.openSession(any()),
        ).thenThrow(apiError(422, 'VALIDATION_ERROR', field: 'opened_at'));

        await push.pushPendingCashSessionOpens();

        final entry = await entryOf('cash_session_open', session.id);
        expect(entry.status, 'pending');
        expect(entry.retryCount, 1);
        final local = await sessionOf(session.id);
        expect(local.syncStatus, CashSyncStatus.pending);
        expect(local.rejectionCode, isNull);

        when(() => cashRemote.openSession(any())).thenAnswer(
          (_) async =>
              sessionDto(id: session.id, status: 'open', closedAt: null),
        );
        await push.pushPendingCashSessionOpens();

        final bodies = verify(
          () => cashRemote.openSession(captureAny()),
        ).captured.cast<CashSessionOpenRequestDto>();
        expect(bodies, hasLength(2));
        expect(bodies[1].openedAt, bodies[0].openedAt);
        expect((await sessionOf(session.id)).syncStatus, CashSyncStatus.synced);
      },
    );

    test(
      'movement: VALIDATION_ERROR on created_at is retried, not rejected',
      () async {
        final session = await openSynced();
        final movement = await repository.recordMovement(
          sessionId: session.id,
          type: CashMovementType.cashIn,
          reason: CashMovementReason.topUp,
          amount: d('500'),
        );
        when(
          () => cashRemote.createMovement(any(), any()),
        ).thenThrow(apiError(422, 'VALIDATION_ERROR', field: 'created_at'));

        await push.pushPendingCashMovements();

        final entry = await entryOf('cash_movement', movement.id);
        expect(entry.status, 'pending');
        expect(entry.retryCount, 1);
        final local = await movementOf(session.id);
        expect(local.syncStatus, CashSyncStatus.pending);
        expect(local.rejectionCode, isNull);
      },
    );

    test(
      'close: VALIDATION_ERROR on closed_at is retried, not rejected',
      () async {
        final session = await openSynced();
        await repository.closeSession(
          sessionId: session.id,
          countedAmount: d('25000'),
        );
        when(
          () => cashRemote.closeSession(any(), any()),
        ).thenThrow(apiError(422, 'VALIDATION_ERROR', field: 'closed_at'));

        await push.pushPendingCashSessionCloses();

        final entry = await entryOf('cash_session_close', session.id);
        expect(entry.status, 'pending');
        expect(entry.retryCount, 1);
        final local = await sessionOf(session.id);
        expect(local.syncStatus, CashSyncStatus.pending);
        expect(local.rejectionCode, isNull);
      },
    );

    test('VALIDATION_ERROR on another field is still rejected', () async {
      final session = await openSynced();
      final movement = await repository.recordMovement(
        sessionId: session.id,
        type: CashMovementType.cashIn,
        reason: CashMovementReason.topUp,
        amount: d('500'),
      );
      when(
        () => cashRemote.createMovement(any(), any()),
      ).thenThrow(apiError(422, 'VALIDATION_ERROR', field: 'amount'));

      await push.pushPendingCashMovements();

      expect((await entryOf('cash_movement', movement.id)).status, 'rejected');
    });
  });
}
