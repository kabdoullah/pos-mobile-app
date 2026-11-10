import 'package:decimal/decimal.dart';

import '../../../../database/app_database.dart' as drift_db;
import '../../../returns/domain/entities/sale_return.dart';
import '../../../sales/domain/entities/sale.dart';
import '../../domain/entities/cash_labels.dart';
import '../../domain/entities/cash_movement.dart';
import '../../domain/entities/cash_session.dart';

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

/// Corps de `POST /cash-sessions` (api.md, « Ouverture »).
Map<String, dynamic> cashSessionOpenPayload({
  required String id,
  required String deviceId,
  required Decimal openingAmount,
  required String? openingNote,
  required DateTime openedAt,
}) => {
  'id': id,
  'device_id': deviceId,
  'opening_amount': openingAmount.toString(),
  'opening_note': openingNote,
  'opened_at': openedAt.toUtc().toIso8601String(),
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
}) => {
  'session_id': sessionId,
  'counted_amount': countedAmount.toString(),
  'client_expected_amount': clientExpectedAmount.toString(),
  'closing_note': closingNote,
  'closed_at': closedAt.toUtc().toIso8601String(),
};
