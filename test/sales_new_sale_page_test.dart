import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/app/theme/app_theme.dart';
import 'package:mobile/core/widgets/index.dart';
import 'package:mobile/core/providers/connectivity_provider.dart';
import 'package:mobile/core/sync/sync_providers.dart';
import 'package:mobile/features/auth/domain/entities/store.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/auth/providers/store_provider.dart';
import 'package:mobile/features/cash_register/domain/entities/cash_session.dart';
import 'package:mobile/features/cash_register/domain/repositories/cash_register_repository.dart';
import 'package:mobile/features/cash_register/providers/cash_register_di_providers.dart';
import 'package:mobile/features/catalog/domain/entities/category.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/catalog/domain/entities/product_page.dart';
import 'package:mobile/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:mobile/features/catalog/providers/catalog_di_providers.dart';
import 'package:mobile/features/sales/presentation/pages/new_sale_page.dart';
import 'package:mobile/features/sales/presentation/providers/cart_provider.dart';
import 'package:mobile/features/sales/presentation/providers/checkout_provider.dart';
import 'package:mobile/features/sales/presentation/widgets/product_browser.dart';
import 'package:mobile/features/sales/presentation/widgets/product_search_results.dart';
import 'package:mobile/features/sales/presentation/widgets/sale_cart_sheet.dart';
import 'package:mobile/features/sales/presentation/widgets/sale_scanner_panel.dart';

/// Évite que l'orchestrateur de synchro (pastille réseau) initialise la vraie
/// authentification.
class _NoAuth extends Auth {
  @override
  Future<AuthStatus> build() async => const AuthUnauthenticated();
}

class _Store extends StoreConfig {
  @override
  Future<Store?> build() async =>
      const Store(name: 'Ma boutique', isSubjectToVat: false);
}

class _MockCatalog extends Mock implements CatalogRepository {}

class _MockCashRegister extends Mock implements CashRegisterRepository {}

Product product(
  String name, {
  int? stock,
  String price = '2000',
  String? categoryId,
}) => Product(
  id: name,
  name: name,
  sellingPrice: Decimal.parse(price),
  currentStock: stock,
  categoryId: categoryId,
  updatedAt: DateTime(2026),
);

final catalog = [
  product('Coca-Cola 33cl', stock: 24, categoryId: 'boissons'),
  product('Eau 1,5L', stock: 1, price: '500', categoryId: 'boissons'),
  product('Fanta', stock: 0, price: '1500'),
];

final _openSession = CashSession(
  id: 's1',
  deviceId: 'device-1',
  status: CashSessionStatus.open,
  openingAmount: Decimal.parse('10000'),
  openedAt: DateTime.utc(2026, 11, 10, 8),
  syncStatus: CashSyncStatus.synced,
  serverRecalculated: false,
);

Future<ProviderContainer> pumpPage(
  WidgetTester tester, {
  bool cashOpen = false,
}) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  // Caméra refusée : le bandeau affiche l'invite, sans monter MobileScanner.
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  const permissions = MethodChannel('flutter.baseflow.com/permissions/methods');
  messenger.setMockMethodCallHandler(
    permissions,
    (call) async => switch (call.method) {
      'requestPermissions' => {for (final p in call.arguments as List) p: 0},
      _ => 0,
    },
  );
  addTearDown(() => messenger.setMockMethodCallHandler(permissions, null));

  final repo = _MockCatalog();
  when(repo.watchProducts).thenAnswer((_) => Stream.value(catalog));
  when(repo.watchCategories).thenAnswer(
    (_) => Stream.value(const [Category(id: 'boissons', name: 'Boissons')]),
  );
  when(
    () => repo.getProducts(
      query: any(named: 'query'),
      limit: any(named: 'limit'),
    ),
  ).thenAnswer((inv) async {
    final q = (inv.namedArguments[#query] as String).toLowerCase();
    return ProductPage(
      items: catalog.where((p) => p.name.toLowerCase().contains(q)).toList(),
      nextCursor: null,
      hasMore: false,
    );
  });

  // Par défaut caisse fermée : la barre propose de l'ouvrir.
  final session = cashOpen ? _openSession : null;
  final cash = _MockCashRegister();
  when(cash.getActiveSession).thenAnswer((_) async => session);
  when(cash.watchActiveSession).thenAnswer((_) => Stream.value(session));

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(_NoAuth.new),
        cashRegisterRepositoryProvider.overrideWithValue(cash),
        storeConfigProvider.overrideWith(_Store.new),
        isOnlineProvider.overrideWith((ref) => Stream.value(true)),
        pendingSyncCountProvider.overrideWith((ref) => Stream.value(0)),
        catalogRepositoryProvider.overrideWithValue(repo),
      ],
      child: MaterialApp(theme: AppTheme.light(), home: const NewSalePage()),
    ),
  );
  await tester.pumpAndSettle();
  return ProviderScope.containerOf(tester.element(find.byType(NewSalePage)));
}

/// Laisse expirer le toast de confirmation (minuteur de la page).
Future<void> settleToast(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 3));
  await tester.pumpAndSettle();
}

final encaisser2000 = 'Encaisser ${formatFcfa(Decimal.parse('2000'))}';

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  testWidgets('catalogue d’abord, scanner replié, caisse fermée annoncée', (
    tester,
  ) async {
    await pumpPage(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Vendre'), findsOneWidget);
    expect(find.byType(ProductBrowser), findsOneWidget);
    expect(find.text('Coca-Cola 33cl'), findsOneWidget);
    // Caisse fermée : annoncée avant d'encaisser.
    expect(
      find.text(
        'Caisse fermée\nOuvrez-la pour encaisser. Votre panier '
        'est gardé.',
      ),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(PrimaryButton, 'Ouvrir la caisse'),
      findsOneWidget,
    );
    // Scanner replié par défaut : il s'ouvre à la demande.
    expect(find.byType(SaleScannerPanel), findsNothing);
    await tester.tap(find.widgetWithText(TextButton, 'Scanner'));
    await tester.pumpAndSettle();
    expect(find.byType(SaleScannerPanel), findsOneWidget);
  });

  testWidgets('caisse ouverte, panier vide : Encaisser désactivé', (
    tester,
  ) async {
    await pumpPage(tester, cashOpen: true);
    expect(find.textContaining('Caisse fermée'), findsNothing);
    final button = tester.widget<PrimaryButton>(
      find.widgetWithText(PrimaryButton, 'Encaisser'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('les catégories filtrent le catalogue', (tester) async {
    await pumpPage(tester);
    expect(find.text('Fanta'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Boissons'));
    await tester.pumpAndSettle();
    expect(find.text('Fanta'), findsNothing);
    expect(find.text('Coca-Cola 33cl'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Tous'));
    await tester.pumpAndSettle();
    expect(find.text('Fanta'), findsOneWidget);
  });

  testWidgets('toucher la ligne ajoute 1 ; la ligne passe en stepper', (
    tester,
  ) async {
    final container = await pumpPage(tester, cashOpen: true);
    await tester.tap(find.text('Coca-Cola 33cl'));
    await tester.pump();

    expect(
      container.read(cartProvider.notifier).quantityOf('Coca-Cola 33cl'),
      1,
    );
    expect(find.text('Coca-Cola 33cl ajouté'), findsOneWidget);
    expect(find.byTooltip('Ajouter Coca-Cola 33cl'), findsNothing);
    expect(find.byTooltip('Retirer Coca-Cola 33cl'), findsOneWidget);
    expect(find.text('1 article'), findsOneWidget);
    expect(find.widgetWithText(PrimaryButton, encaisser2000), findsOneWidget);
    await settleToast(tester);

    // « − » à 1 : la ligne quitte le panier, avec « Annuler ».
    await tester.tap(find.byTooltip('Retirer Coca-Cola 33cl'));
    await tester.pump();
    expect(container.read(cartProvider).isEmpty, isTrue);
    await tester.tap(find.widgetWithText(TextButton, 'Annuler'));
    await tester.pumpAndSettle();
    expect(container.read(cartProvider).unitCount, 1);
  });

  testWidgets('appui long : choix de quantité existant', (tester) async {
    final container = await pumpPage(tester);
    await tester.longPress(find.text('Coca-Cola 33cl'));
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsOneWidget);
    await tester.tap(find.textContaining('Ajouter · '));
    await tester.pumpAndSettle();
    expect(
      container.read(cartProvider.notifier).quantityOf('Coca-Cola 33cl'),
      1,
    );
    await settleToast(tester);
  });

  testWidgets('pas d’ajout au-delà du stock', (tester) async {
    final container = await pumpPage(tester);
    await tester.tap(find.text('Eau 1,5L'));
    await tester.pump();
    await settleToast(tester);
    await tester.tap(find.text('Eau 1,5L'));
    await tester.pump();

    expect(container.read(cartProvider.notifier).quantityOf('Eau 1,5L'), 1);
    expect(
      find.text('Stock insuffisant · Stock disponible : 1'),
      findsOneWidget,
    );
    await settleToast(tester);
  });

  testWidgets('produit en rupture : visible, non ajoutable', (tester) async {
    final container = await pumpPage(tester);
    expect(find.text('Rupture'), findsOneWidget);
    await tester.tap(find.byTooltip('Ajouter Fanta'));
    await tester.tap(find.text('Fanta'));
    await tester.pump();
    expect(container.read(cartProvider).isEmpty, isTrue);
  });

  testWidgets('la recherche remplace le catalogue, puis le rend', (
    tester,
  ) async {
    await pumpPage(tester);
    await tester.enterText(find.byType(TextField), 'eau');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.byType(ProductSearchResults), findsOneWidget);
    expect(find.byType(ProductBrowser), findsNothing);
    expect(find.text('Coca-Cola 33cl'), findsNothing);

    // Ajout depuis la recherche : la recherche se vide, le catalogue revient.
    await tester.tap(find.byTooltip('Ajouter Eau 1,5L'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductSearchResults), findsNothing);
    expect(find.byType(ProductBrowser), findsOneWidget);
    await settleToast(tester);
  });

  testWidgets('recherche sans résultat : créer le produit à la volée', (
    tester,
  ) async {
    await pumpPage(tester);
    await tester.enterText(find.byType(TextField), 'savon');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(find.text('Aucun produit « savon »'), findsOneWidget);
    expect(
      find.widgetWithText(SecondaryButton, 'Créer « savon »'),
      findsOneWidget,
    );
  });

  testWidgets('caisse fermée : ouverture proposée, panier gardé', (
    tester,
  ) async {
    final container = await pumpPage(tester);
    await tester.tap(find.text('Coca-Cola 33cl'));
    await settleToast(tester);

    await tester.tap(find.widgetWithText(PrimaryButton, 'Ouvrir la caisse'));
    await tester.pumpAndSettle();

    expect(find.text('Fond de caisse'), findsOneWidget);
    expect(container.read(cartProvider).unitCount, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Encaisser ouvre le paiement : il manque, puis à rendre', (
    tester,
  ) async {
    final container = await pumpPage(tester, cashOpen: true);
    await tester.tap(find.text('Coca-Cola 33cl'));
    await settleToast(tester);

    await tester.tap(find.widgetWithText(PrimaryButton, encaisser2000));
    await tester.pumpAndSettle();
    expect(find.text('Paiement'), findsOneWidget);
    expect(find.text('À payer'), findsOneWidget);
    expect(find.text('MTN Mobile Money'), findsOneWidget);

    container
        .read(checkoutProvider.notifier)
        .setCashReceived(Decimal.parse('500'));
    await tester.pumpAndSettle();
    expect(find.text('Il manque'), findsOneWidget);
    expect(
      tester
          .widget<PrimaryButton>(
            find.widgetWithText(PrimaryButton, 'Valider la vente'),
          )
          .onPressed,
      isNull,
    );

    await tester.tap(
      find.widgetWithText(ChoiceChip, formatAmount(Decimal.parse('5000'))),
    );
    await tester.pumpAndSettle();
    expect(find.text('À rendre au client'), findsOneWidget);
    expect(
      tester
          .widget<PrimaryButton>(
            find.widgetWithText(PrimaryButton, 'Valider la vente'),
          )
          .onPressed,
      isNotNull,
    );

    // Retour au panier : rien n'est perdu.
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Paiement'), findsNothing);
    expect(container.read(cartProvider).unitCount, 1);
    expect(
      container.read(checkoutProvider).cashReceived,
      Decimal.parse('5000'),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('le panier s’ouvre en feuille, modifiable, retrait annulable', (
    tester,
  ) async {
    final container = await pumpPage(tester, cashOpen: true);
    await tester.tap(find.text('Coca-Cola 33cl'));
    await tester.pump();
    await tester.tap(find.text('Coca-Cola 33cl'));
    await settleToast(tester);

    await tester.tap(find.text('2 articles'));
    await tester.pumpAndSettle();
    expect(find.byType(SaleCartSheet), findsOneWidget);
    expect(find.text('Panier · 2 articles'), findsOneWidget);

    // Un glissement vers la gauche retire la ligne, sans confirmation.
    await tester.drag(
      find.descendant(
        of: find.byType(SaleCartSheet),
        matching: find.byType(Dismissible),
      ),
      const Offset(-600, 0),
    );
    await tester.pumpAndSettle();
    expect(container.read(cartProvider).isEmpty, isTrue);
    expect(find.text('Coca-Cola 33cl retiré'), findsOneWidget);

    // Le retrait s'annule depuis la pastille : la ligne revient telle quelle.
    await tester.tap(find.widgetWithText(TextButton, 'Annuler'));
    await tester.pumpAndSettle();
    expect(container.read(cartProvider).unitCount, 2);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
