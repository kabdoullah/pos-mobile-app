import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/auth/domain/entities/store.dart';
import 'package:mobile/features/auth/providers/store_provider.dart';
import 'package:mobile/features/printing/domain/repositories/printer_repository.dart';
import 'package:mobile/features/printing/presentation/providers/printer_provider.dart';
import 'package:mobile/features/printing/providers/printing_di_providers.dart';
import 'package:mobile/features/sales/domain/entities/cart_item.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

/// Imprimante Bluetooth factice qui enregistre ce qui s'est passé.
class _FakePrinter implements PrinterRepository {
  bool connected = false;
  bool failSend = false;
  int printed = 0;
  int testPages = 0;

  @override
  Future<bool> connect(String mac) async => connected = true;

  @override
  Future<void> disconnect() async => connected = false;

  @override
  Future<List<BluetoothInfo>> getPairedDevices() async => [];

  @override
  Future<bool> get isConnected async => connected;

  @override
  Future<void> printReceipt({
    required Store store,
    required Sale sale,
    List<CartItem>? items,
  }) async {
    if (failSend) {
      throw const PrintException(
        reason: PrintFailureReason.sendFailed,
        details: 'send failed',
      );
    }
    printed++;
  }

  @override
  Future<void> printTestPage({required Store store}) async => testPages++;
}

class _ConfiguredStore extends StoreConfig {
  @override
  Future<Store?> build() async =>
      const Store(name: 'Boutique Awa', isSubjectToVat: false);
}

final _sale = Sale(
  id: 's1',
  receiptNumber: 1,
  totalAmount: Decimal.fromInt(1500),
  vatAmount: Decimal.zero,
  paymentMethod: PaymentMethod.cash,
  createdAt: DateTime(2026),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakePrinter bt;
  late ProviderContainer container;

  setUp(() {
    bt = _FakePrinter();
    container = ProviderContainer(
      overrides: [
        printerRepositoryProvider.overrideWithValue(bt),
        storeConfigProvider.overrideWith(_ConfiguredStore.new),
      ],
    );
    addTearDown(container.dispose);
  });

  test('prints with the saved printer on first use (receipt pages do not '
      'watch the provider)', () async {
    FlutterSecureStorage.setMockInitialValues({
      'printer_mac': 'AA:BB:CC',
      'printer_name': 'PT-210',
    });

    await container.read(printerProvider.notifier).print(sale: _sale);

    expect(bt.printed, 1);
    expect(bt.connected, isFalse, reason: 'BT link released after printing');
  });

  test('no saved printer: noPrinterConfigured', () async {
    FlutterSecureStorage.setMockInitialValues({});

    await expectLater(
      container.read(printerProvider.notifier).print(sale: _sale),
      throwsA(
        isA<PrintException>().having(
          (e) => e.reason,
          'reason',
          PrintFailureReason.noPrinterConfigured,
        ),
      ),
    );
  });

  test('send failure still releases the BT link', () async {
    FlutterSecureStorage.setMockInitialValues({'printer_mac': 'AA:BB:CC'});
    bt.failSend = true;

    await expectLater(
      container.read(printerProvider.notifier).print(sale: _sale),
      throwsA(isA<PrintException>()),
    );
    expect(bt.connected, isFalse);
    expect(container.read(printerProvider), isA<PrinterDisconnected>());
  });

  test('ticket de test : reconnexion à l’imprimante enregistrée puis lien '
      'libéré', () async {
    FlutterSecureStorage.setMockInitialValues({
      'printer_mac': 'AA:BB:CC',
      'printer_name': 'PT-210',
    });

    await container.read(printerProvider.notifier).printTest();

    expect(bt.testPages, 1);
    expect(bt.printed, 0, reason: 'aucune vente simulée');
    expect(bt.connected, isFalse);
  });

  test(
    'oublier : efface l’imprimante, la prochaine impression la redemande',
    () async {
      FlutterSecureStorage.setMockInitialValues({
        'printer_mac': 'AA:BB:CC',
        'printer_name': 'PT-210',
      });
      final notifier = container.read(printerProvider.notifier);

      await notifier.forget();

      final state = container.read(printerProvider);
      expect(state, isA<PrinterDisconnected>());
      expect((state as PrinterDisconnected).savedMac, isNull);
      await expectLater(
        notifier.print(sale: _sale),
        throwsA(
          isA<PrintException>().having(
            (e) => e.reason,
            'reason',
            PrintFailureReason.noPrinterConfigured,
          ),
        ),
      );
    },
  );
}
