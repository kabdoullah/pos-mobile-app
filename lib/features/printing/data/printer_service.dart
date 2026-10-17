import 'dart:io';

import 'package:logger/logger.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../auth/domain/entities/store.dart';
import '../../returns/domain/entities/sale_return.dart';
import '../../sales/domain/entities/cart_item.dart';
import '../../sales/domain/entities/sale.dart';
import '../domain/repositories/printer_repository.dart';
import 'receipt_formatter.dart';

/// Orchestre la découverte BT, la connexion et la transmission des données.
///
/// Utilise [print_bluetooth_thermal] pour toutes les opérations BT.
/// Ne conserve PAS d'état de connexion persistant — c'est [PrinterProvider] qui
/// s'en charge.
class PrinterService implements PrinterRepository {
  /// Crée un [PrinterService].
  const PrinterService();

  static final _log = Logger();

  /// Liste tous les appareils BT appairés disponibles sur le système.
  @override
  Future<List<BluetoothInfo>> getPairedDevices() async {
    if (Platform.isIOS) await _waitForIosBluetooth();
    return PrintBluetoothThermal.pairedBluetooths;
  }

  /// Attend que CoreBluetooth soit prêt avant le premier scan iOS.
  ///
  /// Le plugin ne crée son `CBCentralManager` qu'au premier appel, dont l'état
  /// est alors « inconnu » : un scan lancé tout de suite ne démarre pas et
  /// renvoie une liste vide au bout de 5 s. Si le Bluetooth reste éteint, on
  /// abandonne après ~2 s et le scan renvoie la liste vide comme avant.
  Future<void> _waitForIosBluetooth() async {
    for (var i = 0; i < 20; i++) {
      if (await PrintBluetoothThermal.bluetoothEnabled) return;
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }

  /// Se connecte à l'appareil [mac].
  ///
  /// Retourne true en cas de succès. Lève [PrintException] en cas d'échec.
  /// Note : [PrintBluetoothThermal.disconnect] est un getter, pas une méthode.
  @override
  Future<bool> connect(String mac) async {
    _log.i('Connecting to BT device: $mac');
    final result = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    if (!result) {
      throw PrintException(
        reason: PrintFailureReason.connectionFailed,
        details: 'Could not connect to $mac',
      );
    }
    return result;
  }

  /// Se déconnecte de l'appareil BT courant.
  @override
  Future<void> disconnect() async {
    // Note : disconnect est un getter, pas une méthode, dans
    // print_bluetooth_thermal v1.2.x
    await PrintBluetoothThermal.disconnect;
  }

  /// Retourne true si un appareil BT est actuellement connecté.
  @override
  Future<bool> get isConnected => PrintBluetoothThermal.connectionStatus;

  /// Imprime un reçu pour [sale].
  ///
  /// Formate les octets via [ReceiptFormatter] et les envoie à l'imprimante
  /// connectée.
  /// Lève [PrintException] si l'imprimante n'est pas connectée ou si l'envoi
  /// échoue.
  @override
  Future<void> printReceipt({
    required Store store,
    required Sale sale,
    List<CartItem>? items,
    String? sellerName,
    List<int>? logo,
  }) async {
    await _send(
      await ReceiptFormatter.format(
        store: store,
        sale: sale,
        items: items,
        sellerName: sellerName,
        logo: logo,
      ),
    );
    _log.i('Receipt printed successfully');
  }

  @override
  Future<void> printReturnReceipt({
    required Store store,
    required Sale sale,
    required SaleReturn saleReturn,
    required List<ReturnReceiptLine> lines,
    String? sellerName,
    List<int>? logo,
  }) async {
    await _send(
      await ReceiptFormatter.formatReturn(
        store: store,
        sale: sale,
        saleReturn: saleReturn,
        lines: lines,
        sellerName: sellerName,
        logo: logo,
      ),
    );
    _log.i('Return receipt printed successfully');
  }

  @override
  Future<void> printTestPage({required Store store, List<int>? logo}) async {
    await _send(
      await ReceiptFormatter.formatTestPage(store: store, logo: logo),
    );
    _log.i('Test page printed successfully');
  }

  /// Envoie des octets ESC/POS à l'imprimante connectée.
  ///
  /// Lève [PrintException] si l'imprimante n'est pas connectée ou si l'envoi
  /// échoue.
  Future<void> _send(List<int> bytes) async {
    final connected = await isConnected;
    if (!connected) {
      throw const PrintException(
        reason: PrintFailureReason.connectionFailed,
        details: 'Printer not connected',
      );
    }
    final result = await PrintBluetoothThermal.writeBytes(bytes);
    if (!result) {
      throw const PrintException(
        reason: PrintFailureReason.sendFailed,
        details: 'Failed to send data to printer',
      );
    }
  }
}
