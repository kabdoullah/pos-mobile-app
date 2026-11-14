// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_session_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CashSessionDto _$CashSessionDtoFromJson(Map<String, dynamic> json) =>
    _CashSessionDto(
      id: json['id'] as String,
      deviceId: json['device_id'] as String,
      status: json['status'] as String,
      openingAmount: json['opening_amount'] as String,
      openingNote: json['opening_note'] as String?,
      openedAt: json['opened_at'] as String,
      openedBy: json['opened_by'] as String?,
      expectedAmount: json['expected_amount'] as String?,
      clientExpectedAmount: json['client_expected_amount'] as String?,
      countedAmount: json['counted_amount'] as String?,
      discrepancyAmount: json['discrepancy_amount'] as String?,
      closingNote: json['closing_note'] as String?,
      closedAt: json['closed_at'] as String?,
      closedBy: json['closed_by'] as String?,
    );

Map<String, dynamic> _$CashSessionDtoToJson(_CashSessionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'device_id': instance.deviceId,
      'status': instance.status,
      'opening_amount': instance.openingAmount,
      'opening_note': instance.openingNote,
      'opened_at': instance.openedAt,
      'opened_by': instance.openedBy,
      'expected_amount': instance.expectedAmount,
      'client_expected_amount': instance.clientExpectedAmount,
      'counted_amount': instance.countedAmount,
      'discrepancy_amount': instance.discrepancyAmount,
      'closing_note': instance.closingNote,
      'closed_at': instance.closedAt,
      'closed_by': instance.closedBy,
    };

_CashMovementDto _$CashMovementDtoFromJson(Map<String, dynamic> json) =>
    _CashMovementDto(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      type: json['type'] as String,
      reason: json['reason'] as String,
      amount: json['amount'] as String,
      note: json['note'] as String?,
      createdAt: json['created_at'] as String,
      createdBy: json['created_by'] as String?,
      syncedAt: json['synced_at'] as String,
    );

Map<String, dynamic> _$CashMovementDtoToJson(_CashMovementDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.sessionId,
      'type': instance.type,
      'reason': instance.reason,
      'amount': instance.amount,
      'note': instance.note,
      'created_at': instance.createdAt,
      'created_by': instance.createdBy,
      'synced_at': instance.syncedAt,
    };

_CashSummaryDto _$CashSummaryDtoFromJson(Map<String, dynamic> json) =>
    _CashSummaryDto(
      openingAmount: json['opening_amount'] as String,
      cashSales: json['cash_sales'] as String,
      cashSalesCount: (json['cash_sales_count'] as num).toInt(),
      mobileMoneySales: json['mobile_money_sales'] as String,
      cashIn: json['cash_in'] as String,
      cashOut: json['cash_out'] as String,
      cashRefunds: json['cash_refunds'] as String,
      expectedAmount: json['expected_amount'] as String,
      lateImpact: json['late_impact'] as String,
      serverRecalculated: json['server_recalculated'] as bool,
    );

Map<String, dynamic> _$CashSummaryDtoToJson(_CashSummaryDto instance) =>
    <String, dynamic>{
      'opening_amount': instance.openingAmount,
      'cash_sales': instance.cashSales,
      'cash_sales_count': instance.cashSalesCount,
      'mobile_money_sales': instance.mobileMoneySales,
      'cash_in': instance.cashIn,
      'cash_out': instance.cashOut,
      'cash_refunds': instance.cashRefunds,
      'expected_amount': instance.expectedAmount,
      'late_impact': instance.lateImpact,
      'server_recalculated': instance.serverRecalculated,
    };

_CashCountLineDto _$CashCountLineDtoFromJson(Map<String, dynamic> json) =>
    _CashCountLineDto(
      denominationType: json['denomination_type'] as String,
      denomination: json['denomination'] as String,
      quantity: (json['quantity'] as num).toInt(),
      subtotal: json['subtotal'] as String,
    );

Map<String, dynamic> _$CashCountLineDtoToJson(_CashCountLineDto instance) =>
    <String, dynamic>{
      'denomination_type': instance.denominationType,
      'denomination': instance.denomination,
      'quantity': instance.quantity,
      'subtotal': instance.subtotal,
    };

_CashCountDto _$CashCountDtoFromJson(Map<String, dynamic> json) =>
    _CashCountDto(
      lines: (json['lines'] as List<dynamic>)
          .map((e) => CashCountLineDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      billsTotal: json['bills_total'] as String,
      coinsTotal: json['coins_total'] as String,
      total: json['total'] as String,
    );

Map<String, dynamic> _$CashCountDtoToJson(_CashCountDto instance) =>
    <String, dynamic>{
      'lines': instance.lines,
      'bills_total': instance.billsTotal,
      'coins_total': instance.coinsTotal,
      'total': instance.total,
    };

_CashSessionDetailDto _$CashSessionDetailDtoFromJson(
  Map<String, dynamic> json,
) => _CashSessionDetailDto(
  session: CashSessionDto.fromJson(json['session'] as Map<String, dynamic>),
  summary: CashSummaryDto.fromJson(json['summary'] as Map<String, dynamic>),
  movements: (json['movements'] as List<dynamic>)
      .map((e) => CashMovementDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  openingCount: json['opening_count'] == null
      ? null
      : CashCountDto.fromJson(json['opening_count'] as Map<String, dynamic>),
  closingCount: json['closing_count'] == null
      ? null
      : CashCountDto.fromJson(json['closing_count'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CashSessionDetailDtoToJson(
  _CashSessionDetailDto instance,
) => <String, dynamic>{
  'session': instance.session,
  'summary': instance.summary,
  'movements': instance.movements,
  'opening_count': instance.openingCount,
  'closing_count': instance.closingCount,
};

_CashSessionPageDto _$CashSessionPageDtoFromJson(Map<String, dynamic> json) =>
    _CashSessionPageDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => CashSessionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
      hasMore: json['has_more'] as bool,
    );

Map<String, dynamic> _$CashSessionPageDtoToJson(_CashSessionPageDto instance) =>
    <String, dynamic>{
      'items': instance.items,
      'next_cursor': instance.nextCursor,
      'has_more': instance.hasMore,
    };

_CashSessionOpenRequestDto _$CashSessionOpenRequestDtoFromJson(
  Map<String, dynamic> json,
) => _CashSessionOpenRequestDto(
  id: json['id'] as String,
  deviceId: json['device_id'] as String,
  openingAmount: json['opening_amount'] as String,
  openingNote: json['opening_note'] as String?,
  openedAt: json['opened_at'] as String,
  openingCount: (json['opening_count'] as List<dynamic>?)
      ?.map((e) => CashCountLineRequestDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CashSessionOpenRequestDtoToJson(
  _CashSessionOpenRequestDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'device_id': instance.deviceId,
  'opening_amount': instance.openingAmount,
  'opening_note': instance.openingNote,
  'opened_at': instance.openedAt,
  'opening_count': ?instance.openingCount,
};

_CashMovementCreateRequestDto _$CashMovementCreateRequestDtoFromJson(
  Map<String, dynamic> json,
) => _CashMovementCreateRequestDto(
  id: json['id'] as String,
  type: json['type'] as String,
  reason: json['reason'] as String,
  amount: json['amount'] as String,
  note: json['note'] as String?,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$CashMovementCreateRequestDtoToJson(
  _CashMovementCreateRequestDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'reason': instance.reason,
  'amount': instance.amount,
  'note': instance.note,
  'created_at': instance.createdAt,
};

_CashSessionCloseRequestDto _$CashSessionCloseRequestDtoFromJson(
  Map<String, dynamic> json,
) => _CashSessionCloseRequestDto(
  countedAmount: json['counted_amount'] as String,
  clientExpectedAmount: json['client_expected_amount'] as String,
  closingNote: json['closing_note'] as String?,
  closedAt: json['closed_at'] as String,
  closingCount: (json['closing_count'] as List<dynamic>?)
      ?.map((e) => CashCountLineRequestDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CashSessionCloseRequestDtoToJson(
  _CashSessionCloseRequestDto instance,
) => <String, dynamic>{
  'counted_amount': instance.countedAmount,
  'client_expected_amount': instance.clientExpectedAmount,
  'closing_note': instance.closingNote,
  'closed_at': instance.closedAt,
  'closing_count': ?instance.closingCount,
};

_CashCountLineRequestDto _$CashCountLineRequestDtoFromJson(
  Map<String, dynamic> json,
) => _CashCountLineRequestDto(
  denominationType: json['denomination_type'] as String,
  denomination: (json['denomination'] as num).toInt(),
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$CashCountLineRequestDtoToJson(
  _CashCountLineRequestDto instance,
) => <String, dynamic>{
  'denomination_type': instance.denominationType,
  'denomination': instance.denomination,
  'quantity': instance.quantity,
};
