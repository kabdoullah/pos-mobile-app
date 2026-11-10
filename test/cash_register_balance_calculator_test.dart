import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/cash_register/domain/cash_balance_calculator.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_movement.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_session.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_summary.dart';
import 'package:mobile/features/returns/domain/entities/sale_return.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart';

Decimal d(String v) => Decimal.parse(v);

CashMovement movement(CashMovementType type, String amount) => CashMovement(
  id: 'm-$type-$amount',
  sessionId: 's1',
  type: type,
  reason: type == CashMovementType.cashIn
      ? CashMovementReason.topUp
      : CashMovementReason.expense,
  amount: d(amount),
  createdAt: DateTime.utc(2026, 11, 10),
  syncStatus: CashSyncStatus.pending,
);

void main() {
  const calculator = CashBalanceCalculator();
  final opening = d('10000');

  CashSummary run({
    List<CashSaleLine> sales = const [],
    List<CashMovement> movements = const [],
    List<CashRefundLine> refunds = const [],
  }) => calculator.summarize(
    openingAmount: opening,
    sales: sales,
    movements: movements,
    refunds: refunds,
  );

  test('no operations -> 10000', () {
    expect(run().expectedAmount, d('10000'));
  });

  test('cash sale 3000 -> 13000', () {
    final s = run(
      sales: [
        CashSaleLine(paymentMethod: PaymentMethod.cash, totalAmount: d('3000')),
      ],
    );
    expect(s.expectedAmount, d('13000'));
    expect(s.cashSales, d('3000'));
    expect(s.cashSalesCount, 1);
  });

  test('wave sale 5000 excluded, mobileMoneySales 5000', () {
    final s = run(
      sales: [
        CashSaleLine(paymentMethod: PaymentMethod.wave, totalAmount: d('5000')),
      ],
    );
    expect(s.expectedAmount, d('10000'));
    expect(s.mobileMoneySales, d('5000'));
    expect(s.cashSalesCount, 0);
  });

  test('mixed 8000 (cash 3000) -> 13000', () {
    final s = run(
      sales: [
        CashSaleLine(
          paymentMethod: PaymentMethod.mixed,
          totalAmount: d('8000'),
          cashAmount: d('3000'),
        ),
      ],
    );
    expect(s.expectedAmount, d('13000'));
    expect(s.cashSalesCount, 1);
  });

  test('in 5000 / out 3500 -> 11500', () {
    final s = run(
      movements: [
        movement(CashMovementType.cashIn, '5000'),
        movement(CashMovementType.cashOut, '3500'),
      ],
    );
    expect(s.expectedAmount, d('11500'));
    expect(s.cashIn, d('5000'));
    expect(s.cashOut, d('3500'));
  });

  test('cash refund 1000 counted, orange refund 500 not', () {
    final s = run(
      refunds: [
        CashRefundLine(
          refundMethod: RefundMethod.cash,
          refundAmount: d('1000'),
          rejected: false,
        ),
        CashRefundLine(
          refundMethod: RefundMethod.orangeMoney,
          refundAmount: d('500'),
          rejected: false,
        ),
      ],
    );
    expect(s.cashRefunds, d('1000'));
    expect(s.expectedAmount, d('9000'));
  });

  test('rejected cash refund 2000 not counted, rejectedCashRefunds 2000', () {
    final s = run(
      refunds: [
        CashRefundLine(
          refundMethod: RefundMethod.cash,
          refundAmount: d('2000'),
          rejected: true,
        ),
      ],
    );
    expect(s.cashRefunds, Decimal.zero);
    expect(s.rejectedCashRefunds, d('2000'));
    expect(s.expectedAmount, d('10000'));
  });

  test('refund bigger than drawer gives negative balance (-2000)', () {
    final s = run(
      refunds: [
        CashRefundLine(
          refundMethod: RefundMethod.cash,
          refundAmount: d('12000'),
          rejected: false,
        ),
      ],
    );
    expect(s.expectedAmount, d('-2000'));
  });

  test('decimal amounts 1500.50', () {
    final s = run(
      sales: [
        CashSaleLine(
          paymentMethod: PaymentMethod.cash,
          totalAmount: d('1500.50'),
        ),
      ],
    );
    expect(s.expectedAmount, d('11500.5'));
  });

  test('allowedFor matches the API rules', () {
    expect(CashMovementReason.allowedFor(CashMovementType.cashIn), [
      CashMovementReason.topUp,
      CashMovementReason.float,
      CashMovementReason.other,
    ]);
    expect(CashMovementReason.allowedFor(CashMovementType.cashOut), [
      CashMovementReason.expense,
      CashMovementReason.withdrawal,
      CashMovementReason.supplies,
      CashMovementReason.other,
    ]);
  });
}
