import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/widgets/index.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/catalog/domain/entities/product_page.dart';
import 'package:mobile/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:mobile/features/catalog/presentation/pages/product_form_page.dart';
import 'package:mobile/features/catalog/providers/catalog_di_providers.dart';

class _MockCatalog extends Mock implements CatalogRepository {}

void main() {
  testWidgets(
    'enregistrer un nouveau produit : aucune erreur affichée, retour arrière',
    (tester) async {
      final catalog = _MockCatalog();
      when(catalog.watchCategories).thenAnswer((_) => Stream.value(const []));
      when(
        () => catalog.createProduct(
          name: any(named: 'name'),
          sellingPrice: any(named: 'sellingPrice'),
          purchasePrice: any(named: 'purchasePrice'),
          barcode: any(named: 'barcode'),
          currentStock: any(named: 'currentStock'),
          minStock: any(named: 'minStock'),
          categoryId: any(named: 'categoryId'),
        ),
      ).thenAnswer((_) async {
        // Écriture qui prend du temps, comme drift + file de synchro.
        await Future<void>.delayed(const Duration(milliseconds: 50));
        return Product(
          id: 'p1',
          name: 'Coca',
          sellingPrice: Decimal.fromInt(500),
          updatedAt: DateTime(2026),
        );
      });
      when(
        () => catalog.getProducts(
          query: any(named: 'query'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async =>
            const ProductPage(items: [], nextCursor: null, hasMore: false),
      );

      final router = GoRouter(
        initialLocation: '/form',
        routes: [
          GoRoute(path: '/', builder: (_, _) => const Text('stock')),
          GoRoute(path: '/form', builder: (_, _) => const ProductFormPage()),
        ],
      );
      router.go('/');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [catalogRepositoryProvider.overrideWithValue(catalog)],
          child: MaterialApp.router(
            theme: AppTheme.light(),
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();
      unawaited(router.push<void>('/form'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(AppTextField, 'Nom du produit'),
        'Coca',
      );
      await tester.enterText(
        find.widgetWithText(AppTextField, 'Prix de vente'),
        '500',
      );
      // Clavier fermé : sinon le champ encore actif ramène le défilement sur
      // lui et le bouton repasse sous le bord de l'écran de test.
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      final save = find.text('Enregistrer le produit');
      await tester.ensureVisible(save);
      await tester.pumpAndSettle();
      await tester.tap(save);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsNothing);
      expect(find.text('stock'), findsOneWidget);
    },
  );

  testWidgets(
    'modifier : le stock suivi est relu à l’enregistrement, jamais écrasé',
    (tester) async {
      final catalog = _MockCatalog();
      when(catalog.watchCategories).thenAnswer((_) => Stream.value(const []));
      Product withStock(int stock) => Product(
        id: 'p1',
        name: 'Coca',
        sellingPrice: Decimal.fromInt(500),
        currentStock: stock,
        updatedAt: DateTime(2026),
      );
      // 10 à l'ouverture du formulaire, 7 au moment d'enregistrer : trois
      // ventes ont eu lieu entre-temps.
      var reads = 0;
      when(
        () => catalog.getProduct('p1'),
      ).thenAnswer((_) async => withStock(reads++ == 0 ? 10 : 7));
      when(
        () => catalog.updateProduct(
          id: any(named: 'id'),
          name: any(named: 'name'),
          sellingPrice: any(named: 'sellingPrice'),
          purchasePrice: any(named: 'purchasePrice'),
          barcode: any(named: 'barcode'),
          currentStock: any(named: 'currentStock'),
          minStock: any(named: 'minStock'),
        ),
      ).thenAnswer((_) async => withStock(7));

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (_, _) => const Text('stock')),
          GoRoute(
            path: '/form',
            builder: (_, _) => const ProductFormPage(productId: 'p1'),
          ),
        ],
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [catalogRepositoryProvider.overrideWithValue(catalog)],
          child: MaterialApp.router(
            theme: AppTheme.light(),
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();
      unawaited(router.push<void>('/form'));
      await tester.pumpAndSettle();

      // Stock suivi : affiché, mais modifiable seulement par « Ajuster ».
      expect(find.text('Stock actuel'), findsOneWidget);
      expect(find.text('Se modifie par « Ajuster ».'), findsOneWidget);

      await tester.tap(find.text('Enregistrer les modifications'));
      await tester.pumpAndSettle();

      verify(
        () => catalog.updateProduct(
          id: 'p1',
          name: 'Coca',
          sellingPrice: '500',
          purchasePrice: null,
          barcode: null,
          currentStock: 7,
          minStock: null,
        ),
      ).called(1);
      expect(find.text('stock'), findsOneWidget);
    },
  );
}
