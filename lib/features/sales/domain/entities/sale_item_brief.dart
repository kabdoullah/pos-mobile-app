/// Article d'une vente réduit à ce que montre la liste de l'historique :
/// nom figé à la vente et quantité.
class SaleItemBrief {
  /// Crée un article résumé.
  const SaleItemBrief({required this.productName, required this.quantity});

  /// Nom du produit au moment de la vente.
  final String productName;

  /// Quantité vendue.
  final int quantity;
}

/// Résumé lisible des articles d'une vente : « Riz ×21, Lotus ×2 », les
/// [max] premiers puis « + N autres ». Quantité 1 sans « ×1 ».
String summarizeSaleItems(List<SaleItemBrief> items, {int max = 3}) {
  String label(SaleItemBrief i) =>
      i.quantity == 1 ? i.productName : '${i.productName} ×${i.quantity}';
  final shown = items.take(max).map(label).join(', ');
  final rest = items.length - max;
  if (rest <= 0) return shown;
  return '$shown + $rest ${rest == 1 ? 'autre' : 'autres'}';
}
