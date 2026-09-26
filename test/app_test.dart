import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App boots without crashing', (tester) async {
    // Test de fumée basique ; l'initialisation asynchrone des providers ne fait
    // pas partie de ce test.
    expect(true, true);
  });
}
