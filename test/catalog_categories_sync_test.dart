import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_models/category_dto.dart';
import 'package:mobile/core/network/api_models/product_dto.dart';
import 'package:mobile/core/network/api_models/sale_dto.dart';
import 'package:mobile/core/network/api_models/sync_changes_dto.dart';
import 'package:mobile/core/network/api_models/sync_responses_dto.dart';
import 'package:mobile/core/sync/pull_service.dart';
import 'package:mobile/core/sync/push_service.dart';
import 'package:mobile/core/sync/sync_queue_repository.dart';
import 'package:mobile/core/sync/sync_remote_datasource.dart';
import 'package:mobile/database/app_database.dart' hide Category;
import 'package:mobile/features/catalog/data/repositories/catalog_repository_impl.dart';
import 'package:mobile/features/catalog/domain/entities/category.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqlite3/open.dart';

class _MockRemote extends Mock implements SyncRemoteDataSource {}

const _now = '2026-09-27T10:00:00Z';

void main() {
  late AppDatabase db;
  late SyncQueueRepository queue;
  late CatalogRepositoryImpl catalog;
  late _MockRemote remote;
  late PushService push;
  late PullService pull;

  setUpAll(() {
    if (Platform.isLinux) {
      open.overrideFor(
        OperatingSystem.linux,
        () => DynamicLibrary.open('libsqlite3.so.0'),
      );
    }
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
    catalog = CatalogRepositoryImpl(db: db, syncQueue: queue, dio: Dio());
    remote = _MockRemote();
    push = PushService(
      remoteDataSource: remote,
      queueRepository: queue,
      db: db,
    );
    pull = PullService(
      remoteDataSource: remote,
      db: db,
      queueRepository: queue,
    );
  });

  tearDown(() => db.close());

  CategoryDto serverCategory(String id, String name) => CategoryDto(
    id: id,
    storeId: 's',
    name: name,
    createdAt: _now,
    updatedAt: _now,
  );

  void stubChanges(SyncChangesDto changes) {
    when(
      () => remote.getChanges(
        since: any(named: 'since'),
        limit: any(named: 'limit'),
        cursor: any(named: 'cursor'),
      ),
    ).thenAnswer((_) async => changes);
  }

  Future<List<Map<String, dynamic>>> pendingPayloads(String type) async {
    final entries = await queue.getEntriesByType(type);
    return [
      for (final e in entries) jsonDecode(e.payload) as Map<String, dynamic>,
    ];
  }

  group('catégories locales', () {
    test('nom unique, casse ignorée', () async {
      await catalog.createCategory('Boissons');
      expect(
        () => catalog.createCategory('  BOISSONS '),
        throwsA(isA<CategoryNameTakenException>()),
      );
    });

    test('le produit part avec sa catégorie dans la file', () async {
      final category = await catalog.createCategory('Boissons');
      await catalog.createProduct(
        name: 'Coca',
        sellingPrice: '500',
        categoryId: category.id,
      );
      final payloads = await pendingPayloads('product');
      expect(payloads.single['category_id'], category.id);
    });

    test(
      'supprimer une catégorie renvoie ses produits sans catégorie',
      () async {
        final category = await catalog.createCategory('Boissons');
        final product = await catalog.createProduct(
          name: 'Coca',
          sellingPrice: '500',
          categoryId: category.id,
        );

        await catalog.deleteCategory(category.id);

        final row = await (db.select(
          db.products,
        )..where((p) => p.id.equals(product.id))).getSingle();
        expect(row.categoryId, isNull);
        // L'ancien envoi (avec la catégorie) est retiré, le nouveau n'en a pas.
        final payloads = await pendingPayloads('product');
        expect(payloads.map((p) => p['category_id']), [null]);
        expect((await pendingPayloads('category')).last['deleted'], isTrue);
      },
    );
  });

  group('envoi', () {
    test(
      'un produit attend que sa catégorie soit acceptée par le serveur',
      () async {
        final category = await catalog.createCategory('Boissons');
        await catalog.createProduct(
          name: 'Coca',
          sellingPrice: '500',
          categoryId: category.id,
        );
        when(() => remote.pushProduct(any())).thenAnswer(
          (_) async => const ProductSyncResponseDto(status: 'created'),
        );
        when(() => remote.pushCategory(any())).thenAnswer(
          (_) async => const CategorySyncResponseDto(status: 'created'),
        );

        // Catégorie encore en file : le produit n'est pas envoyé.
        await push.pushPendingProductChanges();
        verifyNever(() => remote.pushProduct(any()));

        await push.pushPendingCategoryChanges();
        await push.pushPendingProductChanges();
        final sent =
            verify(() => remote.pushProduct(captureAny())).captured.single
                as ProductSyncItemDto;
        expect(sent.categoryId, category.id);
      },
    );

    test('conflit : l’état serveur plus récent l’emporte', () async {
      final category = await catalog.createCategory('Boisons');
      when(() => remote.pushCategory(any())).thenAnswer(
        (_) async => CategorySyncResponseDto(
          status: 'conflict',
          serverState: serverCategory(category.id, 'Boissons'),
        ),
      );

      await push.pushPendingCategoryChanges();

      final row = await (db.select(
        db.categories,
      )..where((c) => c.id.equals(category.id))).getSingle();
      expect(row.name, 'Boissons');
      expect(row.dirty, isFalse);
    });
  });

  group('pull', () {
    test(
      'fusionne une catégorie locale refusée (nom pris) avec celle du serveur',
      () async {
        final local = await catalog.createCategory('Boissons');
        final product = await catalog.createProduct(
          name: 'Coca',
          sellingPrice: '500',
          categoryId: local.id,
        );
        // Le serveur refuse la catégorie locale : une autre porte ce nom.
        when(() => remote.pushCategory(any())).thenAnswer(
          (_) async => const CategorySyncResponseDto(status: 'conflict'),
        );
        await push.pushPendingCategoryChanges();

        stubChanges(
          SyncChangesDto(
            categories: [serverCategory('server-cat', 'boissons')],
            products: const [],
            sales: const [],
            hasMore: false,
            serverTime: _now,
          ),
        );
        await pull.pullChanges();

        final categories = await db.select(db.categories).get();
        expect(categories.map((c) => c.id), ['server-cat']);
        final row = await (db.select(
          db.products,
        )..where((p) => p.id.equals(product.id))).getSingle();
        expect(row.categoryId, 'server-cat');
        // Le produit repart avec la catégorie du serveur, une seule fois.
        final payloads = await pendingPayloads('product');
        expect(payloads.map((p) => p['category_id']), ['server-cat']);
      },
    );

    test('conserve catégorie et version d’image des produits reçus', () async {
      stubChanges(
        const SyncChangesDto(
          products: [
            ProductDto(
              id: 'p1',
              storeId: 's',
              name: 'Coca',
              sellingPrice: '500',
              categoryId: 'c1',
              imageVersion: 'abc',
              createdAt: _now,
              updatedAt: _now,
            ),
          ],
          sales: [],
          hasMore: false,
          serverTime: _now,
        ),
      );
      await pull.pullChanges();

      final row = await db.select(db.products).getSingle();
      expect(row.categoryId, 'c1');
      expect(row.imageVersion, 'abc');
    });

    test('enregistre les articles des ventes reçues du serveur', () async {
      stubChanges(
        const SyncChangesDto(
          products: [],
          sales: [
            SaleDto(
              id: 'sale-1',
              storeId: 's',
              receiptNumber: 42,
              totalAmount: '1000.00',
              vatAmount: '0.00',
              paymentMethod: 'cash',
              createdAt: _now,
              syncedAt: _now,
              items: [
                SaleItemDto(
                  id: 'item-1',
                  saleId: 'sale-1',
                  productId: null,
                  productNameAtSale: 'Baguette',
                  unitPriceAtSale: '250.00',
                  quantity: 4,
                  lineTotal: '1000.00',
                ),
              ],
            ),
          ],
          hasMore: false,
          serverTime: _now,
        ),
      );

      await pull.pullChanges();
      // Rejouer le même pull n'ajoute pas de doublon.
      await pull.pullChanges();

      final items = await db.select(db.saleItems).get();
      expect(items, hasLength(1));
      expect(items.single.productName, 'Baguette');
      expect(items.single.quantity, 4);
    });
  });
}
