import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../providers/sales_di_providers.dart';
import '../../domain/entities/sale.dart' as sale_entity;
import 'cart_provider.dart';

part 'sales_providers.g.dart';

/// Submit current cart as a sale (calls CreateSaleUseCase).
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

/// Watches sales within a date range (inclusive) — re-emits on every drift
/// change.
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

/// Downloads the PDF receipt for a sale.
@riverpod
Future<Uint8List> downloadSaleReceiptPdf(Ref ref, String saleId) {
  return ref.read(salesRepositoryProvider).downloadReceiptPdf(saleId);
}
