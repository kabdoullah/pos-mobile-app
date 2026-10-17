import 'package:decimal/decimal.dart';

import '../../../sales/domain/entities/sale.dart';
import '../entities/returnable_line.dart';
import '../entities/sale_return.dart';

/// Ligne d'un retour à enregistrer (montant déjà calculé).
typedef NewReturnLine = ({
  String saleItemId,
  String? productId,
  int quantity,
  ItemCondition condition,
  Decimal refundAmount,
});

/// Repository des retours clients (local d'abord, synchronisé ensuite).
abstract class ReturnsRepository {
  /// Observe les lignes de [sale] avec leurs quantités déjà rendues — réémet
  /// à chaque retour enregistré ou reçu du serveur.
  Stream<List<ReturnableLine>> watchReturnableLines(Sale sale);

  /// Observe les retours d'une vente, du plus ancien au plus récent.
  Stream<List<SaleReturn>> watchReturnsForSale(String saleId);

  /// Enregistre un retour de façon atomique (retour, lignes, remise en stock,
  /// file de synchro). Idempotent : un [id] déjà enregistré renvoie le retour
  /// existant sans rien réécrire (double appui, nouvel essai).
  Future<SaleReturn> createReturn({
    required String id,
    required String saleId,
    required ReturnReason reason,
    String? note,
    required RefundMethod refundMethod,
    required List<NewReturnLine> lines,
  });
}
