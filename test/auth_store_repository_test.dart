import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/storage/image_file_cache.dart';
import 'package:mobile/core/network/api_models/store_dto.dart';
import 'package:mobile/features/auth/data/datasources/stores_remote_datasource.dart';
import 'package:mobile/features/auth/data/repositories/store_repository_impl.dart';
import 'package:mobile/features/auth/domain/entities/store.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements StoresRemoteDataSource {}

/// Remplaçant en mémoire du trousseau de la plateforme.
class _FakeStorage extends Fake implements FlutterSecureStorage {
  final Map<String, String> values = {};

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => values[key];

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => values.remove(key);
}

const _remoteStore = StoreDto(
  id: 's1',
  ownerId: 'u1',
  name: 'Boutique Awa',
  ncc: 'CI-123',
  vatSubject: true,
  nextReceiptNumber: 1,
  createdAt: '2026-01-01T00:00:00Z',
  updatedAt: '2026-01-01T00:00:00Z',
);

void main() {
  setUpAll(() => registerFallbackValue(const StoreUpdateDto()));

  late _MockRemote remote;
  late _FakeStorage storage;
  late StoreRepositoryImpl repo;
  late Directory imageDir;

  setUp(() {
    remote = _MockRemote();
    storage = _FakeStorage();
    imageDir = Directory.systemTemp.createTempSync('store_repo_test');
    repo = StoreRepositoryImpl(
      remoteDataSource: remote,
      storage: storage,
      imageCache: ImageFileCache(baseDirectory: () async => imageDir),
    );
  });

  test('serves the local cache without calling the backend', () async {
    storage.values['store_name'] = 'Boutique locale';

    expect((await repo.getStore())?.name, 'Boutique locale');
    verifyNever(() => remote.getCurrentStore());
  });

  test('empty cache: fetches /stores/me and caches it', () async {
    when(() => remote.getCurrentStore()).thenAnswer((_) async => _remoteStore);

    final store = await repo.getStore();

    expect(store?.name, 'Boutique Awa');
    expect(store?.isSubjectToVat, isTrue);
    expect(storage.values['store_name'], 'Boutique Awa');
    expect(storage.values['store_ncc'], 'CI-123');
  });

  test('empty cache and backend unreachable: returns null', () async {
    when(() => remote.getCurrentStore()).thenThrow(Exception('offline'));

    expect(await repo.getStore(), isNull);
  });

  test('clearLocal removes every cached field', () async {
    when(() => remote.updateStore(any())).thenAnswer((_) async => _remoteStore);
    await repo.saveStore(
      const Store(
        name: 'Ancienne boutique',
        address: 'Cocody',
        ncc: 'CI-999',
        isSubjectToVat: true,
        receiptFooterText: 'Merci',
      ),
    );
    expect(storage.values, hasLength(5));
    // Logo du compte précédent en cache.
    await ImageFileCache(
      baseDirectory: () async => imageDir,
    ).put('store_logo', 'v1', [1, 2, 3]);

    await repo.clearLocal();

    expect(storage.values, isEmpty);
    expect(
      await ImageFileCache(
        baseDirectory: () async => imageDir,
      ).get('store_logo', 'v1'),
      isNull,
    );
  });
}
