import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/storage/device_id_storage.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late _MockSecureStorage secure;
  late Map<String, String> store;

  setUp(() {
    secure = _MockSecureStorage();
    store = {};
    when(
      () => secure.read(key: any(named: 'key')),
    ).thenAnswer((i) async => store[i.namedArguments[#key] as String]);
    when(
      () => secure.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((i) async {
      store[i.namedArguments[#key] as String] =
          i.namedArguments[#value] as String;
    });
  });

  test('same id twice', () async {
    final storage = DeviceIdStorage(secureStorage: secure);
    final first = await storage.getOrCreate();
    final second = await storage.getOrCreate();
    expect(first, second);
    expect(first, matches(RegExp(r'^[0-9a-f-]{36}$')));
    expect(store.keys, ['cash_device_id']);
  });

  test('id survives a new instance', () async {
    final first = await DeviceIdStorage(secureStorage: secure).getOrCreate();
    final second = await DeviceIdStorage(secureStorage: secure).getOrCreate();
    expect(second, first);
  });
}
