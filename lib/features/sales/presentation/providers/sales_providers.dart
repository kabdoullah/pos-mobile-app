import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../catalog/domain/entities/product.dart';
import '../../../catalog/providers/catalog_di_providers.dart';
import '../../providers/sales_di_providers.dart';
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
