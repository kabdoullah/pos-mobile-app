import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

/// Télécharge le reçu PDF d'une vente.
@riverpod
Future<Uint8List> downloadSaleReceiptPdf(Ref ref, String saleId) {
  return ref.read(salesRepositoryProvider).downloadReceiptPdf(saleId);
}
