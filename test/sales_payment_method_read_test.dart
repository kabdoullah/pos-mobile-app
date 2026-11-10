import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/sync/sync_queue_repository.dart';
import 'package:mobile/database/app_database.dart';
import 'package:mobile/features/returns/domain/entities/sale_return.dart';
import 'package:mobile/features/returns/presentation/providers/returns_providers.dart';
import 'package:mobile/features/sales/data/repositories/sales_repository_impl.dart';
import 'package:mobile/features/sales/domain/entities/cart_item.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart' as domain;

/// Une vente créée sur l'appareil stocke le nom du domaine (`wave`), une vente
/// reçue au pull la valeur de l'API (`mobile_money_wave`) : la relecture
/// accepte les deux.
void main() {
  late AppDatabase db;
  late SalesRepositoryImpl repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = SalesRepositoryImpl(
      db: db,
      syncQueue: SyncQueueRepository(db: db),
      dio: Dio(),
    );
  });

  tearDown(() => db.close());

  Future<domain.Sale> createLocal(domain.PaymentMethod method) =>
      repository.createSale(
        items: [
          CartItem(
            productId: 'p1',
            productName: 'Savon',
            unitPrice: Decimal.parse('500'),
            quantity: 1,
          ),
        ],
        totalAmount: Decimal.parse('500'),
        vatAmount: Decimal.zero,
        paymentMethod: method,
      );

  test('local Wave sale reads back as Wave, refunded by Wave', () async {
    final created = await createLocal(domain.PaymentMethod.wave);

    final read = await repository.getSale(created.id);

    expect(read!.paymentMethod, domain.PaymentMethod.wave);
    expect(defaultRefundMethod(read.paymentMethod), RefundMethod.wave);
  });

  for (final method in [
    domain.PaymentMethod.orangeMoney,
    domain.PaymentMethod.mtn,
    domain.PaymentMethod.mixed,
  ]) {
    test('local ${method.name} sale reads back unchanged', () async {
      final created = await createLocal(method);

      expect((await repository.getSale(created.id))!.paymentMethod, method);
    });
  }

  test('pulled API value still reads back (mobile_money_wave)', () async {
    await db
        .into(db.sales)
        .insert(
          SalesCompanion.insert(
            id: 'pulled',
            receiptNumber: 3,
            totalAmount: '500',
            vatAmount: '0',
            paymentMethod: 'mobile_money_wave',
            createdAt: DateTime.utc(2026, 11, 10),
          ),
        );

    expect(
      (await repository.getSale('pulled'))!.paymentMethod,
      domain.PaymentMethod.wave,
    );
  });
}
