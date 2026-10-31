import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/sync/sync_queue_repository.dart';
import 'package:mobile/core/utils/barcode_utils.dart';
import 'package:mobile/database/app_database.dart';
import 'package:mobile/features/catalog/data/repositories/catalog_repository_impl.dart';

void main() {
  late AppDatabase db;
  late CatalogRepositoryImpl catalog;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    catalog = CatalogRepositoryImpl(
      db: db,
      syncQueue: SyncQueueRepository(db: db),
      dio: Dio(),
    );
  });

  tearDown(() => db.close());

  group('getByBarcode', () {
    test(
      'retrouve un UPC-A (12 chiffres) lu en EAN-13 par la caisse',
      () async {
        final created = await catalog.createProduct(
          name: 'Coca',
          sellingPrice: '500',
          barcode: '049000050103',
        );

        final found = await catalog.getByBarcode('0049000050103');

        expect(found?.id, created.id);
      },
    );

    test('retrouve un EAN-13 à zéro initial saisi sur 12 chiffres', () async {
      final created = await catalog.createProduct(
        name: 'Coca',
        sellingPrice: '500',
        barcode: '0049000050103',
      );

      final found = await catalog.getByBarcode('049000050103');

      expect(found?.id, created.id);
    });

    test('préfère la correspondance exacte', () async {
      await catalog.createProduct(
        name: 'Variante 12',
        sellingPrice: '500',
        barcode: '049000050103',
      );
      final exact = await catalog.createProduct(
        name: 'Variante 13',
        sellingPrice: '500',
        barcode: '0049000050103',
      );

      final found = await catalog.getByBarcode('0049000050103');

      expect(found?.id, exact.id);
    });

    test("n'invente pas d'équivalence hors UPC-A / EAN-13", () async {
      await catalog.createProduct(
        name: 'EAN-13',
        sellingPrice: '500',
        barcode: '1234567890128',
      );

      expect(await catalog.getByBarcode('234567890128'), isNull);
    });
  });

  group('barcodeLookupCandidates', () {
    test('code ordinaire : lui seul', () {
      expect(barcodeLookupCandidates('ABC12345'), ['ABC12345']);
    });

    test('UPC-A et sa forme EAN-13', () {
      expect(barcodeLookupCandidates('049000050103'), [
        '049000050103',
        '0049000050103',
      ]);
      expect(barcodeLookupCandidates('0049000050103'), [
        '0049000050103',
        '049000050103',
      ]);
    });
  });
}
