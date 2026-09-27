import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Cache disque des images serveur (photos produit, logo), ADR-0008.
///
/// Une image = un fichier `<clé>_<version>.webp`. La version est le SHA-256
/// renvoyé par l'API : une image ne change jamais sous une même version, donc
/// un fichier présent est toujours valide. Écrire une nouvelle version supprime
/// les anciennes de la même clé.
class ImageFileCache {
  /// Crée le cache ; [baseDirectory] permet de l'isoler en test.
  ImageFileCache({Future<Directory> Function()? baseDirectory})
    : _baseDirectory = baseDirectory ?? getApplicationSupportDirectory;

  final Future<Directory> Function() _baseDirectory;

  Future<Directory> _dir() async {
    final dir = Directory('${(await _baseDirectory()).path}/images');
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir;
  }

  File _file(Directory dir, String key, String version) =>
      File('${dir.path}/${key}_$version.webp');

  /// Fichier de [key] à la [version] donnée, s'il est en cache.
  Future<File?> get(String key, String version) async {
    final file = _file(await _dir(), key, version);
    return file.existsSync() ? file : null;
  }

  /// Enregistre [bytes] pour [key]/[version] et supprime les autres versions.
  Future<File> put(String key, String version, List<int> bytes) async {
    final dir = await _dir();
    await remove(key);
    return _file(dir, key, version).writeAsBytes(bytes, flush: true);
  }

  /// Supprime toutes les versions de [key].
  Future<void> remove(String key) async {
    final dir = await _dir();
    await for (final entity in dir.list()) {
      final name = entity.uri.pathSegments.last;
      if (entity is File && name.startsWith('${key}_')) await entity.delete();
    }
  }

  /// Vide le cache (changement de compte).
  Future<void> clear() async {
    final dir = await _dir();
    if (dir.existsSync()) await dir.delete(recursive: true);
  }
}
