import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:logger/logger.dart';

import '../../core/network/api_models/product_dto.dart';
import '../utils/barcode_utils.dart';
import '../../core/network/api_models/sale_dto.dart';
import '../../core/network/api_models/sync_changes_dto.dart';
import '../../core/network/api_models/sync_responses_dto.dart';
import '../../database/app_database.dart';
import 'sync_queue_repository.dart';
import 'sync_remote_datasource.dart';

/// Service qui envoie les changements locaux (ventes, produits) au serveur.
class PushService {
  /// Constructeur.
  PushService({
    required SyncRemoteDataSource remoteDataSource,
    required SyncQueueRepository queueRepository,
    required AppDatabase db,
    Logger? logger,
  }) : _remoteDataSource = remoteDataSource,
       _queueRepository = queueRepository,
       _db = db,
       _logger = logger;

  final SyncRemoteDataSource _remoteDataSource;
  final SyncQueueRepository _queueRepository;
  final AppDatabase _db;
  final Logger? _logger;

  /// Envoie toutes les ventes en attente au serveur.
  /// Synchro par lots au mieux, avec gestion de l'idempotence.
  Future<void> pushPendingSales() async {
    try {
      final entries = await _queueRepository.getEntriesByType('sale');
      if (entries.isEmpty) {
        _logger?.d('No pending sales to push');
        return;
      }

      // Traitement par lots de 50 (limite du backend)
      const batchSize = 50;
      for (var i = 0; i < entries.length; i += batchSize) {
        final batch = entries.skip(i).take(batchSize).toList();
        await _pushSalesBatch(batch);
      }
    } catch (e, st) {
      _logger?.e('Push pending sales failed', error: e, stackTrace: st);
    }
  }

  /// Envoie un lot de ventes.
  Future<void> _pushSalesBatch(List<SyncQueueData> entries) async {
    // Marque tout comme en cours de synchro en une seule opération DB
    await _queueRepository.markSyncingBatch(entries.map((e) => e.id).toList());

    try {
      // Construction de la requête
      final sales = <SaleCreateDto>[];
      final entryMap = <String, SyncQueueData>{};

      for (final entry in entries) {
        entryMap[entry.entityId] = entry;
        final payload = jsonDecode(entry.payload) as Map<String, dynamic>;
        sales.add(SaleCreateDto.fromJson(payload));
      }

      // Appel au backend
      final response = await _remoteDataSource.pushSales(
        SalesSyncBatchRequestDto(sales: sales),
      );

      // Traitement des résultats
      for (final result in response.results) {
        final entry = entryMap[result.id];
        if (entry == null) continue;

        switch (result.status) {
          case 'created':
          case 'already_exists':
            // Les deux sont traités comme un succès (idempotence)
            await _queueRepository.markSynced(entry.id);
            if (result.status == 'already_exists') {
              _logger?.i('Sale ${result.id} already synced (idempotent)');
            }
            break;
          case 'failed':
            // Incrémente le compteur d'essais ; au-delà du seuil, échec
            // définitif
            await _queueRepository.incrementRetry(entry.id);
            final errorMsg = result.error ?? 'Unknown error';

            final retryEntry = await _queueRepository.getEntry(entry.id);
            if (retryEntry != null && retryEntry.retryCount >= 5) {
              _logger?.w(
                'Sale ${result.id} failed permanently after 5 retries: $errorMsg',
              );
              await _queueRepository.markFailed(entry.id, errorMsg);
            } else {
              _logger?.i('Sale ${result.id} failed (will retry): $errorMsg');
            }
            break;
          default:
            _logger?.w('Unknown sale sync result status: ${result.status}');
        }
      }
    } catch (e, st) {
      // Erreur réseau ; on remet les entrées en attente pour réessayer
      for (final entry in entries) {
        await _queueRepository.markFailed(entry.id, 'Network error: $e');
      }
      _logger?.e('Push sales batch failed', error: e, stackTrace: st);
    }
  }

  /// Envoie tous les changements de produits en attente au serveur.
  /// Synchro par état avec résolution de conflit (le serveur gagne).
  Future<void> pushPendingProductChanges() async {
    try {
      final entries = await _queueRepository.getEntriesByType('product');
      if (entries.isEmpty) {
        _logger?.d('No pending product changes to push');
        return;
      }

      for (final entry in entries) {
        await _pushProductChange(entry);
      }
    } catch (e, st) {
      _logger?.e('Push pending products failed', error: e, stackTrace: st);
    }
  }

  /// Envoie le changement d'un seul produit.
  Future<void> _pushProductChange(SyncQueueData entry) async {
    await _queueRepository.markSyncing(entry.id);

    try {
      final payload = jsonDecode(entry.payload) as Map<String, dynamic>;
      ProductSyncItemDto productItem;
      try {
        final parsed = ProductSyncItemDto.fromJson(payload);
        // Réapplique normalizeBarcode pour que tout code-barres enregistré
        // avant l'ajout de la validation du format soit nettoyé avant
        // d'atteindre le serveur.
        productItem = parsed.copyWith(
          barcode: normalizeBarcode(parsed.barcode),
        );
      } catch (_) {
        // L'ancien payload utilisait des clés en camelCase — on le reconstruit
        // depuis l'état drift actuel.
        final product = await (_db.select(
          _db.products,
        )..where((p) => p.id.equals(entry.entityId))).getSingleOrNull();
        if (product == null) {
          await _queueRepository.markFailed(
            entry.id,
            'Legacy payload: product not found locally',
          );
          return;
        }
        productItem = ProductSyncItemDto(
          id: product.id,
          name: product.name,
          barcode: normalizeBarcode(product.barcode),
          unitPrice: product.unitPrice,
          currentStock: product.currentStock,
          minStock: product.minStock,
          clientUpdatedAt: product.updatedAt.toUtc().toIso8601String(),
          deleted: product.deletedAt != null,
        );
        _logger?.i('Product ${entry.entityId} payload repaired from drift');
      }

      final response = await _remoteDataSource.pushProduct(productItem);

      switch (response.status) {
        case 'created':
        case 'updated':
        case 'no_change':
        case 'deleted':
          // Tous les résultats hors conflit sont traités comme un succès
          await _queueRepository.markSynced(entry.id);
          _logger?.i(
            'Product ${entry.entityId} synced (status: ${response.status})',
          );
          break;
        case 'conflict':
          // La version serveur est plus récente ; on écrase la version locale
          // avec server_state
          if (response.serverState != null) {
            await _updateProductFromServerState(response.serverState!);
            _logger?.i(
              'Product ${entry.entityId} conflict resolved (server won)',
            );
          }
          await _queueRepository.markSynced(entry.id);
          break;
        default:
          _logger?.w(
            'Unknown product sync response status: ${response.status}',
          );
      }
    } catch (e) {
      // Conflit 409 : le serveur a un état plus récent ou en conflit.
      // On analyse le corps à la main car Dio lève une exception pour les
      // réponses non-2xx.
      if (e is DioException &&
          e.response?.statusCode == 409 &&
          e.response?.data is Map<String, dynamic>) {
        try {
          final conflictResponse = ProductSyncResponseDto.fromJson(
            e.response!.data as Map<String, dynamic>,
          );
          if (conflictResponse.serverState != null) {
            final storedPayload =
                jsonDecode(entry.payload) as Map<String, dynamic>;
            final clientUpdatedAt = DateTime.parse(
              storedPayload['client_updated_at'] as String,
            );
            final serverUpdatedAt = DateTime.parse(
              conflictResponse.serverState!.updatedAt,
            );

            if (serverUpdatedAt.isBefore(clientUpdatedAt)) {
              // Le client était plus récent (en horodatage) mais le code-barres
              // a été refusé car il est déjà utilisé par un autre produit.
              // On retire le code-barres et on réessaie pour conserver les
              // autres modifications.
              final sentBarcode = storedPayload['barcode'] as String?;
              if (sentBarcode != null) {
                final stripped = Map<String, dynamic>.from(storedPayload)
                  ..['barcode'] = null;
                await (_db.update(_db.products)
                      ..where((p) => p.id.equals(entry.entityId)))
                    .write(const ProductsCompanion(barcode: drift.Value(null)));
                await _queueRepository.resetWithPayload(
                  entry.id,
                  jsonEncode(stripped),
                );
                _logger?.w(
                  'Product ${entry.entityId}: barcode "$sentBarcode" '
                  'rejected (taken by another product) — stripped, will retry',
                );
              } else {
                // Pas de code-barres dans le payload mais toujours un conflit
                // d'horodatage.
                await _updateProductFromServerState(
                  conflictResponse.serverState!,
                );
                await _queueRepository.markSynced(entry.id);
                _logger?.w(
                  'Product ${entry.entityId}: unexpected barcode conflict '
                  '(no barcode in payload) — server state applied',
                );
              }
            } else {
              // Le serveur a vraiment une version plus récente — on l'accepte.
              await _updateProductFromServerState(
                conflictResponse.serverState!,
              );
              _logger?.i(
                'Product ${entry.entityId} conflict resolved (server won)',
              );
              await _queueRepository.markSynced(entry.id);
            }
          } else {
            // Pas de server_state = nouveau produit dont le code-barres est
            // pris par un autre produit.
            // On retire le code-barres et on réessaie pour que le produit soit
            // quand même créé.
            final storedPayload =
                jsonDecode(entry.payload) as Map<String, dynamic>;
            if (storedPayload['barcode'] != null) {
              final stripped = Map<String, dynamic>.from(storedPayload)
                ..['barcode'] = null;
              await (_db.update(_db.products)
                    ..where((p) => p.id.equals(entry.entityId)))
                  .write(const ProductsCompanion(barcode: drift.Value(null)));
              await _queueRepository.resetWithPayload(
                entry.id,
                jsonEncode(stripped),
              );
              _logger?.i(
                'Product ${entry.entityId} barcode conflict — stripped barcode, will retry',
              );
            } else {
              // Déjà sans code-barres et toujours 409 : la version supprimée
              // côté serveur gagne. On abandonne.
              _logger?.i(
                'Product ${entry.entityId} conflict — no server_state, dropping local change',
              );
              await _queueRepository.markSynced(entry.id);
            }
          }
          return;
        } catch (_) {
          // On passe à la logique de réessai si l'analyse échoue.
        }
      }

      // Erreurs client non réessayables (4xx) : on journalise et on marque en
      // échec immédiatement.
      if (e is DioException &&
          e.response?.statusCode != null &&
          e.response!.statusCode! >= 400 &&
          e.response!.statusCode! < 500) {
        _logger?.w(
          'Product ${entry.entityId} rejected by server '
          '(${e.response!.statusCode}): ${e.response?.data} — marking failed',
        );
        await _queueRepository.markFailed(
          entry.id,
          'Server rejected: ${e.response!.statusCode} ${e.response?.data}',
        );
        return;
      }

      // Erreur réseau / serveur : on incrémente le compteur d'essais.
      await _queueRepository.incrementRetry(entry.id);

      final retryEntry = await _queueRepository.getEntry(entry.id);
      if (retryEntry != null && retryEntry.retryCount >= 5) {
        _logger?.w(
          'Product ${entry.entityId} failed permanently after 5 retries: $e',
        );
        await _queueRepository.markFailed(entry.id, 'Max retries exceeded: $e');
      } else {
        _logger?.i('Product ${entry.entityId} push failed (will retry): $e');
      }
    }
  }

  /// Met à jour un produit local depuis l'état serveur (utilisé en résolution
  /// de conflit).
  Future<void> _updateProductFromServerState(ProductDto serverState) async {
    final deletedAt = serverState.deletedAt != null
        ? DateTime.parse(serverState.deletedAt!)
        : null;

    // min_stock n'est pas encore connu du backend, donc serverState.minStock
    // vaut toujours null — on se replie sur la valeur locale au lieu de
    // l'effacer.
    final current = await (_db.select(
      _db.products,
    )..where((p) => p.id.equals(serverState.id))).getSingleOrNull();

    await _db
        .update(_db.products)
        .replace(
          ProductsCompanion(
            id: drift.Value(serverState.id),
            name: drift.Value(serverState.name),
            barcode: drift.Value(normalizeBarcode(serverState.barcode)),
            unitPrice: drift.Value(serverState.unitPrice),
            currentStock: drift.Value(serverState.currentStock),
            minStock: drift.Value(serverState.minStock ?? current?.minStock),
            dirty: const drift.Value(false), // Mark clean after sync
            updatedAt: drift.Value(DateTime.parse(serverState.updatedAt)),
            deletedAt: drift.Value(deletedAt),
          ),
        );
  }
}
