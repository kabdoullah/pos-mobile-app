import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Table des produits du catalogue local.
class Products extends Table {
  /// UUID v4 généré côté client.
  TextColumn get id => text()();

  /// Nom du produit.
  TextColumn get name => text().withLength(min: 1, max: 255)();

  /// Code-barres optionnel.
  TextColumn get barcode => text().nullable()();

  /// Prix de vente en FCFA, stocké en string pour préserver la précision.
  /// Colonne `unit_price` renommée en v7 (ADR-0009).
  TextColumn get sellingPrice => text()();

  /// Prix d'achat en FCFA (null = non renseigné, ADR-0009).
  TextColumn get purchasePrice => text().nullable()();

  /// Stock actuel (null = stock non géré).
  IntColumn get currentStock => integer().nullable()();

  /// Seuil de réapprovisionnement (null = pas d'alerte configurée).
  IntColumn get minStock => integer().nullable()();

  /// Catégorie du produit (null = sans catégorie), voir [Categories].
  TextColumn get categoryId => text().nullable()();

  /// Version (SHA-256) de l'image serveur ; null = pas d'image (ADR-0008).
  TextColumn get imageVersion => text().nullable()();

  /// Marqué pour synchronisation.
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  /// Dernière modification locale.
  DateTimeColumn get updatedAt => dateTime()();

  /// Soft delete.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table des catégories de produits (ADR-0008) — synchronisées par état comme
/// le catalogue (flag [dirty], dernier écrit gagne).
class Categories extends Table {
  /// UUID v4 généré côté client.
  TextColumn get id => text()();

  /// Nom (unique par boutique, casse ignorée, parmi les non supprimées).
  TextColumn get name => text().withLength(min: 1, max: 60)();

  /// Marquée pour synchronisation.
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  /// Dernière modification.
  DateTimeColumn get updatedAt => dateTime()();

  /// Suppression logique.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table des ventes locales.
class Sales extends Table {
  /// UUID v4 généré côté client (idempotence sync).
  TextColumn get id => text()();

  /// Numéro de reçu séquentiel.
  IntColumn get receiptNumber => integer()();

  /// Total TTC en FCFA.
  TextColumn get totalAmount => text()();

  /// Montant TVA.
  TextColumn get vatAmount => text()();

  /// Mode de paiement.
  TextColumn get paymentMethod => text()();

  /// Type de remise globale (`amount` / `percentage`), null = aucune.
  TextColumn get discountType => text().nullable()();

  /// Valeur saisie de la remise globale (FCFA ou %).
  TextColumn get discountValue => text().nullable()();

  /// Montant de la remise globale en FCFA ; `total_amount` l'a déjà déduit.
  TextColumn get discountAmount => text().withDefault(const Constant('0'))();

  /// Part payée en espèces en FCFA (paiement mixte), null si non renseignée.
  TextColumn get cashAmount => text().nullable()();

  /// Part payée en mobile money en FCFA (paiement mixte), null si non
  /// renseignée.
  TextColumn get mobileMoneyAmount => text().nullable()();

  /// Session de caisse de la vente, null si vendue hors session.
  TextColumn get cashSessionId => text().nullable()();

  /// Date de création.
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Lignes de vente.
class SaleItems extends Table {
  /// UUID v4 généré côté client.
  TextColumn get id => text()();

  /// Référence à la vente (FK).
  TextColumn get saleId => text()();

  /// UUID du produit.
  TextColumn get productId => text()();

  /// Nom du produit au moment de la vente.
  TextColumn get productName => text()();

  /// Prix de vente unitaire au moment de la vente, en FCFA (string).
  TextColumn get unitPrice => text()();

  /// Quantité.
  IntColumn get quantity => integer()();

  /// Total net de la ligne (brut − réduction) en FCFA, stocké en string.
  TextColumn get lineTotal => text()();

  /// Prix d'achat unitaire au moment de la vente (null = inconnu).
  TextColumn get purchaseUnitPrice => text().nullable()();

  /// Type de réduction de la ligne (`amount` / `percentage`), null = aucune.
  TextColumn get discountType => text().nullable()();

  /// Valeur saisie de la réduction (FCFA ou %).
  TextColumn get discountValue => text().nullable()();

  /// Montant de la réduction de la ligne en FCFA.
  TextColumn get discountAmount => text().withDefault(const Constant('0'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Retours clients (ADR-0010) — immuables une fois enregistrés ; seuls le
/// numéro et le statut de synchro évoluent.
class SaleReturns extends Table {
  /// UUID v4 généré côté client (idempotence sync).
  TextColumn get id => text()();

  /// Vente d'origine.
  TextColumn get saleId => text()();

  /// Numéro attribué par le serveur (0 = pas encore synchronisé).
  IntColumn get returnNumber => integer().withDefault(const Constant(0))();

  /// Motif, valeur de l'API (`defective`, `other`…).
  TextColumn get reason => text()();

  /// Commentaire (obligatoire pour le motif `other`).
  TextColumn get note => text().nullable()();

  /// Moyen de remboursement, valeur de l'API (`cash`, `mobile_money_wave`…).
  TextColumn get refundMethod => text()();

  /// Montant rendu au client en FCFA (string).
  TextColumn get refundAmount => text()();

  /// Date du retour.
  DateTimeColumn get createdAt => dateTime()();

  /// `pending` (à envoyer), `synced`, `rejected` (refus définitif du serveur).
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  /// Code du refus serveur (`quantity_exceeded`…), null sinon.
  TextColumn get rejectionCode => text().nullable()();

  /// Session de caisse du retour, null si enregistré hors session.
  TextColumn get cashSessionId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Lignes d'un retour, chacune rattachée à une ligne de vente.
class SaleReturnItems extends Table {
  /// UUID v4 généré côté client.
  TextColumn get id => text()();

  /// Retour parent.
  TextColumn get returnId => text()();

  /// Ligne de vente d'origine.
  TextColumn get saleItemId => text()();

  /// Produit (null si supprimé côté serveur).
  TextColumn get productId => text().nullable()();

  /// Quantité rendue.
  IntColumn get quantity => integer()();

  /// État de l'article, valeur de l'API (`resellable`, `unsellable`…).
  TextColumn get condition => text()();

  /// L'article a réintégré le stock disponible.
  BoolColumn get restocked => boolean()();

  /// Montant remboursé pour cette ligne en FCFA (string).
  TextColumn get refundAmount => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Sessions de caisse : ouverture avec un fond, clôture avec un comptage.
class CashSessions extends Table {
  /// UUID v4 généré côté client (idempotence sync).
  TextColumn get id => text()();

  /// Appareil qui a ouvert la session.
  TextColumn get deviceId => text()();

  /// `open` ou `closed`.
  TextColumn get status => text()();

  /// Fond de caisse à l'ouverture en FCFA (string).
  TextColumn get openingAmount => text()();

  /// Commentaire d'ouverture.
  TextColumn get openingNote => text().nullable()();

  /// Date d'ouverture (UTC).
  DateTimeColumn get openedAt => dateTime()();

  /// Solde théorique retenu par le serveur en FCFA, null avant clôture.
  TextColumn get expectedAmount => text().nullable()();

  /// Solde théorique calculé sur l'appareil à la clôture en FCFA.
  TextColumn get clientExpectedAmount => text().nullable()();

  /// Montant compté à la clôture en FCFA.
  TextColumn get countedAmount => text().nullable()();

  /// Écart (compté − théorique) en FCFA.
  TextColumn get discrepancyAmount => text().nullable()();

  /// Commentaire de clôture.
  TextColumn get closingNote => text().nullable()();

  /// Date de clôture (UTC), renvoyée à l'identique à chaque retry.
  DateTimeColumn get closedAt => dateTime().nullable()();

  /// Le serveur a recalculé le solde théorique (différent de celui de
  /// l'appareil).
  BoolColumn get serverRecalculated =>
      boolean().withDefault(const Constant(false))();

  /// `pending` (à envoyer), `synced`, `rejected` (refus définitif).
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  /// Code du refus serveur, null sinon.
  TextColumn get rejectionCode => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Entrées et sorties d'espèces d'une session de caisse.
class CashMovements extends Table {
  /// UUID v4 généré côté client (idempotence sync).
  TextColumn get id => text()();

  /// Session de caisse parente.
  TextColumn get sessionId => text()();

  /// `cash_in` ou `cash_out`.
  TextColumn get type => text()();

  /// Motif, valeur de l'API.
  TextColumn get reason => text()();

  /// Montant en FCFA (string).
  TextColumn get amount => text()();

  /// Commentaire.
  TextColumn get note => text().nullable()();

  /// Date du mouvement (UTC).
  DateTimeColumn get createdAt => dateTime()();

  /// `pending` (à envoyer), `synced`, `rejected` (refus définitif).
  TextColumn get syncStatus => text()();

  /// Code du refus serveur, null sinon.
  TextColumn get rejectionCode => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Métadonnées de synchronisation — stocke les timestamps du dernier pull.
class SyncMetadata extends Table {
  /// Clé unique (ex: 'last_pull').
  TextColumn get key => text()();

  /// Valeur du timestamp (ISO 8601).
  TextColumn get value => text()();

  /// Dernière mise à jour.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}

/// File d'attente locale pour la synchronisation.
class SyncQueue extends Table {
  /// Auto-incrémenté.
  IntColumn get id => integer().autoIncrement()();

  /// Type d'entité (sale, product, etc.).
  TextColumn get entityType => text()();

  /// UUID de l'entité concernée.
  TextColumn get entityId => text()();

  /// Payload JSON sérialisé.
  TextColumn get payload => text()();

  /// pending, syncing, synced, failed (réessayé), rejected (refus définitif).
  TextColumn get status => text().withDefault(const Constant('pending'))();

  /// Nombre de tentatives.
  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  /// Dernière erreur rencontrée.
  TextColumn get lastError => text().nullable()();

  /// Horodatage de création.
  DateTimeColumn get createdAt => dateTime()();

  /// Horodatage de la dernière tentative de sync.
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
}

/// Base de données drift de l'application.
@DriftDatabase(
  tables: [
    Products,
    Categories,
    Sales,
    SaleItems,
    SaleReturns,
    SaleReturnItems,
    CashSessions,
    CashMovements,
    SyncQueue,
    SyncMetadata,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Constructeur.
  AppDatabase() : super(_openConnection());

  /// Constructor pour les tests : injecte un [QueryExecutor] (ex. mémoire).
  AppDatabase.forTesting(super.executor);

  /// Version courante du schéma drift.
  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 3) {
        // Schémas de pré-production : tout supprimer et recréer.
        await customStatement('DROP TABLE IF EXISTS sale_items');
        await customStatement('DROP TABLE IF EXISTS sales');
        await customStatement('DROP TABLE IF EXISTS products');
        await customStatement('DROP TABLE IF EXISTS sync_queue');
        await customStatement('DROP TABLE IF EXISTS sync_metadata');
        await m.createAll();
        return;
      }
      if (from < 4) {
        // v3 → v4 : retire la contrainte d'unicité (saleId, productId) de
        // sale_items.
        // SQLite ne peut pas supprimer une contrainte sur place —
        // reconstruction via une table temporaire.
        await customStatement(
          'CREATE TABLE sale_items_new ('
          '  id TEXT NOT NULL PRIMARY KEY,'
          '  sale_id TEXT NOT NULL,'
          '  product_id TEXT NOT NULL,'
          '  product_name TEXT NOT NULL,'
          '  unit_price TEXT NOT NULL,'
          '  quantity INTEGER NOT NULL,'
          '  line_total TEXT NOT NULL'
          ')',
        );
        await customStatement(
          'INSERT INTO sale_items_new SELECT id, sale_id, product_id,'
          ' product_name, unit_price, quantity, line_total FROM sale_items',
        );
        await customStatement('DROP TABLE sale_items');
        await customStatement(
          'ALTER TABLE sale_items_new RENAME TO sale_items',
        );
      }
      if (from < 5) {
        // v4 → v5 : ajoute le seuil de réapprovisionnement aux produits.
        await m.addColumn(products, products.minStock);
      }
      if (from < 6) {
        // v5 → v6 (ADR-0008) : catégories, catégorie et version d'image des
        // produits. Aucune donnée existante n'est modifiée.
        await m.createTable(categories);
        await m.addColumn(products, products.categoryId);
        await m.addColumn(products, products.imageVersion);
      }
      if (from < 7) {
        // v6 → v7 (ADR-0009) : prix de vente renommé, prix d'achat, réductions
        // et prix d'achat historique. Aucune donnée supprimée : les produits
        // existants ont un prix d'achat inconnu (NULL), les ventes existantes
        // une réduction nulle.
        await m.renameColumn(products, 'unit_price', products.sellingPrice);
        await m.addColumn(products, products.purchasePrice);
        await m.addColumn(sales, sales.discountType);
        await m.addColumn(sales, sales.discountValue);
        await m.addColumn(sales, sales.discountAmount);
        await m.addColumn(saleItems, saleItems.purchaseUnitPrice);
        await m.addColumn(saleItems, saleItems.discountType);
        await m.addColumn(saleItems, saleItems.discountValue);
        await m.addColumn(saleItems, saleItems.discountAmount);
      }
      if (from < 8) {
        // v7 → v8 : les lignes de vente ont désormais le même id sur l'appareil
        // et le serveur. Oublier le dernier pull force un pull complet, qui
        // remplace les lignes aux ids locaux des ventes déjà synchronisées.
        await customStatement(
          "DELETE FROM sync_metadata WHERE key = 'last_pull_at'",
        );
      }
      if (from < 9) {
        // v8 → v9 (ADR-0010) : retours clients. Tables nouvelles, aucune donnée
        // existante modifiée.
        await m.createTable(saleReturns);
        await m.createTable(saleReturnItems);
      }
      if (from < 10) {
        // v9 → v10 : sessions de caisse. Tables nouvelles ; les ventes et
        // retours existants gardent une session et une ventilation nulles.
        await m.createTable(cashSessions);
        await m.createTable(cashMovements);
        await m.addColumn(sales, sales.cashAmount);
        await m.addColumn(sales, sales.mobileMoneyAmount);
        await m.addColumn(sales, sales.cashSessionId);
        // Ajout seulement si la table date d'avant v10 : en partant d'une
        // version < 9, le bloc v9 vient de la créer avec le schéma courant,
        // colonne comprise.
        if (from >= 9) {
          await m.addColumn(saleReturns, saleReturns.cashSessionId);
        }
      }
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'pos_mobile');
  }
}
