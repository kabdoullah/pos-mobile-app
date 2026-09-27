import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../../auth/domain/entities/store.dart';
import '../../../sales/domain/entities/cart_item.dart';
import '../../../sales/domain/entities/sale.dart';

/// Motifs d'échec d'une impression.
enum PrintFailureReason {
  /// Aucune adresse MAC d'imprimante n'a été enregistrée.
  noPrinterConfigured,

  /// La tentative de connexion BT a échoué ou a expiré.
  connectionFailed,

  /// Les données n'ont pas pu être envoyées à l'imprimante.
  sendFailed,
}

/// Levée quand l'impression échoue.
class PrintException implements Exception {
  /// Crée une [PrintException].
  const PrintException({required this.reason, required this.details});

  /// Cause sous-jacente de l'échec.
  final PrintFailureReason reason;

  /// Détail de l'erreur, lisible par un humain.
  final String details;

  @override
  String toString() => 'PrintException(${reason.name}): $details';
}

/// Message à afficher à l'utilisateur ([PrintException.details] reste
/// technique, pour les logs).
extension PrintExceptionMessage on PrintException {
  /// Explication en français, avec l'action à faire.
  String get userMessage => switch (reason) {
    PrintFailureReason.noPrinterConfigured => 'Aucune imprimante configurée.',
    PrintFailureReason.connectionFailed =>
      'Imprimante injoignable. Vérifiez qu’elle est allumée et à proximité.',
    PrintFailureReason.sendFailed =>
      'Impression interrompue. Vérifiez le papier et réessayez.',
  };
}

/// Repository pour les opérations d'imprimante Bluetooth.
///
/// Abstrait les interactions matérielles et la gestion de la connexion.
abstract interface class PrinterRepository {
  /// Liste tous les appareils BT appairés disponibles sur le système.
  Future<List<BluetoothInfo>> getPairedDevices();

  /// Se connecte à l'appareil [mac].
  ///
  /// Retourne true en cas de succès. Lève [PrintException] en cas d'échec.
  Future<bool> connect(String mac);

  /// Se déconnecte de l'appareil BT courant.
  Future<void> disconnect();

  /// Retourne true si un appareil BT est actuellement connecté.
  Future<bool> get isConnected;

  /// Imprime un reçu pour [sale].
  ///
  /// Lève [PrintException] si l'imprimante n'est pas connectée ou si l'envoi
  /// échoue.
  Future<void> printReceipt({
    required Store store,
    required Sale sale,
    List<CartItem>? items,
  });

  /// Imprime un ticket de test (en-tête de la boutique, date, pied de page) —
  /// vérifie l'imprimante sans simuler de vente.
  Future<void> printTestPage({required Store store});
}
