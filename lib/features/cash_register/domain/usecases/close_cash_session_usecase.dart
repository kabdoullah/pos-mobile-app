import 'package:decimal/decimal.dart';

import '../entities/cash_session.dart';
import '../repositories/cash_register_repository.dart';
import 'open_cash_session_usecase.dart';

/// Clôture de la session ouverte avec le montant compté dans le tiroir.
class CloseCashSessionUseCase {
  /// Crée le cas d'usage.
  const CloseCashSessionUseCase({required this.repository});

  /// Repository des sessions de caisse.
  final CashRegisterRepository repository;

  /// Clôture la session ouverte avec [countedAmount] (≥ 0).
  ///
  /// Le solde théorique local au moment de la clôture (éventuellement
  /// négatif) devient `client_expected_amount` ; la date de clôture est
  /// générée une seule fois et persistée par le repository, pour être
  /// renvoyée à l'identique à chaque retry.
  ///
  /// Lève [CashRegisterException] : `no_open_session` sans session ouverte,
  /// `invalid_amount` si le montant compté est négatif, `note_required` si
  /// l'écart n'est pas nul et le commentaire vide.
  Future<CashSession> call({
    required Decimal countedAmount,
    String? note,
  }) async {
    final session = await repository.getActiveSession();
    if (session == null) {
      throw const CashRegisterException(CashRegisterException.noOpenSession);
    }
    if (countedAmount < Decimal.zero) {
      throw const CashRegisterException(CashRegisterException.invalidAmount);
    }
    final summary = await repository.watchSummary(session.id).first;
    final cleanNote = cleanCashNote(note);
    if (countedAmount != summary.expectedAmount && cleanNote == null) {
      throw const CashRegisterException(CashRegisterException.noteRequired);
    }
    return repository.closeSession(
      sessionId: session.id,
      countedAmount: countedAmount,
      note: cleanNote,
    );
  }
}
