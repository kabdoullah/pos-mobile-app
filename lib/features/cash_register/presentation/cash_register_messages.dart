import '../../../core/network/error_mapper.dart';
import '../domain/repositories/cash_register_repository.dart';

/// Message en français pour un code de refus de caisse : codes de
/// [CashRegisterException] (appareil) ou codes de refus du serveur portés par
/// `CashSession.rejectionCode` / `CashMovement.rejectionCode`.
String cashRegisterMessage(String code) => switch (code) {
  CashRegisterException.sessionAlreadyOpen || 'CASH_SESSION_ALREADY_OPEN' =>
    'Une caisse est déjà ouverte sur cet appareil.',
  CashRegisterException.noOpenSession => 'Ouvrez la caisse avant de continuer.',
  CashRegisterException.invalidAmount => 'Saisissez un montant valide.',
  CashRegisterException.countMismatch =>
    'Le total ne correspond pas au comptage. Recomptez.',
  CashRegisterException.noteRequired => 'Ajoutez un commentaire.',
  CashRegisterException.noteTooLong =>
    'Commentaire trop long (${CashRegisterException.maxNoteLength} '
        'caractères au plus).',
  CashRegisterException.insufficientCash ||
  'INSUFFICIENT_CASH' => 'Montant supérieur aux espèces dans la caisse.',
  CashRegisterException.reasonTypeMismatch =>
    'Ce motif ne correspond pas au type de mouvement.',
  CashRegisterException.closingNoteRequired =>
    'Le solde recalculé diffère : ajoutez un commentaire pour clôturer.',
  CashRegisterException.sessionOpenRejected =>
    "L'ouverture de cette caisse a été refusée.",
  CashRegisterException.closeNotResubmittable =>
    'Cette clôture ne peut pas être renvoyée.',
  'CASH_SESSION_CLOSED' => 'Cette caisse est déjà clôturée.',
  'IDEMPOTENCY_CONFLICT' => 'Opération déjà enregistrée avec d’autres valeurs.',
  _ => 'Une erreur est survenue.',
};

/// Message en français pour une erreur d'opération de caisse : le code d'une
/// [CashRegisterException], sinon le message générique de [errorToFrench].
String cashRegisterErrorMessage(Object error) => error is CashRegisterException
    ? cashRegisterMessage(error.code)
    : errorToFrench(error);
