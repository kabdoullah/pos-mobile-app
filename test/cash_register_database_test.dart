import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_models/sale_dto.dart';
import 'package:mobile/core/network/api_models/sale_return_dto.dart';
import 'package:mobile/core/network/api_models/sync_changes_dto.dart';
import 'package:mobile/core/sync/local_data_reset_service.dart';
import 'package:mobile/core/sync/pull_service.dart';
import 'package:mobile/core/sync/sync_queue_repository.dart';
import 'package:mobile/core/sync/sync_remote_datasource.dart';
import 'package:mobile/database/app_database.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

class _MockRemote extends Mock implements SyncRemoteDataSource {}

const _now = '2026-11-10T10:00:00Z';

void main() {
  test('migration v9 to v10 keeps sales and adds cash tables', () async {
    final file = File(
      '${Directory.systemTemp.createTempSync('pos_migration_v10').path}'
      '/db.sqlite',
    );
    // Schéma v9 minimal des tables modifiées, avec une vente et un retour.
    final raw = sqlite.sqlite3.open(file.path)
      ..execute('''
        CREATE TABLE sales (id TEXT NOT NULL PRIMARY KEY,
          receipt_number INTEGER NOT NULL, total_amount TEXT NOT NULL,
          vat_amount TEXT NOT NULL, payment_method TEXT NOT NULL,
          discount_type TEXT, discount_value TEXT,
          discount_amount TEXT NOT NULL DEFAULT '0',
          created_at INTEGER NOT NULL);
        CREATE TABLE sale_returns (id TEXT NOT NULL PRIMARY KEY,
          sale_id TEXT NOT NULL, return_number INTEGER NOT NULL DEFAULT 0,
          reason TEXT NOT NULL, note TEXT, refund_method TEXT NOT NULL,
          refund_amount TEXT NOT NULL, created_at INTEGER NOT NULL,
          sync_status TEXT NOT NULL DEFAULT 'pending', rejection_code TEXT);
        INSERT INTO sales (id, receipt_number, total_amount, vat_amount,
          payment_method, created_at)
          VALUES ('s1', 7, '4000', '0', 'cash', 0);
        INSERT INTO sale_returns (id, sale_id, reason, refund_method,
          refund_amount, created_at)
          VALUES ('r1', 's1', 'other', 'cash', '2000', 0);
        PRAGMA user_version = 9;
      ''');
    raw.close();

    final db = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(db.close);

    final sale = await db.select(db.sales).getSingle();
    expect(sale.receiptNumber, 7);
    expect(sale.totalAmount, '4000');
    expect(sale.paymentMethod, 'cash');
    expect(sale.cashAmount, isNull);
    expect(sale.mobileMoneyAmount, isNull);
    expect(sale.cashSessionId, isNull);
    final saleReturn = await db.select(db.saleReturns).getSingle();
    expect(saleReturn.refundAmount, '2000');
    expect(saleReturn.cashSessionId, isNull);
    expect(await db.select(db.cashSessions).get(), isEmpty);
    expect(await db.select(db.cashMovements).get(), isEmpty);
    expect(await db.select(db.cashCountLines).get(), isEmpty);
  });

  test(
    'migration v10 to v11 keeps cash sessions and adds count lines',
    () async {
      final file = File(
        '${Directory.systemTemp.createTempSync('pos_migration_v11').path}'
        '/db.sqlite',
      );
      // Schéma v10 de cash_sessions, avec une session clôturée sans billetterie.
      final raw = sqlite.sqlite3.open(file.path)
        ..execute('''
        CREATE TABLE cash_sessions (id TEXT NOT NULL PRIMARY KEY,
          device_id TEXT NOT NULL, status TEXT NOT NULL,
          opening_amount TEXT NOT NULL, opening_note TEXT,
          opened_at INTEGER NOT NULL, expected_amount TEXT,
          client_expected_amount TEXT, counted_amount TEXT,
          discrepancy_amount TEXT, closing_note TEXT, closed_at INTEGER,
          server_recalculated INTEGER NOT NULL DEFAULT 0,
          sync_status TEXT NOT NULL DEFAULT 'pending', rejection_code TEXT);
        INSERT INTO cash_sessions (id, device_id, status, opening_amount,
          opened_at, counted_amount, closed_at)
          VALUES ('cs1', 'device-1', 'closed', '10000', 0, '12000', 3600);
        PRAGMA user_version = 10;
      ''');
      raw.close();

      final db = AppDatabase.forTesting(NativeDatabase(file));
      addTearDown(db.close);

      final session = await db.select(db.cashSessions).getSingle();
      expect(session.countedAmount, '12000');
      expect(await db.select(db.cashCountLines).get(), isEmpty);
      await db
          .into(db.cashCountLines)
          .insert(
            CashCountLinesCompanion.insert(
              sessionId: 'cs1',
              operation: 'closing',
              denominationType: 'bill',
              denomination: 10000,
              quantity: 1,
            ),
          );
      expect(await db.select(db.cashCountLines).get(), hasLength(1));
    },
  );

  group('base en mémoire', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
    });

    tearDown(() => db.close());

    test('wipeBusinessData clears cash tables', () async {
      await db
          .into(db.cashSessions)
          .insert(
            CashSessionsCompanion.insert(
              id: 'cs1',
              deviceId: 'device-1',
              status: 'open',
              openingAmount: '10000',
              openedAt: DateTime.utc(2026, 11, 10, 8),
            ),
          );
      await db
          .into(db.cashMovements)
          .insert(
            CashMovementsCompanion.insert(
              id: 'cm1',
              sessionId: 'cs1',
              type: 'cash_out',
              reason: 'expense',
              amount: '1500',
              createdAt: DateTime.utc(2026, 11, 10, 9),
              syncStatus: 'pending',
            ),
          );

      await db
          .into(db.cashCountLines)
          .insert(
            CashCountLinesCompanion.insert(
              sessionId: 'cs1',
              operation: 'opening',
              denominationType: 'bill',
              denomination: 10000,
              quantity: 1,
            ),
          );

      await LocalDataResetService(db).wipeBusinessData();

      expect(await db.select(db.cashCountLines).get(), isEmpty);
      expect(await db.select(db.cashMovements).get(), isEmpty);
      expect(await db.select(db.cashSessions).get(), isEmpty);
    });

    test(
      'a new cash session defaults to pending and not recalculated',
      () async {
        await db
            .into(db.cashSessions)
            .insert(
              CashSessionsCompanion.insert(
                id: 'cs1',
                deviceId: 'device-1',
                status: 'open',
                openingAmount: '10000',
                openedAt: DateTime.utc(2026, 11, 10, 8),
              ),
            );

        final session = await db.select(db.cashSessions).getSingle();
        expect(session.syncStatus, 'pending');
        expect(session.serverRecalculated, isFalse);
        expect(session.closedAt, isNull);
        expect(session.countedAmount, isNull);
      },
    );

    test('pull stores cash split and session of a mixed sale', () async {
      final remote = _MockRemote();
      final pull = PullService(
        remoteDataSource: remote,
        db: db,
        queueRepository: SyncQueueRepository(db: db),
      );
      const changes = SyncChangesDto(
        products: [],
        sales: [
          SaleDto(
            id: 'sale-mixed',
            storeId: 'store-1',
            receiptNumber: 12,
            totalAmount: '5000.00',
            vatAmount: '0.00',
            paymentMethod: 'mixed',
            cashAmount: '3000.00',
            mobileMoneyAmount: '2000.00',
            cashSessionId: 'cs-server',
            createdAt: _now,
            syncedAt: _now,
            items: [],
          ),
        ],
        returns: [
          SaleReturnDto(
            id: 'ret-1',
            saleId: 'sale-mixed',
            returnNumber: 3,
            reason: 'other',
            note: 'abîmé',
            refundMethod: 'cash',
            refundAmount: '1000.00',
            cashSessionId: 'cs-server',
            createdAt: _now,
            items: [],
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

      final sale = await db.select(db.sales).getSingle();
      expect(sale.paymentMethod, 'mixed');
      expect(sale.cashAmount, '3000.00');
      expect(sale.mobileMoneyAmount, '2000.00');
      expect(sale.cashSessionId, 'cs-server');
      final saleReturn = await db.select(db.saleReturns).getSingle();
      expect(saleReturn.cashSessionId, 'cs-server');
    });

    test('SaleReturnCreateDto sends cash_session_id', () {
      const dto = SaleReturnCreateDto(
        id: 'r1',
        saleId: 's1',
        reason: 'other',
        refundMethod: 'cash',
        refundAmount: '1000',
        cashSessionId: 'cs1',
        createdAt: _now,
        items: [],
      );
      expect(dto.toJson()['cash_session_id'], 'cs1');
      expect(
        SaleDto.fromJson(const {
          'id': 's1',
          'store_id': 'st',
          'total_amount': '1000.00',
          'vat_amount': '0',
          'payment_method': 'cash',
          'cash_session_id': 'cs1',
          'created_at': _now,
          'synced_at': _now,
          'items': <Object>[],
        }).cashSessionId,
        'cs1',
      );
    });
  });
}
