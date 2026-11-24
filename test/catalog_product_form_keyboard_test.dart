import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/widgets/index.dart';
import 'package:mobile/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:mobile/features/catalog/presentation/pages/product_form_page.dart';
import 'package:mobile/features/catalog/providers/catalog_di_providers.dart';

class _MockCatalog extends Mock implements CatalogRepository {}

void main() {
  Future<void> pumpForm(WidgetTester tester) async {
    // Petit écran : les derniers champs sont hors de vue au départ.
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

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

  EditableText editable(WidgetTester tester, String label) =>
      tester.widget<EditableText>(
        find.descendant(
          of: find.widgetWithText(AppTextField, label),
          matching: find.byType(EditableText),
        ),
      );

  bool hasFocus(WidgetTester tester, String label) =>
      editable(tester, label).focusNode.hasFocus;

  testWidgets('« Suivant » enchaîne les champs, sans passer par la catégorie', (
    tester,
  ) async {
    await pumpForm(tester);
    await tester.tap(find.widgetWithText(AppTextField, 'Code-barres'));
    await tester.pump();

    const order = [
      'Code-barres',
      'Nom du produit',
      "Prix d'achat",
      'Prix de vente',
      'Stock initial',
      "Seuil d'alerte",
    ];
    for (var i = 0; i < order.length - 1; i++) {
      expect(hasFocus(tester, order[i]), isTrue, reason: order[i]);
      expect(editable(tester, order[i]).textInputAction, TextInputAction.next);
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();
    }

    // Dernier champ : « Terminé » ferme le clavier, et il est visible.
    expect(hasFocus(tester, "Seuil d'alerte"), isTrue);
    expect(
      editable(tester, "Seuil d'alerte").textInputAction,
      TextInputAction.done,
    );
    expect(
      tester
          .getRect(find.widgetWithText(AppTextField, "Seuil d'alerte"))
          .bottom,
      lessThanOrEqualTo(640),
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(hasFocus(tester, "Seuil d'alerte"), isFalse);
  });
}
