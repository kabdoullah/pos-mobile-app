import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_models/cash_session_dto.dart';
import 'package:mobile/core/storage/device_id_storage.dart';
import 'package:mobile/core/sync/cash_session_restore.dart';
import 'package:mobile/core/sync/cash_sync_remote_datasource.dart';
import 'package:mobile/database/app_database.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements CashRegisterRemoteDataSource {}

class _MockDeviceId extends Mock implements DeviceIdStorage {}

const _device = 'device-1';

CashSessionDto _session(
  String id, {
  String status = 'closed',
  String openedAt = '2026-11-13T07:45:00Z',
}) => CashSessionDto(
  id: id,
  deviceId: _device,
  status: status,
  openingAmount: '10000.00',
  openedAt: openedAt,
  countedAmount: status == 'closed' ? '47000.00' : null,
  expectedAmount: status == 'closed' ? '48175.00' : null,
  discrepancyAmount: status == 'closed' ? '-1175.00' : null,
  closedAt: status == 'closed' ? '2026-11-13T23:24:00Z' : null,
);

const _summary = CashSummaryDto(
  openingAmount: '10000',
  cashSales: '0',
  cashSalesCount: 0,
  mobileMoneySales: '0',
  cashIn: '2000',
  cashOut: '0',
  cashRefunds: '0',
  expectedAmount: '12000',
  lateImpact: '0',
  serverRecalculated: false,
);

CashSessionDetailDto _activeDetail() => CashSessionDetailDto(
  session: _session('open-1', status: 'open', openedAt: '2026-11-14T07:50:00Z'),
  summary: _summary,
  movements: const [
    CashMovementDto(
      id: 'm1',
      sessionId: 'open-1',
      type: 'in',
      reason: 'other',
      amount: '2000.00',
      createdAt: '2026-11-14T08:10:00Z',
      syncedAt: '2026-11-14T08:10:01Z',
    ),
  ],
);

DioException _notFound() => DioException(
  requestOptions: RequestOptions(path: '/api/v1/cash-sessions/active'),
  response: Response(
    requestOptions: RequestOptions(path: '/api/v1/cash-sessions/active'),
    statusCode: 404,
  ),
);

void main() {
  late AppDatabase db;
  late _MockRemote remote;
  late CashSessionRestorer restorer;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    remote = _MockRemote();
    final deviceId = _MockDeviceId();
    when(deviceId.getOrCreate).thenAnswer((_) async => _device);
    restorer = CashSessionRestorer(
      db: db,
      remote: remote,
      deviceIdStorage: deviceId,
    );
  });

  tearDown(() => db.close());

  void serverHas({CashSessionDetailDto? active, List<CashSessionDto>? recent}) {
    if (active == null) {
      when(() => remote.getActiveSession(_device)).thenThrow(_notFound());
    } else {
      when(
        () => remote.getActiveSession(_device),
      ).thenAnswer((_) async => active);
    }
    when(
      () => remote.listSessions(
        limit: CashSessionRestorer.recentLimit,
        deviceId: _device,
      ),
    ).thenAnswer(
      (_) async =>
          CashSessionPageDto(items: recent ?? const [], hasMore: false),
    );
  }

  test('restaure la session ouverte, ses mouvements et la dernière '
      'clôture', () async {
    serverHas(
      active: _activeDetail(),
      recent: [
        _session('open-1', status: 'open', openedAt: '2026-11-14T07:50:00Z'),
        _session('closed-1'),
      ],
    );

    await restorer.restore();

    final sessions = await db.select(db.cashSessions).get();
    final byId = {for (final s in sessions) s.id: s};
    expect(byId.keys, unorderedEquals(['open-1', 'closed-1']));
    expect(byId['open-1']!.status, 'open');
    expect(byId['open-1']!.openingAmount, '10000');
    expect(byId['open-1']!.syncStatus, 'synced');
    expect(byId['closed-1']!.countedAmount, '47000');
    expect(byId['closed-1']!.discrepancyAmount, '-1175');
    expect(
      byId['closed-1']!.closedAt!.toUtc(),
      DateTime.utc(2026, 11, 13, 23, 24),
    );

    final movements = await db.select(db.cashMovements).get();
    expect(movements.single.id, 'm1');
    expect(movements.single.amount, '2000');
    expect(movements.single.syncStatus, 'synced');
  });

  test('aucune session ouverte (404) : seules les clôtures', () async {
    serverHas(recent: [_session('closed-1')]);

    await restorer.restore();

    final sessions = await db.select(db.cashSessions).get();
    expect(sessions.single.id, 'closed-1');
  });

  test(
    'n\'écrase pas une session locale (clôture en attente d\'envoi)',
    () async {
      // Clôturée sur l'appareil, pas encore envoyée : le serveur la voit
      // encore ouverte.
      await db
          .into(db.cashSessions)
          .insert(
            CashSessionsCompanion.insert(
              id: 'open-1',
              deviceId: _device,
              status: 'closed',
              openingAmount: '10000',
              openedAt: DateTime.utc(2026, 11, 14, 7, 50),
              countedAmount: const drift.Value('12000'),
              closedAt: drift.Value(DateTime.utc(2026, 11, 14, 19)),
            ),
          );
      serverHas(active: _activeDetail());

      await restorer.restore();

      final session = await db.select(db.cashSessions).getSingle();
      expect(session.status, 'closed');
      expect(session.syncStatus, 'pending');
    },
  );

  test('une session déjà ouverte localement n\'est pas doublée', () async {
    await db
        .into(db.cashSessions)
        .insert(
          CashSessionsCompanion.insert(
            id: 'local-open',
            deviceId: _device,
            status: 'open',
            openingAmount: '5000',
            openedAt: DateTime.utc(2026, 11, 14, 9),
          ),
        );
    serverHas(active: _activeDetail());

    await restorer.restore();

    final open = await (db.select(
      db.cashSessions,
    )..where((s) => s.status.equals('open'))).get();
    expect(open.single.id, 'local-open');
    expect(await db.select(db.cashMovements).get(), isEmpty);
  });

  test('erreur réseau : remonte, rien n\'est écrit', () async {
    when(() => remote.getActiveSession(_device)).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/api/v1/cash-sessions/active'),
        type: DioExceptionType.connectionError,
      ),
    );

    await expectLater(restorer.restore(), throwsA(isA<DioException>()));
    expect(await db.select(db.cashSessions).get(), isEmpty);
  });
}
