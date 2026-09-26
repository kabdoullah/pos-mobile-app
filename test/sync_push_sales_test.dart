import 'dart:ffi';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_models/sync_responses_dto.dart';
import 'package:mobile/core/sync/push_service.dart';
import 'package:mobile/core/sync/sync_queue_repository.dart';
import 'package:mobile/core/sync/sync_remote_datasource.dart';
import 'package:mobile/database/app_database.dart';
import 'package:mobile/features/sales/data/repositories/sales_repository_impl.dart';
import 'package:mobile/features/sales/domain/entities/cart_item.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart' as domain;
import 'package:mocktail/mocktail.dart';
import 'package:sqlite3/open.dart';

class MockSyncRemoteDataSource extends Mock implements SyncRemoteDataSource {}

void main() {
  late AppDatabase db;
  late SyncQueueRepository queue;
  late SalesRepositoryImpl salesRepository;
  late MockSyncRemoteDataSource remote;
  late PushService pushService;

  setUpAll(() {
    // Le host Linux expose libsqlite3.so.0 ; drift cherche libsqlite3.so.
    if (Platform.isLinux) {
      open.overrideFor(
        OperatingSystem.linux,
        () => DynamicLibrary.open('libsqlite3.so.0'),
      );
    }
    registerFallbackValue(const SalesSyncBatchRequestDto(sales: []));
  });

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    queue = SyncQueueRepository(db: db);
    salesRepository = SalesRepositoryImpl(db: db, syncQueue: queue, dio: Dio());
    remote = MockSyncRemoteDataSource();
    pushService = PushService(
      remoteDataSource: remote,
      queueRepository: queue,
      db: db,
    );
  });

  tearDown(() async {
    await db.close();
  });

  /// Crée une vente locale (hors ligne) : numéro provisoire 0 + entrée de file.
  Future<domain.Sale> createOfflineSale() {
    return salesRepository.createSale(
      items: [
        CartItem(
          productId: 'p1',
          productName: 'Café',
          unitPrice: Decimal.parse('1500'),
          quantity: 1,
        ),
      ],
      totalAmount: Decimal.parse('1500'),
      vatAmount: Decimal.zero,
      paymentMethod: domain.PaymentMethod.cash,
    );
  }

  void stubPushResult(String saleId, {required int? receiptNumber}) {
    when(() => remote.pushSales(any())).thenAnswer(
      (_) async => SalesSyncBatchResponseDto(
        processed: 1,
        results: [
          SaleSyncResultDto(
            id: saleId,
            status: 'created',
            receiptNumber: receiptNumber,
          ),
        ],
      ),
    );
  }

  test('le push remplace le numéro provisoire par celui du serveur', () async {
    final sale = await createOfflineSale();
    expect(sale.receiptNumber, 0);
    stubPushResult(sale.id, receiptNumber: 42);

    // Le stream émet 0 puis le numéro attribué par le serveur.
    final numbers = salesRepository
        .watchSale(sale.id)
        .map((s) => s?.receiptNumber)
        .take(2)
        .toList();
    await Future<void>.delayed(Duration.zero);

    await pushService.pushPendingSales();

    expect(await numbers, [0, 42]);
    final entry = (await db.select(db.syncQueue).get()).single;
    expect(entry.status, 'synced');
  });

  test('sans numéro dans la réponse, la vente reste provisoire', () async {
    final sale = await createOfflineSale();
    stubPushResult(sale.id, receiptNumber: null);

    await pushService.pushPendingSales();

    expect((await salesRepository.getSale(sale.id))!.receiptNumber, 0);
    final entry = (await db.select(db.syncQueue).get()).single;
    expect(entry.status, 'synced');
  });
}
