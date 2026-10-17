import '../../../sales/domain/entities/sale.dart';
import '../entities/returnable_line.dart';
import '../entities/sale_return.dart';
import '../repositories/returns_repository.dart';

/// Exception pour les violations des règles métier d'un retour.
class CreateSaleReturnException implements Exception {
  /// Crée une exception avec un message affichable.
  CreateSaleReturnException(this.message);

  /// Message d'erreur.
  final String message;

  @override
  String toString() => 'CreateSaleReturnException: $message';
}

/// Article choisi sur l'écran de retour (quantité 0 = non retourné).
typedef ReturnSelection = ({
  ReturnableLine line,
  int quantity,
  ItemCondition condition,
});

/// Logique métier de l'enregistrement d'un retour client (ADR-0010).
class CreateSaleReturnUseCase {
  /// Crée une instance du cas d'usage.
  CreateSaleReturnUseCase({required this.repository});

  /// Repository qui persiste les retours.
  final ReturnsRepository repository;

  /// Enregistre le retour des articles [selections] de [sale].
  ///
  /// Vérifie que :
  /// - la vente est synchronisée (numéro de reçu attribué) ;
  /// - au moins un article est retourné, aucune quantité n'est négative ni
  ///   supérieure à la quantité encore retournable ;
  /// - le motif « autre » est précisé par un commentaire.
  ///
  /// Le montant de chaque ligne est calculé sur les valeurs figées à la vente
  /// (voir [ReturnableLine.refundFor]). [returnId] est généré une fois par
  /// écran : un double appui n'enregistre qu'un retour.
  Future<SaleReturn> call({
    required String returnId,
    required Sale sale,
    required List<ReturnSelection> selections,
    required ReturnReason reason,
    String? note,
    required RefundMethod refundMethod,
  }) async {
    if (sale.receiptNumber <= 0) {
      throw CreateSaleReturnException(
        'La vente doit être synchronisée avant un retour',
      );
    }
    if (selections.any((s) => s.quantity < 0)) {
      throw CreateSaleReturnException('Quantité invalide');
    }
    final chosen = selections.where((s) => s.quantity > 0).toList();
    if (chosen.isEmpty) {
      throw CreateSaleReturnException('Aucun article à retourner');
    }
    for (final s in chosen) {
      if (s.quantity > s.line.returnableQuantity) {
        throw CreateSaleReturnException(
          '${s.line.productName} : ${s.line.returnableQuantity} '
          'retournable(s) au plus',
        );
      }
    }
    final trimmedNote = note?.trim();
    final cleanNote = (trimmedNote == null || trimmedNote.isEmpty)
        ? null
        : trimmedNote;
    if (reason == ReturnReason.other && cleanNote == null) {
      throw CreateSaleReturnException('Précisez le motif du retour');
    }

    return repository.createReturn(
      id: returnId,
      saleId: sale.id,
      reason: reason,
      note: cleanNote,
      refundMethod: refundMethod,
      lines: [
        for (final s in chosen)
          (
            saleItemId: s.line.saleItemId,
            productId: s.line.productId,
            quantity: s.quantity,
            condition: s.condition,
            refundAmount: s.line.refundFor(s.quantity),
          ),
      ],
    );
  }
}
