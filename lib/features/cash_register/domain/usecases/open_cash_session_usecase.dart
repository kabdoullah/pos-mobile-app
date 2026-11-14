import 'package:decimal/decimal.dart';

import '../entities/cash_count.dart';
import '../entities/cash_session.dart';
import '../repositories/cash_register_repository.dart';

/// Ouverture d'une session de caisse avec son fond de caisse.
class OpenCashSessionUseCase {
  /// Crée le cas d'usage.
  const OpenCashSessionUseCase({required this.repository});

  /// Repository des sessions de caisse.
  final CashRegisterRepository repository;

  /// Ouvre une session avec [openingAmount] (≥ 0), le comptage par coupure
  /// [count] en mode billetterie (null en mode « Total seulement ») et un
  /// commentaire facultatif.
  ///
  /// Lève [CashRegisterException] : `invalid_amount` si le montant est
  /// négatif, `count_mismatch` si le total du comptage n'est pas
  /// [openingAmount], `note_too_long` si le commentaire dépasse 500
  /// caractères, `session_already_open` si l'appareil a déjà une session
  /// ouverte.
  Future<CashSession> call({
    required Decimal openingAmount,
    CashCount? count,
    String? note,
  }) async {
    if (openingAmount < Decimal.zero) {
      throw const CashRegisterException(CashRegisterException.invalidAmount);
    }
    checkCountMatches(count, openingAmount);
    final cleanNote = cleanCashNote(note);
    if (await repository.getActiveSession() != null) {
      throw const CashRegisterException(
        CashRegisterException.sessionAlreadyOpen,
      );
    }
    return repository.openSession(
      openingAmount: openingAmount,
      openingCount: count,
      note: cleanNote,
    );
  }
}

/// Vérifie que le total de [count] est [amount] (même règle que le serveur).
///
/// Lève [CashRegisterException] (`count_mismatch`) sinon ; sans effet si
/// [count] est null (mode « Total seulement »).
void checkCountMatches(CashCount? count, Decimal amount) {
  if (count != null && count.total != amount) {
    throw const CashRegisterException(CashRegisterException.countMismatch);
  }
}

/// Commentaire sans espaces superflus, null s'il est vide.
///
/// Lève [CashRegisterException] (`note_too_long`) au-delà de
/// [CashRegisterException.maxNoteLength] caractères.
String? cleanCashNote(String? note) {
  final trimmed = note?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  if (trimmed.length > CashRegisterException.maxNoteLength) {
    throw const CashRegisterException(CashRegisterException.noteTooLong);
  }
  return trimmed;
}
