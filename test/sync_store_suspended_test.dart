import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_models/category_dto.dart';
import 'package:mobile/core/network/api_models/sale_dto.dart';
import 'package:mobile/core/network/api_models/sale_return_dto.dart';
import 'package:mobile/core/network/api_models/sync_changes_dto.dart';
import 'package:mobile/core/network/api_models/sync_responses_dto.dart';
import 'package:mobile/core/sync/push_service.dart';
import 'package:mobile/core/sync/sync_queue_repository.dart';
import 'package:mobile/core/sync/sync_remote_datasource.dart';
import 'package:mobile/database/app_database.dart';
import 'package:mobile/features/cash_register/data/datasources/cash_register_remote_datasource.dart';
import 'package:mobile/features/cash_register/domain/repositories/cash_register_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements SyncRemoteDataSource {}

const _now = '2026-10-31T10:00:00Z';

/// Réponse du serveur pour une boutique suspendue par la plateforme.
DioException suspendedError() => DioException(
  requestOptions: RequestOptions(),
  response: Response<Object?>(
    requestOptions: RequestOptions(),
    statusCode: 403,
    data: {
      'detail': 'Store is suspended.',
      'code': 'STORE_SUSPENDED',
      'field': null,
      'details': {
        'support_contact': 'support@pos.ci',
        'support_whatsapp': '+2250700000000',
      },
    },
  ),
);

/// Une suspension est temporaire : rien de ce qui attend l'envoi ne doit être
/// refusé ni compté comme un échec, tout repart à la réactivation.
class _UnusedCashRemote extends Mock implements CashRegisterRemoteDataSource {}

class _UnusedCashRepository extends Mock implements CashRegisterRepository {}

void main() {
  late AppDatabase db;
  late SyncQueueRepository queue;
  late _MockRemote remote;
  late PushService push;

  setUpAll(() {
    registerFallbackValue(
      const SalesSyncBatchRequestDto(sales: <SaleCreateDto>[]),
    );
    registerFallbackValue(const ReturnsSyncBatchRequestDto(returns: []));
    registerFallbackValue(
      const CategorySyncItemDto(id: 'x', name: 'x', clientUpdatedAt: _now),
    );
    registerFallbackValue(
      const ProductSyncItemDto(
        id: 'x',
        name: 'x',
        sellingPrice: '0',
        clientUpdatedAt: _now,
      ),
    );
  });

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    queue = SyncQueueRepository(db: db);
    remote = _MockRemote();
    push = PushService(
      remoteDataSource: remote,
      cashRemoteDataSource: _UnusedCashRemote(),
      cashRegisterRepository: _UnusedCashRepository(),
      queueRepository: queue,
      db: db,
    );
  });

  tearDown(() => db.close());

  Future<SyncQueueData> entry() async =>
      (await db.select(db.syncQueue).get()).single;

  void expectKeptForLater(SyncQueueData e) {
    expect(e.status, 'pending');
    expect(e.retryCount, 0);
  }

  test('vente : reste en attente, sans essai compté', () async {
    await queue.enqueueSale(
      saleId: 's1',
      salePayload: const SaleCreateDto(
        id: 's1',
        items: [],
        totalAmount: '0',
        vatAmount: '0',
        paymentMethod: PaymentMethodDto.cash,
        createdAt: _now,
      ).toJson(),
    );
    when(() => remote.pushSales(any())).thenThrow(suspendedError());

    await push.pushPendingSales();

    expectKeptForLater(await entry());
  });

  test('produit : reste en attente au lieu d’être refusé', () async {
    await queue.enqueueProductChange(
      productId: 'p1',
      productPayload: const ProductSyncItemDto(
        id: 'p1',
        name: 'Savon',
        sellingPrice: '500',
        clientUpdatedAt: _now,
      ).toJson(),
    );
    when(() => remote.pushProduct(any())).thenThrow(suspendedError());

    await push.pushPendingProductChanges();

    expectKeptForLater(await entry());
  });

  test('catégorie : reste en attente au lieu d’être refusée', () async {
    await queue.enqueueCategoryChange(
      categoryId: 'c1',
      categoryPayload: const CategorySyncItemDto(
        id: 'c1',
        name: 'Boissons',
        clientUpdatedAt: _now,
      ).toJson(),
    );
    when(() => remote.pushCategory(any())).thenThrow(suspendedError());

    await push.pushPendingCategoryChanges();

    expectKeptForLater(await entry());
  });
}
