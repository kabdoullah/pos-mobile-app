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
  /// négatif, `session_already_open` si l'appareil a déjà une session ouverte.
  Future<CashSession> call({
    required Decimal openingAmount,
    String? note,
  }) async {
    if (openingAmount < Decimal.zero) {
      throw const CashRegisterException(CashRegisterException.invalidAmount);
    }
    if (await repository.getActiveSession() != null) {
      throw const CashRegisterException(
        CashRegisterException.sessionAlreadyOpen,
      );
    }
    return repository.openSession(
      openingAmount: openingAmount,
      note: cleanCashNote(note),
    );
  }
}

/// Commentaire sans espaces superflus, null s'il est vide.
String? cleanCashNote(String? note) {
  final trimmed = note?.trim();
  return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
}
