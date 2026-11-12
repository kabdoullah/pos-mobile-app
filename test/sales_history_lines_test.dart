import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/sync/sync_queue_repository.dart';
import 'package:mobile/database/app_database.dart';
import 'package:mobile/features/sales/data/repositories/sales_repository_impl.dart';
import 'package:mobile/features/sales/domain/entities/cart_item.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart' as domain;

/// Lignes des ventes d'une période, par vente : aperçu des articles et
/// recherche par produit dans l'historique.
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

  CartItem item(String name, int quantity) => CartItem(
    productId: name,
    productName: name,
    unitPrice: Decimal.parse('500'),
    quantity: quantity,
  );

  Future<domain.Sale> create(List<CartItem> items) => repository.createSale(
    items: items,
    totalAmount: Decimal.parse('500'),
    vatAmount: Decimal.zero,
    paymentMethod: domain.PaymentMethod.cash,
  );

  test('groupe les lignes du jour par vente', () async {
    final first = await create([item('Savon', 2), item('Riz', 1)]);
    final second = await create([item('Riz', 5)]);
    final today = DateTime.now();

    final lines = await repository
        .watchSaleLinesByDateRange(today, today)
        .first;

    expect(lines.keys, unorderedEquals([first.id, second.id]));
    expect(
      lines[first.id],
      unorderedEquals([
        (productName: 'Savon', quantity: 2),
        (productName: 'Riz', quantity: 1),
      ]),
    );
    expect(lines[second.id], [(productName: 'Riz', quantity: 5)]);
  });

  test('ignore les ventes hors période', () async {
    await create([item('Savon', 1)]);
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    final lines = await repository
        .watchSaleLinesByDateRange(yesterday, yesterday)
        .first;

    expect(lines, isEmpty);
  });
}
