import 'package:clock/clock.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:mobile/features/catalog/providers/catalog_di_providers.dart';
import 'package:mobile/features/sales/presentation/providers/cart_provider.dart';
import 'package:mobile/features/sales/presentation/providers/scan_provider.dart';
import 'package:mocktail/mocktail.dart';

class _MockCatalog extends Mock implements CatalogRepository {}

const _code = '1234567890128';

void main() {
  late ProviderContainer container;
  late DateTime now;

  setUp(() {
    final catalog = _MockCatalog();
    when(() => catalog.getByBarcode(_code)).thenAnswer(
      (_) async => Product(
        id: 'p1',
        name: 'Coca',
        sellingPrice: Decimal.fromInt(500),
        updatedAt: DateTime(2026),
      ),
    );
    container = ProviderContainer(
      overrides: [catalogRepositoryProvider.overrideWithValue(catalog)],
    );
    addTearDown(container.dispose);
    now = DateTime(2026, 10, 31, 12);
  });

  Future<ScanResult> scanAt(Duration elapsed) =>
      withClock(Clock.fixed(now.add(elapsed)), () async {
        final scanner = container.read(scanControllerProvider.notifier);
        return (await scanner.scan(_code)).result;
      });

  int quantity() => container.read(cartProvider).items.single.quantity;

  test('un second passage du même article après le délai ajoute 1', () async {
    final sub = container.listen(scanControllerProvider, (_, _) {});
    addTearDown(sub.close);

    expect(await scanAt(Duration.zero), ScanResult.added);
    expect(
      await scanAt(const Duration(seconds: 3)),
      ScanResult.quantityIncremented,
    );
    expect(quantity(), 2);
  });

  test('un code gardé dans le cadre ne s’ajoute pas en boucle', () async {
    final sub = container.listen(scanControllerProvider, (_, _) {});
    addTearDown(sub.close);

    expect(await scanAt(Duration.zero), ScanResult.added);
    // La caméra relit le code toutes les ~250 ms tant qu'il reste visible.
    for (var ms = 250; ms <= 5000; ms += 250) {
      expect(
        await scanAt(Duration(milliseconds: ms)),
        ScanResult.cooldown,
        reason: 'à $ms ms',
      );
    }
    expect(quantity(), 1);

    // Retiré du cadre plus de 2 s, puis rescanné : compté.
    expect(
      await scanAt(const Duration(milliseconds: 7500)),
      ScanResult.quantityIncremented,
    );
  });
}
