import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/home/presentation/providers/home_providers.dart';

void main() {
  test('todayProvider rolls over to the new day at midnight', () {
    fakeAsync((async) {
      withClock(async.getClock(DateTime(2026, 9, 26, 23, 58)), () {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        container.listen(todayProvider, (_, _) {});

        expect(container.read(todayProvider), DateTime(2026, 9, 26));

        async.elapse(const Duration(minutes: 1));
        expect(container.read(todayProvider), DateTime(2026, 9, 26));

        async.elapse(const Duration(minutes: 1));
        expect(container.read(todayProvider), DateTime(2026, 9, 27));
      });
    });
  });
}
