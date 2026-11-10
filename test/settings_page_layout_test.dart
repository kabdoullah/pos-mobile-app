import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/providers/connectivity_provider.dart';
import 'package:mobile/core/sync/sync_orchestrator.dart';
import 'package:mobile/core/sync/sync_providers.dart';
import 'package:mobile/features/auth/domain/entities/account_email.dart';
import 'package:mobile/features/auth/domain/entities/store.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/auth/providers/account_email_provider.dart';
import 'package:mobile/features/auth/providers/seller_profile_provider.dart';
import 'package:mobile/features/auth/providers/store_provider.dart';
import 'package:mobile/features/cash_register/domain/repositories/cash_register_repository.dart';
import 'package:mobile/features/cash_register/providers/cash_register_di_providers.dart';
import 'package:mobile/features/settings/presentation/pages/settings_page.dart';
import 'package:mobile/features/settings/presentation/widgets/receipt_settings_sheet.dart';

class _Authenticated extends Auth {
  @override
  Future<AuthStatus> build() async =>
      const AuthAuthenticated(User(id: 'u1', phoneNumber: '+2250700000000'));
}

class _Seller extends SellerProfile {
  @override
  Future<String?> build() async => 'Awa Koné';
}

/// Email non confirmé et long : la ligne la plus chargée.
class _UnverifiedEmail extends AccountEmailStatus {
  @override
  Future<AccountEmail> build() async => const AccountEmail(
    email: 'awa.kone.boutique.cocody.angre@example.com',
    isVerified: false,
  );
}

/// Synchro figée (pas de timers ni d'appels réseau).
class _IdleSync extends SyncOrchestrator {
  @override
  SyncStatus build() =>
      SyncStatusIdle(lastSyncAt: DateTime(2026, 9, 27, 14, 32));
}

const _store = Store(
  name: 'Boutique Chez Awa — Cocody Angré 8e tranche',
  address: 'Rue des Jardins, près de la pharmacie, Abidjan',
  ncc: '1234567A',
  isSubjectToVat: false,
  receiptFooterText: 'Ouvert 7j/7 de 7h à 22h — Tél. 07 00 00 00 00',
);

class _Store extends StoreConfig {
  @override
  Future<Store?> build() async => _store;
}

class _MockCashRegister extends Mock implements CashRegisterRepository {}

Future<void> pump(WidgetTester tester, Widget home, ThemeData theme) async {
  // Caisse fermée : la déconnexion reste possible
  // (`cash_register_guards_test.dart` couvre le refus).
  final cash = _MockCashRegister();
  when(cash.getActiveSession).thenAnswer((_) async => null);
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  FlutterSecureStorage.setMockInitialValues({
    'printer_mac': 'AA:BB:CC',
    'printer_name': 'Goojprt PT-210 comptoir principal',
  });

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(_Authenticated.new),
        storeConfigProvider.overrideWith(_Store.new),
        sellerProfileProvider.overrideWith(_Seller.new),
        accountEmailStatusProvider.overrideWith(_UnverifiedEmail.new),
        syncOrchestratorProvider.overrideWith(_IdleSync.new),
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
        pendingSyncCountProvider.overrideWith((ref) => Stream.value(3)),
        cashRegisterRepositoryProvider.overrideWithValue(cash),
      ],
      child: MaterialApp(theme: theme, home: home),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  for (final (name, theme) in [
    ('clair', AppTheme.light()),
    ('sombre', AppTheme.dark()),
  ]) {
    testWidgets('paramètres, thème $name', (tester) async {
      await pump(tester, const SettingsPage(), theme);
      expect(tester.takeException(), isNull);
      expect(find.text('Commerce'), findsOneWidget);
      expect(find.text('3 ventes en attente'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Se déconnecter'), 200);
      expect(
        find.text('+225 07 00 00 00 00 · Vendeur : Awa Koné'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);

      // Déconnexion avec ventes en attente : avertissement explicite.
      await tester.ensureVisible(find.text('Se déconnecter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Se déconnecter'));
      await tester.pumpAndSettle();
      expect(find.textContaining('elles seront effacées'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('feuille Reçus avec aperçu, thème $name', (tester) async {
      await pump(
        tester,
        const Scaffold(body: ReceiptSettingsSheet(store: _store)),
        theme,
      );
      expect(tester.takeException(), isNull);
      await tester.enterText(find.byType(TextField), 'Merci, à bientôt !');
      await tester.pump();
      // Le texte apparaît dans le champ et dans l'aperçu du ticket.
      expect(find.text('Merci, à bientôt !'), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });
  }
}
