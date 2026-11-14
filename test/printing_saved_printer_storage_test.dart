import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/printing/data/saved_printer_storage.dart';

void main() {
  late SavedPrinterStorage storage;

  setUp(() => storage = SavedPrinterStorage());

  test('rien de mémorisé : null', () async {
    FlutterSecureStorage.setMockInitialValues({});
    expect(await storage.read(), isNull);
  });

  test('save puis read : même imprimante', () async {
    FlutterSecureStorage.setMockInitialValues({});
    await storage.save((mac: 'AA:BB:CC', name: 'PT-210'));
    expect(await storage.read(), (mac: 'AA:BB:CC', name: 'PT-210'));
  });

  test('nom absent : l\'adresse MAC sert de libellé', () async {
    FlutterSecureStorage.setMockInitialValues({'printer_mac': 'AA:BB:CC'});
    expect(await storage.read(), (mac: 'AA:BB:CC', name: 'AA:BB:CC'));
  });

  test('clear : plus rien de mémorisé', () async {
    FlutterSecureStorage.setMockInitialValues({
      'printer_mac': 'AA:BB:CC',
      'printer_name': 'PT-210',
    });
    await storage.clear();
    expect(await storage.read(), isNull);
  });
}
