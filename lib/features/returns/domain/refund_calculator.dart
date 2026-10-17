import 'package:decimal/decimal.dart';

/// Calcul du montant remboursable d'un retour (ADR-0010).
///
/// Reproduit à l'identique `app/modules/returns/refund.py` du backend, qui
/// recalcule chaque montant et refuse tout écart :
/// 1. le montant payé d'une ligne est sa part du total encaissé — la remise
///    globale est répartie au prorata des totaux nets de ligne, au franc
///    entier, par la méthode du plus fort reste (égalités départagées par l'id
///    de ligne croissant) ;
/// 2. rembourser q unités d'une ligne de Q unités dont r sont déjà retournées :
///    floor(payé × (r+q) / Q) − floor(payé × r / Q). La somme des retours
///    successifs d'une ligne vaut son montant payé, jamais davantage.
///
/// Calculs en entiers ([BigInt]) : aucune division décimale inexacte.
abstract final class RefundCalculator {
  static BigInt _cents(Decimal amount) =>
      (amount * Decimal.fromInt(100)).toBigInt();

  /// Montant payé (francs entiers) de chaque ligne, par id de ligne de vente.
  static Map<String, Decimal> allocatePaidAmounts(
    List<({String id, Decimal lineTotal})> lines,
    Decimal total,
  ) {
    final totalFrancs = total.toBigInt();
    final subtotalCents = lines.fold(
      BigInt.zero,
      (sum, line) => sum + _cents(line.lineTotal),
    );
    if (subtotalCents == BigInt.zero) {
      return {for (final line in lines) line.id: Decimal.zero};
    }

    final quotas = [
      for (final line in lines)
        (
          id: line.id,
          floor: _cents(line.lineTotal) * totalFrancs ~/ subtotalCents,
          remainder: _cents(line.lineTotal) * totalFrancs % subtotalCents,
        ),
    ];
    final paid = {for (final q in quotas) q.id: q.floor};
    var leftover =
        totalFrancs - paid.values.fold(BigInt.zero, (sum, v) => sum + v);
    final byRemainder = [...quotas]
      ..sort((a, b) {
        final byRest = b.remainder.compareTo(a.remainder);
        return byRest != 0 ? byRest : a.id.compareTo(b.id);
      });
    for (final q in byRemainder) {
      if (leftover <= BigInt.zero) break;
      paid[q.id] = paid[q.id]! + BigInt.one;
      leftover -= BigInt.one;
    }
    return paid.map((id, francs) => MapEntry(id, Decimal.fromBigInt(francs)));
  }

  /// Montant (francs entiers) à rembourser pour [quantity] unités d'une ligne
  /// de [sold] unités payée [paid], dont [alreadyReturned] sont déjà rendues.
  static Decimal refundFor({
    required Decimal paid,
    required int sold,
    required int alreadyReturned,
    required int quantity,
  }) {
    final paidFrancs = paid.toBigInt();
    final soldCount = BigInt.from(sold);
    final before = paidFrancs * BigInt.from(alreadyReturned) ~/ soldCount;
    final after =
        paidFrancs * BigInt.from(alreadyReturned + quantity) ~/ soldCount;
    return Decimal.fromBigInt(after - before);
  }
}
