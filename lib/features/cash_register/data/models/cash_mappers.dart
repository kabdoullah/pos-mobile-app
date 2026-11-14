import 'package:decimal/decimal.dart';

import '../../../../core/network/api_models/cash_session_dto.dart';
import '../../../../database/app_database.dart' as drift_db;
import '../../../returns/domain/entities/sale_return.dart';
import '../../../sales/domain/entities/sale.dart';
import '../../domain/entities/cash_count.dart';
import '../../domain/entities/cash_labels.dart';
import '../../domain/entities/cash_movement.dart';
import '../../domain/entities/cash_session.dart';
import '../../domain/entities/cash_session_detail.dart';
import '../../domain/entities/denomination.dart';

/// Valeur drift d'un [CashSessionStatus].
String cashSessionStatusToString(CashSessionStatus status) => switch (status) {
  CashSessionStatus.open => 'open',
  CashSessionStatus.closed => 'closed',
};

/// [CashSessionStatus] d'une valeur drift ; échoue si inconnue.
CashSessionStatus cashSessionStatusFromString(String value) => switch (value) {
  'open' => CashSessionStatus.open,
  'closed' => CashSessionStatus.closed,
  _ => throw FormatException('Statut de session inconnu : $value'),
};

/// [CashSyncStatus] d'une valeur drift ; échoue si inconnue.
CashSyncStatus cashSyncStatusFromString(String value) => switch (value) {
  'pending' => CashSyncStatus.pending,
  'synced' => CashSyncStatus.synced,
  'rejected' => CashSyncStatus.rejected,
  _ => throw FormatException('État de synchro inconnu : $value'),
};

/// Moyen de paiement d'une vente drift. Une vente créée sur l'appareil
/// stocke le nom du domaine (`orangeMoney`), une vente reçue au pull la
/// valeur de l'API (`mobile_money_orange`) : les deux sont acceptées.
PaymentMethod salePaymentMethodFromStored(String value) => switch (value) {
  'cash' => PaymentMethod.cash,
  'mixed' => PaymentMethod.mixed,
  'orangeMoney' || 'mobile_money_orange' => PaymentMethod.orangeMoney,
  'mtn' || 'mobile_money_mtn' => PaymentMethod.mtn,
  'wave' || 'mobile_money_wave' => PaymentMethod.wave,
  _ => throw FormatException('Moyen de paiement inconnu : $value'),
};

/// Moyen de remboursement d'un retour drift (valeur de l'API).
RefundMethod refundMethodFromStored(String value) => switch (value) {
  'cash' => RefundMethod.cash,
  'mobile_money_orange' => RefundMethod.orangeMoney,
  'mobile_money_mtn' => RefundMethod.mtn,
  'mobile_money_wave' => RefundMethod.wave,
  _ => throw FormatException('Moyen de remboursement inconnu : $value'),
};

/// Décimal facultatif d'une colonne drift.
Decimal? _parseOrNull(String? value) =>
    value == null ? null : Decimal.parse(value);

/// Convertit une session drift → domaine.
extension DriftCashSessionToDomain on drift_db.CashSession {
  /// Convertit la ligne drift en [CashSession].
  CashSession toDomain() => CashSession(
    id: id,
    deviceId: deviceId,
    status: cashSessionStatusFromString(status),
    openingAmount: Decimal.parse(openingAmount),
    openedAt: openedAt.toUtc(),
    syncStatus: cashSyncStatusFromString(syncStatus),
    serverRecalculated: serverRecalculated,
    openingNote: openingNote,
    expectedAmount: _parseOrNull(expectedAmount),
    clientExpectedAmount: _parseOrNull(clientExpectedAmount),
    countedAmount: _parseOrNull(countedAmount),
    discrepancyAmount: _parseOrNull(discrepancyAmount),
    closingNote: closingNote,
    closedAt: closedAt?.toUtc(),
    rejectionCode: rejectionCode,
  );
}

/// Convertit un mouvement drift → domaine.
extension DriftCashMovementToDomain on drift_db.CashMovement {
  /// Convertit la ligne drift en [CashMovement].
  CashMovement toDomain() => CashMovement(
    id: id,
    sessionId: sessionId,
    type: cashMovementTypeFromApi(type),
    reason: cashMovementReasonFromApi(reason),
    amount: Decimal.parse(amount),
    createdAt: createdAt.toUtc(),
    syncStatus: cashSyncStatusFromString(syncStatus),
    note: note,
    rejectionCode: rejectionCode,
  );
}

/// Valeur drift / API d'un [CashCountOperation].
String cashCountOperationToString(CashCountOperation operation) =>
    switch (operation) {
      CashCountOperation.opening => 'opening',
      CashCountOperation.closing => 'closing',
    };

/// Lignes de billetterie envoyées au serveur (api.md, « Billetterie ») :
/// toutes les coupures du comptage, quantités nulles comprises.
List<Map<String, dynamic>> cashCountPayload(CashCount count) => [
  for (final MapEntry(key: d, value: quantity) in count.quantities.entries)
    {
      'denomination_type': denominationTypeToApi(d.type),
      'denomination': d.value,
      'quantity': quantity,
    },
];

/// Lignes drift d'un comptage de la session [sessionId].
List<drift_db.CashCountLinesCompanion> cashCountCompanions(
  String sessionId,
  CashCountOperation operation,
  CashCount count,
) => [
  for (final MapEntry(key: d, value: quantity) in count.quantities.entries)
    drift_db.CashCountLinesCompanion.insert(
      sessionId: sessionId,
      operation: cashCountOperationToString(operation),
      denominationType: denominationTypeToApi(d.type),
      denomination: d.value,
      quantity: quantity,
    ),
];

/// Comptage reconstitué depuis ses lignes drift, null s'il n'y en a pas.
CashCount? cashCountFromRows(Iterable<drift_db.CashCountLine> rows) {
  if (rows.isEmpty) return null;
  return CashCount.fromQuantities({
    for (final row in rows)
      Denomination(
        denominationTypeFromApi(row.denominationType),
        row.denomination,
      ): row.quantity,
  });
}

/// Corps de `POST /cash-sessions` (api.md, « Ouverture »). Sans
/// [openingCount] (mode « Total seulement »), la clé est absente.
Map<String, dynamic> cashSessionOpenPayload({
  required String id,
  required String deviceId,
  required Decimal openingAmount,
  required String? openingNote,
  required DateTime openedAt,
  CashCount? openingCount,
}) => {
  'id': id,
  'device_id': deviceId,
  'opening_amount': openingAmount.toString(),
  'opening_note': openingNote,
  'opened_at': openedAt.toUtc().toIso8601String(),
  if (openingCount != null) 'opening_count': cashCountPayload(openingCount),
};

/// Corps de `POST /cash-sessions/{id}/movements` (api.md, « Mouvement »),
/// plus `session_id` pour construire l'URL.
Map<String, dynamic> cashMovementPayload(CashMovement movement) => {
  'session_id': movement.sessionId,
  'id': movement.id,
  'type': cashMovementTypeToApi(movement.type),
  'reason': cashMovementReasonToApi(movement.reason),
  'amount': movement.amount.toString(),
  'note': movement.note,
  'created_at': movement.createdAt.toUtc().toIso8601String(),
};

/// Corps de `POST /cash-sessions/{id}/close` (api.md, « Clôture »), plus
/// `session_id` pour construire l'URL.
Map<String, dynamic> cashSessionClosePayload({
  required String sessionId,
  required Decimal countedAmount,
  required Decimal clientExpectedAmount,
  required String? closingNote,
  required DateTime closedAt,
  CashCount? closingCount,
}) => {
  'session_id': sessionId,
  'counted_amount': countedAmount.toString(),
  'client_expected_amount': clientExpectedAmount.toString(),
  'closing_note': closingNote,
  'closed_at': closedAt.toUtc().toIso8601String(),
  if (closingCount != null) 'closing_count': cashCountPayload(closingCount),
};

/// Convertit une session serveur → domaine.
extension CashSessionDtoToDomain on CashSessionDto {
  /// Convertit le DTO en [CashSession] synchronisée. Sans [serverRecalculated]
  /// explicite (historique, sans résumé), il vaut true si le montant figé
  /// diffère du solde affiché par l'app — même règle que le serveur.
  CashSession toDomain({bool? serverRecalculated}) {
    final expected = _parseOrNull(expectedAmount);
    final clientExpected = _parseOrNull(clientExpectedAmount);
    return CashSession(
      id: id,
      deviceId: deviceId,
      status: cashSessionStatusFromString(status),
      openingAmount: Decimal.parse(openingAmount),
      openedAt: DateTime.parse(openedAt).toUtc(),
      syncStatus: CashSyncStatus.synced,
      serverRecalculated:
          serverRecalculated ??
          (expected != null &&
              clientExpected != null &&
              expected != clientExpected),
      openingNote: openingNote,
      expectedAmount: expected,
      clientExpectedAmount: clientExpected,
      countedAmount: _parseOrNull(countedAmount),
      discrepancyAmount: _parseOrNull(discrepancyAmount),
      closingNote: closingNote,
      closedAt: closedAt == null ? null : DateTime.parse(closedAt!).toUtc(),
    );
  }
}

/// Convertit un mouvement serveur → domaine.
extension CashMovementDtoToDomain on CashMovementDto {
  /// Convertit le DTO en [CashMovement] synchronisé.
  CashMovement toDomain() => CashMovement(
    id: id,
    sessionId: sessionId,
    type: cashMovementTypeFromApi(type),
    reason: cashMovementReasonFromApi(reason),
    amount: Decimal.parse(amount),
    createdAt: DateTime.parse(createdAt).toUtc(),
    syncStatus: CashSyncStatus.synced,
    note: note,
  );
}

/// Convertit un récapitulatif serveur → domaine.
extension CashSummaryDtoToDomain on CashSummaryDto {
  /// Convertit le DTO en [CashServerSummary].
  CashServerSummary toDomain() => CashServerSummary(
    openingAmount: Decimal.parse(openingAmount),
    cashSales: Decimal.parse(cashSales),
    cashSalesCount: cashSalesCount,
    mobileMoneySales: Decimal.parse(mobileMoneySales),
    cashIn: Decimal.parse(cashIn),
    cashOut: Decimal.parse(cashOut),
    cashRefunds: Decimal.parse(cashRefunds),
    expectedAmount: Decimal.parse(expectedAmount),
    lateImpact: Decimal.parse(lateImpact),
    serverRecalculated: serverRecalculated,
  );
}

/// Convertit un comptage serveur → domaine.
extension CashCountDtoToDomain on CashCountDto {
  /// Convertit le DTO en [CashCount]. Les sous-totaux et totaux du serveur
  /// se déduisent des quantités ; une coupure non entière échoue.
  CashCount toDomain() => CashCount.fromQuantities({
    for (final line in lines)
      Denomination(
        denominationTypeFromApi(line.denominationType),
        _wholeFcfa(line.denomination),
      ): line.quantity,
  });
}

/// Montant entier en FCFA d'une chaîne décimale (« 10000.00 » → 10000).
int _wholeFcfa(String value) {
  final amount = Decimal.parse(value);
  if (!amount.isInteger) {
    throw FormatException('Coupure non entière : $value');
  }
  return amount.toBigInt().toInt();
}

/// Convertit un détail de session serveur → domaine.
extension CashSessionDetailDtoToDomain on CashSessionDetailDto {
  /// Convertit le DTO en [CashSessionDetail] ; le recalcul serveur de la
  /// session est celui du résumé.
  CashSessionDetail toDomain() => CashSessionDetail(
    session: session.toDomain(serverRecalculated: summary.serverRecalculated),
    summary: summary.toDomain(),
    movements: [for (final m in movements) m.toDomain()],
    openingCount: openingCount?.toDomain(),
    closingCount: closingCount?.toDomain(),
  );
}

/// Convertit une page d'historique serveur → domaine.
extension CashSessionPageDtoToDomain on CashSessionPageDto {
  /// Convertit le DTO en [CashSessionPage].
  CashSessionPage toDomain() => CashSessionPage(
    items: [for (final s in items) s.toDomain()],
    nextCursor: nextCursor,
    hasMore: hasMore,
  );
}
