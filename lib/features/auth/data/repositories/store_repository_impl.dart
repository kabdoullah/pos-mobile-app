import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/storage/image_file_cache.dart';

import '../../domain/entities/store.dart';
import '../../domain/repositories/store_repository.dart';
import '../datasources/stores_remote_datasource.dart';
import '../models/store_mappers.dart';

/// Clés de stockage des données boutique dans flutter_secure_storage.
abstract class _StoreKeys {
  static const String name = 'store_name';
  static const String address = 'store_address';
  static const String ncc = 'store_ncc';
  static const String isSubjectToVat = 'store_vat';
  static const String footerText = 'store_footer';
  static const String phone = 'store_phone';
  static const String logoVersion = 'store_logo_version';

  static const List<String> all = [
    name,
    address,
    ncc,
    isSubjectToVat,
    footerText,
    phone,
    logoVersion,
  ];
}

/// Implémentation concrète de [StoreRepository] : cache secure storage devant
/// l'API `/stores/me`.
class StoreRepositoryImpl implements StoreRepository {
  /// Crée un StoreRepositoryImpl.
  StoreRepositoryImpl({
    required this.remoteDataSource,
    FlutterSecureStorage? storage,
    ImageFileCache? imageCache,
  }) : _storage = storage ?? const FlutterSecureStorage(),
       _imageCache = imageCache ?? ImageFileCache();

  static const String _logoKey = 'store_logo';

  /// Data source distante pour les appels API boutique.
  final StoresRemoteDataSource remoteDataSource;

  final FlutterSecureStorage _storage;
  final ImageFileCache _imageCache;

  @override
  Future<Store?> getStore() async {
    final name = await _storage.read(key: _StoreKeys.name);
    if (name != null) {
      return Store(
        name: name,
        address: await _storage.read(key: _StoreKeys.address),
        ncc: await _storage.read(key: _StoreKeys.ncc),
        isSubjectToVat:
            await _storage.read(key: _StoreKeys.isSubjectToVat) == 'true',
        receiptFooterText: await _storage.read(key: _StoreKeys.footerText),
        phone: await _storage.read(key: _StoreKeys.phone),
        logoVersion: await _storage.read(key: _StoreKeys.logoVersion),
      );
    }

    // Cache vide (nouvel appareil, réinstallation, changement de compte) :
    // récupérer la boutique depuis le backend. Hors ligne ou pas encore de
    // boutique → null, comme avant.
    try {
      final store = (await remoteDataSource.getCurrentStore()).toDomain();
      await _writeLocal(store);
      return store;
    } on Exception {
      return null;
    }
  }

  @override
  Future<void> saveStore(Store store) async {
    // Écriture locale d'abord ; l'échec du PATCH remonte pour que l'UI
    // l'affiche.
    await _writeLocal(store);
    await remoteDataSource.updateStore(store.toUpdateDto());
  }

  @override
  Future<void> clearLocal() async {
    await Future.wait(_StoreKeys.all.map((key) => _storage.delete(key: key)));
    await _imageCache.remove(_logoKey);
  }

  @override
  Future<Store> uploadLogo(File image) async {
    final store = (await remoteDataSource.uploadLogo(image)).toDomain();
    await _writeLocal(store);
    await _imageCache.remove(_logoKey);
    return store;
  }

  @override
  Future<Store> deleteLogo(Store current) async {
    await remoteDataSource.deleteLogo();
    final store = current.copyWith(logoVersion: null);
    await _writeLocal(store);
    await _imageCache.remove(_logoKey);
    return store;
  }

  @override
  Future<List<int>?> logoBytes(String version) async {
    final cached = await _imageCache.get(_logoKey, version);
    if (cached != null) return cached.readAsBytes();
    try {
      final response = await remoteDataSource.getLogo();
      await _imageCache.put(_logoKey, version, response.data);
      return response.data;
    } on Exception {
      return null;
    }
  }

  Future<void> _writeLocal(Store store) async {
    await _storage.write(key: _StoreKeys.name, value: store.name);
    await _storage.write(key: _StoreKeys.address, value: store.address);
    await _storage.write(key: _StoreKeys.ncc, value: store.ncc);
    await _storage.write(
      key: _StoreKeys.isSubjectToVat,
      value: store.isSubjectToVat.toString(),
    );
    await _storage.write(
      key: _StoreKeys.footerText,
      value: store.receiptFooterText,
    );
    await _storage.write(key: _StoreKeys.phone, value: store.phone);
    await _storage.write(key: _StoreKeys.logoVersion, value: store.logoVersion);
  }
}
