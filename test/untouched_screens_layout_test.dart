import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/features/auth/domain/entities/store.dart';
import 'package:mobile/features/auth/presentation/pages/phone_login_page.dart';
import 'package:mobile/features/auth/presentation/pages/pin_login_page.dart';
import 'package:mobile/features/auth/presentation/pages/pin_setup_page.dart';
import 'package:mobile/features/auth/presentation/pages/register_page.dart';
import 'package:mobile/features/auth/presentation/pages/store_setup_page.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/auth/providers/store_provider.dart';
import 'package:mobile/features/catalog/presentation/pages/product_form_page.dart';
import 'package:mobile/features/catalog/presentation/pages/product_import_page.dart';
import 'package:mobile/features/onboarding/presentation/pages/tutorial_page.dart';

class _Unauthenticated extends Auth {
  @override
  Future<AuthStatus> build() async => const AuthUnauthenticated();
}

class _Store extends StoreConfig {
  @override
  Future<Store?> build() async => const Store(
    name: 'Boutique Chez Awa — Cocody Angré 8e tranche',
    isSubjectToVat: true,
  );
}

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  final screens = <(String, Widget)>[
    ('connexion', const PhoneLoginPage()),
    ('inscription', const RegisterPage()),
    ('création du PIN', const PinSetupPage()),
    ('saisie du PIN', const PinLoginPage()),
    ('configuration boutique', const StoreSetupPage()),
    ('tutoriel', const TutorialPage()),
    ('nouveau produit', const ProductFormPage(initialBarcode: '5449000000996')),
    ('import de produits', const ProductImportPage()),
  ];

  for (final (themeName, theme) in [
    ('clair', AppTheme.light()),
    ('sombre', AppTheme.dark()),
  ]) {
    for (final (screen, page) in screens) {
      testWidgets('$screen, 360×640, thème $themeName', (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        FlutterSecureStorage.setMockInitialValues({});

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(_Unauthenticated.new),
              storeConfigProvider.overrideWith(_Store.new),
            ],
            child: MaterialApp(theme: theme, home: page),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
