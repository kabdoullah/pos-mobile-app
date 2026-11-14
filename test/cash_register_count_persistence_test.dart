import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_models/cash_session_dto.dart';
import 'package:mobile/core/storage/device_id_storage.dart';
import 'package:mobile/core/sync/cash_session_restore.dart';
import 'package:mobile/core/sync/cash_sync_remote_datasource.dart';
import 'package:mobile/core/sync/push_service.dart';
import 'package:mobile/core/sync/sync_queue_repository.dart';
import 'package:mobile/core/sync/sync_remote_datasource.dart';
import 'package:mobile/database/app_database.dart'
    hide CashMovement, CashSession;
import 'package:mobile/features/cash_register/data/models/cash_mappers.dart';
import 'package:mobile/features/cash_register/data/repositories/cash_register_repository_impl.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_count.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_movement.dart';
import 'package:mobile/features/cash_register/domain/entities/denomination.dart';
import 'package:mobile/features/cash_register/domain/repositories/cash_register_repository.dart';
import 'package:mobile/features/cash_register/domain/usecases/close_cash_session_usecase.dart';
import 'package:mobile/features/cash_register/domain/usecases/open_cash_session_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockDeviceIdStorage extends Mock implements DeviceIdStorage {}

class _MockCashRemote extends Mock implements CashRegisterRemoteDataSource {}

class _MockSyncRemote extends Mock implements SyncRemoteDataSource {}

Matcher _refused(String code) =>
    throwsA(isA<CashRegisterException>().having((e) => e.code, 'code', code));

Decimal d(String v) => Decimal.parse(v);

const bill10000 = Denomination(DenominationType.bill, 10000);
const bill5000 = Denomination(DenominationType.bill, 5000);
const coin250 = Denomination(DenominationType.coin, 250);
const coin100 = Denomination(DenominationType.coin, 100);

/// 2 × 10 000 + 1 × 5 000 + 4 × 250 = 26 000.
CashCount openingCount() => CashCount.empty()
    .withQuantity(bill10000, 2)
    .withQuantity(bill5000, 1)
    .withQuantity(coin250, 4);

/// Corps tel qu'il part sur le réseau : `toJson()` puis encodage JSON.
Map<String, dynamic> wire(Object? json) =>
    jsonDecode(jsonEncode(json)) as Map<String, dynamic>;

void main() {
  late AppDatabase db;
  late SyncQueueRepository queue;
  late _MockCashRemote cashRemote;
  late CashRegisterRepositoryImpl repository;
  late OpenCashSessionUseCase open;
  late CloseCashSessionUseCase close;

  setUpAll(() {
    registerFallbackValue(
      const CashSessionOpenRequestDto(
        id: '',
        deviceId: '',
        openingAmount: '0',
        openedAt: '',
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
    open = OpenCashSessionUseCase(repository: repository);
    close = CloseCashSessionUseCase(repository: repository);
  });

  tearDown(() => db.close());

  Future<Map<String, dynamic>> queuedPayload(String entityType) async {
    final entry = await (db.select(
      db.syncQueue,
    )..where((q) => q.entityType.equals(entityType))).getSingle();
    return jsonDecode(entry.payload) as Map<String, dynamic>;
  }

  Future<int> countLines() async =>
      (await db.select(db.cashCountLines).get()).length;

  group('ouverture', () {
    test('comptage enregistré (toutes les coupures) et mis en file', () async {
      final count = openingCount();
      final session = await open(
        openingAmount: count.total,
        count: count,
        note: 'Matin',
      );

      expect(session.openingAmount, d('26000'));
      expect(await countLines(), fcfaDenominations.length);
      expect(
        await repository
            .watchCount(session.id, CashCountOperation.opening)
            .first,
        count,
      );
      expect(
        await repository
            .watchCount(session.id, CashCountOperation.closing)
            .first,
        isNull,
      );

      final payload = await queuedPayload('cash_session_open');
      expect(payload['opening_amount'], '26000');
      final lines = payload['opening_count'] as List<dynamic>;
      expect(lines, hasLength(fcfaDenominations.length));
      expect(lines.first, {
        'denomination_type': 'bill',
        'denomination': 10000,
        'quantity': 2,
      });
      expect(
        lines,
        contains(
          equals({
            'denomination_type': 'coin',
            'denomination': 250,
            'quantity': 4,
          }),
        ),
      );
    });

    test('mode « Total seulement » : ni lignes ni clé opening_count', () async {
      await open(openingAmount: d('15000'));

      expect(await countLines(), 0);
      expect(
        (await queuedPayload('cash_session_open')).containsKey('opening_count'),
        isFalse,
      );
    });

    test('total du comptage différent du montant : rien écrit', () async {
      await expectLater(
        open(openingAmount: d('30000'), count: openingCount()),
        _refused(CashRegisterException.countMismatch),
      );
      expect(await db.select(db.cashSessions).get(), isEmpty);
      expect(await countLines(), 0);
    });
  });

  group('clôture', () {
    test('écart = compté − théorique, comptage figé et mis en file', () async {
      final session = await open(
        openingAmount: openingCount().total,
        count: openingCount(),
      );
      await repository.recordMovement(
        sessionId: session.id,
        type: CashMovementType.cashIn,
        reason: CashMovementReason.topUp,
        amount: d('1500'),
      );
      // Théorique 27 500 ; compté 2 × 10 000 + 1 × 5 000 + 20 × 100 = 27 000.
      final counted = CashCount.empty()
          .withQuantity(bill10000, 2)
          .withQuantity(bill5000, 1)
          .withQuantity(coin100, 20);

      final closed = await close(
        countedAmount: counted.total,
        count: counted,
        note: 'Monnaie rendue en trop',
      );

      // Le solde théorique n'est jamais ajusté au comptage.
      expect(closed.clientExpectedAmount, d('27500'));
      expect(closed.countedAmount, d('27000'));
      expect(closed.discrepancyAmount, d('-500'));
      expect(
        await repository
            .watchCount(session.id, CashCountOperation.closing)
            .first,
        counted,
      );
      expect(await repository.lastClosingCount(), counted);

      final payload = await queuedPayload('cash_session_close');
      expect(payload['counted_amount'], '27000');
      expect(
        payload['closing_count'] as List<dynamic>,
        contains(
          equals({
            'denomination_type': 'coin',
            'denomination': 100,
            'quantity': 20,
          }),
        ),
      );
    });

    test(
      'clôture refusée (note manquante) : aucune ligne de clôture',
      () async {
        await open(openingAmount: d('10000'));
        final counted = CashCount.empty().withQuantity(bill5000, 1);

        await expectLater(
          repository.closeSession(
            sessionId: (await repository.getActiveSession())!.id,
            countedAmount: counted.total,
            closingCount: counted,
          ),
          _refused(CashRegisterException.noteRequired),
        );
        expect(await countLines(), 0);
        expect(await repository.lastClosingCount(), isNull);
      },
    );

    test('total du comptage différent du montant compté refusé', () async {
      await open(openingAmount: d('10000'));
      await expectLater(
        close(
          countedAmount: d('10000'),
          count: CashCount.empty().withQuantity(bill5000, 1),
        ),
        _refused(CashRegisterException.countMismatch),
      );
    });

    test('dernière clôture sans billetterie : rien à reprendre', () async {
      await open(openingAmount: d('10000'));
      await close(countedAmount: d('10000'));
      expect(await repository.lastClosingCount(), isNull);
    });
  });

  group('synchro', () {
    test("les comptages survivent à l'aller-retour du push", () async {
      final push = PushService(
        remoteDataSource: _MockSyncRemote(),
        cashRemoteDataSource: cashRemote,
        queueRepository: queue,
        db: db,
      );
      await queue.enqueueCashSessionOpen(
        sessionId: 's1',
        payload: cashSessionOpenPayload(
          id: 's1',
          deviceId: 'device-1',
          openingAmount: d('26000'),
          openingNote: null,
          openedAt: DateTime.utc(2026, 11, 14, 7, 45),
          openingCount: openingCount(),
        ),
      );
      when(() => cashRemote.openSession(any())).thenAnswer(
        (_) async => const CashSessionDto(
          id: 's1',
          deviceId: 'device-1',
          status: 'open',
          openingAmount: '26000.00',
          openedAt: '2026-11-14T07:45:00Z',
        ),
      );

      await push.pushPendingCashSessionOpens();

      final body =
          verify(() => cashRemote.openSession(captureAny())).captured.single
              as CashSessionOpenRequestDto;
      final json = wire(body.toJson());
      expect(json['opening_count'], hasLength(fcfaDenominations.length));
      expect((json['opening_count'] as List<dynamic>).first, {
        'denomination_type': 'bill',
        'denomination': 10000,
        'quantity': 2,
      });
    });

    test('entrée de file sans comptage : la clé reste absente', () {
      final body = CashSessionCloseRequestDto.fromJson({
        'counted_amount': '100',
        'client_expected_amount': '100',
        'closing_note': null,
        'closed_at': '2026-11-14T19:30:00Z',
      });
      expect(wire(body.toJson()).containsKey('closing_count'), isFalse);
    });

    test('détail serveur : comptages lus en CashCount', () {
      final detail = CashSessionDetailDto.fromJson({
        'session': {
          'id': 's1',
          'device_id': 'device-1',
          'status': 'open',
          'opening_amount': '26000.00',
          'opened_at': '2026-11-14T07:45:00Z',
        },
        'summary': {
          'opening_amount': '26000.00',
          'cash_sales': '0',
          'cash_sales_count': 0,
          'mobile_money_sales': '0',
          'cash_in': '0',
          'cash_out': '0',
          'cash_refunds': '0',
          'expected_amount': '26000.00',
          'late_impact': '0',
          'server_recalculated': false,
        },
        'movements': <dynamic>[],
        'opening_count': {
          'lines': [
            {
              'denomination_type': 'bill',
              'denomination': '10000.00',
              'quantity': 2,
              'subtotal': '20000.00',
            },
            {
              'denomination_type': 'coin',
              'denomination': '250.00',
              'quantity': 24,
              'subtotal': '6000.00',
            },
          ],
          'bills_total': '20000.00',
          'coins_total': '6000.00',
          'total': '26000.00',
        },
        'closing_count': null,
      }).toDomain();

      expect(detail.openingCount!.billsTotal, d('20000'));
      expect(detail.openingCount!.coinsTotal, d('6000'));
      expect(detail.openingCount!.quantityOf(coin250), 24);
      expect(detail.closingCount, isNull);
    });

    test('restauration : le comptage de la session ouverte revient', () async {
      final deviceId = _MockDeviceIdStorage();
      when(deviceId.getOrCreate).thenAnswer((_) async => 'device-1');
      when(() => cashRemote.getActiveSession('device-1')).thenAnswer(
        (_) async => const CashSessionDetailDto(
          session: CashSessionDto(
            id: 'open-1',
            deviceId: 'device-1',
            status: 'open',
            openingAmount: '20000.00',
            openedAt: '2026-11-14T07:45:00Z',
          ),
          summary: CashSummaryDto(
            openingAmount: '20000',
            cashSales: '0',
            cashSalesCount: 0,
            mobileMoneySales: '0',
            cashIn: '0',
            cashOut: '0',
            cashRefunds: '0',
            expectedAmount: '20000',
            lateImpact: '0',
            serverRecalculated: false,
          ),
          movements: [],
          openingCount: CashCountDto(
            lines: [
              CashCountLineDto(
                denominationType: 'bill',
                denomination: '10000.00',
                quantity: 2,
                subtotal: '20000.00',
              ),
            ],
            billsTotal: '20000.00',
            coinsTotal: '0',
            total: '20000.00',
          ),
        ),
      );
      when(
        () => cashRemote.listSessions(
          limit: CashSessionRestorer.recentLimit,
          deviceId: 'device-1',
        ),
      ).thenAnswer(
        (_) async => const CashSessionPageDto(items: [], hasMore: false),
      );

      await CashSessionRestorer(
        db: db,
        remote: cashRemote,
        deviceIdStorage: deviceId,
      ).restore();

      expect(
        await repository.watchCount('open-1', CashCountOperation.opening).first,
        CashCount.fromQuantities({bill10000: 2}),
      );
    });
  });
}
