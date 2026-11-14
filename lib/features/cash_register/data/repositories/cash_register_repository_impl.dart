import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/storage/device_id_storage.dart';
import '../../../../core/sync/cash_sync_closure.dart';
import '../../../../core/sync/sync_queue_repository.dart';
import '../../../../database/app_database.dart' as drift_db;
import '../../domain/cash_balance_calculator.dart';
import '../../domain/entities/cash_count.dart';
import '../../domain/entities/cash_labels.dart';
import '../../domain/entities/cash_movement.dart';
import '../../domain/entities/cash_session.dart';
import '../../domain/entities/cash_session_detail.dart';
import '../../domain/entities/cash_summary.dart';
import '../../domain/repositories/cash_register_repository.dart';
import '../../domain/usecases/open_cash_session_usecase.dart';
import '../../../../core/sync/cash_sync_remote_datasource.dart';
import '../models/cash_mappers.dart';

/// Implémentation drift de [CashRegisterRepository].
///
/// Local d'abord : chaque écriture (ligne métier + entrée de file de synchro)
/// se fait dans une seule transaction. Les horodatages sont générés une fois,
/// en UTC à la seconde (précision de stockage de drift), pour que la ligne
/// drift et le payload mis en file portent exactement la même valeur.
class CashRegisterRepositoryImpl implements CashRegisterRepository {
  /// Crée un CashRegisterRepositoryImpl.
  CashRegisterRepositoryImpl({
    required this.db,
    required this.syncQueue,
    required this.deviceIdStorage,
    required this.remote,
    this.calculator = const CashBalanceCalculator(),
  });

  /// Base drift locale.
  final drift_db.AppDatabase db;

  /// File de synchro.
  final SyncQueueRepository syncQueue;

  /// Identifiant de l'appareil, envoyé à l'ouverture.
  final DeviceIdStorage deviceIdStorage;

  /// API des sessions de caisse, pour les lectures en ligne.
  final CashRegisterRemoteDataSource remote;

  /// Calcul du solde théorique (mêmes règles que le serveur).
  final CashBalanceCalculator calculator;

  static const _uuid = Uuid();

  /// Maintenant, en UTC tronqué à la seconde.
  static DateTime _now() {
    final now = DateTime.now().toUtc();
    return now.subtract(
      Duration(milliseconds: now.millisecond, microseconds: now.microsecond),
    );
  }

  drift.SimpleSelectStatement<drift_db.$CashSessionsTable, drift_db.CashSession>
  _activeSessionQuery() => db.select(db.cashSessions)
    ..where(
      (s) => s.status.equals(cashSessionStatusToString(CashSessionStatus.open)),
    )
    ..orderBy([(s) => drift.OrderingTerm.desc(s.openedAt)])
    ..limit(1);

  @override
  Stream<CashSession?> watchActiveSession() =>
      _activeSessionQuery().watchSingleOrNull().map((row) => row?.toDomain());

  @override
  Future<CashSession?> getActiveSession() async =>
      (await _activeSessionQuery().getSingleOrNull())?.toDomain();

  @override
  Future<bool> hasPendingCashOperations() async {
    final query = db.selectOnly(db.syncQueue)
      ..addColumns([db.syncQueue.id])
      ..where(
        db.syncQueue.entityType.isIn(const [
              'cash_session_open',
              'cash_movement',
              'cash_session_close',
            ]) &
            db.syncQueue.status.isIn(const ['pending', 'syncing', 'failed']),
      )
      ..limit(1);
    return (await query.get()).isNotEmpty;
  }

  @override
  Future<bool> hasCloseAwaitingNote() async {
    final query = db.selectOnly(db.cashSessions)
      ..addColumns([db.cashSessions.id])
      ..where(
        db.cashSessions.status.equals(
              cashSessionStatusToString(CashSessionStatus.closed),
            ) &
            db.cashSessions.rejectionCode.equals(
              CashRegisterException.closingNoteRequired,
            ),
      )
      ..limit(1);
    return (await query.get()).isNotEmpty;
  }

  @override
  Stream<CashSummary> watchSummary(String sessionId) {
    // Requête témoin : réémet dès qu'une des quatre tables change, puis le
    // récapitulatif est recalculé en entier.
    return db
        .customSelect(
          'SELECT 1',
          readsFrom: {
            db.cashSessions,
            db.cashMovements,
            db.sales,
            db.saleReturns,
          },
        )
        .watch()
        .asyncMap((_) => _computeSummary(sessionId));
  }

  Future<CashSummary> _computeSummary(String sessionId) async {
    final session = await (db.select(
      db.cashSessions,
    )..where((s) => s.id.equals(sessionId))).getSingleOrNull();
    if (session == null) {
      throw StateError('Session de caisse inconnue : $sessionId');
    }

    final sales = await (db.select(
      db.sales,
    )..where((s) => s.cashSessionId.equals(sessionId))).get();

    // Un mouvement refusé par le serveur n'existe pas côté serveur : il n'a
    // jamais touché le tiroir aux yeux du serveur, dont le solde fait foi à
    // la clôture. Il n'entre donc ni dans les entrées ni dans les sorties.
    final movements =
        await (db.select(db.cashMovements)
              ..where((m) => m.sessionId.equals(sessionId))
              ..where((m) => m.syncStatus.equals('rejected').not()))
            .get();

    final returns = await (db.select(
      db.saleReturns,
    )..where((r) => r.cashSessionId.equals(sessionId))).get();

    return calculator.summarize(
      openingAmount: Decimal.parse(session.openingAmount),
      sales: [
        for (final sale in sales)
          CashSaleLine(
            paymentMethod: salePaymentMethodFromStored(sale.paymentMethod),
            totalAmount: Decimal.parse(sale.totalAmount),
            cashAmount: sale.cashAmount == null
                ? null
                : Decimal.parse(sale.cashAmount!),
          ),
      ],
      movements: [for (final m in movements) m.toDomain()],
      refunds: [
        for (final r in returns)
          CashRefundLine(
            refundMethod: refundMethodFromStored(r.refundMethod),
            refundAmount: Decimal.parse(r.refundAmount),
            rejected: r.syncStatus == 'rejected',
          ),
      ],
    );
  }

  @override
  Stream<List<CashMovement>> watchMovements(String sessionId) {
    return (db.select(db.cashMovements)
          ..where((m) => m.sessionId.equals(sessionId))
          ..orderBy([
            (m) => drift.OrderingTerm.desc(m.createdAt),
            (m) => drift.OrderingTerm.desc(m.rowId),
          ]))
        .watch()
        .map((rows) => [for (final row in rows) row.toDomain()]);
  }

  @override
  Future<CashSession> openSession({
    required Decimal openingAmount,
    CashCount? openingCount,
    String? note,
  }) async {
    final id = _uuid.v4();
    final deviceId = await deviceIdStorage.getOrCreate();
    final openedAt = _now();

    await db.transaction(() async {
      // Garde contre un double appui : une seule session ouverte par appareil.
      if (await _activeSessionQuery().getSingleOrNull() != null) {
        throw const CashRegisterException(
          CashRegisterException.sessionAlreadyOpen,
        );
      }
      await db
          .into(db.cashSessions)
          .insert(
            drift_db.CashSessionsCompanion.insert(
              id: id,
              deviceId: deviceId,
              status: cashSessionStatusToString(CashSessionStatus.open),
              openingAmount: openingAmount.toString(),
              openingNote: drift.Value(note),
              openedAt: openedAt,
              syncStatus: const drift.Value('pending'),
            ),
          );
      if (openingCount != null) {
        await _insertCount(id, CashCountOperation.opening, openingCount);
      }
      await syncQueue.enqueueCashSessionOpen(
        sessionId: id,
        payload: cashSessionOpenPayload(
          id: id,
          deviceId: deviceId,
          openingAmount: openingAmount,
          openingNote: note,
          openedAt: openedAt,
          openingCount: openingCount,
        ),
      );
    });

    return CashSession(
      id: id,
      deviceId: deviceId,
      status: CashSessionStatus.open,
      openingAmount: openingAmount,
      openedAt: openedAt,
      syncStatus: CashSyncStatus.pending,
      serverRecalculated: false,
      openingNote: note,
    );
  }

  @override
  Future<CashMovement> recordMovement({
    required String sessionId,
    required CashMovementType type,
    required CashMovementReason reason,
    required Decimal amount,
    String? note,
  }) async {
    final movement = CashMovement(
      id: _uuid.v4(),
      sessionId: sessionId,
      type: type,
      reason: reason,
      amount: amount,
      createdAt: _now(),
      syncStatus: CashSyncStatus.pending,
      note: note,
    );

    await db.transaction(() async {
      final session = await _sessionRow(sessionId);
      if (session == null ||
          session.status != cashSessionStatusToString(CashSessionStatus.open)) {
        throw const CashRegisterException(CashRegisterException.noOpenSession);
      }
      // Solde relu sous transaction : une écriture survenue depuis la
      // vérification du cas d'usage (synchro en arrière-plan) est prise en
      // compte, et le serveur refuserait définitivement la sortie.
      if (type == CashMovementType.cashOut &&
          amount > (await _computeSummary(sessionId)).expectedAmount) {
        throw const CashRegisterException(
          CashRegisterException.insufficientCash,
        );
      }
      await db
          .into(db.cashMovements)
          .insert(
            drift_db.CashMovementsCompanion.insert(
              id: movement.id,
              sessionId: sessionId,
              type: cashMovementTypeToApi(type),
              reason: cashMovementReasonToApi(reason),
              amount: amount.toString(),
              note: drift.Value(note),
              createdAt: movement.createdAt,
              // Pas de valeur par défaut sur cette colonne : toujours explicite.
              syncStatus: 'pending',
            ),
          );
      await syncQueue.enqueueCashMovement(
        movementId: movement.id,
        payload: cashMovementPayload(movement),
      );
    });

    return movement;
  }

  @override
  Future<CashSession> closeSession({
    required String sessionId,
    required Decimal countedAmount,
    CashCount? closingCount,
    String? note,
  }) async {
    await db.transaction(() async {
      final session = await _sessionRow(sessionId);
      if (session == null) {
        throw const CashRegisterException(CashRegisterException.noOpenSession);
      }
      // Déjà clôturée : rien n'est réécrit ni remis en file (le payload
      // d'origine, avec son closed_at, reste le seul envoyé).
      if (session.status ==
          cashSessionStatusToString(CashSessionStatus.closed)) {
        return;
      }

      final summary = await _computeSummary(sessionId);
      final expected = summary.expectedAmount;
      // Revérifié sur le solde figé ici : un écart sans commentaire serait
      // refusé définitivement par le serveur, et le payload de clôture ne
      // change plus une fois en file. La transaction est annulée.
      if (countedAmount != expected && (note == null || note.trim().isEmpty)) {
        throw const CashRegisterException(CashRegisterException.noteRequired);
      }
      final closedAt = _now();

      await (db.update(
        db.cashSessions,
      )..where((s) => s.id.equals(sessionId))).write(
        drift_db.CashSessionsCompanion(
          status: drift.Value(
            cashSessionStatusToString(CashSessionStatus.closed),
          ),
          countedAmount: drift.Value(countedAmount.toString()),
          clientExpectedAmount: drift.Value(expected.toString()),
          discrepancyAmount: drift.Value((countedAmount - expected).toString()),
          closingNote: drift.Value(note),
          closedAt: drift.Value(closedAt),
          // En attente jusqu'à la réponse du serveur à la clôture, même si
          // l'ouverture est déjà synchronisée.
          syncStatus: const drift.Value('pending'),
          rejectionCode: const drift.Value(null),
        ),
      );
      if (closingCount != null) {
        await _insertCount(sessionId, CashCountOperation.closing, closingCount);
      }
      await syncQueue.enqueueCashSessionClose(
        sessionId: sessionId,
        payload: cashSessionClosePayload(
          sessionId: sessionId,
          countedAmount: countedAmount,
          clientExpectedAmount: expected,
          closingNote: note,
          closedAt: closedAt,
          closingCount: closingCount,
        ),
      );
    });

    return (await _sessionRow(sessionId))!.toDomain();
  }

  @override
  Stream<CashCount?> watchCount(
    String sessionId,
    CashCountOperation operation,
  ) => _countQuery(sessionId, operation).watch().map(cashCountFromRows);

  @override
  Future<CashCount?> lastClosingCount() async {
    final last =
        await (db.select(db.cashSessions)
              ..where((s) => s.closedAt.isNotNull())
              ..orderBy([(s) => drift.OrderingTerm.desc(s.closedAt)])
              ..limit(1))
            .getSingleOrNull();
    if (last == null) return null;
    return cashCountFromRows(
      await _countQuery(last.id, CashCountOperation.closing).get(),
    );
  }

  drift.SimpleSelectStatement<
    drift_db.$CashCountLinesTable,
    drift_db.CashCountLine
  >
  _countQuery(String sessionId, CashCountOperation operation) =>
      db.select(db.cashCountLines)..where(
        (l) =>
            l.sessionId.equals(sessionId) &
            l.operation.equals(cashCountOperationToString(operation)),
      );

  /// Écrit les lignes d'un comptage ; à appeler dans la transaction de
  /// l'ouverture ou de la clôture.
  Future<void> _insertCount(
    String sessionId,
    CashCountOperation operation,
    CashCount count,
  ) => db.batch(
    (b) => b.insertAll(
      db.cashCountLines,
      cashCountCompanions(sessionId, operation, count),
    ),
  );

  @override
  Stream<List<CashSession>> watchLocalHistory() {
    return (db.select(db.cashSessions)
          ..orderBy([(s) => drift.OrderingTerm.desc(s.openedAt)]))
        .watch()
        .map((rows) => [for (final row in rows) row.toDomain()]);
  }

  @override
  Future<void> applyServerClosure(String sessionId, CashSessionDetail detail) {
    final discrepancy = detail.session.discrepancyAmount;
    return applyCashServerClosure(
      db,
      sessionId,
      // Session clôturée : même montant figé dans la session et le résumé.
      expected: (detail.session.expectedAmount ?? detail.summary.expectedAmount)
          .toString(),
      discrepancy: discrepancy?.toString(),
      serverRecalculated: detail.summary.serverRecalculated,
    );
  }

  @override
  Future<void> resubmitCloseWithNote(String sessionId, String note) async {
    final cleanNote = cleanCashNote(note);
    if (cleanNote == null) {
      throw const CashRegisterException(CashRegisterException.noteRequired);
    }
    await db.transaction(() async {
      final session = await _sessionRow(sessionId);
      if (session == null ||
          session.status !=
              cashSessionStatusToString(CashSessionStatus.closed) ||
          session.rejectionCode != CashRegisterException.closingNoteRequired) {
        throw const CashRegisterException(
          CashRegisterException.closeNotResubmittable,
        );
      }
      // L'entrée refusée est remise en attente avec le même payload (montant
      // compté, solde affiché, closed_at) et le commentaire : une seule
      // entrée de clôture par session.
      final rejected =
          await (db.select(db.syncQueue)
                ..where((q) => q.entityType.equals('cash_session_close'))
                ..where((q) => q.entityId.equals(sessionId))
                ..where((q) => q.status.equals('rejected'))
                ..orderBy([(q) => drift.OrderingTerm.desc(q.id)])
                ..limit(1))
              .getSingleOrNull();
      if (rejected == null) {
        throw const CashRegisterException(
          CashRegisterException.closeNotResubmittable,
        );
      }
      final payload = Map<String, dynamic>.from(
        jsonDecode(rejected.payload) as Map<String, dynamic>,
      )..['closing_note'] = cleanNote;
      await (db.update(
        db.cashSessions,
      )..where((s) => s.id.equals(sessionId))).write(
        drift_db.CashSessionsCompanion(
          closingNote: drift.Value(cleanNote),
          syncStatus: const drift.Value('pending'),
          rejectionCode: const drift.Value(null),
        ),
      );
      await syncQueue.resetWithPayload(rejected.id, jsonEncode(payload));
    });
  }

  @override
  Future<CashSessionPage> fetchRemoteHistory({String? cursor}) async {
    try {
      return (await remote.listSessions(cursor: cursor)).toDomain();
    } on DioException catch (e) {
      throw parseException(e);
    }
  }

  @override
  Future<CashSessionDetail> fetchRemoteDetail(String id) async {
    try {
      return (await remote.getSession(id)).toDomain();
    } on DioException catch (e) {
      throw parseException(e);
    }
  }

  Future<drift_db.CashSession?> _sessionRow(String sessionId) => (db.select(
    db.cashSessions,
  )..where((s) => s.id.equals(sessionId))).getSingleOrNull();
}
