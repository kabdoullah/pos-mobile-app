import 'dart:convert';

import 'package:drift/drift.dart' as drift;

import '../../database/app_database.dart';

/// Repository de gestion de la file de synchro (table SyncQueue).
class SyncQueueRepository {
  /// Constructeur.
  SyncQueueRepository({required AppDatabase db}) : _db = db;

  final AppDatabase _db;

  static const int _maxRetries = 5;

  /// Nombre en direct des entrées restant à synchroniser (en attente, ou en
  /// échec en attente de nouvel essai).
  Stream<int> watchPendingCount() {
    return (_db.select(_db.syncQueue)
          ..where((row) => row.status.isIn(['pending', 'failed'])))
        .watch()
        .map((rows) => rows.length);
  }

  /// Ajoute une vente à la file de synchro.
  /// Retourne l'ID de l'entrée dans la file.
  Future<int> enqueueSale({
    required String saleId,
    required Map<String, dynamic> salePayload,
  }) async {
    final result = await _db
        .into(_db.syncQueue)
        .insert(
          SyncQueueCompanion(
            entityType: const drift.Value('sale'),
            entityId: drift.Value(saleId),
            payload: drift.Value(jsonEncode(salePayload)),
            status: const drift.Value('pending'),
            createdAt: drift.Value(DateTime.now()),
          ),
        );
    return result;
  }

  /// Ajoute un changement de produit à la file de synchro.
  /// Retourne l'ID de l'entrée dans la file.
  Future<int> enqueueProductChange({
    required String productId,
    required Map<String, dynamic> productPayload,
  }) async {
    final result = await _db
        .into(_db.syncQueue)
        .insert(
          SyncQueueCompanion(
            entityType: const drift.Value('product'),
            entityId: drift.Value(productId),
            payload: drift.Value(jsonEncode(productPayload)),
            status: const drift.Value('pending'),
            createdAt: drift.Value(DateTime.now()),
          ),
        );
    return result;
  }

  /// Ajoute un changement de catégorie à la file de synchro (ADR-0008).
  Future<int> enqueueCategoryChange({
    required String categoryId,
    required Map<String, dynamic> categoryPayload,
  }) {
    return _db
        .into(_db.syncQueue)
        .insert(
          SyncQueueCompanion(
            entityType: const drift.Value('category'),
            entityId: drift.Value(categoryId),
            payload: drift.Value(jsonEncode(categoryPayload)),
            status: const drift.Value('pending'),
            createdAt: drift.Value(DateTime.now()),
          ),
        );
  }

  /// Récupère les entrées en attente ou en échec, dans la limite indiquée.
  Future<List<SyncQueueData>> getPendingEntries({
    int limit = 50,
    List<String> entityTypes = const ['sale', 'product'],
  }) async {
    final entries =
        await (_db.select(_db.syncQueue)
              ..where((t) => t.status.isIn(['pending', 'failed']))
              ..where((t) => t.entityType.isIn(entityTypes))
              ..orderBy([(t) => drift.OrderingTerm(expression: t.createdAt)])
              ..limit(limit))
            .get();
    return entries;
  }

  /// Marque plusieurs entrées de la file comme en cours de synchro en une seule
  /// opération DB.
  Future<void> markSyncingBatch(List<int> ids) async {
    if (ids.isEmpty) return;
    final now = DateTime.now();
    await (_db.update(_db.syncQueue)..where((t) => t.id.isIn(ids))).write(
      SyncQueueCompanion(
        status: const drift.Value('syncing'),
        lastAttemptAt: drift.Value(now),
      ),
    );
  }

  /// Marque une entrée de la file comme en cours de synchro.
  Future<bool> markSyncing(int id) async {
    final rowsAffected =
        await (_db.update(_db.syncQueue)..where((t) => t.id.equals(id))).write(
          SyncQueueCompanion(
            status: const drift.Value('syncing'),
            lastAttemptAt: drift.Value(DateTime.now()),
          ),
        );
    return rowsAffected > 0;
  }

  /// Marque une entrée de la file comme synchronisée avec succès.
  Future<bool> markSynced(int id) async {
    final rowsAffected =
        await (_db.update(_db.syncQueue)..where((t) => t.id.equals(id))).write(
          SyncQueueCompanion(
            status: const drift.Value('synced'),
            lastAttemptAt: drift.Value(DateTime.now()),
          ),
        );
    return rowsAffected > 0;
  }

  /// Marque une entrée de la file en échec avec un message d'erreur.
  Future<bool> markFailed(int id, String error) async {
    final rowsAffected =
        await (_db.update(_db.syncQueue)..where((t) => t.id.equals(id))).write(
          SyncQueueCompanion(
            status: const drift.Value('failed'),
            lastError: drift.Value(error),
            lastAttemptAt: drift.Value(DateTime.now()),
          ),
        );
    return rowsAffected > 0;
  }

  /// Incrémente le compteur d'essais d'une entrée.
  Future<bool> incrementRetry(int id) async {
    final entry = await (_db.select(
      _db.syncQueue,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (entry == null) return false;

    final newRetryCount = entry.retryCount + 1;
    final newStatus = newRetryCount > _maxRetries ? 'failed' : 'pending';

    final rowsAffected =
        await (_db.update(_db.syncQueue)..where((t) => t.id.equals(id))).write(
          SyncQueueCompanion(
            retryCount: drift.Value(newRetryCount),
            status: drift.Value(newStatus),
          ),
        );
    return rowsAffected > 0;
  }

  /// Purge les entrées synchronisées depuis plus de 7 jours.
  Future<int> purgeSynced() async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return (_db.delete(_db.syncQueue)..where(
          (t) =>
              t.status.equals('synced') &
              t.createdAt.isSmallerThanValue(sevenDaysAgo),
        ))
        .go();
  }

  /// Récupère une entrée précise de la file par son ID.
  Future<SyncQueueData?> getEntry(int id) async {
    return (_db.select(
      _db.syncQueue,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Efface toutes les entrées (pour les tests).
  Future<int> clear() async {
    return (_db.delete(_db.syncQueue)).go();
  }

  /// Remet en attente les entrées en échec et celles bloquées en cours de
  /// synchro.
  /// Une entrée reste bloquée en cours de synchro quand l'app plante entre
  /// markSyncing et markSynced/markFailed.
  Future<int> resetFailedEntries() async {
    return (_db.update(
      _db.syncQueue,
    )..where((t) => t.status.isIn(['failed', 'syncing']))).write(
      const SyncQueueCompanion(
        status: drift.Value('pending'),
        retryCount: drift.Value(0),
      ),
    );
  }

  /// Remet une entrée de la file en attente avec un payload mis à jour.
  Future<bool> resetWithPayload(int id, String newPayload) async {
    final rowsAffected =
        await (_db.update(_db.syncQueue)..where((t) => t.id.equals(id))).write(
          SyncQueueCompanion(
            status: const drift.Value('pending'),
            payload: drift.Value(newPayload),
            retryCount: const drift.Value(0),
            lastError: const drift.Value(null),
          ),
        );
    return rowsAffected > 0;
  }

  /// Retire de l'envoi les entrées en attente/en échec d'une entité, rendues
  /// obsolètes par un état plus récent (ex. fusion de catégories au pull).
  Future<int> supersedePendingEntries(String entityType, String entityId) {
    return (_db.update(_db.syncQueue)
          ..where((t) => t.entityType.equals(entityType))
          ..where((t) => t.entityId.equals(entityId))
          ..where((t) => t.status.isIn(['pending', 'failed'])))
        .write(const SyncQueueCompanion(status: drift.Value('synced')));
  }

  /// Récupère toutes les entrées en attente/en échec d'un type d'entité.
  Future<List<SyncQueueData>> getEntriesByType(String entityType) async {
    return (_db.select(_db.syncQueue)
          ..where((t) => t.entityType.equals(entityType))
          ..where((t) => t.status.isIn(['pending', 'failed']))
          ..orderBy([(t) => drift.OrderingTerm(expression: t.createdAt)]))
        .get();
  }
}
