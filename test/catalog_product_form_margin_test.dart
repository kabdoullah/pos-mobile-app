import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/app/theme/app_colors.dart';
import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/widgets/index.dart';
import 'package:mobile/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:mobile/features/catalog/presentation/pages/product_form_page.dart';
import 'package:mobile/features/catalog/providers/catalog_di_providers.dart';

class _MockCatalog extends Mock implements CatalogRepository {}

void main() {
  Future<void> pumpForm(WidgetTester tester) async {
    final catalog = _MockCatalog();
    when(catalog.watchCategories).thenAnswer((_) => Stream.value(const []));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [catalogRepositoryProvider.overrideWithValue(catalog)],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const ProductFormPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  final purchaseField = find.widgetWithText(AppTextField, "Prix d'achat");
  final sellingField = find.widgetWithText(AppTextField, 'Prix de vente');

  testWidgets(
    "vente à perte : pas d'alerte pendant la saisie du prix de vente",
    (tester) async {
      await pumpForm(tester);
      await tester.enterText(purchaseField, '1000');
      // Le commerçant est en train de taper « 1500 » : « 15 » n'est pas fini.
      await tester.enterText(sellingField, '15');
      await tester.pump();

      expect(find.textContaining('vente à perte'), findsNothing);
    },
  );

  testWidgets(
    'vente à perte : alerte (avertissement) une fois le prix de vente quitté',
    (tester) async {
      await pumpForm(tester);
      await tester.enterText(purchaseField, '1000');
      await tester.enterText(sellingField, '15');
      // Le focus quitte le prix de vente.
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();

      final loss = find.textContaining('vente à perte');
      expect(loss, findsOneWidget);
      final context = tester.element(loss);
      expect(
        tester.widget<Text>(loss).style?.color,
        AppColors.of(context).warning,
      );
    },
  );

  testWidgets('marge positive : affichée pendant la saisie', (tester) async {
    await pumpForm(tester);
    await tester.enterText(purchaseField, '1000');
    await tester.enterText(sellingField, '1500');
    await tester.pump();

    expect(find.textContaining('Marge estimée : + 500'), findsOneWidget);
  });
}
