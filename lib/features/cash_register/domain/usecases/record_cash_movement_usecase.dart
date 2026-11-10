import 'package:decimal/decimal.dart';

import '../entities/cash_movement.dart';
import '../repositories/cash_register_repository.dart';
import 'open_cash_session_usecase.dart';

/// Entrée ou sortie d'espèces dans la session ouverte.
class RecordCashMovementUseCase {
  /// Crée le cas d'usage.
  const RecordCashMovementUseCase({required this.repository});

  /// Repository des sessions de caisse.
  final CashRegisterRepository repository;

  /// Enregistre un mouvement de [amount] dans la session ouverte.
  ///
  /// Lève [CashRegisterException] :
  /// - `no_open_session` sans session ouverte ;
  /// - `invalid_amount` si le montant est ≤ 0 ;
  /// - `reason_type_mismatch` si [reason] n'est pas autorisé pour [type] ;
  /// - `note_required` pour le motif `other` sans commentaire ;
  /// - `note_too_long` pour un commentaire de plus de 500 caractères ;
  /// - `insufficient_cash` pour une sortie supérieure au solde théorique
  ///   (une sortie égale au solde est acceptée).
  Future<CashMovement> call({
    required CashMovementType type,
    required CashMovementReason reason,
    required Decimal amount,
    String? note,
  }) async {
    final session = await repository.getActiveSession();
    if (session == null) {
      throw const CashRegisterException(CashRegisterException.noOpenSession);
    }
    if (amount <= Decimal.zero) {
      throw const CashRegisterException(CashRegisterException.invalidAmount);
    }
    if (!CashMovementReason.allowedFor(type).contains(reason)) {
      throw const CashRegisterException(
        CashRegisterException.reasonTypeMismatch,
      );
    }
    final cleanNote = cleanCashNote(note);
    if (reason == CashMovementReason.other && cleanNote == null) {
      throw const CashRegisterException(CashRegisterException.noteRequired);
    }
    if (type == CashMovementType.cashOut) {
      final summary = await repository.watchSummary(session.id).first;
      if (amount > summary.expectedAmount) {
        throw const CashRegisterException(
          CashRegisterException.insufficientCash,
        );
      }
    }
    return repository.recordMovement(
      sessionId: session.id,
      type: type,
      reason: reason,
      amount: amount,
      note: cleanNote,
    );
  }
}
