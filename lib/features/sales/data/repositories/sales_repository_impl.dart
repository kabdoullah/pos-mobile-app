import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

import '../../../../core/sync/sync_queue_repository.dart';
import '../../../../database/app_database.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/discount.dart';
import '../../domain/entities/margin_summary.dart';
import '../../domain/entities/sale.dart' as sale_entity;
import '../../domain/repositories/sales_repository.dart';
import '../models/sale_mappers.dart';

/// Implémentation concrète de [SalesRepository].
/// Local d'abord : lit et écrit dans la base drift. Les changements sont mis en
/// file pour la synchro.
/// Le téléchargement du reçu PDF fait exception — il appelle directement l'API
/// distante (sans miroir drift), car c'est une action ponctuelle dont le
/// résultat n'est pas conservé en local.
class SalesRepositoryImpl implements SalesRepository {
  /// Crée un SalesRepositoryImpl.
  SalesRepositoryImpl({
    required this.db,
    required this.syncQueue,
    required this.dio,
  });

  /// Instance de la base drift locale.
  final AppDatabase db;

  /// Repository de la file de synchro pour marquer les changements.
  final SyncQueueRepository syncQueue;

  /// Instance Dio utilisée pour télécharger le reçu PDF.
  final Dio dio;

  @override
  Future<sale_entity.Sale> createSale({
    required List<CartItem> items,
    required Decimal totalAmount,
    required Decimal vatAmount,
    required sale_entity.PaymentMethod paymentMethod,
    Discount? discount,
    Decimal? cashAmount,
    Decimal? mobileMoneyAmount,
  }) async {
    const uuid = Uuid();
    final saleId = uuid.v4();
    final now = DateTime.now().toUtc();
    final subtotal = items.fold(Decimal.zero, (sum, i) => sum + i.lineTotal);
    final discountAmount = discount?.amountOn(subtotal) ?? Decimal.zero;

    // Construit le payload de synchro avec les articles (avant la
    // transaction). Il porte l'instantané complet des prix (ADR-0009) : le
    // serveur ne relit jamais le produit pour reconstituer la vente.
    final itemPayloads = items
        .map(
          (item) => {
            'product_id': item.productId,
            'product_name_at_sale': item.productName,
            'unit_price_at_sale': item.unitPrice.toString(),
            'quantity': item.quantity,
            'line_total': item.lineTotal.toString(),
            'purchase_price_at_sale': item.purchaseUnitPrice?.toString(),
            'discount_type': item.discount == null
                ? null
                : discountTypeToString(item.discount!.type),
            'discount_value': item.discount?.value.toString(),
            'discount_amount': item.discountAmount.toString(),
          },
        )
        .toList();

    final salePayload = {
      'id': saleId,
      'items': itemPayloads,
      'total_amount': totalAmount.toString(),
      'vat_amount': vatAmount.toString(),
      'payment_method': _paymentMethodToDtoString(paymentMethod),
      if (cashAmount != null) 'cash_amount': cashAmount.toString(),
      if (mobileMoneyAmount != null)
        'mobile_money_amount': mobileMoneyAmount.toString(),
      'created_at': now.toIso8601String(),
      'discount_type': discount == null
          ? null
          : discountTypeToString(discount.type),
      'discount_value': discount?.value.toString(),
      'discount_amount': discountAmount.toString(),
    };

    // Transaction : insertion atomique de la vente + articles + entrée de file
    await db.transaction(() async {
      // Création de l'enregistrement de la vente
      await db
          .into(db.sales)
          .insert(
            SalesCompanion(
              id: drift.Value(saleId),
              receiptNumber: const drift.Value(0),
              totalAmount: drift.Value(totalAmount.toString()),
              vatAmount: drift.Value(vatAmount.toString()),
              paymentMethod: drift.Value(_paymentMethodToString(paymentMethod)),
              createdAt: drift.Value(now),
              discountType: drift.Value(
                discount == null ? null : discountTypeToString(discount.type),
              ),
              discountValue: drift.Value(discount?.value.toString()),
              discountAmount: drift.Value(discountAmount.toString()),
            ),
          );

      // Création des articles de la vente
      for (final item in items) {
        final itemId = uuid.v4();
        await db
            .into(db.saleItems)
            .insert(
              SaleItemsCompanion(
                id: drift.Value(itemId),
                saleId: drift.Value(saleId),
                productId: drift.Value(item.productId),
                productName: drift.Value(item.productName),
                unitPrice: drift.Value(item.unitPrice.toString()),
                quantity: drift.Value(item.quantity),
                lineTotal: drift.Value(item.lineTotal.toString()),
                purchaseUnitPrice: drift.Value(
                  item.purchaseUnitPrice?.toString(),
                ),
                discountType: drift.Value(
                  item.discount == null
                      ? null
                      : discountTypeToString(item.discount!.type),
                ),
                discountValue: drift.Value(item.discount?.value.toString()),
                discountAmount: drift.Value(item.discountAmount.toString()),
              ),
            );
      }

      // Décrémente le stock de chaque article (les produits au stock null sont
      // illimités)
      for (final item in items) {
        await db.customUpdate(
          'UPDATE products '
          'SET current_stock = current_stock - ?, dirty = 1 '
          'WHERE id = ? AND current_stock IS NOT NULL',
          variables: [
            drift.Variable.withInt(item.quantity),
            drift.Variable.withString(item.productId),
          ],
          updates: {db.products},
        );
      }

      // Mise en file pour la synchro dans la même transaction (garantit
      // l'atomicité)
      await syncQueue.enqueueSale(saleId: saleId, salePayload: salePayload);
    });

    return sale_entity.Sale(
      id: saleId,
      receiptNumber: 0,
      totalAmount: totalAmount,
      vatAmount: vatAmount,
      paymentMethod: paymentMethod,
      createdAt: now,
      discount: discount,
      discountAmount: discountAmount,
    );
  }

  @override
  Future<List<sale_entity.Sale>> getSales({
    String? cursor,
    int limit = 50,
  }) async {
    final query = db.select(db.sales);
    // Pagination par clé : le curseur est la chaîne ISO createdAt du dernier
    // élément.
    if (cursor != null) {
      final cursorDate = DateTime.parse(cursor);
      query.where((t) => t.createdAt.isSmallerThanValue(cursorDate));
    }
    query.orderBy([
      (t) => drift.OrderingTerm(
        expression: t.createdAt,
        mode: drift.OrderingMode.desc,
      ),
    ]);
    query.limit(limit);

    final sales = await query.get();
    return sales.map((s) => s.toDomain()).toList();
  }

  @override
  Future<List<sale_entity.Sale>> getSalesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final rangeStart = DateTime(startDate.year, startDate.month, startDate.day);
    final rangeEnd = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
    ).add(const Duration(days: 1));

    final sales =
        await (db.select(db.sales)
              ..where(
                (t) =>
                    t.createdAt.isBiggerOrEqualValue(rangeStart) &
                    t.createdAt.isSmallerThanValue(rangeEnd),
              )
              ..orderBy([
                (t) => drift.OrderingTerm(
                  expression: t.createdAt,
                  mode: drift.OrderingMode.desc,
                ),
              ]))
            .get();

    return sales.map((s) => s.toDomain()).toList();
  }

  @override
  Stream<List<sale_entity.Sale>> watchSalesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    final rangeStart = DateTime(startDate.year, startDate.month, startDate.day);
    final rangeEnd = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
    ).add(const Duration(days: 1));

    return (db.select(db.sales)
          ..where(
            (t) =>
                t.createdAt.isBiggerOrEqualValue(rangeStart) &
                t.createdAt.isSmallerThanValue(rangeEnd),
          )
          ..orderBy([
            (t) => drift.OrderingTerm(
              expression: t.createdAt,
              mode: drift.OrderingMode.desc,
            ),
          ]))
        .watch()
        .map((rows) => rows.map((s) => s.toDomain()).toList());
  }

  @override
  Future<sale_entity.Sale?> getSale(String id) async {
    final sale = await (db.select(
      db.sales,
    )..where((t) => t.id.equals(id))).getSingleOrNull();

    return sale?.toDomain();
  }

  @override
  Stream<sale_entity.Sale?> watchSale(String id) {
    return (db.select(db.sales)..where((t) => t.id.equals(id)))
        .watchSingleOrNull()
        .map((sale) => sale?.toDomain());
  }

  @override
  Stream<List<CartItem>> watchSaleItems(String saleId) {
    return (db.select(db.saleItems)..where((t) => t.saleId.equals(saleId)))
        .watch()
        .map((rows) => rows.map((row) => row.toCartItem()).toList());
  }

  @override
  Future<List<sale_entity.Sale>> getTodaySales() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    final sales =
        await (db.select(db.sales)
              ..where((t) => t.createdAt.isBiggerOrEqualValue(todayStart))
              ..orderBy([
                (t) => drift.OrderingTerm(
                  expression: t.createdAt,
                  mode: drift.OrderingMode.desc,
                ),
              ]))
            .get();

    return sales.map((s) => s.toDomain()).toList();
  }

  @override
  Stream<DailyStats> watchTodayStats() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    return db
        .customSelect(
          'SELECT '
          '  COUNT(*) AS sale_count, '
          '  COALESCE(SUM(CAST(total_amount AS INTEGER)), 0) AS total, '
          '  COALESCE(SUM(CASE WHEN payment_method = ? THEN CAST(total_amount AS INTEGER) ELSE 0 END), 0) AS cash_total, '
          '  COALESCE(SUM(CASE WHEN payment_method != ? THEN CAST(total_amount AS INTEGER) ELSE 0 END), 0) AS mobile_total '
          'FROM sales WHERE created_at >= ?',
          variables: [
            drift.Variable.withString('cash'),
            drift.Variable.withString('cash'),
            drift.Variable.withDateTime(todayStart),
          ],
          readsFrom: {db.sales},
        )
        .watchSingle()
        .map((row) {
          Decimal fromInt(int v) => Decimal.fromInt(v);
          return (
            saleCount: row.read<int>('sale_count'),
            totalAmount: fromInt(row.read<int>('total')),
            cashTotal: fromInt(row.read<int>('cash_total')),
            mobileMoneyTotal: fromInt(row.read<int>('mobile_total')),
          );
        });
  }

  @override
  Stream<MarginSummary> watchMarginSummary(
    DateTime startDate,
    DateTime endDate,
  ) {
    final rangeStart = DateTime(startDate.year, startDate.month, startDate.day);
    final rangeEnd = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
    ).add(const Duration(days: 1));

    final query =
        db.select(db.sales).join([
          drift.leftOuterJoin(
            db.saleItems,
            db.saleItems.saleId.equalsExp(db.sales.id),
          ),
        ])..where(
          db.sales.createdAt.isBiggerOrEqualValue(rangeStart) &
              db.sales.createdAt.isSmallerThanValue(rangeEnd),
        );

    return query.watch().map((rows) {
      final sales = <String, ({sale_entity.Sale sale, List<CartItem> items})>{};
      for (final row in rows) {
        final saleRow = row.readTable(db.sales);
        final entry = sales.putIfAbsent(
          saleRow.id,
          () => (sale: saleRow.toDomain(), items: <CartItem>[]),
        );
        final itemRow = row.readTableOrNull(db.saleItems);
        if (itemRow != null) entry.items.add(itemRow.toCartItem());
      }
      return MarginSummary.fromSales(sales.values);
    });
  }

  @override
  Future<Uint8List> downloadReceiptPdf(String saleId) async {
    final response = await dio.get<List<int>>(
      '/api/v1/sales/$saleId/receipt',
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }

  /// Convertit le PaymentMethod du domaine au format chaîne drift.
  String _paymentMethodToString(sale_entity.PaymentMethod method) {
    return switch (method) {
      sale_entity.PaymentMethod.cash => 'cash',
      sale_entity.PaymentMethod.orangeMoney => 'orangeMoney',
      sale_entity.PaymentMethod.mtn => 'mtn',
      sale_entity.PaymentMethod.wave => 'wave',
      sale_entity.PaymentMethod.mixed => 'mixed',
    };
  }

  /// Convertit le PaymentMethod du domaine au format chaîne de l'API.
  String _paymentMethodToDtoString(sale_entity.PaymentMethod method) {
    return switch (method) {
      sale_entity.PaymentMethod.cash => 'cash',
      sale_entity.PaymentMethod.orangeMoney => 'mobile_money_orange',
      sale_entity.PaymentMethod.mtn => 'mobile_money_mtn',
      sale_entity.PaymentMethod.wave => 'mobile_money_wave',
      sale_entity.PaymentMethod.mixed => 'mixed',
    };
  }
}
