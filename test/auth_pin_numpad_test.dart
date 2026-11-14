import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/features/auth/presentation/widgets/pin_numpad.dart';

void main() {
  testWidgets('touches activables par les lecteurs d’écran', (tester) async {
    final handle = tester.ensureSemantics();
    final digits = <String>[];
    var erased = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: PinNumpad(onDigit: digits.add, onBackspace: () => erased++),
        ),
      ),
    );

    // Chaque touche est un bouton avec une action « toucher ».
    expect(
      tester.getSemantics(find.bySemanticsLabel('5')),
      matchesSemantics(
        label: '5',
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );

    // Double-tap TalkBack = action sémantique « tap ».
    tester.semantics.tap(find.semantics.byLabel('5'));
    tester.semantics.tap(find.semantics.byLabel('Effacer'));
    await tester.pump();
    expect(digits, ['5']);
    expect(erased, 1);
    handle.dispose();
  });
}
