import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/sync/sync_queue_repository.dart';
import 'package:mobile/database/app_database.dart'
    show AppDatabase, ProductsCompanion;
import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/sales/data/repositories/sales_repository_impl.dart';
import 'package:mobile/features/sales/domain/entities/cart_item.dart';
import 'package:mobile/features/sales/domain/entities/discount.dart';
import 'package:mobile/features/sales/domain/entities/margin_summary.dart';
import 'package:mobile/features/sales/domain/entities/sale.dart';
import 'package:mobile/features/sales/domain/repositories/sales_repository.dart';
import 'package:mobile/features/sales/domain/usecases/create_sale_usecase.dart';
import 'package:mobile/features/sales/presentation/providers/cart_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

Decimal d(String value) => Decimal.parse(value);

Discount amount(String value) =>
    Discount(type: DiscountType.amount, value: d(value));

Discount percent(String value) =>
    Discount(type: DiscountType.percentage, value: d(value));

CartItem line({
  String price = '2000',
  int quantity = 1,
  String? purchase,
  Discount? discount,
}) => CartItem(
  productId: 'p1',
  productName: 'Coca-Cola 33cl',
  unitPrice: d(price),
  quantity: quantity,
  purchaseUnitPrice: purchase == null ? null : d(purchase),
  discount: discount,
);

Product coca({String selling = '2000', String? purchase = '1500'}) => Product(
  id: 'p1',
  name: 'Coca-Cola 33cl',
  sellingPrice: d(selling),
  purchasePrice: purchase == null ? null : d(purchase),
  updatedAt: DateTime(2026),
);

class _MockSalesRepository extends Mock implements SalesRepository {}

void main() {
  setUpAll(() {
    // Le host Linux expose libsqlite3.so.0 ; drift cherche libsqlite3.so.
    if (Platform.isLinux) {
      open.overrideFor(
        OperatingSystem.linux,
        () => DynamicLibrary.open('libsqlite3.so.0'),
      );
    }
  });

  group('Prix et marge produit', () {
    test('achat 1 500, vente 2 000 → marge 500', () {
      expect(coca().unitMargin, d('500'));
    });

    test('vente à perte autorisée : marge négative', () {
      expect(coca(selling: '1200').unitMargin, d('-300'));
    });

    test('prix d\'achat non renseigné → marge inconnue', () {
      expect(coca(purchase: null).unitMargin, isNull);
    });
  });

  group('Réduction', () {
    test('montant : 2 000 − 300 → 1 700', () {
      final item = line(discount: amount('300'));
      expect(item.discountAmount, d('300'));
      expect(item.lineTotal, d('1700'));
    });

    test('pourcentage : 10 % de 2 000 → 1 800', () {
      final item = line(discount: percent('10'));
      expect(item.discountAmount, d('200'));
      expect(item.lineTotal, d('1800'));
    });

    test('réduction maximale : 2 000 − 2 000 → 0', () {
      final discount = amount('2000');
      expect(discount.validate(d('2000')), isNull);
      expect(line(discount: discount).lineTotal, Decimal.zero);
    });

    test('réduction supérieure au montant rejetée (2 500 sur 2 000)', () {
      expect(amount('2500').validate(d('2000')), isNotNull);
      // Même appliquée par erreur, jamais de total négatif.
      expect(line(discount: amount('2500')).lineTotal, Decimal.zero);
    });

    test('pourcentage > 100 et valeur nulle ou négative rejetés', () {
      expect(percent('101').validate(d('2000')), isNotNull);
      expect(percent('0').validate(d('2000')), isNotNull);
      expect(amount('-5').validate(d('2000')), isNotNull);
      expect(percent('100').validate(d('2000')), isNull);
    });

    test('la réduction porte sur le total brut de la ligne', () {
      final item = line(quantity: 2, discount: amount('500'));
      expect(item.grossTotal, d('4000'));
      expect(item.lineTotal, d('3500'));
      expect(line(quantity: 3, discount: percent('10')).lineTotal, d('5400'));
    });

    test('pourcentage arrondi au franc, demi vers le haut', () {
      // 12,5 % de 1 999 = 249,875 → 250.
      expect(percent('12.5').amountOn(d('1999')), d('250'));
      // 10 % de 1 995 = 199,5 → 200.
      expect(percent('10').amountOn(d('1995')), d('200'));
      // 10 % de 1 994 = 199,4 → 199.
      expect(percent('10').amountOn(d('1994')), d('199'));
    });

    test('quantité réduite : un montant est plafonné au nouveau brut', () {
      final item = line(quantity: 3, discount: amount('5000'));
      final reduced = item.withQuantity(2);
      expect(reduced.discount, amount('4000'));
      expect(reduced.lineTotal, Decimal.zero);
      // Le pourcentage se recalcule simplement.
      final pct = line(quantity: 3, discount: percent('10')).withQuantity(1);
      expect(pct.lineTotal, d('1800'));
    });
  });

  group('Marge après réduction', () {
    test('achat 1 500, vente 2 000, réduction 300 → marge 200', () {
      final item = line(purchase: '1500', discount: amount('300'));
      expect(item.lineTotal, d('1700'));
      expect(item.margin, d('200'));
    });

    test('plusieurs quantités : (1 800 − 1 500) × 2 = 600', () {
      final item = line(quantity: 2, purchase: '1500', discount: amount('400'));
      expect(item.lineTotal, d('3600'));
      expect(item.margin, d('600'));
    });

    test('coût inconnu → marge inconnue', () {
      expect(line(discount: amount('300')).margin, isNull);
    });
  });

  group('Précision Decimal', () {
    test('0,1 + 0,2 reste exact', () {
      final cart = CartState(
        items: [
          line(price: '0.1'),
          line(price: '0.2').copyWith(productId: 'p2'),
        ],
      );
      expect(cart.total, d('0.3'));
    });

    test('grands montants au-delà de 2^53 sans perte', () {
      final item = line(price: '9007199254740993', discount: amount('1'));
      expect(item.lineTotal, d('9007199254740992'));
      expect(item.lineTotal.toString(), '9007199254740992');
    });

    test('pourcentage sur un prix décimal', () {
      // 15 % de 3 × 33,33 = 99,99 × 0,15 = 14,9985 → 15.
      expect(
        line(price: '33.33', quantity: 3, discount: percent('15')).lineTotal,
        d('84.99'),
      );
    });
  });

  group('Panier', () {
    late ProviderContainer container;
    late Cart cart;

    setUp(() {
      container = ProviderContainer();
      addTearDown(container.dispose);
      container.listen(cartProvider, (_, _) {});
      cart = container.read(cartProvider.notifier);
    });

    test('fige le prix de vente et le prix d\'achat à l\'ajout', () {
      cart.addItem(coca());
      final item = container.read(cartProvider).items.single;
      expect(item.unitPrice, d('2000'));
      expect(item.purchaseUnitPrice, d('1500'));
    });

    test('Sous-total 4 000, réduction ligne 500 → total 3 500', () {
      cart
        ..addItem(coca(), quantity: 2)
        ..setItemDiscount('p1', amount('500'));
      final state = container.read(cartProvider);
      expect(state.items.single.grossTotal, d('4000'));
      expect(state.total, d('3500'));
    });

    test('remise globale distincte des réductions de ligne', () {
      cart
        ..addItem(coca(), quantity: 2)
        ..setItemDiscount('p1', amount('500'))
        ..setDiscount(amount('1000'));
      final state = container.read(cartProvider);
      expect(state.subtotal, d('3500'));
      expect(state.discountAmount, d('1000'));
      expect(state.total, d('2500'));
      expect(state.items.single.discount, amount('500'));
    });

    test('la remise globale suit le panier (jamais de total négatif)', () {
      cart
        ..addItem(coca(), quantity: 2)
        ..setDiscount(amount('4000'))
        ..updateQuantity('p1', 1);
      final state = container.read(cartProvider);
      expect(state.discount, amount('2000'));
      expect(state.total, Decimal.zero);
      cart.removeItem('p1');
      expect(container.read(cartProvider).discount, isNull);
    });

    test('vider retire aussi la remise globale', () {
      cart
        ..addItem(coca())
        ..setDiscount(percent('10'))
        ..clear();
      expect(container.read(cartProvider).discount, isNull);
    });
  });

  group('CreateSaleUseCase', () {
    late _MockSalesRepository repository;
    late CreateSaleUseCase useCase;

    setUpAll(() {
      registerFallbackValue(PaymentMethod.cash);
      registerFallbackValue(Decimal.zero);
      registerFallbackValue(<CartItem>[]);
      registerFallbackValue(amount('1'));
    });

    setUp(() {
      repository = _MockSalesRepository();
      useCase = CreateSaleUseCase(repository: repository);
      when(
        () => repository.createSale(
          items: any(named: 'items'),
          totalAmount: any(named: 'totalAmount'),
          vatAmount: any(named: 'vatAmount'),
          paymentMethod: any(named: 'paymentMethod'),
          discount: any(named: 'discount'),
          cashAmount: any(named: 'cashAmount'),
          mobileMoneyAmount: any(named: 'mobileMoneyAmount'),
        ),
      ).thenAnswer(
        (_) async => Sale(
          id: 's',
          receiptNumber: 0,
          totalAmount: Decimal.zero,
          vatAmount: Decimal.zero,
          paymentMethod: PaymentMethod.cash,
          createdAt: DateTime(2026),
          discountAmount: Decimal.zero,
        ),
      );
    });

    test('accepte total = Σ lignes nettes − remise globale', () async {
      await useCase(
        items: [line(quantity: 2, discount: amount('500'))],
        discount: percent('10'),
        totalAmount: d('3150'),
        vatAmount: Decimal.zero,
        paymentMethod: PaymentMethod.cash,
      );
      verify(
        () => repository.createSale(
          items: any(named: 'items'),
          totalAmount: d('3150'),
          vatAmount: Decimal.zero,
          paymentMethod: PaymentMethod.cash,
          discount: percent('10'),
        ),
      ).called(1);
    });

    test('rejette une réduction de ligne supérieure au brut', () {
      expect(
        () => useCase(
          items: [line(discount: amount('2500'))],
          totalAmount: Decimal.zero,
          vatAmount: Decimal.zero,
          paymentMethod: PaymentMethod.cash,
        ),
        throwsA(isA<CreateSaleException>()),
      );
    });

    test('rejette une remise globale invalide', () {
      expect(
        () => useCase(
          items: [line()],
          discount: amount('3000'),
          totalAmount: Decimal.zero,
          vatAmount: Decimal.zero,
          paymentMethod: PaymentMethod.cash,
        ),
        throwsA(isA<CreateSaleException>()),
      );
    });

    test('rejette un total qui ignore la remise', () {
      expect(
        () => useCase(
          items: [line(discount: amount('300'))],
          totalAmount: d('2000'),
          vatAmount: Decimal.zero,
          paymentMethod: PaymentMethod.cash,
        ),
        throwsA(isA<CreateSaleException>()),
      );
    });
  });

  group('Résumé de marge', () {
    Sale sale(String total, {String discount = '0'}) => Sale(
      id: 's$total',
      receiptNumber: 1,
      totalAmount: d(total),
      vatAmount: Decimal.zero,
      paymentMethod: PaymentMethod.cash,
      createdAt: DateTime(2026),
      discountAmount: d(discount),
    );

    test('CA, coût, marge et taux', () {
      final summary = MarginSummary.fromSales([
        (
          sale: sale('3600'),
          items: [line(quantity: 2, purchase: '1500', discount: amount('400'))],
        ),
      ]);
      expect(summary.revenue, d('3600'));
      expect(summary.cost, d('3000'));
      expect(summary.margin, d('600'));
      expect(summary.marginRate, d('16.66'));
      expect(summary.hasUnknownCost, isFalse);
    });

    test('la remise globale réduit la marge', () {
      final summary = MarginSummary.fromSales([
        (sale: sale('1800', discount: '200'), items: [line(purchase: '1500')]),
      ]);
      expect(summary.margin, d('300'));
    });

    test('lignes au coût inconnu exclues et signalées', () {
      final summary = MarginSummary.fromSales([
        (
          sale: sale('4000'),
          items: [
            line(purchase: '1500'),
            line().copyWith(productId: 'p2'),
          ],
        ),
      ]);
      expect(summary.revenue, d('4000'));
      expect(summary.coveredRevenue, d('2000'));
      expect(summary.margin, d('500'));
      expect(summary.hasUnknownCost, isTrue);
    });
  });

  group('Historique (drift)', () {
    late AppDatabase db;
    late SyncQueueRepository queue;
    late SalesRepositoryImpl repository;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      queue = SyncQueueRepository(db: db);
      repository = SalesRepositoryImpl(db: db, syncQueue: queue, dio: Dio());
    });

    tearDown(() => db.close());

    Future<Sale> sellTwoCocas() => repository.createSale(
      items: [line(quantity: 2, purchase: '1500', discount: amount('400'))],
      discount: amount('100'),
      totalAmount: d('3500'),
      vatAmount: Decimal.zero,
      paymentMethod: PaymentMethod.cash,
    );

    test(
      'une ancienne vente garde ses prix après changement du produit',
      () async {
        await db
            .into(db.products)
            .insert(
              ProductsCompanion.insert(
                id: 'p1',
                name: 'Coca-Cola 33cl',
                sellingPrice: '2000',
                purchasePrice: const drift.Value('1500'),
                updatedAt: DateTime(2026),
              ),
            );
        final sale = await sellTwoCocas();

        // Le lendemain, le produit change de prix.
        await (db.update(db.products)..where((p) => p.id.equals('p1'))).write(
          const ProductsCompanion(
            sellingPrice: drift.Value('2500'),
            purchasePrice: drift.Value('1700'),
          ),
        );

        final stored = await repository.getSale(sale.id);
        final items = await repository.watchSaleItems(sale.id).first;
        final item = items.single;
        expect(item.unitPrice, d('2000'));
        expect(item.purchaseUnitPrice, d('1500'));
        expect(item.discountAmount, d('400'));
        expect(item.lineTotal, d('3600'));
        expect(item.margin, d('600'));
        expect(stored!.discount, amount('100'));
        expect(stored.discountAmount, d('100'));
        expect(stored.totalAmount, d('3500'));
        expect(stored.subtotalAmount, d('3600'));
      },
    );

    test('le payload de synchro porte l\'instantané complet', () async {
      final sale = await sellTwoCocas();
      final entry = (await queue.getEntriesByType('sale')).single;
      final payload = jsonDecode(entry.payload) as Map<String, dynamic>;
      expect(payload['id'], sale.id);
      expect(payload['total_amount'], '3500');
      expect(payload['discount_type'], 'amount');
      expect(payload['discount_value'], '100');
      expect(payload['discount_amount'], '100');
      final item = (payload['items'] as List<dynamic>).single as Map;
      expect(item['unit_price_at_sale'], '2000');
      expect(item['purchase_price_at_sale'], '1500');
      expect(item['discount_type'], 'amount');
      expect(item['discount_value'], '400');
      expect(item['discount_amount'], '400');
      expect(item['line_total'], '3600');
    });

    test('résumé de marge depuis drift', () async {
      await sellTwoCocas();
      final today = DateTime.now();
      final summary = await repository.watchMarginSummary(today, today).first;
      expect(summary.revenue, d('3500'));
      expect(summary.cost, d('3000'));
      expect(summary.margin, d('500'));
    });
  });

  test('migration drift v6 → v7 : données conservées', () async {
    final file = File(
      '${Directory.systemTemp.createTempSync('pos_migration').path}/db.sqlite',
    );
    // Schéma v6 minimal des tables modifiées, avec une vente existante.
    final raw = sqlite.sqlite3.open(file.path)
      ..execute('''
        CREATE TABLE products (id TEXT NOT NULL PRIMARY KEY, name TEXT NOT NULL,
          barcode TEXT, unit_price TEXT NOT NULL, current_stock INTEGER,
          min_stock INTEGER, category_id TEXT, image_version TEXT,
          dirty INTEGER NOT NULL DEFAULT 0, updated_at INTEGER NOT NULL,
          deleted_at INTEGER);
        CREATE TABLE categories (id TEXT NOT NULL PRIMARY KEY,
          name TEXT NOT NULL, dirty INTEGER NOT NULL DEFAULT 0,
          updated_at INTEGER NOT NULL, deleted_at INTEGER);
        CREATE TABLE sales (id TEXT NOT NULL PRIMARY KEY,
          receipt_number INTEGER NOT NULL, total_amount TEXT NOT NULL,
          vat_amount TEXT NOT NULL, payment_method TEXT NOT NULL,
          created_at INTEGER NOT NULL);
        CREATE TABLE sale_items (id TEXT NOT NULL PRIMARY KEY,
          sale_id TEXT NOT NULL, product_id TEXT NOT NULL,
          product_name TEXT NOT NULL, unit_price TEXT NOT NULL,
          quantity INTEGER NOT NULL, line_total TEXT NOT NULL);
        CREATE TABLE sync_queue (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
          entity_type TEXT NOT NULL, entity_id TEXT NOT NULL,
          payload TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'pending',
          retry_count INTEGER NOT NULL DEFAULT 0, last_error TEXT,
          created_at INTEGER NOT NULL, last_attempt_at INTEGER);
        CREATE TABLE sync_metadata (key TEXT NOT NULL PRIMARY KEY,
          value TEXT NOT NULL, updated_at INTEGER NOT NULL);
        INSERT INTO products (id, name, unit_price, updated_at)
          VALUES ('p1', 'Coca', '2000', 0);
        INSERT INTO sales VALUES ('s1', 7, '4000', '0', 'cash', 0);
        INSERT INTO sale_items VALUES ('i1', 's1', 'p1', 'Coca', '2000', 2,
          '4000');
        PRAGMA user_version = 6;
      ''');
    raw.dispose();

    final db = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(db.close);

    final product = await db.select(db.products).getSingle();
    expect(product.sellingPrice, '2000');
    expect(product.purchasePrice, isNull);
    final sale = await db.select(db.sales).getSingle();
    expect(sale.totalAmount, '4000');
    expect(sale.discountAmount, '0');
    expect(sale.discountType, isNull);
    final item = await db.select(db.saleItems).getSingle();
    expect(item.lineTotal, '4000');
    expect(item.discountAmount, '0');
    expect(item.purchaseUnitPrice, isNull);
  });
}
