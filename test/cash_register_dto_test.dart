import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_models/cash_session_dto.dart';
import 'package:mobile/features/cash_register/data/models/cash_mappers.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_movement.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_session.dart';

/// `CashSessionResponse` d'api.md (session clôturée).
Map<String, dynamic> closedSessionJson() => {
  'id': 's1',
  'device_id': 'device-1',
  'status': 'closed',
  'opening_amount': '25000.00',
  'opening_note': 'Fond de caisse lundi',
  'opened_at': '2026-11-10T07:58:12Z',
  'opened_by': 'u1',
  'expected_amount': '61500.00',
  'client_expected_amount': '61500.00',
  'counted_amount': '61000.00',
  'discrepancy_amount': '-500.00',
  'closing_note': 'Manque 500, monnaie rendue en trop',
  'closed_at': '2026-11-10T19:02:40Z',
  'closed_by': 'u1',
};

/// `CashMovementResponse` d'api.md.
Map<String, dynamic> movementJson() => {
  'id': 'm1',
  'session_id': 's1',
  'type': 'cash_out',
  'reason': 'supplies',
  'amount': '3500.00',
  'note': 'Sachets',
  'created_at': '2026-11-10T11:20:00Z',
  'created_by': 'u1',
  'synced_at': '2026-11-10T11:20:05Z',
};

/// `CashSessionDetailResponse` d'api.md ; `late_impact` et `cash_refunds`
/// reviennent `"0"` (total nul du résumé).
Map<String, dynamic> closedDetailJson() => {
  'session': closedSessionJson(),
  'summary': {
    'opening_amount': '25000.00',
    'cash_sales': '48000.00',
    'cash_sales_count': 23,
    'mobile_money_sales': '31000.00',
    'cash_in': '5000.00',
    'cash_out': '14500.00',
    'cash_refunds': '0',
    'expected_amount': '61500.00',
    'late_impact': '0',
    'server_recalculated': false,
  },
  'movements': [movementJson()],
};

void main() {
  Decimal d(String v) => Decimal.parse(v);

  test('dto parses api.md examples', () {
    final dto = CashSessionDetailDto.fromJson(closedDetailJson());

    expect(dto.session.id, 's1');
    expect(dto.session.deviceId, 'device-1');
    expect(dto.session.openingAmount, '25000.00');
    expect(dto.session.discrepancyAmount, '-500.00');
    expect(dto.session.closedBy, 'u1');
    expect(dto.summary.cashSalesCount, 23);
    expect(dto.summary.lateImpact, '0');
    expect(dto.summary.serverRecalculated, isFalse);
    expect(dto.movements.single.sessionId, 's1');
    expect(dto.movements.single.syncedAt, '2026-11-10T11:20:05Z');

    final detail = dto.toDomain();
    expect(detail.session.status, CashSessionStatus.closed);
    expect(detail.session.syncStatus, CashSyncStatus.synced);
    // "25000.00" et "25000" sont la même valeur en Decimal.
    expect(detail.session.openingAmount, d('25000'));
    expect(detail.session.expectedAmount, d('61500'));
    expect(detail.session.countedAmount, d('61000'));
    expect(detail.session.discrepancyAmount, d('-500'));
    expect(detail.session.closedAt, DateTime.utc(2026, 11, 10, 19, 2, 40));
    expect(detail.session.openedAt.isUtc, isTrue);
    expect(detail.session.serverRecalculated, isFalse);
    expect(detail.summary.cashRefunds, Decimal.zero);
    expect(detail.summary.lateImpact, Decimal.zero);
    expect(detail.summary.cashSales, d('48000'));
    expect(detail.summary.cashSalesCount, 23);
    expect(detail.summary.mobileMoneySales, d('31000'));
    expect(detail.summary.expectedAmount, d('61500'));
    final movement = detail.movements.single;
    expect(movement.type, CashMovementType.cashOut);
    expect(movement.reason, CashMovementReason.supplies);
    expect(movement.amount, d('3500'));
    expect(movement.syncStatus, CashSyncStatus.synced);
  });

  test('open session: closing fields are null', () {
    final json = closedSessionJson()
      ..['status'] = 'open'
      ..['opening_note'] = null
      ..['opened_by'] = null
      ..['expected_amount'] = null
      ..['client_expected_amount'] = null
      ..['counted_amount'] = null
      ..['discrepancy_amount'] = null
      ..['closing_note'] = null
      ..['closed_at'] = null
      ..['closed_by'] = null;

    final session = CashSessionDto.fromJson(json).toDomain();

    expect(session.status, CashSessionStatus.open);
    expect(session.expectedAmount, isNull);
    expect(session.closedAt, isNull);
    expect(session.serverRecalculated, isFalse);
  });

  test('server_recalculated summary and negative amounts', () {
    final json = closedDetailJson();
    (json['session'] as Map<String, dynamic>)['client_expected_amount'] =
        '62000';
    (json['summary'] as Map<String, dynamic>)
      ..['server_recalculated'] = true
      ..['late_impact'] = '-2000.00';

    final detail = CashSessionDetailDto.fromJson(json).toDomain();

    expect(detail.summary.serverRecalculated, isTrue);
    expect(detail.session.serverRecalculated, isTrue);
    expect(detail.summary.lateImpact, d('-2000'));
    expect(detail.session.clientExpectedAmount, d('62000'));
  });

  test('history page parses items, cursor and has_more', () {
    final json = closedSessionJson()..['client_expected_amount'] = '62000.00';
    final page = CashSessionPageDto.fromJson({
      'items': [json],
      'next_cursor': 'abc',
      'has_more': true,
    }).toDomain();

    expect(page.items.single.id, 's1');
    // Sans résumé, l'écart figé / client donne le recalcul serveur.
    expect(page.items.single.serverRecalculated, isTrue);
    expect(page.nextCursor, 'abc');
    expect(page.hasMore, isTrue);

    final last = CashSessionPageDto.fromJson({
      'items': <Object>[],
      'next_cursor': null,
      'has_more': false,
    }).toDomain();
    expect(last.items, isEmpty);
    expect(last.nextCursor, isNull);
  });

  test('request DTOs serialize api.md bodies', () {
    expect(
      const CashSessionOpenRequestDto(
        id: 's1',
        deviceId: 'device-1',
        openingAmount: '25000',
        openingNote: 'Fond de caisse lundi',
        openedAt: '2026-11-10T07:58:12Z',
      ).toJson(),
      {
        'id': 's1',
        'device_id': 'device-1',
        'opening_amount': '25000',
        'opening_note': 'Fond de caisse lundi',
        'opened_at': '2026-11-10T07:58:12Z',
      },
    );
    expect(
      const CashMovementCreateRequestDto(
        id: 'm1',
        type: 'cash_out',
        reason: 'supplies',
        amount: '3500',
        note: 'Sachets',
        createdAt: '2026-11-10T11:20:00Z',
      ).toJson(),
      {
        'id': 'm1',
        'type': 'cash_out',
        'reason': 'supplies',
        'amount': '3500',
        'note': 'Sachets',
        'created_at': '2026-11-10T11:20:00Z',
      },
    );
    expect(
      const CashSessionCloseRequestDto(
        countedAmount: '61000',
        clientExpectedAmount: '-1500',
        closingNote: 'Manque',
        closedAt: '2026-11-10T19:02:40Z',
      ).toJson(),
      {
        'counted_amount': '61000',
        'client_expected_amount': '-1500',
        'closing_note': 'Manque',
        'closed_at': '2026-11-10T19:02:40Z',
      },
    );
  });
}
