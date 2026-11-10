import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/connectivity_provider.dart';
import '../../../../core/sync/sync_orchestrator.dart';
import '../../domain/entities/cash_movement.dart';
import '../../domain/entities/cash_session.dart';
import '../../domain/entities/cash_summary.dart';
import '../../providers/cash_register_di_providers.dart';

part 'cash_register_providers.g.dart';

/// Observe la session de caisse ouverte sur l'appareil, null si aucune.
@riverpod
Stream<CashSession?> activeCashSession(Ref ref) =>
    ref.watch(cashRegisterRepositoryProvider).watchActiveSession();

/// Observe le récapitulatif du tiroir de la session [sessionId].
@riverpod
Stream<CashSummary> cashSummary(Ref ref, String sessionId) =>
    ref.watch(cashRegisterRepositoryProvider).watchSummary(sessionId);

/// Observe les mouvements de la session [sessionId], du plus récent au plus
/// ancien.
@riverpod
Stream<List<CashMovement>> cashMovements(Ref ref, String sessionId) =>
    ref.watch(cashRegisterRepositoryProvider).watchMovements(sessionId);

/// Écritures de caisse déclenchées depuis l'UI : ouverture, mouvement,
/// clôture et renvoi d'une clôture avec commentaire.
///
/// `keepAlive` : l'écriture ne doit pas être interrompue par un dispose
/// pendant l'await (voir `SaleSubmission`). Chaque méthode propage la
/// `CashRegisterException` du domaine pour que l'écran affiche le message,
/// puis lance une synchro si l'appareil est en ligne.
@Riverpod(keepAlive: true)
class CashRegisterController extends _$CashRegisterController {
  @override
  void build() {}

  /// Ouvre une session avec le fond de caisse [openingAmount].
  Future<CashSession> open({
    required Decimal openingAmount,
    String? note,
  }) async {
    final session = await ref.read(openCashSessionUseCaseProvider)(
      openingAmount: openingAmount,
      note: note,
    );
    _syncIfOnline();
    return session;
  }

  /// Enregistre une entrée ou une sortie d'espèces dans la session ouverte.
  Future<CashMovement> recordMovement({
    required CashMovementType type,
    required CashMovementReason reason,
    required Decimal amount,
    String? note,
  }) async {
    final movement = await ref.read(recordCashMovementUseCaseProvider)(
      type: type,
      reason: reason,
      amount: amount,
      note: note,
    );
    _syncIfOnline();
    return movement;
  }

  /// Clôture la session ouverte avec le montant compté [countedAmount].
  Future<CashSession> close({
    required Decimal countedAmount,
    String? note,
  }) async {
    final session = await ref.read(closeCashSessionUseCaseProvider)(
      countedAmount: countedAmount,
      note: note,
    );
    _syncIfOnline();
    return session;
  }

  /// Renvoie une clôture refusée faute de commentaire, avec [note].
  Future<void> resubmitCloseWithNote(String sessionId, String note) async {
    await ref
        .read(cashRegisterRepositoryProvider)
        .resubmitCloseWithNote(sessionId, note);
    _syncIfOnline();
  }

  void _syncIfOnline() {
    if (ref.read(isOnlineProvider).value ?? false) {
      unawaited(ref.read(syncOrchestratorProvider.notifier).syncNow());
    }
  }
}
