import '../../database/app_database.dart';
import '../storage/image_file_cache.dart';

/// Efface toutes les données métier locales (drift).
/// Appelé au changement de commerçant pour éviter la fuite cross-tenant.
class LocalDataResetService {
  /// Crée le service avec l'instance drift.
  const LocalDataResetService(this._db, {ImageFileCache? imageCache})
    : _imageCache = imageCache;

  final AppDatabase _db;
  final ImageFileCache? _imageCache;

  /// Supprime produits, catégories, ventes, lignes de vente, file de sync et
  /// metadata.
  /// Transaction unique : tout ou rien.
  Future<void> wipeBusinessData() async {
    await _db.transaction(() async {
      await _db.delete(_db.saleItems).go();
      await _db.delete(_db.sales).go();
      await _db.delete(_db.products).go();
      await _db.delete(_db.categories).go();
      await _db.delete(_db.syncQueue).go();
      await _db.delete(_db.syncMetadata).go();
    });
    // Photos et logo du compte précédent.
    await _imageCache?.clear();
  }
}
