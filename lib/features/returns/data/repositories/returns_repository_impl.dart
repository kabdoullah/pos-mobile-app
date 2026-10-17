import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

import '../../../../core/network/api_models/sale_return_dto.dart';
import '../../../../core/sync/sync_queue_repository.dart';
import '../../../../database/app_database.dart' as drift_db;
import '../../../sales/domain/entities/sale.dart';
import '../../domain/entities/returnable_line.dart';
import '../../domain/entities/sale_return.dart';
import '../../domain/refund_calculator.dart';
import '../../domain/repositories/returns_repository.dart';
import '../models/sale_return_mappers.dart';

/// Implémentation drift de [ReturnsRepository] (ADR-0010).
///
/// Local d'abord : le retour, ses lignes, la remise en stock et l'entrée de
/// file de synchro sont écrits dans une seule transaction. Le serveur valide
/// ensuite les quantités (verrou sur la vente) et peut refuser le retour.
class ReturnsRepositoryImpl implements ReturnsRepository {
  /// Crée un ReturnsRepositoryImpl.
  ReturnsRepositoryImpl({required this.db, required this.syncQueue});

  /// Base drift locale.
  final drift_db.AppDatabase db;

  /// File de synchro.
  final SyncQueueRepository syncQueue;

  @override
  Stream<List<ReturnableLine>> watchReturnableLines(Sale sale) {
    // Quantité déjà rendue par ligne, retours refusés par le serveur exclus.
    return db
        .customSelect(
          'SELECT si.*, COALESCE(('
          '  SELECT SUM(ri.quantity) FROM sale_return_items ri '
          '  JOIN sale_returns r ON r.id = ri.return_id '
          "  WHERE ri.sale_item_id = si.id AND r.sync_status != 'rejected'"
          '), 0) AS returned_quantity '
          'FROM sale_items si WHERE si.sale_id = ? ORDER BY si.rowid',
          variables: [drift.Variable.withString(sale.id)],
          readsFrom: {db.saleItems, db.saleReturns, db.saleReturnItems},
        )
        .watch()
        .map((rows) {
          final items = [
            for (final row in rows)
              (
                item: db.saleItems.map(row.data),
                returned: row.read<int>('returned_quantity'),
              ),
          ];
          final paid = RefundCalculator.allocatePaidAmounts([
            for (final i in items)
              (id: i.item.id, lineTotal: Decimal.parse(i.item.lineTotal)),
          ], sale.totalAmount);
          return [
            for (final i in items)
              ReturnableLine(
                saleItemId: i.item.id,
                // Produit supprimé côté serveur : id vide au pull.
                productId: i.item.productId.isEmpty ? null : i.item.productId,
                productName: i.item.productName,
                unitPrice: Decimal.parse(i.item.unitPrice),
                discountAmount: Decimal.parse(i.item.discountAmount),
                soldQuantity: i.item.quantity,
                returnedQuantity: i.returned,
                paidAmount: paid[i.item.id]!,
              ),
          ];
        });
  }

  @override
  Stream<List<SaleReturn>> watchReturnsForSale(String saleId) {
    final query =
        db.select(db.saleReturns).join([
            drift.leftOuterJoin(
              db.saleReturnItems,
              db.saleReturnItems.returnId.equalsExp(db.saleReturns.id),
            ),
          ])
          ..where(db.saleReturns.saleId.equals(saleId))
          ..orderBy([drift.OrderingTerm.asc(db.saleReturns.createdAt)]);
    return query.watch().map(_groupReturns);
  }

  @override
  Future<SaleReturn> createReturn({
    required String id,
    required String saleId,
    required ReturnReason reason,
    String? note,
    required RefundMethod refundMethod,
    required List<NewReturnLine> lines,
  }) async {
    const uuid = Uuid();
    final now = DateTime.now().toUtc();

    await db.transaction(() async {
      // Idempotence : un double appui ou un nouvel essai ne réécrit rien.
      final existing = await (db.select(
        db.saleReturns,
      )..where((r) => r.id.equals(id))).getSingleOrNull();
      if (existing != null) return;

      final rows = <drift_db.SaleReturnItemsCompanion>[];
      for (final line in lines) {
        rows.add(
          drift_db.SaleReturnItemsCompanion.insert(
            id: uuid.v4(),
            returnId: id,
            saleItemId: line.saleItemId,
            productId: drift.Value(line.productId),
            quantity: line.quantity,
            condition: itemConditionToString(line.condition),
            restocked: line.condition.restocks && await _isActive(line),
            refundAmount: line.refundAmount.toString(),
          ),
        );
      }
      final total = lines.fold(
        Decimal.zero,
        (sum, line) => sum + line.refundAmount,
      );

      await db
          .into(db.saleReturns)
          .insert(
            drift_db.SaleReturnsCompanion.insert(
              id: id,
              saleId: saleId,
              reason: returnReasonToString(reason),
              note: drift.Value(note),
              refundMethod: refundMethodToString(refundMethod),
              refundAmount: total.toString(),
              createdAt: now,
            ),
          );
      for (final row in rows) {
        await db.into(db.saleReturnItems).insert(row);
        // Revendable : remis en stock (un produit non suivi le reste).
        if (row.restocked.value) {
          await _adjustStock(row.productId.value!, row.quantity.value);
        }
      }

      await syncQueue.enqueueReturn(
        returnId: id,
        returnPayload: SaleReturnCreateDto(
          id: id,
          saleId: saleId,
          reason: returnReasonToString(reason),
          note: note,
          refundMethod: refundMethodToString(refundMethod),
          refundAmount: total.toString(),
          createdAt: now.toIso8601String(),
          items: [
            for (final row in rows)
              SaleReturnItemCreateDto(
                id: row.id.value,
                saleItemId: row.saleItemId.value,
                quantity: row.quantity.value,
                condition: row.condition.value,
                refundAmount: row.refundAmount.value,
              ),
          ],
        ).toJson(),
      );
    });

    return (await watchReturnsForSale(
      saleId,
    ).first).singleWhere((r) => r.id == id);
  }

  /// Le produit existe encore localement (non supprimé).
  Future<bool> _isActive(NewReturnLine line) async {
    final productId = line.productId;
    if (productId == null) return false;
    final product =
        await (db.select(db.products)
              ..where((p) => p.id.equals(productId) & p.deletedAt.isNull()))
            .getSingleOrNull();
    return product != null;
  }

  Future<void> _adjustStock(String productId, int delta) {
    return db.customUpdate(
      'UPDATE products SET current_stock = current_stock + ? '
      'WHERE id = ? AND current_stock IS NOT NULL',
      variables: [
        drift.Variable.withInt(delta),
        drift.Variable.withString(productId),
      ],
      updates: {db.products},
    );
  }

  List<SaleReturn> _groupReturns(List<drift.TypedResult> rows) {
    final grouped =
        <
          String,
          ({drift_db.SaleReturn row, List<drift_db.SaleReturnItem> items})
        >{};
    for (final row in rows) {
      final header = row.readTable(db.saleReturns);
      final entry = grouped.putIfAbsent(
        header.id,
        () => (row: header, items: <drift_db.SaleReturnItem>[]),
      );
      final item = row.readTableOrNull(db.saleReturnItems);
      if (item != null) entry.items.add(item);
    }
    return [for (final e in grouped.values) e.row.toDomain(e.items)];
  }
}
