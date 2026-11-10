import 'package:decimal/decimal.dart';

import '../entities/cash_movement.dart';
import '../entities/cash_session.dart';
import '../entities/cash_session_detail.dart';
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

  /// Commentaire plus long que [maxNoteLength] caractères.
  static const noteTooLong = 'note_too_long';

  /// Longueur maximale d'un commentaire (limite du serveur).
  static const maxNoteLength = 500;

  /// Sortie supérieure au solde théorique du tiroir.
  static const insufficientCash = 'insufficient_cash';

  /// Motif incompatible avec le sens du mouvement.
  static const reasonTypeMismatch = 'reason_type_mismatch';

  /// Clôture refusée par le serveur : son solde recalculé diffère de celui
  /// de l'appareil et aucun commentaire n'a été envoyé. Porté par
  /// `CashSession.rejectionCode` ; la session reste ouverte côté serveur et
  /// la clôture se renvoie avec un commentaire (`resubmitCloseWithNote`).
  /// Même valeur que `cashClosingNoteRequiredCode` (core/sync).
  static const closingNoteRequired = 'closing_note_required';

  /// Mouvement ou clôture d'une session dont l'ouverture a été refusée par
  /// le serveur. Même valeur que `cashSessionOpenRejectedCode` (core/sync).
  static const sessionOpenRejected = 'session_open_rejected';

  /// La clôture ne peut pas être renvoyée : la session n'est pas clôturée ou
  /// son refus n'est pas [closingNoteRequired].
  static const closeNotResubmittable = 'close_not_resubmittable';

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

  /// Vrai si une opération de caisse (ouverture, mouvement ou clôture) attend
  /// encore d'être envoyée au serveur : entrée de file `pending`, `syncing`
  /// ou `failed`. Une déconnexion suivie d'un changement de compte l'effacerait.
  Future<bool> hasPendingCashOperations();

  /// Vrai si une clôture refusée faute de commentaire
  /// ([CashRegisterException.closingNoteRequired]) attend d'être renvoyée :
  /// la session reste ouverte côté serveur.
  Future<bool> hasCloseAwaitingNote();

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
  /// Lève [CashRegisterException] : `no_open_session` si la session n'est pas
  /// ouverte, `insufficient_cash` pour une sortie supérieure au solde relu
  /// dans la transaction.
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
  /// Lève [CashRegisterException] : `no_open_session` si la session est
  /// inconnue, `note_required` si l'écart avec le solde calculé dans la
  /// transaction n'est pas nul et le commentaire vide (rien n'est écrit).
  Future<CashSession> closeSession({
    required String sessionId,
    required Decimal countedAmount,
    String? note,
  });

  /// Observe toutes les sessions de l'appareil, de la plus récente à la plus
  /// ancienne.
  Stream<List<CashSession>> watchLocalHistory();

  /// Renvoie au serveur une clôture refusée faute de commentaire
  /// ([CashRegisterException.closingNoteRequired]), avec [note]. Le montant
  /// compté, le solde affiché et la date de clôture d'origine sont renvoyés à
  /// l'identique ; la session repasse en attente de synchro.
  ///
  /// Lève [CashRegisterException] : `close_not_resubmittable` si la session
  /// n'est pas clôturée avec ce refus, `note_required` si [note] est vide,
  /// `note_too_long` au-delà de 500 caractères.
  Future<void> resubmitCloseWithNote(String sessionId, String note);

  /// Reporte sur la session locale le résultat de la clôture serveur :
  /// solde théorique figé, écart et recalcul serveur. Le montant compté, le
  /// commentaire et la date de clôture locaux ne changent pas. Sans effet si
  /// la session n'existe pas sur l'appareil (rien n'est inséré).
  Future<void> applyServerClosure(String sessionId, CashSessionDetail detail);

  /// Historique distant des sessions de la boutique, tous appareils
  /// confondus. Lecture en ligne : rien n'est écrit sur l'appareil.
  ///
  /// Lève une `NetworkException` si le serveur est injoignable ou refuse.
  Future<CashSessionPage> fetchRemoteHistory({String? cursor});

  /// Détail distant d'une session. Lecture en ligne : rien n'est écrit sur
  /// l'appareil.
  ///
  /// Lève une `NetworkException` si le serveur est injoignable ou refuse.
  Future<CashSessionDetail> fetchRemoteDetail(String id);
}
