import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/providers/catalog_di_providers.dart';
import '../../providers/sales_di_providers.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/sale.dart' as sale_entity;
import 'cart_provider.dart';

part 'sales_providers.g.dart';

/// Enregistre le panier courant comme vente (appelle CreateSaleUseCase).
@riverpod
Future<sale_entity.Sale> submitSale(
  Ref ref, {
  required Decimal totalAmount,
  required Decimal vatAmount,
  required sale_entity.PaymentMethod paymentMethod,
  Decimal? cashAmount,
  Decimal? mobileMoneyAmount,
}) async {
  final useCase = ref.read(createSaleUseCaseProvider);
  final cartState = ref.read(cartProvider);

  final sale = await useCase(
    items: cartState.items,
    totalAmount: totalAmount,
    vatAmount: vatAmount,
    paymentMethod: paymentMethod,
    cashAmount: cashAmount,
    mobileMoneyAmount: mobileMoneyAmount,
  );

  return sale;
}

/// Observe les ventes d'une plage de dates (incluse) — réémet à chaque
/// changement drift.
@riverpod
Stream<List<sale_entity.Sale>> salesHistory(
  Ref ref, {
  required DateTime startDate,
  required DateTime endDate,
}) {
  return ref
      .watch(salesRepositoryProvider)
      .watchSalesByDateRange(startDate, endDate);
}

/// Observe une vente — permet aux écrans ouverts d'afficher le numéro de reçu
/// dès que la synchro l'attribue.
@riverpod
Stream<sale_entity.Sale?> saleById(Ref ref, String id) {
  return ref.watch(salesRepositoryProvider).watchSale(id);
}

/// Observe les lignes d'une vente (vide si la vente vient du serveur).
@riverpod
Stream<List<CartItem>> saleItems(Ref ref, String saleId) {
  return ref.watch(salesRepositoryProvider).watchSaleItems(saleId);
}

/// Nombre de ventes et chiffre d'affaires d'une liste de ventes.
({int count, Decimal total}) salesTotals(List<sale_entity.Sale> sales) => (
  count: sales.length,
  total: sales.fold(Decimal.zero, (sum, sale) => sum + sale.totalAmount),
);

/// Recherche par numéro de reçu (préfixe « # » accepté). Une vente pas encore
/// synchronisée n'a pas de numéro : elle ne correspond à aucune recherche.
List<sale_entity.Sale> searchSalesByReceipt(
  List<sale_entity.Sale> sales,
  String query,
) {
  final digits = query.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return sales;
  return sales
      .where(
        (sale) =>
            sale.receiptNumber > 0 &&
            sale.receiptNumber.toString().contains(digits),
      )
      .toList();
}

/// Télécharge le reçu PDF d'une vente.
@riverpod
Future<Uint8List> downloadSaleReceiptPdf(Ref ref, String saleId) {
  return ref.read(salesRepositoryProvider).downloadReceiptPdf(saleId);
}

/// Recherche de produits pour la caisse (nom ou code-barres, catalogue local).
///
/// Distincte de `catalogListProvider` : une recherche en caisse ne filtre pas
/// l'onglet Catalogue.
@riverpod
Future<List<Product>> saleProductSearch(Ref ref, String query) async {
  final page = await ref
      .watch(catalogRepositoryProvider)
      .getProducts(query: query, limit: 30);
  return page.items;
}
