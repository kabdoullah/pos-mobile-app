import 'package:drift/drift.dart' as drift;
import 'package:logger/logger.dart';

import '../../database/app_database.dart';
import '../utils/barcode_utils.dart';
import 'sync_remote_datasource.dart';

/// Service qui récupère les changements du serveur et les écrit dans la base
/// drift locale.
class PullService {
  /// Constructeur.
  const PullService({
    required SyncRemoteDataSource remoteDataSource,
    required AppDatabase db,
    Logger? logger,
  }) : _remoteDataSource = remoteDataSource,
       _db = db,
       _logger = logger;

  final SyncRemoteDataSource _remoteDataSource;
  final AppDatabase _db;
  final Logger? _logger;

  static const int _defaultLimit = 100;

  /// Récupère tous les changements du serveur et les écrit dans drift
  /// (idempotent).
  ///
  /// Retourne true si la récupération a réussi, false sinon. En cas de succès,
  /// met à jour la métadonnée last_pull_at.
  ///
  /// Quand [forceFullPull] vaut true, ignore [last_pull_at] et récupère tout le
  /// catalogue (since=null). À utiliser pour un rafraîchissement manuel, afin
  /// de récupérer les produits insérés côté serveur avec un horodatage
  /// antérieur à last_pull_at.
  Future<bool> pullChanges({bool forceFullPull = false}) async {
    try {
      final storage = SyncMetadataStorage(_db);
      final lastPullAt = forceFullPull ? null : await storage.getLastPullAt();
      final since = lastPullAt?.toIso8601String();

      _logger?.d('Starting pull. Full: $forceFullPull. Last pull: $lastPullAt');

      String? cursor;
      bool hasMore = true;
      String? serverTime;

      // Parcourt toutes les pages de résultats.
      while (hasMore) {
        _logger?.d('Fetching page. Cursor: $cursor');

        final response = await _remoteDataSource.getChanges(
          since: since,
          limit: _defaultLimit,
          cursor: cursor,
        );

        serverTime = response.serverTime;

        // Upsert des produits (idempotent) — une seule transaction par lot.
        if (response.products.isNotEmpty) {
          // min_stock n'est pas encore connu du backend : il ne revient jamais
          // dans productDto.minStock, donc remplacer aveuglément la ligne à
          // chaque récupération effacerait silencieusement le seuil défini
          // localement. On conserve la valeur locale existante quand le serveur
          // n'en envoie pas.
          final existingMinStocks = <String, int?>{
            for (final row
                in await (_db.select(_db.products)..where(
                      (p) => p.id.isIn(response.products.map((p) => p.id)),
                    ))
                    .get())
              row.id: row.minStock,
          };

          await _db.batch((batch) {
            for (final productDto in response.products) {
              final deletedAt = productDto.deletedAt != null
                  ? DateTime.parse(productDto.deletedAt!)
                  : null;
              batch.insert(
                _db.products,
                ProductsCompanion(
                  id: drift.Value(productDto.id),
                  name: drift.Value(productDto.name),
                  barcode: drift.Value(normalizeBarcode(productDto.barcode)),
                  unitPrice: drift.Value(productDto.unitPrice),
                  currentStock: drift.Value(productDto.currentStock),
                  minStock: drift.Value(
                    productDto.minStock ?? existingMinStocks[productDto.id],
                  ),
                  dirty: const drift.Value(false),
                  updatedAt: drift.Value(DateTime.parse(productDto.updatedAt)),
                  deletedAt: drift.Value(deletedAt),
                ),
                mode: drift.InsertMode.insertOrReplace,
              );
            }
          });
        }

        // Upsert des ventes (idempotent, append-only) — une seule transaction
        // par lot.
        if (response.sales.isNotEmpty) {
          await _db.batch((batch) {
            for (final saleDto in response.sales) {
              batch.insert(
                _db.sales,
                SalesCompanion(
                  id: drift.Value(saleDto.id),
                  receiptNumber: drift.Value(saleDto.receiptNumber ?? 0),
                  totalAmount: drift.Value(saleDto.totalAmount),
                  vatAmount: drift.Value(saleDto.vatAmount),
                  paymentMethod: drift.Value(saleDto.paymentMethod),
                  createdAt: drift.Value(DateTime.parse(saleDto.createdAt)),
                ),
                mode: drift.InsertMode.insertOrReplace,
              );
            }
          });
        }

        // Vérification de la pagination.
        hasMore = response.hasMore;
        cursor = response.nextCursor;
      }

      // Met à jour les métadonnées seulement si la récupération s'est terminée
      // avec succès.
      if (serverTime != null) {
        final timestamp = DateTime.parse(serverTime);
        await storage.setLastPullAt(timestamp);
        _logger?.d('Pull completed. Server time: $serverTime');
      }

      return true;
    } catch (e, st) {
      _logger?.e('Pull failed', error: e, stackTrace: st);
      return false;
    }
  }
}

/// Gère les métadonnées de synchro (horodatage du dernier pull) stockées dans
/// drift.
class SyncMetadataStorage {
  /// Constructeur.
  const SyncMetadataStorage(this._db);

  final AppDatabase _db;

  /// Clé de stockage de l'horodatage du dernier pull.
  static const String _lastPullKey = 'last_pull_at';

  /// Clé du store actuellement actif dans la DB locale.
  static const String _activeStoreKey = 'active_store_id';

  /// Lit l'id du store actif. Null si jamais défini (DB fraîche/wipée).
  Future<String?> getActiveStoreId() async {
    final record = await (_db.select(
      _db.syncMetadata,
    )..where((t) => t.key.equals(_activeStoreKey))).getSingleOrNull();
    return record?.value;
  }

  /// Persiste l'id du store actif (après un wipe, pour le nouveau store).
  Future<void> setActiveStoreId(String storeId) async {
    await _db
        .into(_db.syncMetadata)
        .insertOnConflictUpdate(
          SyncMetadataCompanion(
            key: const drift.Value(_activeStoreKey),
            value: drift.Value(storeId),
            updatedAt: drift.Value(DateTime.now()),
          ),
        );
  }

  /// Lit l'horodatage du dernier pull. Retourne null si aucun pull n'a eu lieu.
  Future<DateTime?> getLastPullAt() async {
    final record = await (_db.select(
      _db.syncMetadata,
    )..where((t) => t.key.equals(_lastPullKey))).getSingleOrNull();

    if (record == null) return null;
    return DateTime.parse(record.value);
  }

  /// Enregistre l'horodatage du dernier pull (server_time de la réponse de
  /// synchro).
  Future<void> setLastPullAt(DateTime timestamp) async {
    await _db
        .into(_db.syncMetadata)
        .insertOnConflictUpdate(
          SyncMetadataCompanion(
            key: const drift.Value(_lastPullKey),
            value: drift.Value(timestamp.toIso8601String()),
            updatedAt: drift.Value(DateTime.now()),
          ),
        );
  }

  /// Efface toutes les métadonnées de synchro (utilisé en test ou pour une
  /// remise à zéro).
  Future<void> clear() async {
    await (_db.delete(_db.syncMetadata)).go();
  }
}
