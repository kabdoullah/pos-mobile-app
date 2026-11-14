import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/repositories/saved_printer_repository.dart';

/// [SavedPrinterRepository] sur le secure storage (clés `printer_mac` et
/// `printer_name`).
class SavedPrinterStorage implements SavedPrinterRepository {
  /// Crée le stockage de l'imprimante mémorisée.
  SavedPrinterStorage({FlutterSecureStorage? secureStorage})
    : _storage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _macKey = 'printer_mac';
  static const _nameKey = 'printer_name';

  @override
  Future<SavedPrinter?> read() async {
    final mac = await _storage.read(key: _macKey);
    if (mac == null) return null;
    // Nom absent (ancienne version) : l'adresse MAC sert de libellé.
    return (mac: mac, name: await _storage.read(key: _nameKey) ?? mac);
  }

  @override
  Future<void> save(SavedPrinter printer) async {
    await _storage.write(key: _macKey, value: printer.mac);
    await _storage.write(key: _nameKey, value: printer.name);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _macKey);
    await _storage.delete(key: _nameKey);
  }
}
