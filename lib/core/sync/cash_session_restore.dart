import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;

import '../../database/app_database.dart';
import '../network/api_models/cash_session_dto.dart';
import '../storage/device_id_storage.dart';
import 'cash_sync_remote_datasource.dart';

/// Restaure depuis le serveur les sessions de caisse de cet appareil que la
/// base locale ne connaît pas : la session ouverte (avec ses mouvements) et
/// les dernières sessions clôturées. Le comptage d'ouverture de la session
/// ouverte est restauré ; celui des sessions clôturées se lit en ligne
/// (détail de session).
///
/// `/sync/changes` ne transporte pas les sessions de caisse : après un
/// effacement local (changement de compte, réinstallation), l'appareil
/// croirait sa caisse fermée et perdrait « Dernière clôture ». Appelé lors
/// d'un pull complet, après l'envoi de la file.
///
/// N'écrase jamais une ligne locale (insert-or-ignore) et n'ajoute pas la
/// session ouverte du serveur si une session est déjà ouverte localement :
/// l'état de l'appareil, plus récent, l'emporte.
class CashSessionRestorer {
  /// Crée le restaurateur.
  CashSessionRestorer({
    required AppDatabase db,
    required CashRegisterRemoteDataSource remote,
    required DeviceIdStorage deviceIdStorage,
  }) : _db = db,
       _remote = remote,
       _deviceIdStorage = deviceIdStorage;

  final AppDatabase _db;
  final CashRegisterRemoteDataSource _remote;
  final DeviceIdStorage _deviceIdStorage;

  /// Nombre de sessions récentes relues (la dernière clôture suffit à
  /// l'accueil ; quelques-unes de plus pour l'historique hors ligne).
  static const recentLimit = 5;

  /// Restaure la session ouverte et les dernières clôtures de l'appareil.
  /// Les erreurs réseau remontent (l'appelant réessaie plus tard).
  Future<void> restore() async {
    final deviceId = await _deviceIdStorage.getOrCreate();
    CashSessionDetailDto? active;
    try {
      active = await _remote.getActiveSession(deviceId);
    } on DioException catch (e) {
      // 404 : aucune session ouverte sur le serveur pour cet appareil.
      if (e.response?.statusCode != 404) rethrow;
    }
    final recent = await _remote.listSessions(
      limit: recentLimit,
      deviceId: deviceId,
    );

    await _db.transaction(() async {
      if (active != null && !await _hasLocalOpenSession()) {
        await _insertSession(
          active.session,
          serverRecalculated: active.summary.serverRecalculated,
        );
        for (final movement in active.movements) {
          await _insertMovement(movement);
        }
        final openingCount = active.openingCount;
        if (openingCount != null) {
          await _insertCount(active.session.id, 'opening', openingCount);
        }
      }
      for (final session in recent.items) {
        // La session ouverte vient de `/active`, avec ses mouvements.
        if (session.status == 'closed') await _insertSession(session);
      }
    });
  }

  Future<bool> _hasLocalOpenSession() async {
    final open =
        await (_db.select(_db.cashSessions)
              ..where((s) => s.status.equals('open'))
              ..limit(1))
            .getSingleOrNull();
    return open != null;
  }

  Future<void> _insertSession(
    CashSessionDto dto, {
    bool serverRecalculated = false,
  }) {
    final closedAt = dto.closedAt;
    return _db
        .into(_db.cashSessions)
        .insert(
          CashSessionsCompanion.insert(
            id: dto.id,
            deviceId: dto.deviceId,
            status: dto.status,
            openingAmount: _amount(dto.openingAmount),
            openingNote: drift.Value(dto.openingNote),
            openedAt: DateTime.parse(dto.openedAt).toUtc(),
            expectedAmount: drift.Value(_amountOrNull(dto.expectedAmount)),
            clientExpectedAmount: drift.Value(
              _amountOrNull(dto.clientExpectedAmount),
            ),
            countedAmount: drift.Value(_amountOrNull(dto.countedAmount)),
            discrepancyAmount: drift.Value(
              _amountOrNull(dto.discrepancyAmount),
            ),
            closingNote: drift.Value(dto.closingNote),
            closedAt: drift.Value(
              closedAt == null ? null : DateTime.parse(closedAt).toUtc(),
            ),
            serverRecalculated: drift.Value(serverRecalculated),
            syncStatus: const drift.Value('synced'),
          ),
          mode: drift.InsertMode.insertOrIgnore,
        );
  }

  Future<void> _insertMovement(CashMovementDto dto) {
    return _db
        .into(_db.cashMovements)
        .insert(
          CashMovementsCompanion.insert(
            id: dto.id,
            sessionId: dto.sessionId,
            type: dto.type,
            reason: dto.reason,
            amount: _amount(dto.amount),
            note: drift.Value(dto.note),
            createdAt: DateTime.parse(dto.createdAt).toUtc(),
            syncStatus: 'synced',
          ),
          mode: drift.InsertMode.insertOrIgnore,
        );
  }

  Future<void> _insertCount(
    String sessionId,
    String operation,
    CashCountDto count,
  ) => _db.batch(
    (b) => b.insertAll(_db.cashCountLines, [
      for (final line in count.lines)
        CashCountLinesCompanion.insert(
          sessionId: sessionId,
          operation: operation,
          denominationType: line.denominationType,
          denomination: Decimal.parse(line.denomination).toBigInt().toInt(),
          quantity: line.quantity,
        ),
    ], mode: drift.InsertMode.insertOrIgnore),
  );

  /// Montant normalisé comme ceux écrits par l'appareil (« 25000.00 » →
  /// « 25000 »).
  static String _amount(String value) => Decimal.parse(value).toString();

  static String? _amountOrNull(String? value) =>
      value == null ? null : _amount(value);
}
