import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/domain/entities/store.dart';
import '../../domain/repositories/printer_repository.dart';
import '../../providers/printing_di_providers.dart';
import '../../../auth/providers/store_provider.dart';
import '../../../sales/domain/entities/cart_item.dart';
import '../../../sales/domain/entities/sale.dart';

part 'printer_provider.g.dart';

/// Clés de stockage des préférences d'imprimante dans flutter_secure_storage.
abstract class _PrinterKeys {
  /// Clé de l'adresse MAC de l'imprimante enregistrée.
  static const String mac = 'printer_mac';

  /// Clé du nom de l'imprimante enregistrée.
  static const String name = 'printer_name';
}

/// État scellé de l'imprimante Bluetooth.
sealed class PrinterState {
  /// Crée un [PrinterState].
  const PrinterState();
}

/// Aucune imprimante connectée ; une adresse MAC d'une session précédente peut
/// être enregistrée.
class PrinterDisconnected extends PrinterState {
  /// Crée un état [PrinterDisconnected].
  const PrinterDisconnected({this.savedMac, this.savedName});

  /// Adresse MAC enregistrée dans le secure storage, s'il y en a une.
  final String? savedMac;

  /// Nom de l'appareil enregistré dans le secure storage, s'il y en a un.
  final String? savedName;
}

/// Tentative de connexion à une imprimante en cours.
class PrinterConnecting extends PrinterState {
  /// Crée un état [PrinterConnecting].
  const PrinterConnecting();
}

/// Connecté avec succès à une imprimante BT.
class PrinterConnected extends PrinterState {
  /// Crée un état [PrinterConnected].
  const PrinterConnected({required this.mac, required this.name});

  /// Adresse MAC de l'imprimante connectée.
  final String mac;

  /// Nom affiché de l'imprimante connectée.
  final String name;
}

/// Une erreur est survenue pendant la connexion ou l'impression.
class PrinterError extends PrinterState {
  /// Crée un état [PrinterError].
  const PrinterError({required this.message, this.savedMac});

  /// Message d'erreur lisible par un humain.
  final String message;

  /// Adresse MAC enregistrée, si disponible (pour l'UI de reconnexion).
  final String? savedMac;
}

/// Manages Bluetooth printer connection lifecycle and printing.
///
/// keepAlive : un seul lien BT pour toute l'app. Les pages de reçu appellent
/// [print] sans écouter ce provider — une instance auto-dispose serait
/// recréée (puis libérée) à chaque impression.
@Riverpod(keepAlive: true)
class Printer extends _$Printer {
  static const _storage = FlutterSecureStorage();
  static final _log = Logger();

  @override
  PrinterState build() {
    unawaited(_loadSavedPrinter());
    return const PrinterDisconnected();
  }

  /// Charge de façon asynchrone les infos de l'imprimante enregistrée depuis le
  /// secure storage.
  /// Met à jour l'état une fois chargées.
  Future<void> _loadSavedPrinter() async {
    final saved = await _readSavedPrinter();
    if (saved != null && state is PrinterDisconnected) {
      // Ne met à jour que si toujours déconnecté (aucune opération en cours)
      state = PrinterDisconnected(savedMac: saved.mac, savedName: saved.name);
    }
  }

  /// Imprimante enregistrée lors du dernier [connect] réussi, lue depuis le
  /// stockage (et non depuis [state], qui ne l'a peut-être pas encore chargée).
  Future<({String mac, String name})?> _readSavedPrinter() async {
    final mac = await _storage.read(key: _PrinterKeys.mac);
    if (mac == null) return null;
    return (mac: mac, name: await _storage.read(key: _PrinterKeys.name) ?? mac);
  }

  /// Se connecte à l'appareil BT [mac] affiché sous le nom [name].
  ///
  /// Passe l'état à [PrinterConnecting], puis à [PrinterConnected] ou
  /// [PrinterError].
  Future<void> connect(String mac, String name) async {
    state = const PrinterConnecting();
    try {
      final service = ref.read(printerRepositoryProvider);
      await service.connect(mac);
      await _storage.write(key: _PrinterKeys.mac, value: mac);
      await _storage.write(key: _PrinterKeys.name, value: name);
      state = PrinterConnected(mac: mac, name: name);
      _log.i('Printer connected: $name ($mac)');
    } on PrintException catch (e) {
      state = PrinterError(message: e.details, savedMac: mac);
    } catch (e) {
      state = PrinterError(message: e.toString(), savedMac: mac);
    }
  }

  /// Déconnecte l'imprimante BT courante.
  Future<void> disconnect() async {
    final service = ref.read(printerRepositoryProvider);
    final current = state;
    await service.disconnect();
    if (current is PrinterConnected) {
      state = PrinterDisconnected(
        savedMac: current.mac,
        savedName: current.name,
      );
    } else {
      state = const PrinterDisconnected();
    }
  }

  /// Imprime un reçu. Se reconnecte si nécessaire avec l'adresse MAC
  /// enregistrée.
  ///
  /// Lève [PrintException] si aucune imprimante n'est configurée ou si l'envoi
  /// échoue.
  Future<void> print({required Sale sale, List<CartItem>? items}) => _printWith(
    (service, store) =>
        service.printReceipt(store: store, sale: sale, items: items),
  );

  /// Imprime un ticket de test sur l'imprimante enregistrée.
  ///
  /// Lève [PrintException] comme [print].
  Future<void> printTest() =>
      _printWith((service, store) => service.printTestPage(store: store));

  /// Oublie l'imprimante enregistrée : coupe le lien et efface l'adresse MAC.
  /// La prochaine impression demandera de choisir une imprimante.
  Future<void> forget() async {
    await ref.read(printerRepositoryProvider).disconnect();
    await _storage.delete(key: _PrinterKeys.mac);
    await _storage.delete(key: _PrinterKeys.name);
    state = const PrinterDisconnected();
  }

  /// Reconnecte l'imprimante enregistrée si besoin, exécute [job], puis libère
  /// le lien Bluetooth (même en échec).
  Future<void> _printWith(
    Future<void> Function(PrinterRepository service, Store store) job,
  ) async {
    final store = await ref.read(storeConfigProvider.future);
    if (store == null) {
      throw const PrintException(
        reason: PrintFailureReason.noPrinterConfigured,
        details: 'Store not configured',
      );
    }

    final service = ref.read(printerRepositoryProvider);

    // Reconnexion automatique à l'imprimante enregistrée si non connecté.
    final current = state;
    final ({String mac, String name}) printer;
    if (current is PrinterConnected) {
      printer = (mac: current.mac, name: current.name);
    } else {
      final saved = await _readSavedPrinter();
      if (saved == null) {
        throw const PrintException(
          reason: PrintFailureReason.noPrinterConfigured,
          details: 'No printer configured',
        );
      }
      printer = saved;
      await connect(printer.mac, printer.name);
    }

    try {
      await job(service, store);
    } finally {
      // Libère le lien BT immédiatement après impression (même en échec).
      await service.disconnect();
      state = PrinterDisconnected(
        savedMac: printer.mac,
        savedName: printer.name,
      );
    }
  }
}
