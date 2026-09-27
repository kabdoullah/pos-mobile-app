import 'dart:io';
import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

import '../../../../core/network/api_models/sync_changes_dto.dart';
import '../../../../core/sync/sync_queue_repository.dart';
import '../../../../core/utils/barcode_utils.dart';
import '../../../../database/app_database.dart' hide Product;
import '../../domain/entities/product.dart' as product_domain;
import '../../domain/entities/product_import_result.dart';
import '../../domain/entities/product_page.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_remote_datasource.dart';
import '../models/product_import_mappers.dart';
import '../models/product_mappers.dart';

/// Implémentation concrète de [CatalogRepository].
/// Local d'abord : lit et écrit dans la base drift. Les changements sont mis en
/// file pour la synchro.
/// L'import en masse et le téléchargement du modèle font exception — ils
/// appellent directement l'API distante (sans miroir drift), car ce sont des
/// actions ponctuelles dont le résultat est ensuite réconcilié en local par un
/// pull de synchro normal.
class CatalogRepositoryImpl implements CatalogRepository {
  /// Crée un CatalogRepositoryImpl.
  CatalogRepositoryImpl({
    required this.db,
    required this.syncQueue,
    required this.dio,
  });

  /// Instance de la base drift locale.
  final AppDatabase db;

  /// Repository de la file de synchro pour marquer les changements.
  final SyncQueueRepository syncQueue;

  /// Instance Dio utilisée pour l'import en masse / le téléchargement du
  /// modèle.
  final Dio dio;

  @override
  Future<ProductPage> getProducts({
    String? query,
    String? cursor,
    int limit = 50,
  }) async {
    final dbQuery = db.select(db.products);

    dbQuery.where((p) => p.deletedAt.isNull());

    if (query != null && query.isNotEmpty) {
      final searchTerm = '%$query%';
      dbQuery.where(
        (p) => p.name.like(searchTerm) | p.barcode.like(searchTerm),
      );
    }

    // Pagination par clé : le curseur est l'id du dernier élément de la page
    // précédente.
    // ORDER BY id est stable et cohérent avec la comparaison des UUID en
    // chaîne.
    if (cursor != null) {
      dbQuery.where((p) => p.id.isBiggerThanValue(cursor));
    }

    dbQuery.orderBy([(p) => drift.OrderingTerm(expression: p.id)]);
    // Récupère limit+1 pour savoir s'il reste des pages — sans parcourir toute
    // la table.
    dbQuery.limit(limit + 1);

    final records = await dbQuery.get();

    final hasMore = records.length > limit;
    final items = records.take(limit).map((r) => r.toDomain()).toList();
    final nextCursor = hasMore ? items.last.id : null;

    return ProductPage(items: items, nextCursor: nextCursor, hasMore: hasMore);
  }

  @override
  Future<product_domain.Product> createProduct({
    required String name,
    required String unitPrice,
    String? barcode,
    int? currentStock,
    int? minStock,
  }) async {
    final normalizedBarcode = normalizeBarcode(barcode);
    final id = const Uuid().v4();
    final now = DateTime.now();
    final product = product_domain.Product(
      id: id,
      name: name,
      unitPrice: Decimal.parse(unitPrice),
      barcode: normalizedBarcode,
      currentStock: currentStock,
      minStock: minStock,
      updatedAt: now,
      deletedAt: null,
    );

    // Écriture dans drift
    await db
        .into(db.products)
        .insert(
          ProductsCompanion(
            id: drift.Value(id),
            name: drift.Value(name),
            barcode: normalizedBarcode != null
                ? drift.Value(normalizedBarcode)
                : const drift.Value.absent(),
            unitPrice: drift.Value(unitPrice),
            currentStock: currentStock != null
                ? drift.Value(currentStock)
                : const drift.Value.absent(),
            minStock: minStock != null
                ? drift.Value(minStock)
                : const drift.Value.absent(),
            dirty: const drift.Value(true), // Marquer pour la synchro
            updatedAt: drift.Value(now),
          ),
        );

    // Mise en file pour la synchronisation
    await syncQueue.enqueueProductChange(
      productId: id,
      productPayload: ProductSyncItemDto(
        id: id,
        name: name,
        barcode: normalizedBarcode,
        unitPrice: unitPrice,
        currentStock: currentStock,
        minStock: minStock,
        clientUpdatedAt: now.toUtc().toIso8601String(),
      ).toJson(),
    );

    return product;
  }

  @override
  Future<product_domain.Product> updateProduct({
    required String id,
    String? name,
    String? unitPrice,
    String? barcode,
    int? currentStock,
    int? minStock,
  }) async {
    // Récupère le produit courant
    final current = await (db.select(
      db.products,
    )..where((p) => p.id.equals(id))).getSingleOrNull();
    if (current == null) {
      throw Exception('Product not found: $id');
    }

    final now = DateTime.now();
    final updatedName = name ?? current.name;
    final updatedPrice = unitPrice ?? current.unitPrice;
    final updatedBarcode = barcode != null
        ? normalizeBarcode(barcode)
        : current.barcode;
    final updatedStock = currentStock ?? current.currentStock;
    final updatedMinStock = minStock ?? current.minStock;

    // Mise à jour de drift
    await (db.update(db.products)..where((p) => p.id.equals(id))).write(
      ProductsCompanion(
        name: drift.Value(updatedName),
        barcode: drift.Value(updatedBarcode),
        unitPrice: drift.Value(updatedPrice),
        currentStock: updatedStock != null
            ? drift.Value(updatedStock)
            : const drift.Value.absent(),
        minStock: updatedMinStock != null
            ? drift.Value(updatedMinStock)
            : const drift.Value.absent(),
        dirty: const drift.Value(true), // Marquer pour la synchro
        updatedAt: drift.Value(now),
      ),
    );

    // Mise en file pour la synchronisation
    await syncQueue.enqueueProductChange(
      productId: id,
      productPayload: ProductSyncItemDto(
        id: id,
        name: updatedName,
        barcode: updatedBarcode,
        unitPrice: updatedPrice,
        currentStock: updatedStock,
        minStock: updatedMinStock,
        clientUpdatedAt: now.toUtc().toIso8601String(),
      ).toJson(),
    );

    return product_domain.Product(
      id: id,
      name: updatedName,
      unitPrice: Decimal.parse(updatedPrice),
      barcode: updatedBarcode,
      currentStock: updatedStock,
      minStock: updatedMinStock,
      updatedAt: now,
      deletedAt: null,
    );
  }

  @override
  Future<void> deleteProduct(String id) async {
    final now = DateTime.now();

    final current = await (db.select(
      db.products,
    )..where((p) => p.id.equals(id))).getSingleOrNull();
    if (current == null) return;

    // Suppression logique dans drift
    await (db.update(db.products)..where((p) => p.id.equals(id))).write(
      ProductsCompanion(
        dirty: const drift.Value(true),
        deletedAt: drift.Value(now),
      ),
    );

    // Mise en file pour la synchronisation
    await syncQueue.enqueueProductChange(
      productId: id,
      productPayload: ProductSyncItemDto(
        id: id,
        name: current.name,
        barcode: current.barcode,
        unitPrice: current.unitPrice,
        currentStock: current.currentStock,
        minStock: current.minStock,
        clientUpdatedAt: now.toUtc().toIso8601String(),
        deleted: true,
      ).toJson(),
    );
  }

  @override
  Future<product_domain.Product?> getProduct(String id) async {
    final record =
        await (db.select(db.products)
              ..where((p) => p.id.equals(id))
              ..where((p) => p.deletedAt.isNull()))
            .getSingleOrNull();
    return record?.toDomain();
  }

  @override
  Future<product_domain.Product?> getByBarcode(String barcode) async {
    final normalized = normalizeBarcode(barcode);
    if (normalized == null) return null;

    final record =
        await (db.select(db.products)
              ..where((p) => p.barcode.equals(normalized))
              ..where((p) => p.deletedAt.isNull()))
            .getSingleOrNull();
    return record?.toDomain();
  }

  @override
  Future<ProductImportResult> importProductsFromFile(File file) async {
    final remote = CatalogRemoteDataSource(dio);
    final response = await remote.importProductsFromFile(file);
    return response.toDomain();
  }

  // Reprend Product.stockLevel (outOfStock | low) en SQL pour filtrer en local.
  @override
  Stream<List<product_domain.Product>> watchProducts() {
    return (db.select(db.products)
          ..where((p) => p.deletedAt.isNull())
          ..orderBy([(p) => drift.OrderingTerm.asc(p.name)]))
        .watch()
        .map((rows) => rows.map((row) => row.toDomain()).toList());
  }

  @override
  Stream<List<product_domain.Product>> watchLowStockProducts() {
    return (db.select(db.products)
          ..where(
            (p) =>
                p.deletedAt.isNull() &
                p.currentStock.isNotNull() &
                (p.currentStock.equals(0) |
                    (p.minStock.isNotNull() &
                        p.currentStock.isSmallerOrEqual(p.minStock))),
          )
          ..orderBy([
            (p) => drift.OrderingTerm.asc(p.currentStock),
            (p) => drift.OrderingTerm.asc(p.name),
          ]))
        .watch()
        .map((rows) => rows.map((row) => row.toDomain()).toList());
  }

  @override
  Future<Uint8List> downloadImportTemplate({required String format}) async {
    final response = await dio.get<List<int>>(
      '/api/v1/products/bulk/template',
      queryParameters: {'format': format},
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }
}
