import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../sales/domain/entities/sale.dart';
import '../../domain/entities/returnable_line.dart';
import '../../domain/entities/sale_return.dart';
import '../../domain/usecases/create_sale_return_usecase.dart';
import '../../providers/returns_di_providers.dart';

part 'returns_providers.freezed.dart';
part 'returns_providers.g.dart';

/// Lignes de [sale] avec leurs quantités déjà rendues (drift, en direct).
@riverpod
Stream<List<ReturnableLine>> returnableLines(Ref ref, Sale sale) {
  return ref.watch(returnsRepositoryProvider).watchReturnableLines(sale);
}

/// Retours d'une vente (drift, en direct).
@riverpod
Stream<List<SaleReturn>> saleReturns(Ref ref, String saleId) {
  return ref.watch(returnsRepositoryProvider).watchReturnsForSale(saleId);
}

/// Moyen de remboursement proposé par défaut : celui de la vente, espèces pour
/// un paiement mixte (l'opérateur mobile money n'est pas connu).
RefundMethod defaultRefundMethod(PaymentMethod method) => switch (method) {
  PaymentMethod.cash || PaymentMethod.mixed => RefundMethod.cash,
  PaymentMethod.orangeMoney => RefundMethod.orangeMoney,
  PaymentMethod.mtn => RefundMethod.mtn,
  PaymentMethod.wave => RefundMethod.wave,
};

/// Saisie en cours de l'écran de retour.
@freezed
sealed class ReturnDraftState with _$ReturnDraftState {
  /// Crée un [ReturnDraftState].
  const factory ReturnDraftState({
    /// Id du retour, généré une fois par écran (idempotence).
    required String returnId,

    /// Quantité choisie par ligne de vente (absente = 0).
    @Default(<String, int>{}) Map<String, int> quantities,

    /// État choisi par ligne de vente (absent = revendable).
    @Default(<String, ItemCondition>{}) Map<String, ItemCondition> conditions,
    ReturnReason? reason,
    @Default('') String note,
    required RefundMethod refundMethod,

    /// Retour enregistré : l'écran affiche la confirmation.
    SaleReturn? saved,
  }) = _ReturnDraftState;

  const ReturnDraftState._();

  /// Quantité choisie pour la ligne [saleItemId].
  int quantityOf(String saleItemId) => quantities[saleItemId] ?? 0;

  /// État choisi pour la ligne [saleItemId].
  ItemCondition conditionOf(String saleItemId) =>
      conditions[saleItemId] ?? ItemCondition.resellable;

  /// Le motif « autre » attend un commentaire.
  bool get needsNote => reason == ReturnReason.other && note.trim().isEmpty;

  /// Articles choisis, avec leur état.
  List<ReturnSelection> selections(List<ReturnableLine> lines) => [
    for (final line in lines)
      if (quantityOf(line.saleItemId) > 0)
        (
          line: line,
          quantity: quantityOf(line.saleItemId),
          condition: conditionOf(line.saleItemId),
        ),
  ];

  /// Montant remboursable des articles choisis.
  Decimal refundTotal(List<ReturnableLine> lines) => selections(
    lines,
  ).fold(Decimal.zero, (sum, s) => sum + s.line.refundFor(s.quantity));
}

/// Saisie de l'écran de retour d'une vente ; libérée en quittant l'écran.
@riverpod
class ReturnDraft extends _$ReturnDraft {
  @override
  ReturnDraftState build(Sale sale) => ReturnDraftState(
    returnId: const Uuid().v4(),
    refundMethod: defaultRefundMethod(sale.paymentMethod),
  );

  /// Fixe la quantité rendue d'une ligne (bornée par l'appelant).
  void setQuantity(String saleItemId, int quantity) => state = state.copyWith(
    quantities: {...state.quantities, saleItemId: quantity},
  );

  /// Fixe l'état d'un article rendu.
  void setCondition(String saleItemId, ItemCondition condition) => state = state
      .copyWith(conditions: {...state.conditions, saleItemId: condition});

  /// Fixe le motif.
  void setReason(ReturnReason reason) => state = state.copyWith(reason: reason);

  /// Fixe le commentaire.
  void setNote(String note) => state = state.copyWith(note: note);

  /// Fixe le moyen de remboursement.
  void setRefundMethod(RefundMethod method) =>
      state = state.copyWith(refundMethod: method);

  /// Retour enregistré : affiche la confirmation.
  void markSaved(SaleReturn saleReturn) =>
      state = state.copyWith(saved: saleReturn);
}

/// Enregistre un retour.
///
/// Maintenu en vie volontairement (voir `StockAdjustment`) : l'écran peut être
/// quitté pendant l'écriture ; un provider auto-dispose échouerait alors sur un
/// retour pourtant enregistré.
@Riverpod(keepAlive: true)
class SaleReturnSubmission extends _$SaleReturnSubmission {
  @override
  void build() {}

  /// Enregistre le retour décrit par [draft] ; lève
  /// [CreateSaleReturnException] si une règle n'est pas respectée.
  Future<SaleReturn> submit({
    required Sale sale,
    required List<ReturnableLine> lines,
    required ReturnDraftState draft,
  }) {
    final reason = draft.reason;
    if (reason == null) {
      throw CreateSaleReturnException('Choisissez le motif du retour');
    }
    return ref.read(createSaleReturnUseCaseProvider)(
      returnId: draft.returnId,
      sale: sale,
      selections: draft.selections(lines),
      reason: reason,
      note: draft.note,
      refundMethod: draft.refundMethod,
    );
  }
}
