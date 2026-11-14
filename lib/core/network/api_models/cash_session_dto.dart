import 'package:freezed_annotation/freezed_annotation.dart';

part 'cash_session_dto.freezed.dart';
part 'cash_session_dto.g.dart';

// Sessions de caisse (api.md, « Sessions de caisse »). Montants en chaînes
// décimales : `"25000.00"`, parfois `"0"`, éventuellement négatifs. Ils sont
// parsés en Decimal dans les mappers, jamais comparés en chaîne.

/// Session de caisse renvoyée par le serveur (`CashSessionResponse`).
@freezed
sealed class CashSessionDto with _$CashSessionDto {
  /// Crée un [CashSessionDto].
  const factory CashSessionDto({
    required String id,
    @JsonKey(name: 'device_id') required String deviceId,
    // 'open' ou 'closed'.
    required String status,
    @JsonKey(name: 'opening_amount') required String openingAmount,
    @JsonKey(name: 'opening_note') String? openingNote,
    @JsonKey(name: 'opened_at') required String openedAt,
    @JsonKey(name: 'opened_by') String? openedBy,
    // Champs de clôture : null tant que la session est ouverte.
    @JsonKey(name: 'expected_amount') String? expectedAmount,
    @JsonKey(name: 'client_expected_amount') String? clientExpectedAmount,
    @JsonKey(name: 'counted_amount') String? countedAmount,
    @JsonKey(name: 'discrepancy_amount') String? discrepancyAmount,
    @JsonKey(name: 'closing_note') String? closingNote,
    @JsonKey(name: 'closed_at') String? closedAt,
    @JsonKey(name: 'closed_by') String? closedBy,
  }) = _CashSessionDto;

  factory CashSessionDto.fromJson(Map<String, dynamic> json) =>
      _$CashSessionDtoFromJson(json);
}

/// Mouvement d'espèces renvoyé par le serveur (`CashMovementResponse`).
@freezed
sealed class CashMovementDto with _$CashMovementDto {
  /// Crée un [CashMovementDto].
  const factory CashMovementDto({
    required String id,
    @JsonKey(name: 'session_id') required String sessionId,
    // 'cash_in' ou 'cash_out'.
    required String type,
    required String reason,
    required String amount,
    String? note,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'synced_at') required String syncedAt,
  }) = _CashMovementDto;

  factory CashMovementDto.fromJson(Map<String, dynamic> json) =>
      _$CashMovementDtoFromJson(json);
}

/// Composantes du solde théorique calculées par le serveur (`CashSummary`).
@freezed
sealed class CashSummaryDto with _$CashSummaryDto {
  /// Crée un [CashSummaryDto].
  const factory CashSummaryDto({
    @JsonKey(name: 'opening_amount') required String openingAmount,
    @JsonKey(name: 'cash_sales') required String cashSales,
    @JsonKey(name: 'cash_sales_count') required int cashSalesCount,
    @JsonKey(name: 'mobile_money_sales') required String mobileMoneySales,
    @JsonKey(name: 'cash_in') required String cashIn,
    @JsonKey(name: 'cash_out') required String cashOut,
    @JsonKey(name: 'cash_refunds') required String cashRefunds,
    @JsonKey(name: 'expected_amount') required String expectedAmount,
    @JsonKey(name: 'late_impact') required String lateImpact,
    @JsonKey(name: 'server_recalculated') required bool serverRecalculated,
  }) = _CashSummaryDto;

  factory CashSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$CashSummaryDtoFromJson(json);
}

/// Ligne de billetterie enregistrée par le serveur (ADR-0016).
@freezed
sealed class CashCountLineDto with _$CashCountLineDto {
  /// Crée un [CashCountLineDto].
  const factory CashCountLineDto({
    // 'bill' ou 'coin'.
    @JsonKey(name: 'denomination_type') required String denominationType,
    // Montant décimal en chaîne (« 10000.00 »).
    required String denomination,
    required int quantity,
    required String subtotal,
  }) = _CashCountLineDto;

  factory CashCountLineDto.fromJson(Map<String, dynamic> json) =>
      _$CashCountLineDtoFromJson(json);
}

/// Comptage d'une opération (`CashCountResponse`), totaux recalculés par le
/// serveur.
@freezed
sealed class CashCountDto with _$CashCountDto {
  /// Crée un [CashCountDto].
  const factory CashCountDto({
    required List<CashCountLineDto> lines,
    @JsonKey(name: 'bills_total') required String billsTotal,
    @JsonKey(name: 'coins_total') required String coinsTotal,
    required String total,
  }) = _CashCountDto;

  factory CashCountDto.fromJson(Map<String, dynamic> json) =>
      _$CashCountDtoFromJson(json);
}

/// Session, résumé, mouvements et billetterie (`CashSessionDetailResponse`).
@freezed
sealed class CashSessionDetailDto with _$CashSessionDetailDto {
  /// Crée un [CashSessionDetailDto].
  const factory CashSessionDetailDto({
    required CashSessionDto session,
    required CashSummaryDto summary,
    // Du plus récent au plus ancien.
    required List<CashMovementDto> movements,
    // Billetterie (ADR-0016) : null sans comptage détaillé (mode « Total
    // seulement », serveur antérieur).
    @JsonKey(name: 'opening_count') CashCountDto? openingCount,
    @JsonKey(name: 'closing_count') CashCountDto? closingCount,
  }) = _CashSessionDetailDto;

  factory CashSessionDetailDto.fromJson(Map<String, dynamic> json) =>
      _$CashSessionDetailDtoFromJson(json);
}

/// Page de l'historique des sessions (`CursorPage[CashSessionResponse]`).
@freezed
sealed class CashSessionPageDto with _$CashSessionPageDto {
  /// Crée un [CashSessionPageDto].
  const factory CashSessionPageDto({
    required List<CashSessionDto> items,
    // Jeton opaque, renvoyé tel quel dans `?cursor=`.
    @JsonKey(name: 'next_cursor') String? nextCursor,
    @JsonKey(name: 'has_more') required bool hasMore,
  }) = _CashSessionPageDto;

  factory CashSessionPageDto.fromJson(Map<String, dynamic> json) =>
      _$CashSessionPageDtoFromJson(json);
}

/// Corps de `POST /api/v1/cash-sessions` (`CashSessionOpen`).
@freezed
sealed class CashSessionOpenRequestDto with _$CashSessionOpenRequestDto {
  /// Crée un [CashSessionOpenRequestDto].
  const factory CashSessionOpenRequestDto({
    required String id,
    @JsonKey(name: 'device_id') required String deviceId,
    @JsonKey(name: 'opening_amount') required String openingAmount,
    @JsonKey(name: 'opening_note') String? openingNote,
    @JsonKey(name: 'opened_at') required String openedAt,
    // Billetterie (ADR-0016), absente en mode « Total seulement » et dans les
    // entrées mises en file par une version antérieure.
    @JsonKey(name: 'opening_count', includeIfNull: false)
    List<CashCountLineRequestDto>? openingCount,
  }) = _CashSessionOpenRequestDto;

  factory CashSessionOpenRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CashSessionOpenRequestDtoFromJson(json);
}

/// Corps de `POST /api/v1/cash-sessions/{id}/movements`
/// (`CashMovementCreate`).
@freezed
sealed class CashMovementCreateRequestDto with _$CashMovementCreateRequestDto {
  /// Crée un [CashMovementCreateRequestDto].
  const factory CashMovementCreateRequestDto({
    required String id,
    required String type,
    required String reason,
    required String amount,
    String? note,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _CashMovementCreateRequestDto;

  factory CashMovementCreateRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CashMovementCreateRequestDtoFromJson(json);
}

/// Corps de `POST /api/v1/cash-sessions/{id}/close` (`CashSessionClose`).
@freezed
sealed class CashSessionCloseRequestDto with _$CashSessionCloseRequestDto {
  /// Crée un [CashSessionCloseRequestDto].
  const factory CashSessionCloseRequestDto({
    @JsonKey(name: 'counted_amount') required String countedAmount,
    // Peut être négatif ; traçabilité seulement, le serveur recalcule.
    @JsonKey(name: 'client_expected_amount')
    required String clientExpectedAmount,
    @JsonKey(name: 'closing_note') String? closingNote,
    // Persisté à la clôture locale, renvoyé à l'identique à chaque retry.
    @JsonKey(name: 'closed_at') required String closedAt,
    // Billetterie (ADR-0016), facultative comme à l'ouverture.
    @JsonKey(name: 'closing_count', includeIfNull: false)
    List<CashCountLineRequestDto>? closingCount,
  }) = _CashSessionCloseRequestDto;

  factory CashSessionCloseRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CashSessionCloseRequestDtoFromJson(json);
}

/// Ligne de billetterie envoyée au serveur : entiers JSON, le serveur
/// recalcule les sous-totaux.
@freezed
sealed class CashCountLineRequestDto with _$CashCountLineRequestDto {
  /// Crée un [CashCountLineRequestDto].
  const factory CashCountLineRequestDto({
    @JsonKey(name: 'denomination_type') required String denominationType,
    required int denomination,
    required int quantity,
  }) = _CashCountLineRequestDto;

  factory CashCountLineRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CashCountLineRequestDtoFromJson(json);
}
