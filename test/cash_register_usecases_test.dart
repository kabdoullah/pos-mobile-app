import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/storage/device_id_storage.dart';
import 'package:mobile/core/sync/sync_queue_repository.dart';
import 'package:mobile/database/app_database.dart' hide CashMovement;
import 'package:mobile/features/cash_register/data/repositories/cash_register_repository_impl.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_movement.dart';
import 'package:mobile/features/cash_register/domain/repositories/cash_register_repository.dart';
import 'package:mobile/features/cash_register/domain/usecases/close_cash_session_usecase.dart';
import 'package:mobile/features/cash_register/domain/usecases/open_cash_session_usecase.dart';
import 'package:mobile/features/cash_register/domain/usecases/record_cash_movement_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/features/cash_register/data/datasources/cash_register_remote_datasource.dart';

class _MockDeviceIdStorage extends Mock implements DeviceIdStorage {}

Matcher _refused(String code) =>
    throwsA(isA<CashRegisterException>().having((e) => e.code, 'code', code));

class _MockCashRemote extends Mock implements CashRegisterRemoteDataSource {}

void main() {
  late AppDatabase db;
  late CashRegisterRepositoryImpl repository;
  late OpenCashSessionUseCase open;
  late RecordCashMovementUseCase record;
  late CloseCashSessionUseCase close;

  Decimal d(String v) => Decimal.parse(v);

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    final deviceId = _MockDeviceIdStorage();
    when(deviceId.getOrCreate).thenAnswer((_) async => 'device-1');
    repository = CashRegisterRepositoryImpl(
      db: db,
      syncQueue: SyncQueueRepository(db: db),
      deviceIdStorage: deviceId,
      remote: _MockCashRemote(),
    );
    open = OpenCashSessionUseCase(repository: repository);
    record = RecordCashMovementUseCase(repository: repository);
    close = CloseCashSessionUseCase(repository: repository);
  });

  tearDown(() => db.close());

  Future<int> movementCount() async =>
      (await db.select(db.cashMovements).get()).length;

  group('ouverture', () {
    test('second open on device refused', () async {
      await open(openingAmount: d('25000'));

      await expectLater(
        open(openingAmount: d('1000')),
        _refused(CashRegisterException.sessionAlreadyOpen),
      );
      expect(await db.select(db.cashSessions).get(), hasLength(1));
    });

    test('negative opening amount refused, zero allowed', () async {
      await expectLater(
        open(openingAmount: d('-1')),
        _refused(CashRegisterException.invalidAmount),
      );
      final session = await open(openingAmount: Decimal.zero, note: '  ');
      expect(session.openingAmount, Decimal.zero);
      expect(session.openingNote, isNull);
    });
  });

  group('mouvements', () {
    test('refused without an open session', () async {
      await expectLater(
        record(
          type: CashMovementType.cashIn,
          reason: CashMovementReason.topUp,
          amount: d('100'),
        ),
        _refused(CashRegisterException.noOpenSession),
      );
    });

    test('zero or negative amount refused', () async {
      await open(openingAmount: d('1000'));
      for (final amount in ['0', '-5']) {
        await expectLater(
          record(
            type: CashMovementType.cashIn,
            reason: CashMovementReason.topUp,
            amount: d(amount),
          ),
          _refused(CashRegisterException.invalidAmount),
        );
      }
    });

    test('reason must match the type', () async {
      await open(openingAmount: d('1000'));
      await expectLater(
        record(
          type: CashMovementType.cashIn,
          reason: CashMovementReason.expense,
          amount: d('100'),
        ),
        _refused(CashRegisterException.reasonTypeMismatch),
      );
    });

    test('other reason requires a note', () async {
      await open(openingAmount: d('1000'));
      await expectLater(
        record(
          type: CashMovementType.cashOut,
          reason: CashMovementReason.other,
          amount: d('100'),
          note: '   ',
        ),
        _refused(CashRegisterException.noteRequired),
      );
      final movement = await record(
        type: CashMovementType.cashOut,
        reason: CashMovementReason.other,
        amount: d('100'),
        note: ' Pourboire livreur ',
      );
      expect(movement.note, 'Pourboire livreur');
    });

    test('cash_out above balance refused, equal allowed', () async {
      await open(openingAmount: d('5000'));
      await record(
        type: CashMovementType.cashIn,
        reason: CashMovementReason.float,
        amount: d('1500'),
      );

      await expectLater(
        record(
          type: CashMovementType.cashOut,
          reason: CashMovementReason.withdrawal,
          amount: d('6500.01'),
        ),
        _refused(CashRegisterException.insufficientCash),
      );
      expect(await movementCount(), 1);

      await record(
        type: CashMovementType.cashOut,
        reason: CashMovementReason.withdrawal,
        amount: d('6500'),
      );
      expect(await movementCount(), 2);
      final session = await repository.getActiveSession();
      expect(
        (await repository.watchSummary(session!.id).first).expectedAmount,
        Decimal.zero,
      );
    });
  });

  test('notes longer than 500 characters are refused', () async {
    final tooLong = 'a' * 501;
    await expectLater(
      open(openingAmount: d('1000'), note: tooLong),
      _refused(CashRegisterException.noteTooLong),
    );
    await open(openingAmount: d('1000'), note: 'a' * 500);
    await expectLater(
      record(
        type: CashMovementType.cashIn,
        reason: CashMovementReason.topUp,
        amount: d('100'),
        note: tooLong,
      ),
      _refused(CashRegisterException.noteTooLong),
    );
    await expectLater(
      close(countedAmount: d('0'), note: tooLong),
      _refused(CashRegisterException.noteTooLong),
    );
    expect(await movementCount(), 0);
    expect(await repository.getActiveSession(), isNotNull);
  });

  group('clôture', () {
    test('refused without an open session', () async {
      await expectLater(
        close(countedAmount: d('0')),
        _refused(CashRegisterException.noOpenSession),
      );
    });

    test('negative counted amount refused', () async {
      await open(openingAmount: d('1000'));
      await expectLater(
        close(countedAmount: d('-1')),
        _refused(CashRegisterException.invalidAmount),
      );
    });

    test('close with non-zero gap requires note', () async {
      await open(openingAmount: d('25000'));

      await expectLater(
        close(countedAmount: d('24500'), note: ' '),
        _refused(CashRegisterException.noteRequired),
      );
      expect(await repository.getActiveSession(), isNotNull);

      final closed = await close(countedAmount: d('24500'), note: 'Manque 500');
      expect(closed.discrepancyAmount, d('-500'));
      expect(closed.clientExpectedAmount, d('25000'));
      expect(closed.closingNote, 'Manque 500');
      expect(await repository.getActiveSession(), isNull);
    });

    test('close without gap needs no note', () async {
      await open(openingAmount: d('25000'));
      final closed = await close(countedAmount: d('25000.00'));
      expect(closed.discrepancyAmount, Decimal.zero);
      expect(closed.closingNote, isNull);
      expect(closed.closedAt, isNotNull);
    });
  });
}
