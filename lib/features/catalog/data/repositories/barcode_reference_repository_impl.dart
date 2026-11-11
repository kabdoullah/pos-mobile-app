import 'dart:convert';

import '../../../../core/utils/barcode_utils.dart';
import '../../domain/repositories/barcode_reference_repository.dart';

/// Lit le référentiel `{code-barres: nom}` généré par
/// `tool/build_barcode_reference.py`, une seule fois, au premier besoin.
class BarcodeReferenceRepositoryImpl implements BarcodeReferenceRepository {
  /// Crée le repository. [loadJson] renvoie le contenu JSON du référentiel
  /// (asset en production, chaîne en dur dans les tests).
  BarcodeReferenceRepositoryImpl({required Future<String> Function() loadJson})
    : _loadJson = loadJson;

  /// Chemin de l'asset embarqué.
  static const assetPath = 'assets/data/barcode_reference.json';

  final Future<String> Function() _loadJson;
  Future<Map<String, String>>? _reference;

  @override
  Future<String?> suggestName(String barcode) async {
    final normalized = normalizeBarcode(barcode);
    if (normalized == null) return null;
    final reference = await (_reference ??= _load());
    for (final candidate in barcodeLookupCandidates(normalized)) {
      final name = reference[candidate];
      if (name != null) return name;
    }
    return null;
  }

  Future<Map<String, String>> _load() async {
    try {
      final decoded = jsonDecode(await _loadJson()) as Map<String, Object?>;
      return {
        for (final entry in decoded.entries)
          if (entry.value case final String name) entry.key: name,
      };
    } catch (_) {
      // Échec de lecture : on permet un nouvel essai au prochain scan.
      _reference = null;
      rethrow;
    }
  }
}
