import 'package:decimal/decimal.dart';

import '../entities/cash_movement.dart';
import '../entities/cash_session.dart';
import '../entities/cash_summary.dart';

/// Refus d'une opération de caisse, identifié par un [code] stable.
class CashRegisterException implements Exception {
  /// Crée une exception avec son [code].
  const CashRegisterException(this.code);

  /// Une session est déjà ouverte sur l'appareil.
  static const sessionAlreadyOpen = 'session_already_open';

  /// Aucune session ouverte sur l'appareil.
  static const noOpenSession = 'no_open_session';

  /// Montant négatif (ou nul pour un mouvement).
  static const invalidAmount = 'invalid_amount';

  /// Commentaire obligatoire manquant.
  static const noteRequired = 'note_required';

  /// Sortie supérieure au solde théorique du tiroir.
  static const insufficientCash = 'insufficient_cash';

  /// Motif incompatible avec le sens du mouvement.
  static const reasonTypeMismatch = 'reason_type_mismatch';

  /// Code du refus.
  final String code;

  @override
  String toString() => 'CashRegisterException: $code';
}

/// Sessions de caisse de l'appareil (local d'abord, synchronisées ensuite).
abstract class CashRegisterRepository {
  /// Observe la session ouverte sur l'appareil, null si aucune.
  Stream<CashSession?> watchActiveSession();

  /// La session ouverte sur l'appareil, null si aucune.
  Future<CashSession?> getActiveSession();

  /// Observe le récapitulatif du tiroir d'une session — réémet à chaque
  /// vente, retour ou mouvement.
  Stream<CashSummary> watchSummary(String sessionId);

  /// Observe les mouvements d'une session, du plus récent au plus ancien.
  Stream<List<CashMovement>> watchMovements(String sessionId);

  /// Ouvre une session avec son fond de caisse et la met en file de synchro,
  /// dans une seule transaction.
  ///
  /// Lève [CashRegisterException] (`session_already_open`) si une session est
  /// déjà ouverte.
  Future<CashSession> openSession({
    required Decimal openingAmount,
    String? note,
  });

  /// Enregistre une entrée ou une sortie d'espèces et la met en file de
  /// synchro, dans une seule transaction.
  ///
  /// Lève [CashRegisterException] (`no_open_session`) si la session n'est pas
  /// ouverte.
  Future<CashMovement> recordMovement({
    required String sessionId,
    required CashMovementType type,
    required CashMovementReason reason,
    required Decimal amount,
    String? note,
  });

  /// Clôture la session : fige le solde théorique local, l'écart et la date
  /// de clôture, puis met la clôture en file de synchro, dans une seule
  /// transaction. Une session déjà clôturée est renvoyée telle quelle.
  ///
  /// Lève [CashRegisterException] (`no_open_session`) si la session est
  /// inconnue.
  Future<CashSession> closeSession({
    required String sessionId,
    required Decimal countedAmount,
    String? note,
  });

  /// Observe toutes les sessions de l'appareil, de la plus récente à la plus
  /// ancienne.
  Stream<List<CashSession>> watchLocalHistory();
}
