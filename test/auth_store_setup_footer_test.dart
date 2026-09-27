import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/features/auth/domain/entities/store.dart';
import 'package:mobile/features/auth/presentation/pages/store_setup_page.dart';
import 'package:mobile/features/auth/providers/store_provider.dart';

/// Boutique existante avec un pied de reçu ; mémorise ce qui est enregistré.
class _RecordingStore extends StoreConfig {
  static Store? saved;

  @override
  Future<Store?> build() async => const Store(
    name: 'Boutique Awa',
    isSubjectToVat: false,
    receiptFooterText: 'Ouvert 7j/7',
  );

  @override
  Future<void> save(Store store) async {
    saved = store;
    state = AsyncData(store);
  }
}

void main() {
  testWidgets('modifier la boutique conserve le pied de reçu', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [storeConfigProvider.overrideWith(_RecordingStore.new)],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const StoreSetupPage(isEditMode: true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final button = find.text('Enregistrer ma boutique');
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(_RecordingStore.saved, isNotNull);
    expect(_RecordingStore.saved!.receiptFooterText, 'Ouvert 7j/7');
  });
}
