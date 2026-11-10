import 'package:decimal/decimal.dart';

import '../entities/cash_session.dart';
import '../repositories/cash_register_repository.dart';

/// Ouverture d'une session de caisse avec son fond de caisse.
class OpenCashSessionUseCase {
  /// Crée le cas d'usage.
  const OpenCashSessionUseCase({required this.repository});

  /// Repository des sessions de caisse.
  final CashRegisterRepository repository;

  /// Ouvre une session avec [openingAmount] (≥ 0) et un commentaire
  /// facultatif.
  ///
  /// Lève [CashRegisterException] : `invalid_amount` si le montant est
  /// négatif, `note_too_long` si le commentaire dépasse 500 caractères,
  /// `session_already_open` si l'appareil a déjà une session ouverte.
  Future<CashSession> call({
    required Decimal openingAmount,
    String? note,
  }) async {
    if (openingAmount < Decimal.zero) {
      throw const CashRegisterException(CashRegisterException.invalidAmount);
    }
    final cleanNote = cleanCashNote(note);
    if (await repository.getActiveSession() != null) {
      throw const CashRegisterException(
        CashRegisterException.sessionAlreadyOpen,
      );
    }
    return repository.openSession(
      openingAmount: openingAmount,
      note: cleanNote,
    );
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
