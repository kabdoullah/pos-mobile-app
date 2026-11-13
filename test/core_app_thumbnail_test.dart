import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/app/theme/app_colors.dart';
import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/widgets/index.dart';

void main() {
  for (final (name, theme) in [
    ('clair', AppTheme.light()),
    ('sombre', AppTheme.dark()),
  ]) {
    testWidgets('sans image : pictogramme « colis » sur fond en creux, $name', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: Center(child: AppThumbnail(image: null, size: 40)),
          ),
        ),
      );
      final colors = theme.extension<AppColors>()!;
      final thumbnail = find.byType(AppThumbnail);
      // Plus d'icône Material : le pictogramme est dessiné.
      expect(
        find.descendant(of: thumbnail, matching: find.byType(Icon)),
        findsNothing,
      );
      final background = tester.widget<ColoredBox>(
        find.descendant(of: thumbnail, matching: find.byType(ColoredBox)),
      );
      expect(background.color, colors.surfaceSunken);
      final paint = tester.widget<CustomPaint>(
        find.descendant(
          of: thumbnail,
          matching: find.byWidgetPredicate(
            (w) => w is CustomPaint && w.painter != null,
          ),
        ),
      );
      expect(paint.size, const Size.square(20));
      expect(tester.takeException(), isNull);
    });
  }
}
