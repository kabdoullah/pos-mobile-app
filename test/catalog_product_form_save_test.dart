import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/app/theme/app_theme.dart';
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
          unitPrice: any(named: 'unitPrice'),
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
          unitPrice: Decimal.fromInt(500),
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

      await tester.enterText(find.byType(TextField).at(0), 'Coca');
      await tester.enterText(find.byType(TextField).at(1), '500');
      final save = find.text('Enregistrer');
      await tester.ensureVisible(save);
      await tester.pumpAndSettle();
      await tester.tap(save);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsNothing);
      expect(find.text('stock'), findsOneWidget);
    },
  );
}
