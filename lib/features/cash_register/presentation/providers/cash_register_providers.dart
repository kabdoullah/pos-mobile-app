import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/connectivity_provider.dart';
import '../../../../core/sync/sync_orchestrator.dart';
import '../../domain/entities/cash_count.dart';
import '../../domain/entities/cash_movement.dart';
import '../../domain/entities/cash_session.dart';
import '../../domain/entities/cash_session_detail.dart';
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

/// Observe le comptage [operation] de la session [sessionId] enregistré sur
/// l'appareil, null sans billetterie.
@riverpod
Stream<CashCount?> localCashCount(
  Ref ref,
  String sessionId,
  CashCountOperation operation,
) => ref.watch(cashRegisterRepositoryProvider).watchCount(sessionId, operation);

/// Comptage de la dernière clôture de l'appareil (« Reprendre le comptage
/// d'hier soir »), null si elle n'a pas de billetterie.
@riverpod
Future<CashCount?> lastClosingCount(Ref ref) {
  // Relu quand l'historique local change (nouvelle clôture, restauration).
  ref.watch(localCashSessionHistoryProvider);
  return ref.read(cashRegisterRepositoryProvider).lastClosingCount();
}

/// Observe les sessions de l'appareil, de la plus récente à la plus ancienne.
@riverpod
Stream<List<CashSession>> localCashSessionHistory(Ref ref) =>
    ref.watch(cashRegisterRepositoryProvider).watchLocalHistory();

/// Session clôturée la plus récente de [history] ; `null` s'il n'y en a pas.
CashSession? lastClosedSession(List<CashSession>? history) {
  CashSession? last;
  for (final session in history ?? const <CashSession>[]) {
    final closedAt = session.closedAt;
    if (closedAt == null) continue;
    if (last == null || closedAt.isAfter(last.closedAt!)) last = session;
  }
  return last;
}

/// Observe la session [sessionId] enregistrée sur l'appareil, null si elle
/// n'y est pas (session d'un autre téléphone).
@riverpod
Stream<CashSession?> localCashSession(Ref ref, String sessionId) => ref
    .watch(cashRegisterRepositoryProvider)
    .watchLocalHistory()
    .map((sessions) {
      for (final session in sessions) {
        if (session.id == sessionId) return session;
      }
      return null;
    });

/// Détail de la session [sessionId] vu par le serveur (recalcul, impact après
/// clôture). Null hors ligne : l'écran affiche alors les chiffres locaux.
/// En ligne, une erreur réseau est propagée.
@riverpod
Future<CashSessionDetail?> remoteCashSessionDetail(
  Ref ref,
  String sessionId,
) async {
  final online = await ref.watch(isOnlineProvider.future);
  if (!online) return null;
  return ref.read(cashRegisterRepositoryProvider).fetchRemoteDetail(sessionId);
}

/// Historique distant des sessions de la boutique (tous les appareils),
/// paginé. Lecture en ligne uniquement.
@riverpod
class CashSessionHistory extends _$CashSessionHistory {
  String? _nextCursor;
  bool _hasMore = false;
  bool _loadingMore = false;
  bool _loadMoreFailed = false;

  /// Incrémenté à chaque (re)chargement : une page suivante arrivée après un
  /// [refresh] appartient à l'ancienne liste et est ignorée.
  int _generation = 0;

  @override
  Future<List<CashSession>> build() async {
    _generation++;
    _loadingMore = false;
    _loadMoreFailed = false;
    final page = await ref
        .watch(cashRegisterRepositoryProvider)
        .fetchRemoteHistory();
    _nextCursor = page.nextCursor;
    _hasMore = page.hasMore;
    return page.items;
  }

  /// Des sessions plus anciennes restent à charger.
  bool get hasMore => _hasMore;

  /// Le chargement de la page suivante a échoué (la liste déjà chargée est
  /// conservée) ; [loadMore] le relance.
  bool get loadMoreFailed => _loadMoreFailed;

  /// Charge la page suivante ; sans effet pendant un chargement ou en fin
  /// d'historique.
  Future<void> loadMore() async {
    final current = state.value;
    if (!_hasMore || _loadingMore || current == null) return;
    final generation = _generation;
    _loadingMore = true;
    _loadMoreFailed = false;
    try {
      final page = await ref
          .read(cashRegisterRepositoryProvider)
          .fetchRemoteHistory(cursor: _nextCursor);
      if (generation != _generation) return;
      _nextCursor = page.nextCursor;
      _hasMore = page.hasMore;
      state = AsyncData([...current, ...page.items]);
    } catch (_) {
      if (generation != _generation) return;
      // On garde les sessions déjà affichées ; nouvelle liste pour notifier.
      _loadMoreFailed = true;
      state = AsyncData([...current]);
    } finally {
      if (generation == _generation) _loadingMore = false;
    }
  }

  /// Recharge l'historique depuis la première page.
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

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

  /// Ouvre une session avec le fond de caisse [openingAmount] et, en mode
  /// billetterie, son comptage [count].
  Future<CashSession> open({
    required Decimal openingAmount,
    CashCount? count,
    String? note,
  }) async {
    final session = await ref.read(openCashSessionUseCaseProvider)(
      openingAmount: openingAmount,
      count: count,
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

  /// Clôture la session ouverte avec le montant compté [countedAmount] et,
  /// en mode billetterie, son comptage [count].
  Future<CashSession> close({
    required Decimal countedAmount,
    CashCount? count,
    String? note,
  }) async {
    final session = await ref.read(closeCashSessionUseCaseProvider)(
      countedAmount: countedAmount,
      count: count,
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
