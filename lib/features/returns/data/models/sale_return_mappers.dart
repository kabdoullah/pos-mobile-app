import 'package:decimal/decimal.dart';

import '../../../../database/app_database.dart' as drift_db;
import '../../domain/entities/sale_return.dart';

/// Valeur API / drift d'un [ReturnReason].
String returnReasonToString(ReturnReason reason) => switch (reason) {
  ReturnReason.defective => 'defective',
  ReturnReason.damaged => 'damaged',
  ReturnReason.wrongProduct => 'wrong_product',
  ReturnReason.saleError => 'sale_error',
  ReturnReason.changedMind => 'changed_mind',
  ReturnReason.other => 'other',
};

/// [ReturnReason] d'une valeur API / drift ; échoue si inconnue.
ReturnReason returnReasonFromString(String value) =>
    ReturnReason.values.firstWhere(
      (r) => returnReasonToString(r) == value,
      orElse: () => throw FormatException('Motif de retour inconnu : $value'),
    );

/// Valeur API / drift d'un [ItemCondition].
String itemConditionToString(ItemCondition condition) => switch (condition) {
  ItemCondition.resellable => 'resellable',
  ItemCondition.damaged => 'damaged',
  ItemCondition.defective => 'defective',
  ItemCondition.unsellable => 'unsellable',
};

/// [ItemCondition] d'une valeur API / drift ; échoue si inconnue.
ItemCondition itemConditionFromString(String value) =>
    ItemCondition.values.firstWhere(
      (c) => itemConditionToString(c) == value,
      orElse: () => throw FormatException('État d’article inconnu : $value'),
    );

/// Valeur API / drift d'un [RefundMethod].
String refundMethodToString(RefundMethod method) => switch (method) {
  RefundMethod.cash => 'cash',
  RefundMethod.orangeMoney => 'mobile_money_orange',
  RefundMethod.mtn => 'mobile_money_mtn',
  RefundMethod.wave => 'mobile_money_wave',
};

/// [RefundMethod] d'une valeur API / drift ; échoue si inconnue.
RefundMethod refundMethodFromString(String value) =>
    RefundMethod.values.firstWhere(
      (m) => refundMethodToString(m) == value,
      orElse: () =>
          throw FormatException('Moyen de remboursement inconnu : $value'),
    );

/// [ReturnSyncStatus] d'une valeur drift.
ReturnSyncStatus returnSyncStatusFromString(String value) => switch (value) {
  'synced' => ReturnSyncStatus.synced,
  'rejected' => ReturnSyncStatus.rejected,
  _ => ReturnSyncStatus.pending,
};

/// Convertit une ligne de retour drift → domaine.
extension DriftSaleReturnItemToDomain on drift_db.SaleReturnItem {
  /// Convertit la ligne drift en [SaleReturnLine].
  SaleReturnLine toDomain() => SaleReturnLine(
    id: id,
    saleItemId: saleItemId,
    productId: productId,
    quantity: quantity,
    condition: itemConditionFromString(condition),
    restocked: restocked,
    refundAmount: Decimal.parse(refundAmount),
  );
}

/// Convertit un retour drift → domaine.
extension DriftSaleReturnToDomain on drift_db.SaleReturn {
  /// Convertit la ligne drift et ses [items] en [SaleReturn].
  SaleReturn toDomain(List<drift_db.SaleReturnItem> items) => SaleReturn(
    id: id,
    saleId: saleId,
    returnNumber: returnNumber,
    reason: returnReasonFromString(reason),
    note: note,
    refundMethod: refundMethodFromString(refundMethod),
    refundAmount: Decimal.parse(refundAmount),
    createdAt: createdAt,
    syncStatus: returnSyncStatusFromString(syncStatus),
    rejectionCode: rejectionCode,
    lines: [for (final item in items) item.toDomain()],
  );
}
