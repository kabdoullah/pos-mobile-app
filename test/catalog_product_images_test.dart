import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqlite3/open.dart';

import 'package:mobile/core/storage/image_file_cache.dart';
import 'package:mobile/core/sync/sync_orchestrator.dart';
import 'package:mobile/core/sync/sync_queue_repository.dart';
import 'package:mobile/database/app_database.dart' hide Sale;
import 'package:mobile/features/auth/domain/entities/store.dart';
import 'package:mobile/features/catalog/data/repositories/catalog_repository_impl.dart';
import 'package:mobile/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:mobile/features/catalog/presentation/providers/product_image_providers.dart';
import 'package:mobile/features/catalog/providers/catalog_di_providers.dart';
import 'package:mobile/features/printing/data/receipt_formatter.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart';
import 'package:decimal/decimal.dart';

class _MockDio extends Mock implements Dio {}

class _MockCatalog extends Mock implements CatalogRepository {}

class _FakeSync extends SyncOrchestrator {
  int calls = 0;

  @override
  SyncStatus build() => const SyncStatusIdle();

  @override
  Future<void> syncNow({bool forceFullPull = false}) async => calls++;
}

Response<T> _response<T>(T data, {int status = 200}) => Response<T>(
  data: data,
  statusCode: status,
  requestOptions: RequestOptions(),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
    if (Platform.isLinux) {
      open.overrideFor(
        OperatingSystem.linux,
        () => DynamicLibrary.open('libsqlite3.so.0'),
      );
    }
    registerFallbackValue(Options());
    registerFallbackValue(File('x'));
  });

  late Directory dir;
  late ImageFileCache cache;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('image_cache_test');
    cache = ImageFileCache(baseDirectory: () async => dir);
  });

  group('ImageFileCache', () {
    test('une seule version conservée par image', () async {
      await cache.put('product_p1', 'v1', [1]);
      await cache.put('product_p1', 'v2', [2]);
      await cache.put('product_p2', 'v1', [3]);

      expect(await cache.get('product_p1', 'v1'), isNull);
      expect(await (await cache.get('product_p1', 'v2'))!.readAsBytes(), [2]);
      expect(await cache.get('product_p2', 'v1'), isNotNull);
    });

    test('clear vide tout (changement de compte)', () async {
      await cache.put('store_logo', 'v1', [1]);
      await cache.clear();
      expect(await cache.get('store_logo', 'v1'), isNull);
    });
  });

  group('CatalogRepositoryImpl — images', () {
    late AppDatabase db;
    late _MockDio dio;
    late CatalogRepositoryImpl repo;

    setUp(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      dio = _MockDio();
      repo = CatalogRepositoryImpl(
        db: db,
        syncQueue: SyncQueueRepository(db: db),
        dio: dio,
        imageCache: cache,
      );
      await db
          .into(db.products)
          .insert(
            ProductsCompanion(
              id: const drift.Value('p1'),
              name: const drift.Value('Coca'),
              sellingPrice: const drift.Value('500'),
              updatedAt: drift.Value(DateTime(2026)),
            ),
          );
    });

    tearDown(() => db.close());

    test('image en cache : aucun appel réseau', () async {
      await cache.put('product_p1', 'v1', [9]);
      final file = await repo.productImage('p1', 'v1');
      expect(await file!.readAsBytes(), [9]);
      verifyNever(
        () => dio.get<List<int>>(any(), options: any(named: 'options')),
      );
    });

    test('image absente du cache : téléchargée puis mise en cache', () async {
      when(
        () => dio.get<List<int>>(any(), options: any(named: 'options')),
      ).thenAnswer((_) async => _response<List<int>>([7, 7]));

      await repo.productImage('p1', 'v2');
      expect(await (await cache.get('product_p1', 'v2'))!.readAsBytes(), [
        7,
        7,
      ]);
    });

    test(
      'envoi : la version serveur est enregistrée, sans renvoyer le produit',
      () async {
        final photo = File('${dir.path}/photo.jpg')..writeAsBytesSync([1, 2]);
        when(
          () => dio.put<Map<String, dynamic>>(any(), data: any(named: 'data')),
        ).thenAnswer(
          (_) async => _response<Map<String, dynamic>>({
            'id': 'p1',
            'store_id': 's',
            'name': 'Coca',
            'selling_price': '500.00',
            'image_version': 'sha-v3',
            'created_at': '2026-01-01T00:00:00Z',
            'updated_at': '2026-01-01T00:00:00Z',
          }),
        );

        await repo.uploadProductImage('p1', photo);

        final row = await db.select(db.products).getSingle();
        expect(row.imageVersion, 'sha-v3');
        expect(row.dirty, isFalse);
      },
    );

    test('produit pas encore synchronisé : exception dédiée', () async {
      final photo = File('${dir.path}/photo.jpg')..writeAsBytesSync([1]);
      when(
        () => dio.put<Map<String, dynamic>>(any(), data: any(named: 'data')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: _response<void>(null, status: 404),
        ),
      );

      expect(
        () => repo.uploadProductImage('p1', photo),
        throwsA(isA<ProductNotOnServerException>()),
      );
    });
  });

  test('ProductImageEditor : synchronise puis réessaie une fois', () async {
    final catalog = _MockCatalog();
    var attempts = 0;
    when(() => catalog.uploadProductImage(any(), any())).thenAnswer((_) async {
      attempts++;
      if (attempts == 1) throw const ProductNotOnServerException();
    });
    final sync = _FakeSync();
    final container = ProviderContainer(
      overrides: [
        catalogRepositoryProvider.overrideWithValue(catalog),
        syncOrchestratorProvider.overrideWith(() => sync),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(productImageEditorProvider.notifier)
        .upload('p1', File('photo.jpg'));

    expect(sync.calls, 1);
    expect(attempts, 2);
  });

  group('logo sur le ticket', () {
    final sale = Sale(
      discountAmount: Decimal.zero,
      id: 's1',
      receiptNumber: 1,
      totalAmount: Decimal.fromInt(500),
      vatAmount: Decimal.zero,
      paymentMethod: PaymentMethod.cash,
      createdAt: DateTime(2026),
    );
    const store = Store(name: 'Boutique', isSubjectToVat: false);
    // Commande ESC/POS d'impression d'image raster (GS v 0).
    const raster = [0x1D, 0x76, 0x30];

    bool containsSequence(List<int> bytes, List<int> seq) {
      for (var i = 0; i <= bytes.length - seq.length; i++) {
        var match = true;
        for (var j = 0; j < seq.length; j++) {
          if (bytes[i + j] != seq[j]) {
            match = false;
            break;
          }
        }
        if (match) return true;
      }
      return false;
    }

    test('un logo valide est imprimé en image raster', () async {
      final logo = img.encodePng(img.Image(width: 500, height: 100));
      final bytes = await ReceiptFormatter.format(
        store: store,
        sale: sale,
        logo: logo,
      );
      expect(containsSequence(bytes, raster), isTrue);
    });

    test('un logo illisible n’empêche pas d’imprimer', () async {
      final bytes = await ReceiptFormatter.format(
        store: store,
        sale: sale,
        logo: [1, 2, 3, 4],
      );
      expect(containsSequence(bytes, raster), isFalse);
      expect(bytes, isNotEmpty);
    });
  });
}
