// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sellingPriceMeta = const VerificationMeta(
    'sellingPrice',
  );
  @override
  late final GeneratedColumn<String> sellingPrice = GeneratedColumn<String>(
    'selling_price',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchasePriceMeta = const VerificationMeta(
    'purchasePrice',
  );
  @override
  late final GeneratedColumn<String> purchasePrice = GeneratedColumn<String>(
    'purchase_price',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentStockMeta = const VerificationMeta(
    'currentStock',
  );
  @override
  late final GeneratedColumn<int> currentStock = GeneratedColumn<int>(
    'current_stock',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minStockMeta = const VerificationMeta(
    'minStock',
  );
  @override
  late final GeneratedColumn<int> minStock = GeneratedColumn<int>(
    'min_stock',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageVersionMeta = const VerificationMeta(
    'imageVersion',
  );
  @override
  late final GeneratedColumn<String> imageVersion = GeneratedColumn<String>(
    'image_version',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    barcode,
    sellingPrice,
    purchasePrice,
    currentStock,
    minStock,
    categoryId,
    imageVersion,
    dirty,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('selling_price')) {
      context.handle(
        _sellingPriceMeta,
        sellingPrice.isAcceptableOrUnknown(
          data['selling_price']!,
          _sellingPriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sellingPriceMeta);
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
        _purchasePriceMeta,
        purchasePrice.isAcceptableOrUnknown(
          data['purchase_price']!,
          _purchasePriceMeta,
        ),
      );
    }
    if (data.containsKey('current_stock')) {
      context.handle(
        _currentStockMeta,
        currentStock.isAcceptableOrUnknown(
          data['current_stock']!,
          _currentStockMeta,
        ),
      );
    }
    if (data.containsKey('min_stock')) {
      context.handle(
        _minStockMeta,
        minStock.isAcceptableOrUnknown(data['min_stock']!, _minStockMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('image_version')) {
      context.handle(
        _imageVersionMeta,
        imageVersion.isAcceptableOrUnknown(
          data['image_version']!,
          _imageVersionMeta,
        ),
      );
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      sellingPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selling_price'],
      )!,
      purchasePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_price'],
      ),
      currentStock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_stock'],
      ),
      minStock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_stock'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      imageVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_version'],
      ),
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  /// UUID v4 généré côté client.
  final String id;

  /// Nom du produit.
  final String name;

  /// Code-barres optionnel.
  final String? barcode;

  /// Prix de vente en FCFA, stocké en string pour préserver la précision.
  /// Colonne `unit_price` renommée en v7 (ADR-0009).
  final String sellingPrice;

  /// Prix d'achat en FCFA (null = non renseigné, ADR-0009).
  final String? purchasePrice;

  /// Stock actuel (null = stock non géré).
  final int? currentStock;

  /// Seuil de réapprovisionnement (null = pas d'alerte configurée).
  final int? minStock;

  /// Catégorie du produit (null = sans catégorie), voir [Categories].
  final String? categoryId;

  /// Version (SHA-256) de l'image serveur ; null = pas d'image (ADR-0008).
  final String? imageVersion;

  /// Marqué pour synchronisation.
  final bool dirty;

  /// Dernière modification locale.
  final DateTime updatedAt;

  /// Soft delete.
  final DateTime? deletedAt;
  const Product({
    required this.id,
    required this.name,
    this.barcode,
    required this.sellingPrice,
    this.purchasePrice,
    this.currentStock,
    this.minStock,
    this.categoryId,
    this.imageVersion,
    required this.dirty,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['selling_price'] = Variable<String>(sellingPrice);
    if (!nullToAbsent || purchasePrice != null) {
      map['purchase_price'] = Variable<String>(purchasePrice);
    }
    if (!nullToAbsent || currentStock != null) {
      map['current_stock'] = Variable<int>(currentStock);
    }
    if (!nullToAbsent || minStock != null) {
      map['min_stock'] = Variable<int>(minStock);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || imageVersion != null) {
      map['image_version'] = Variable<String>(imageVersion);
    }
    map['dirty'] = Variable<bool>(dirty);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      sellingPrice: Value(sellingPrice),
      purchasePrice: purchasePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(purchasePrice),
      currentStock: currentStock == null && nullToAbsent
          ? const Value.absent()
          : Value(currentStock),
      minStock: minStock == null && nullToAbsent
          ? const Value.absent()
          : Value(minStock),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      imageVersion: imageVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(imageVersion),
      dirty: Value(dirty),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      sellingPrice: serializer.fromJson<String>(json['sellingPrice']),
      purchasePrice: serializer.fromJson<String?>(json['purchasePrice']),
      currentStock: serializer.fromJson<int?>(json['currentStock']),
      minStock: serializer.fromJson<int?>(json['minStock']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      imageVersion: serializer.fromJson<String?>(json['imageVersion']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'barcode': serializer.toJson<String?>(barcode),
      'sellingPrice': serializer.toJson<String>(sellingPrice),
      'purchasePrice': serializer.toJson<String?>(purchasePrice),
      'currentStock': serializer.toJson<int?>(currentStock),
      'minStock': serializer.toJson<int?>(minStock),
      'categoryId': serializer.toJson<String?>(categoryId),
      'imageVersion': serializer.toJson<String?>(imageVersion),
      'dirty': serializer.toJson<bool>(dirty),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    Value<String?> barcode = const Value.absent(),
    String? sellingPrice,
    Value<String?> purchasePrice = const Value.absent(),
    Value<int?> currentStock = const Value.absent(),
    Value<int?> minStock = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> imageVersion = const Value.absent(),
    bool? dirty,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    barcode: barcode.present ? barcode.value : this.barcode,
    sellingPrice: sellingPrice ?? this.sellingPrice,
    purchasePrice: purchasePrice.present
        ? purchasePrice.value
        : this.purchasePrice,
    currentStock: currentStock.present ? currentStock.value : this.currentStock,
    minStock: minStock.present ? minStock.value : this.minStock,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    imageVersion: imageVersion.present ? imageVersion.value : this.imageVersion,
    dirty: dirty ?? this.dirty,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      sellingPrice: data.sellingPrice.present
          ? data.sellingPrice.value
          : this.sellingPrice,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      currentStock: data.currentStock.present
          ? data.currentStock.value
          : this.currentStock,
      minStock: data.minStock.present ? data.minStock.value : this.minStock,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      imageVersion: data.imageVersion.present
          ? data.imageVersion.value
          : this.imageVersion,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('currentStock: $currentStock, ')
          ..write('minStock: $minStock, ')
          ..write('categoryId: $categoryId, ')
          ..write('imageVersion: $imageVersion, ')
          ..write('dirty: $dirty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    barcode,
    sellingPrice,
    purchasePrice,
    currentStock,
    minStock,
    categoryId,
    imageVersion,
    dirty,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.barcode == this.barcode &&
          other.sellingPrice == this.sellingPrice &&
          other.purchasePrice == this.purchasePrice &&
          other.currentStock == this.currentStock &&
          other.minStock == this.minStock &&
          other.categoryId == this.categoryId &&
          other.imageVersion == this.imageVersion &&
          other.dirty == this.dirty &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> barcode;
  final Value<String> sellingPrice;
  final Value<String?> purchasePrice;
  final Value<int?> currentStock;
  final Value<int?> minStock;
  final Value<String?> categoryId;
  final Value<String?> imageVersion;
  final Value<bool> dirty;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.barcode = const Value.absent(),
    this.sellingPrice = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.minStock = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.imageVersion = const Value.absent(),
    this.dirty = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String name,
    this.barcode = const Value.absent(),
    required String sellingPrice,
    this.purchasePrice = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.minStock = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.imageVersion = const Value.absent(),
    this.dirty = const Value.absent(),
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       sellingPrice = Value(sellingPrice),
       updatedAt = Value(updatedAt);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? barcode,
    Expression<String>? sellingPrice,
    Expression<String>? purchasePrice,
    Expression<int>? currentStock,
    Expression<int>? minStock,
    Expression<String>? categoryId,
    Expression<String>? imageVersion,
    Expression<bool>? dirty,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (barcode != null) 'barcode': barcode,
      if (sellingPrice != null) 'selling_price': sellingPrice,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (currentStock != null) 'current_stock': currentStock,
      if (minStock != null) 'min_stock': minStock,
      if (categoryId != null) 'category_id': categoryId,
      if (imageVersion != null) 'image_version': imageVersion,
      if (dirty != null) 'dirty': dirty,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? barcode,
    Value<String>? sellingPrice,
    Value<String?>? purchasePrice,
    Value<int?>? currentStock,
    Value<int?>? minStock,
    Value<String?>? categoryId,
    Value<String?>? imageVersion,
    Value<bool>? dirty,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      currentStock: currentStock ?? this.currentStock,
      minStock: minStock ?? this.minStock,
      categoryId: categoryId ?? this.categoryId,
      imageVersion: imageVersion ?? this.imageVersion,
      dirty: dirty ?? this.dirty,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (sellingPrice.present) {
      map['selling_price'] = Variable<String>(sellingPrice.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<String>(purchasePrice.value);
    }
    if (currentStock.present) {
      map['current_stock'] = Variable<int>(currentStock.value);
    }
    if (minStock.present) {
      map['min_stock'] = Variable<int>(minStock.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (imageVersion.present) {
      map['image_version'] = Variable<String>(imageVersion.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('currentStock: $currentStock, ')
          ..write('minStock: $minStock, ')
          ..write('categoryId: $categoryId, ')
          ..write('imageVersion: $imageVersion, ')
          ..write('dirty: $dirty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, dirty, updatedAt, deletedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  /// UUID v4 généré côté client.
  final String id;

  /// Nom (unique par boutique, casse ignorée, parmi les non supprimées).
  final String name;

  /// Marquée pour synchronisation.
  final bool dirty;

  /// Dernière modification.
  final DateTime updatedAt;

  /// Suppression logique.
  final DateTime? deletedAt;
  const Category({
    required this.id,
    required this.name,
    required this.dirty,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['dirty'] = Variable<bool>(dirty);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      dirty: Value(dirty),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      dirty: serializer.fromJson<bool>(json['dirty']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'dirty': serializer.toJson<bool>(dirty),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Category copyWith({
    String? id,
    String? name,
    bool? dirty,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    dirty: dirty ?? this.dirty,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dirty: $dirty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, dirty, updatedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.dirty == this.dirty &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> name;
  final Value<bool> dirty;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.dirty = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    this.dirty = const Value.absent(),
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       updatedAt = Value(updatedAt);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<bool>? dirty,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (dirty != null) 'dirty': dirty,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<bool>? dirty,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      dirty: dirty ?? this.dirty,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('dirty: $dirty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receiptNumberMeta = const VerificationMeta(
    'receiptNumber',
  );
  @override
  late final GeneratedColumn<int> receiptNumber = GeneratedColumn<int>(
    'receipt_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<String> totalAmount = GeneratedColumn<String>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vatAmountMeta = const VerificationMeta(
    'vatAmount',
  );
  @override
  late final GeneratedColumn<String> vatAmount = GeneratedColumn<String>(
    'vat_amount',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountTypeMeta = const VerificationMeta(
    'discountType',
  );
  @override
  late final GeneratedColumn<String> discountType = GeneratedColumn<String>(
    'discount_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountValueMeta = const VerificationMeta(
    'discountValue',
  );
  @override
  late final GeneratedColumn<String> discountValue = GeneratedColumn<String>(
    'discount_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountAmountMeta = const VerificationMeta(
    'discountAmount',
  );
  @override
  late final GeneratedColumn<String> discountAmount = GeneratedColumn<String>(
    'discount_amount',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('0'),
  );
  static const VerificationMeta _cashAmountMeta = const VerificationMeta(
    'cashAmount',
  );
  @override
  late final GeneratedColumn<String> cashAmount = GeneratedColumn<String>(
    'cash_amount',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mobileMoneyAmountMeta = const VerificationMeta(
    'mobileMoneyAmount',
  );
  @override
  late final GeneratedColumn<String> mobileMoneyAmount =
      GeneratedColumn<String>(
        'mobile_money_amount',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _cashSessionIdMeta = const VerificationMeta(
    'cashSessionId',
  );
  @override
  late final GeneratedColumn<String> cashSessionId = GeneratedColumn<String>(
    'cash_session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    receiptNumber,
    totalAmount,
    vatAmount,
    paymentMethod,
    discountType,
    discountValue,
    discountAmount,
    cashAmount,
    mobileMoneyAmount,
    cashSessionId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<Sale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('receipt_number')) {
      context.handle(
        _receiptNumberMeta,
        receiptNumber.isAcceptableOrUnknown(
          data['receipt_number']!,
          _receiptNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receiptNumberMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('vat_amount')) {
      context.handle(
        _vatAmountMeta,
        vatAmount.isAcceptableOrUnknown(data['vat_amount']!, _vatAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_vatAmountMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('discount_type')) {
      context.handle(
        _discountTypeMeta,
        discountType.isAcceptableOrUnknown(
          data['discount_type']!,
          _discountTypeMeta,
        ),
      );
    }
    if (data.containsKey('discount_value')) {
      context.handle(
        _discountValueMeta,
        discountValue.isAcceptableOrUnknown(
          data['discount_value']!,
          _discountValueMeta,
        ),
      );
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
        _discountAmountMeta,
        discountAmount.isAcceptableOrUnknown(
          data['discount_amount']!,
          _discountAmountMeta,
        ),
      );
    }
    if (data.containsKey('cash_amount')) {
      context.handle(
        _cashAmountMeta,
        cashAmount.isAcceptableOrUnknown(data['cash_amount']!, _cashAmountMeta),
      );
    }
    if (data.containsKey('mobile_money_amount')) {
      context.handle(
        _mobileMoneyAmountMeta,
        mobileMoneyAmount.isAcceptableOrUnknown(
          data['mobile_money_amount']!,
          _mobileMoneyAmountMeta,
        ),
      );
    }
    if (data.containsKey('cash_session_id')) {
      context.handle(
        _cashSessionIdMeta,
        cashSessionId.isAcceptableOrUnknown(
          data['cash_session_id']!,
          _cashSessionIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      receiptNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}receipt_number'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}total_amount'],
      )!,
      vatAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vat_amount'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      discountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discount_type'],
      ),
      discountValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discount_value'],
      ),
      discountAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discount_amount'],
      )!,
      cashAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cash_amount'],
      ),
      mobileMoneyAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mobile_money_amount'],
      ),
      cashSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cash_session_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class Sale extends DataClass implements Insertable<Sale> {
  /// UUID v4 généré côté client (idempotence sync).
  final String id;

  /// Numéro de reçu séquentiel.
  final int receiptNumber;

  /// Total TTC en FCFA.
  final String totalAmount;

  /// Montant TVA.
  final String vatAmount;

  /// Mode de paiement.
  final String paymentMethod;

  /// Type de remise globale (`amount` / `percentage`), null = aucune.
  final String? discountType;

  /// Valeur saisie de la remise globale (FCFA ou %).
  final String? discountValue;

  /// Montant de la remise globale en FCFA ; `total_amount` l'a déjà déduit.
  final String discountAmount;

  /// Part payée en espèces en FCFA (paiement mixte), null si non renseignée.
  final String? cashAmount;

  /// Part payée en mobile money en FCFA (paiement mixte), null si non
  /// renseignée.
  final String? mobileMoneyAmount;

  /// Session de caisse de la vente, null si vendue hors session.
  final String? cashSessionId;

  /// Date de création.
  final DateTime createdAt;
  const Sale({
    required this.id,
    required this.receiptNumber,
    required this.totalAmount,
    required this.vatAmount,
    required this.paymentMethod,
    this.discountType,
    this.discountValue,
    required this.discountAmount,
    this.cashAmount,
    this.mobileMoneyAmount,
    this.cashSessionId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['receipt_number'] = Variable<int>(receiptNumber);
    map['total_amount'] = Variable<String>(totalAmount);
    map['vat_amount'] = Variable<String>(vatAmount);
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || discountType != null) {
      map['discount_type'] = Variable<String>(discountType);
    }
    if (!nullToAbsent || discountValue != null) {
      map['discount_value'] = Variable<String>(discountValue);
    }
    map['discount_amount'] = Variable<String>(discountAmount);
    if (!nullToAbsent || cashAmount != null) {
      map['cash_amount'] = Variable<String>(cashAmount);
    }
    if (!nullToAbsent || mobileMoneyAmount != null) {
      map['mobile_money_amount'] = Variable<String>(mobileMoneyAmount);
    }
    if (!nullToAbsent || cashSessionId != null) {
      map['cash_session_id'] = Variable<String>(cashSessionId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      receiptNumber: Value(receiptNumber),
      totalAmount: Value(totalAmount),
      vatAmount: Value(vatAmount),
      paymentMethod: Value(paymentMethod),
      discountType: discountType == null && nullToAbsent
          ? const Value.absent()
          : Value(discountType),
      discountValue: discountValue == null && nullToAbsent
          ? const Value.absent()
          : Value(discountValue),
      discountAmount: Value(discountAmount),
      cashAmount: cashAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(cashAmount),
      mobileMoneyAmount: mobileMoneyAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(mobileMoneyAmount),
      cashSessionId: cashSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(cashSessionId),
      createdAt: Value(createdAt),
    );
  }

  factory Sale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<String>(json['id']),
      receiptNumber: serializer.fromJson<int>(json['receiptNumber']),
      totalAmount: serializer.fromJson<String>(json['totalAmount']),
      vatAmount: serializer.fromJson<String>(json['vatAmount']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      discountType: serializer.fromJson<String?>(json['discountType']),
      discountValue: serializer.fromJson<String?>(json['discountValue']),
      discountAmount: serializer.fromJson<String>(json['discountAmount']),
      cashAmount: serializer.fromJson<String?>(json['cashAmount']),
      mobileMoneyAmount: serializer.fromJson<String?>(
        json['mobileMoneyAmount'],
      ),
      cashSessionId: serializer.fromJson<String?>(json['cashSessionId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'receiptNumber': serializer.toJson<int>(receiptNumber),
      'totalAmount': serializer.toJson<String>(totalAmount),
      'vatAmount': serializer.toJson<String>(vatAmount),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'discountType': serializer.toJson<String?>(discountType),
      'discountValue': serializer.toJson<String?>(discountValue),
      'discountAmount': serializer.toJson<String>(discountAmount),
      'cashAmount': serializer.toJson<String?>(cashAmount),
      'mobileMoneyAmount': serializer.toJson<String?>(mobileMoneyAmount),
      'cashSessionId': serializer.toJson<String?>(cashSessionId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Sale copyWith({
    String? id,
    int? receiptNumber,
    String? totalAmount,
    String? vatAmount,
    String? paymentMethod,
    Value<String?> discountType = const Value.absent(),
    Value<String?> discountValue = const Value.absent(),
    String? discountAmount,
    Value<String?> cashAmount = const Value.absent(),
    Value<String?> mobileMoneyAmount = const Value.absent(),
    Value<String?> cashSessionId = const Value.absent(),
    DateTime? createdAt,
  }) => Sale(
    id: id ?? this.id,
    receiptNumber: receiptNumber ?? this.receiptNumber,
    totalAmount: totalAmount ?? this.totalAmount,
    vatAmount: vatAmount ?? this.vatAmount,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    discountType: discountType.present ? discountType.value : this.discountType,
    discountValue: discountValue.present
        ? discountValue.value
        : this.discountValue,
    discountAmount: discountAmount ?? this.discountAmount,
    cashAmount: cashAmount.present ? cashAmount.value : this.cashAmount,
    mobileMoneyAmount: mobileMoneyAmount.present
        ? mobileMoneyAmount.value
        : this.mobileMoneyAmount,
    cashSessionId: cashSessionId.present
        ? cashSessionId.value
        : this.cashSessionId,
    createdAt: createdAt ?? this.createdAt,
  );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      receiptNumber: data.receiptNumber.present
          ? data.receiptNumber.value
          : this.receiptNumber,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      vatAmount: data.vatAmount.present ? data.vatAmount.value : this.vatAmount,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      discountType: data.discountType.present
          ? data.discountType.value
          : this.discountType,
      discountValue: data.discountValue.present
          ? data.discountValue.value
          : this.discountValue,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      cashAmount: data.cashAmount.present
          ? data.cashAmount.value
          : this.cashAmount,
      mobileMoneyAmount: data.mobileMoneyAmount.present
          ? data.mobileMoneyAmount.value
          : this.mobileMoneyAmount,
      cashSessionId: data.cashSessionId.present
          ? data.cashSessionId.value
          : this.cashSessionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('vatAmount: $vatAmount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('discountType: $discountType, ')
          ..write('discountValue: $discountValue, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('cashAmount: $cashAmount, ')
          ..write('mobileMoneyAmount: $mobileMoneyAmount, ')
          ..write('cashSessionId: $cashSessionId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    receiptNumber,
    totalAmount,
    vatAmount,
    paymentMethod,
    discountType,
    discountValue,
    discountAmount,
    cashAmount,
    mobileMoneyAmount,
    cashSessionId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.receiptNumber == this.receiptNumber &&
          other.totalAmount == this.totalAmount &&
          other.vatAmount == this.vatAmount &&
          other.paymentMethod == this.paymentMethod &&
          other.discountType == this.discountType &&
          other.discountValue == this.discountValue &&
          other.discountAmount == this.discountAmount &&
          other.cashAmount == this.cashAmount &&
          other.mobileMoneyAmount == this.mobileMoneyAmount &&
          other.cashSessionId == this.cashSessionId &&
          other.createdAt == this.createdAt);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<String> id;
  final Value<int> receiptNumber;
  final Value<String> totalAmount;
  final Value<String> vatAmount;
  final Value<String> paymentMethod;
  final Value<String?> discountType;
  final Value<String?> discountValue;
  final Value<String> discountAmount;
  final Value<String?> cashAmount;
  final Value<String?> mobileMoneyAmount;
  final Value<String?> cashSessionId;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.receiptNumber = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.vatAmount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.discountType = const Value.absent(),
    this.discountValue = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.cashAmount = const Value.absent(),
    this.mobileMoneyAmount = const Value.absent(),
    this.cashSessionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesCompanion.insert({
    required String id,
    required int receiptNumber,
    required String totalAmount,
    required String vatAmount,
    required String paymentMethod,
    this.discountType = const Value.absent(),
    this.discountValue = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.cashAmount = const Value.absent(),
    this.mobileMoneyAmount = const Value.absent(),
    this.cashSessionId = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       receiptNumber = Value(receiptNumber),
       totalAmount = Value(totalAmount),
       vatAmount = Value(vatAmount),
       paymentMethod = Value(paymentMethod),
       createdAt = Value(createdAt);
  static Insertable<Sale> custom({
    Expression<String>? id,
    Expression<int>? receiptNumber,
    Expression<String>? totalAmount,
    Expression<String>? vatAmount,
    Expression<String>? paymentMethod,
    Expression<String>? discountType,
    Expression<String>? discountValue,
    Expression<String>? discountAmount,
    Expression<String>? cashAmount,
    Expression<String>? mobileMoneyAmount,
    Expression<String>? cashSessionId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (receiptNumber != null) 'receipt_number': receiptNumber,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (vatAmount != null) 'vat_amount': vatAmount,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (discountType != null) 'discount_type': discountType,
      if (discountValue != null) 'discount_value': discountValue,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (cashAmount != null) 'cash_amount': cashAmount,
      if (mobileMoneyAmount != null) 'mobile_money_amount': mobileMoneyAmount,
      if (cashSessionId != null) 'cash_session_id': cashSessionId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesCompanion copyWith({
    Value<String>? id,
    Value<int>? receiptNumber,
    Value<String>? totalAmount,
    Value<String>? vatAmount,
    Value<String>? paymentMethod,
    Value<String?>? discountType,
    Value<String?>? discountValue,
    Value<String>? discountAmount,
    Value<String?>? cashAmount,
    Value<String?>? mobileMoneyAmount,
    Value<String?>? cashSessionId,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SalesCompanion(
      id: id ?? this.id,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      totalAmount: totalAmount ?? this.totalAmount,
      vatAmount: vatAmount ?? this.vatAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      discountAmount: discountAmount ?? this.discountAmount,
      cashAmount: cashAmount ?? this.cashAmount,
      mobileMoneyAmount: mobileMoneyAmount ?? this.mobileMoneyAmount,
      cashSessionId: cashSessionId ?? this.cashSessionId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (receiptNumber.present) {
      map['receipt_number'] = Variable<int>(receiptNumber.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<String>(totalAmount.value);
    }
    if (vatAmount.present) {
      map['vat_amount'] = Variable<String>(vatAmount.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (discountType.present) {
      map['discount_type'] = Variable<String>(discountType.value);
    }
    if (discountValue.present) {
      map['discount_value'] = Variable<String>(discountValue.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<String>(discountAmount.value);
    }
    if (cashAmount.present) {
      map['cash_amount'] = Variable<String>(cashAmount.value);
    }
    if (mobileMoneyAmount.present) {
      map['mobile_money_amount'] = Variable<String>(mobileMoneyAmount.value);
    }
    if (cashSessionId.present) {
      map['cash_session_id'] = Variable<String>(cashSessionId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('vatAmount: $vatAmount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('discountType: $discountType, ')
          ..write('discountValue: $discountValue, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('cashAmount: $cashAmount, ')
          ..write('mobileMoneyAmount: $mobileMoneyAmount, ')
          ..write('cashSessionId: $cashSessionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SaleItemsTable extends SaleItems
    with TableInfo<$SaleItemsTable, SaleItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<String> unitPrice = GeneratedColumn<String>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineTotalMeta = const VerificationMeta(
    'lineTotal',
  );
  @override
  late final GeneratedColumn<String> lineTotal = GeneratedColumn<String>(
    'line_total',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseUnitPriceMeta = const VerificationMeta(
    'purchaseUnitPrice',
  );
  @override
  late final GeneratedColumn<String> purchaseUnitPrice =
      GeneratedColumn<String>(
        'purchase_unit_price',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _discountTypeMeta = const VerificationMeta(
    'discountType',
  );
  @override
  late final GeneratedColumn<String> discountType = GeneratedColumn<String>(
    'discount_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountValueMeta = const VerificationMeta(
    'discountValue',
  );
  @override
  late final GeneratedColumn<String> discountValue = GeneratedColumn<String>(
    'discount_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountAmountMeta = const VerificationMeta(
    'discountAmount',
  );
  @override
  late final GeneratedColumn<String> discountAmount = GeneratedColumn<String>(
    'discount_amount',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('0'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleId,
    productId,
    productName,
    unitPrice,
    quantity,
    lineTotal,
    purchaseUnitPrice,
    discountType,
    discountValue,
    discountAmount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('line_total')) {
      context.handle(
        _lineTotalMeta,
        lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_lineTotalMeta);
    }
    if (data.containsKey('purchase_unit_price')) {
      context.handle(
        _purchaseUnitPriceMeta,
        purchaseUnitPrice.isAcceptableOrUnknown(
          data['purchase_unit_price']!,
          _purchaseUnitPriceMeta,
        ),
      );
    }
    if (data.containsKey('discount_type')) {
      context.handle(
        _discountTypeMeta,
        discountType.isAcceptableOrUnknown(
          data['discount_type']!,
          _discountTypeMeta,
        ),
      );
    }
    if (data.containsKey('discount_value')) {
      context.handle(
        _discountValueMeta,
        discountValue.isAcceptableOrUnknown(
          data['discount_value']!,
          _discountValueMeta,
        ),
      );
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
        _discountAmountMeta,
        discountAmount.isAcceptableOrUnknown(
          data['discount_amount']!,
          _discountAmountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_price'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      lineTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}line_total'],
      )!,
      purchaseUnitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_unit_price'],
      ),
      discountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discount_type'],
      ),
      discountValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discount_value'],
      ),
      discountAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discount_amount'],
      )!,
    );
  }

  @override
  $SaleItemsTable createAlias(String alias) {
    return $SaleItemsTable(attachedDatabase, alias);
  }
}

class SaleItem extends DataClass implements Insertable<SaleItem> {
  /// UUID v4 généré côté client.
  final String id;

  /// Référence à la vente (FK).
  final String saleId;

  /// UUID du produit.
  final String productId;

  /// Nom du produit au moment de la vente.
  final String productName;

  /// Prix de vente unitaire au moment de la vente, en FCFA (string).
  final String unitPrice;

  /// Quantité.
  final int quantity;

  /// Total net de la ligne (brut − réduction) en FCFA, stocké en string.
  final String lineTotal;

  /// Prix d'achat unitaire au moment de la vente (null = inconnu).
  final String? purchaseUnitPrice;

  /// Type de réduction de la ligne (`amount` / `percentage`), null = aucune.
  final String? discountType;

  /// Valeur saisie de la réduction (FCFA ou %).
  final String? discountValue;

  /// Montant de la réduction de la ligne en FCFA.
  final String discountAmount;
  const SaleItem({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.lineTotal,
    this.purchaseUnitPrice,
    this.discountType,
    this.discountValue,
    required this.discountAmount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    map['product_id'] = Variable<String>(productId);
    map['product_name'] = Variable<String>(productName);
    map['unit_price'] = Variable<String>(unitPrice);
    map['quantity'] = Variable<int>(quantity);
    map['line_total'] = Variable<String>(lineTotal);
    if (!nullToAbsent || purchaseUnitPrice != null) {
      map['purchase_unit_price'] = Variable<String>(purchaseUnitPrice);
    }
    if (!nullToAbsent || discountType != null) {
      map['discount_type'] = Variable<String>(discountType);
    }
    if (!nullToAbsent || discountValue != null) {
      map['discount_value'] = Variable<String>(discountValue);
    }
    map['discount_amount'] = Variable<String>(discountAmount);
    return map;
  }

  SaleItemsCompanion toCompanion(bool nullToAbsent) {
    return SaleItemsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      productId: Value(productId),
      productName: Value(productName),
      unitPrice: Value(unitPrice),
      quantity: Value(quantity),
      lineTotal: Value(lineTotal),
      purchaseUnitPrice: purchaseUnitPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseUnitPrice),
      discountType: discountType == null && nullToAbsent
          ? const Value.absent()
          : Value(discountType),
      discountValue: discountValue == null && nullToAbsent
          ? const Value.absent()
          : Value(discountValue),
      discountAmount: Value(discountAmount),
    );
  }

  factory SaleItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleItem(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      productId: serializer.fromJson<String>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      unitPrice: serializer.fromJson<String>(json['unitPrice']),
      quantity: serializer.fromJson<int>(json['quantity']),
      lineTotal: serializer.fromJson<String>(json['lineTotal']),
      purchaseUnitPrice: serializer.fromJson<String?>(
        json['purchaseUnitPrice'],
      ),
      discountType: serializer.fromJson<String?>(json['discountType']),
      discountValue: serializer.fromJson<String?>(json['discountValue']),
      discountAmount: serializer.fromJson<String>(json['discountAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'productId': serializer.toJson<String>(productId),
      'productName': serializer.toJson<String>(productName),
      'unitPrice': serializer.toJson<String>(unitPrice),
      'quantity': serializer.toJson<int>(quantity),
      'lineTotal': serializer.toJson<String>(lineTotal),
      'purchaseUnitPrice': serializer.toJson<String?>(purchaseUnitPrice),
      'discountType': serializer.toJson<String?>(discountType),
      'discountValue': serializer.toJson<String?>(discountValue),
      'discountAmount': serializer.toJson<String>(discountAmount),
    };
  }

  SaleItem copyWith({
    String? id,
    String? saleId,
    String? productId,
    String? productName,
    String? unitPrice,
    int? quantity,
    String? lineTotal,
    Value<String?> purchaseUnitPrice = const Value.absent(),
    Value<String?> discountType = const Value.absent(),
    Value<String?> discountValue = const Value.absent(),
    String? discountAmount,
  }) => SaleItem(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    unitPrice: unitPrice ?? this.unitPrice,
    quantity: quantity ?? this.quantity,
    lineTotal: lineTotal ?? this.lineTotal,
    purchaseUnitPrice: purchaseUnitPrice.present
        ? purchaseUnitPrice.value
        : this.purchaseUnitPrice,
    discountType: discountType.present ? discountType.value : this.discountType,
    discountValue: discountValue.present
        ? discountValue.value
        : this.discountValue,
    discountAmount: discountAmount ?? this.discountAmount,
  );
  SaleItem copyWithCompanion(SaleItemsCompanion data) {
    return SaleItem(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
      purchaseUnitPrice: data.purchaseUnitPrice.present
          ? data.purchaseUnitPrice.value
          : this.purchaseUnitPrice,
      discountType: data.discountType.present
          ? data.discountType.value
          : this.discountType,
      discountValue: data.discountValue.present
          ? data.discountValue.value
          : this.discountValue,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleItem(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('quantity: $quantity, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('purchaseUnitPrice: $purchaseUnitPrice, ')
          ..write('discountType: $discountType, ')
          ..write('discountValue: $discountValue, ')
          ..write('discountAmount: $discountAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    saleId,
    productId,
    productName,
    unitPrice,
    quantity,
    lineTotal,
    purchaseUnitPrice,
    discountType,
    discountValue,
    discountAmount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleItem &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.unitPrice == this.unitPrice &&
          other.quantity == this.quantity &&
          other.lineTotal == this.lineTotal &&
          other.purchaseUnitPrice == this.purchaseUnitPrice &&
          other.discountType == this.discountType &&
          other.discountValue == this.discountValue &&
          other.discountAmount == this.discountAmount);
}

class SaleItemsCompanion extends UpdateCompanion<SaleItem> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<String> productId;
  final Value<String> productName;
  final Value<String> unitPrice;
  final Value<int> quantity;
  final Value<String> lineTotal;
  final Value<String?> purchaseUnitPrice;
  final Value<String?> discountType;
  final Value<String?> discountValue;
  final Value<String> discountAmount;
  final Value<int> rowid;
  const SaleItemsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.quantity = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.purchaseUnitPrice = const Value.absent(),
    this.discountType = const Value.absent(),
    this.discountValue = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaleItemsCompanion.insert({
    required String id,
    required String saleId,
    required String productId,
    required String productName,
    required String unitPrice,
    required int quantity,
    required String lineTotal,
    this.purchaseUnitPrice = const Value.absent(),
    this.discountType = const Value.absent(),
    this.discountValue = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       saleId = Value(saleId),
       productId = Value(productId),
       productName = Value(productName),
       unitPrice = Value(unitPrice),
       quantity = Value(quantity),
       lineTotal = Value(lineTotal);
  static Insertable<SaleItem> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<String>? productId,
    Expression<String>? productName,
    Expression<String>? unitPrice,
    Expression<int>? quantity,
    Expression<String>? lineTotal,
    Expression<String>? purchaseUnitPrice,
    Expression<String>? discountType,
    Expression<String>? discountValue,
    Expression<String>? discountAmount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (quantity != null) 'quantity': quantity,
      if (lineTotal != null) 'line_total': lineTotal,
      if (purchaseUnitPrice != null) 'purchase_unit_price': purchaseUnitPrice,
      if (discountType != null) 'discount_type': discountType,
      if (discountValue != null) 'discount_value': discountValue,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaleItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? saleId,
    Value<String>? productId,
    Value<String>? productName,
    Value<String>? unitPrice,
    Value<int>? quantity,
    Value<String>? lineTotal,
    Value<String?>? purchaseUnitPrice,
    Value<String?>? discountType,
    Value<String?>? discountValue,
    Value<String>? discountAmount,
    Value<int>? rowid,
  }) {
    return SaleItemsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      lineTotal: lineTotal ?? this.lineTotal,
      purchaseUnitPrice: purchaseUnitPrice ?? this.purchaseUnitPrice,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      discountAmount: discountAmount ?? this.discountAmount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<String>(unitPrice.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<String>(lineTotal.value);
    }
    if (purchaseUnitPrice.present) {
      map['purchase_unit_price'] = Variable<String>(purchaseUnitPrice.value);
    }
    if (discountType.present) {
      map['discount_type'] = Variable<String>(discountType.value);
    }
    if (discountValue.present) {
      map['discount_value'] = Variable<String>(discountValue.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<String>(discountAmount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleItemsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('quantity: $quantity, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('purchaseUnitPrice: $purchaseUnitPrice, ')
          ..write('discountType: $discountType, ')
          ..write('discountValue: $discountValue, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SaleReturnsTable extends SaleReturns
    with TableInfo<$SaleReturnsTable, SaleReturn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleReturnsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _returnNumberMeta = const VerificationMeta(
    'returnNumber',
  );
  @override
  late final GeneratedColumn<int> returnNumber = GeneratedColumn<int>(
    'return_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _refundMethodMeta = const VerificationMeta(
    'refundMethod',
  );
  @override
  late final GeneratedColumn<String> refundMethod = GeneratedColumn<String>(
    'refund_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refundAmountMeta = const VerificationMeta(
    'refundAmount',
  );
  @override
  late final GeneratedColumn<String> refundAmount = GeneratedColumn<String>(
    'refund_amount',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _rejectionCodeMeta = const VerificationMeta(
    'rejectionCode',
  );
  @override
  late final GeneratedColumn<String> rejectionCode = GeneratedColumn<String>(
    'rejection_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cashSessionIdMeta = const VerificationMeta(
    'cashSessionId',
  );
  @override
  late final GeneratedColumn<String> cashSessionId = GeneratedColumn<String>(
    'cash_session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleId,
    returnNumber,
    reason,
    note,
    refundMethod,
    refundAmount,
    createdAt,
    syncStatus,
    rejectionCode,
    cashSessionId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_returns';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleReturn> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('return_number')) {
      context.handle(
        _returnNumberMeta,
        returnNumber.isAcceptableOrUnknown(
          data['return_number']!,
          _returnNumberMeta,
        ),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('refund_method')) {
      context.handle(
        _refundMethodMeta,
        refundMethod.isAcceptableOrUnknown(
          data['refund_method']!,
          _refundMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_refundMethodMeta);
    }
    if (data.containsKey('refund_amount')) {
      context.handle(
        _refundAmountMeta,
        refundAmount.isAcceptableOrUnknown(
          data['refund_amount']!,
          _refundAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_refundAmountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('rejection_code')) {
      context.handle(
        _rejectionCodeMeta,
        rejectionCode.isAcceptableOrUnknown(
          data['rejection_code']!,
          _rejectionCodeMeta,
        ),
      );
    }
    if (data.containsKey('cash_session_id')) {
      context.handle(
        _cashSessionIdMeta,
        cashSessionId.isAcceptableOrUnknown(
          data['cash_session_id']!,
          _cashSessionIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleReturn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleReturn(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      )!,
      returnNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}return_number'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      refundMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refund_method'],
      )!,
      refundAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refund_amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      rejectionCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rejection_code'],
      ),
      cashSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cash_session_id'],
      ),
    );
  }

  @override
  $SaleReturnsTable createAlias(String alias) {
    return $SaleReturnsTable(attachedDatabase, alias);
  }
}

class SaleReturn extends DataClass implements Insertable<SaleReturn> {
  /// UUID v4 généré côté client (idempotence sync).
  final String id;

  /// Vente d'origine.
  final String saleId;

  /// Numéro attribué par le serveur (0 = pas encore synchronisé).
  final int returnNumber;

  /// Motif, valeur de l'API (`defective`, `other`…).
  final String reason;

  /// Commentaire (obligatoire pour le motif `other`).
  final String? note;

  /// Moyen de remboursement, valeur de l'API (`cash`, `mobile_money_wave`…).
  final String refundMethod;

  /// Montant rendu au client en FCFA (string).
  final String refundAmount;

  /// Date du retour.
  final DateTime createdAt;

  /// `pending` (à envoyer), `synced`, `rejected` (refus définitif du serveur).
  final String syncStatus;

  /// Code du refus serveur (`quantity_exceeded`…), null sinon.
  final String? rejectionCode;

  /// Session de caisse du retour, null si enregistré hors session.
  final String? cashSessionId;
  const SaleReturn({
    required this.id,
    required this.saleId,
    required this.returnNumber,
    required this.reason,
    this.note,
    required this.refundMethod,
    required this.refundAmount,
    required this.createdAt,
    required this.syncStatus,
    this.rejectionCode,
    this.cashSessionId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    map['return_number'] = Variable<int>(returnNumber);
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['refund_method'] = Variable<String>(refundMethod);
    map['refund_amount'] = Variable<String>(refundAmount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || rejectionCode != null) {
      map['rejection_code'] = Variable<String>(rejectionCode);
    }
    if (!nullToAbsent || cashSessionId != null) {
      map['cash_session_id'] = Variable<String>(cashSessionId);
    }
    return map;
  }

  SaleReturnsCompanion toCompanion(bool nullToAbsent) {
    return SaleReturnsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      returnNumber: Value(returnNumber),
      reason: Value(reason),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      refundMethod: Value(refundMethod),
      refundAmount: Value(refundAmount),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
      rejectionCode: rejectionCode == null && nullToAbsent
          ? const Value.absent()
          : Value(rejectionCode),
      cashSessionId: cashSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(cashSessionId),
    );
  }

  factory SaleReturn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleReturn(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      returnNumber: serializer.fromJson<int>(json['returnNumber']),
      reason: serializer.fromJson<String>(json['reason']),
      note: serializer.fromJson<String?>(json['note']),
      refundMethod: serializer.fromJson<String>(json['refundMethod']),
      refundAmount: serializer.fromJson<String>(json['refundAmount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      rejectionCode: serializer.fromJson<String?>(json['rejectionCode']),
      cashSessionId: serializer.fromJson<String?>(json['cashSessionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'returnNumber': serializer.toJson<int>(returnNumber),
      'reason': serializer.toJson<String>(reason),
      'note': serializer.toJson<String?>(note),
      'refundMethod': serializer.toJson<String>(refundMethod),
      'refundAmount': serializer.toJson<String>(refundAmount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'rejectionCode': serializer.toJson<String?>(rejectionCode),
      'cashSessionId': serializer.toJson<String?>(cashSessionId),
    };
  }

  SaleReturn copyWith({
    String? id,
    String? saleId,
    int? returnNumber,
    String? reason,
    Value<String?> note = const Value.absent(),
    String? refundMethod,
    String? refundAmount,
    DateTime? createdAt,
    String? syncStatus,
    Value<String?> rejectionCode = const Value.absent(),
    Value<String?> cashSessionId = const Value.absent(),
  }) => SaleReturn(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    returnNumber: returnNumber ?? this.returnNumber,
    reason: reason ?? this.reason,
    note: note.present ? note.value : this.note,
    refundMethod: refundMethod ?? this.refundMethod,
    refundAmount: refundAmount ?? this.refundAmount,
    createdAt: createdAt ?? this.createdAt,
    syncStatus: syncStatus ?? this.syncStatus,
    rejectionCode: rejectionCode.present
        ? rejectionCode.value
        : this.rejectionCode,
    cashSessionId: cashSessionId.present
        ? cashSessionId.value
        : this.cashSessionId,
  );
  SaleReturn copyWithCompanion(SaleReturnsCompanion data) {
    return SaleReturn(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      returnNumber: data.returnNumber.present
          ? data.returnNumber.value
          : this.returnNumber,
      reason: data.reason.present ? data.reason.value : this.reason,
      note: data.note.present ? data.note.value : this.note,
      refundMethod: data.refundMethod.present
          ? data.refundMethod.value
          : this.refundMethod,
      refundAmount: data.refundAmount.present
          ? data.refundAmount.value
          : this.refundAmount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      rejectionCode: data.rejectionCode.present
          ? data.rejectionCode.value
          : this.rejectionCode,
      cashSessionId: data.cashSessionId.present
          ? data.cashSessionId.value
          : this.cashSessionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleReturn(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('returnNumber: $returnNumber, ')
          ..write('reason: $reason, ')
          ..write('note: $note, ')
          ..write('refundMethod: $refundMethod, ')
          ..write('refundAmount: $refundAmount, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rejectionCode: $rejectionCode, ')
          ..write('cashSessionId: $cashSessionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    saleId,
    returnNumber,
    reason,
    note,
    refundMethod,
    refundAmount,
    createdAt,
    syncStatus,
    rejectionCode,
    cashSessionId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleReturn &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.returnNumber == this.returnNumber &&
          other.reason == this.reason &&
          other.note == this.note &&
          other.refundMethod == this.refundMethod &&
          other.refundAmount == this.refundAmount &&
          other.createdAt == this.createdAt &&
          other.syncStatus == this.syncStatus &&
          other.rejectionCode == this.rejectionCode &&
          other.cashSessionId == this.cashSessionId);
}

class SaleReturnsCompanion extends UpdateCompanion<SaleReturn> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<int> returnNumber;
  final Value<String> reason;
  final Value<String?> note;
  final Value<String> refundMethod;
  final Value<String> refundAmount;
  final Value<DateTime> createdAt;
  final Value<String> syncStatus;
  final Value<String?> rejectionCode;
  final Value<String?> cashSessionId;
  final Value<int> rowid;
  const SaleReturnsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.returnNumber = const Value.absent(),
    this.reason = const Value.absent(),
    this.note = const Value.absent(),
    this.refundMethod = const Value.absent(),
    this.refundAmount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rejectionCode = const Value.absent(),
    this.cashSessionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaleReturnsCompanion.insert({
    required String id,
    required String saleId,
    this.returnNumber = const Value.absent(),
    required String reason,
    this.note = const Value.absent(),
    required String refundMethod,
    required String refundAmount,
    required DateTime createdAt,
    this.syncStatus = const Value.absent(),
    this.rejectionCode = const Value.absent(),
    this.cashSessionId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       saleId = Value(saleId),
       reason = Value(reason),
       refundMethod = Value(refundMethod),
       refundAmount = Value(refundAmount),
       createdAt = Value(createdAt);
  static Insertable<SaleReturn> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<int>? returnNumber,
    Expression<String>? reason,
    Expression<String>? note,
    Expression<String>? refundMethod,
    Expression<String>? refundAmount,
    Expression<DateTime>? createdAt,
    Expression<String>? syncStatus,
    Expression<String>? rejectionCode,
    Expression<String>? cashSessionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (returnNumber != null) 'return_number': returnNumber,
      if (reason != null) 'reason': reason,
      if (note != null) 'note': note,
      if (refundMethod != null) 'refund_method': refundMethod,
      if (refundAmount != null) 'refund_amount': refundAmount,
      if (createdAt != null) 'created_at': createdAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rejectionCode != null) 'rejection_code': rejectionCode,
      if (cashSessionId != null) 'cash_session_id': cashSessionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaleReturnsCompanion copyWith({
    Value<String>? id,
    Value<String>? saleId,
    Value<int>? returnNumber,
    Value<String>? reason,
    Value<String?>? note,
    Value<String>? refundMethod,
    Value<String>? refundAmount,
    Value<DateTime>? createdAt,
    Value<String>? syncStatus,
    Value<String?>? rejectionCode,
    Value<String?>? cashSessionId,
    Value<int>? rowid,
  }) {
    return SaleReturnsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      returnNumber: returnNumber ?? this.returnNumber,
      reason: reason ?? this.reason,
      note: note ?? this.note,
      refundMethod: refundMethod ?? this.refundMethod,
      refundAmount: refundAmount ?? this.refundAmount,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rejectionCode: rejectionCode ?? this.rejectionCode,
      cashSessionId: cashSessionId ?? this.cashSessionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (returnNumber.present) {
      map['return_number'] = Variable<int>(returnNumber.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (refundMethod.present) {
      map['refund_method'] = Variable<String>(refundMethod.value);
    }
    if (refundAmount.present) {
      map['refund_amount'] = Variable<String>(refundAmount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rejectionCode.present) {
      map['rejection_code'] = Variable<String>(rejectionCode.value);
    }
    if (cashSessionId.present) {
      map['cash_session_id'] = Variable<String>(cashSessionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleReturnsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('returnNumber: $returnNumber, ')
          ..write('reason: $reason, ')
          ..write('note: $note, ')
          ..write('refundMethod: $refundMethod, ')
          ..write('refundAmount: $refundAmount, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rejectionCode: $rejectionCode, ')
          ..write('cashSessionId: $cashSessionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SaleReturnItemsTable extends SaleReturnItems
    with TableInfo<$SaleReturnItemsTable, SaleReturnItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleReturnItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _returnIdMeta = const VerificationMeta(
    'returnId',
  );
  @override
  late final GeneratedColumn<String> returnId = GeneratedColumn<String>(
    'return_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saleItemIdMeta = const VerificationMeta(
    'saleItemId',
  );
  @override
  late final GeneratedColumn<String> saleItemId = GeneratedColumn<String>(
    'sale_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conditionMeta = const VerificationMeta(
    'condition',
  );
  @override
  late final GeneratedColumn<String> condition = GeneratedColumn<String>(
    'condition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restockedMeta = const VerificationMeta(
    'restocked',
  );
  @override
  late final GeneratedColumn<bool> restocked = GeneratedColumn<bool>(
    'restocked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("restocked" IN (0, 1))',
    ),
  );
  static const VerificationMeta _refundAmountMeta = const VerificationMeta(
    'refundAmount',
  );
  @override
  late final GeneratedColumn<String> refundAmount = GeneratedColumn<String>(
    'refund_amount',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    returnId,
    saleItemId,
    productId,
    quantity,
    condition,
    restocked,
    refundAmount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_return_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleReturnItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('return_id')) {
      context.handle(
        _returnIdMeta,
        returnId.isAcceptableOrUnknown(data['return_id']!, _returnIdMeta),
      );
    } else if (isInserting) {
      context.missing(_returnIdMeta);
    }
    if (data.containsKey('sale_item_id')) {
      context.handle(
        _saleItemIdMeta,
        saleItemId.isAcceptableOrUnknown(
          data['sale_item_id']!,
          _saleItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_saleItemIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('condition')) {
      context.handle(
        _conditionMeta,
        condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta),
      );
    } else if (isInserting) {
      context.missing(_conditionMeta);
    }
    if (data.containsKey('restocked')) {
      context.handle(
        _restockedMeta,
        restocked.isAcceptableOrUnknown(data['restocked']!, _restockedMeta),
      );
    } else if (isInserting) {
      context.missing(_restockedMeta);
    }
    if (data.containsKey('refund_amount')) {
      context.handle(
        _refundAmountMeta,
        refundAmount.isAcceptableOrUnknown(
          data['refund_amount']!,
          _refundAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_refundAmountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleReturnItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleReturnItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      returnId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}return_id'],
      )!,
      saleItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_item_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      condition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition'],
      )!,
      restocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}restocked'],
      )!,
      refundAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}refund_amount'],
      )!,
    );
  }

  @override
  $SaleReturnItemsTable createAlias(String alias) {
    return $SaleReturnItemsTable(attachedDatabase, alias);
  }
}

class SaleReturnItem extends DataClass implements Insertable<SaleReturnItem> {
  /// UUID v4 généré côté client.
  final String id;

  /// Retour parent.
  final String returnId;

  /// Ligne de vente d'origine.
  final String saleItemId;

  /// Produit (null si supprimé côté serveur).
  final String? productId;

  /// Quantité rendue.
  final int quantity;

  /// État de l'article, valeur de l'API (`resellable`, `unsellable`…).
  final String condition;

  /// L'article a réintégré le stock disponible.
  final bool restocked;

  /// Montant remboursé pour cette ligne en FCFA (string).
  final String refundAmount;
  const SaleReturnItem({
    required this.id,
    required this.returnId,
    required this.saleItemId,
    this.productId,
    required this.quantity,
    required this.condition,
    required this.restocked,
    required this.refundAmount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['return_id'] = Variable<String>(returnId);
    map['sale_item_id'] = Variable<String>(saleItemId);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    map['quantity'] = Variable<int>(quantity);
    map['condition'] = Variable<String>(condition);
    map['restocked'] = Variable<bool>(restocked);
    map['refund_amount'] = Variable<String>(refundAmount);
    return map;
  }

  SaleReturnItemsCompanion toCompanion(bool nullToAbsent) {
    return SaleReturnItemsCompanion(
      id: Value(id),
      returnId: Value(returnId),
      saleItemId: Value(saleItemId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      quantity: Value(quantity),
      condition: Value(condition),
      restocked: Value(restocked),
      refundAmount: Value(refundAmount),
    );
  }

  factory SaleReturnItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleReturnItem(
      id: serializer.fromJson<String>(json['id']),
      returnId: serializer.fromJson<String>(json['returnId']),
      saleItemId: serializer.fromJson<String>(json['saleItemId']),
      productId: serializer.fromJson<String?>(json['productId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      condition: serializer.fromJson<String>(json['condition']),
      restocked: serializer.fromJson<bool>(json['restocked']),
      refundAmount: serializer.fromJson<String>(json['refundAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'returnId': serializer.toJson<String>(returnId),
      'saleItemId': serializer.toJson<String>(saleItemId),
      'productId': serializer.toJson<String?>(productId),
      'quantity': serializer.toJson<int>(quantity),
      'condition': serializer.toJson<String>(condition),
      'restocked': serializer.toJson<bool>(restocked),
      'refundAmount': serializer.toJson<String>(refundAmount),
    };
  }

  SaleReturnItem copyWith({
    String? id,
    String? returnId,
    String? saleItemId,
    Value<String?> productId = const Value.absent(),
    int? quantity,
    String? condition,
    bool? restocked,
    String? refundAmount,
  }) => SaleReturnItem(
    id: id ?? this.id,
    returnId: returnId ?? this.returnId,
    saleItemId: saleItemId ?? this.saleItemId,
    productId: productId.present ? productId.value : this.productId,
    quantity: quantity ?? this.quantity,
    condition: condition ?? this.condition,
    restocked: restocked ?? this.restocked,
    refundAmount: refundAmount ?? this.refundAmount,
  );
  SaleReturnItem copyWithCompanion(SaleReturnItemsCompanion data) {
    return SaleReturnItem(
      id: data.id.present ? data.id.value : this.id,
      returnId: data.returnId.present ? data.returnId.value : this.returnId,
      saleItemId: data.saleItemId.present
          ? data.saleItemId.value
          : this.saleItemId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      condition: data.condition.present ? data.condition.value : this.condition,
      restocked: data.restocked.present ? data.restocked.value : this.restocked,
      refundAmount: data.refundAmount.present
          ? data.refundAmount.value
          : this.refundAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleReturnItem(')
          ..write('id: $id, ')
          ..write('returnId: $returnId, ')
          ..write('saleItemId: $saleItemId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('condition: $condition, ')
          ..write('restocked: $restocked, ')
          ..write('refundAmount: $refundAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    returnId,
    saleItemId,
    productId,
    quantity,
    condition,
    restocked,
    refundAmount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleReturnItem &&
          other.id == this.id &&
          other.returnId == this.returnId &&
          other.saleItemId == this.saleItemId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.condition == this.condition &&
          other.restocked == this.restocked &&
          other.refundAmount == this.refundAmount);
}

class SaleReturnItemsCompanion extends UpdateCompanion<SaleReturnItem> {
  final Value<String> id;
  final Value<String> returnId;
  final Value<String> saleItemId;
  final Value<String?> productId;
  final Value<int> quantity;
  final Value<String> condition;
  final Value<bool> restocked;
  final Value<String> refundAmount;
  final Value<int> rowid;
  const SaleReturnItemsCompanion({
    this.id = const Value.absent(),
    this.returnId = const Value.absent(),
    this.saleItemId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.condition = const Value.absent(),
    this.restocked = const Value.absent(),
    this.refundAmount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaleReturnItemsCompanion.insert({
    required String id,
    required String returnId,
    required String saleItemId,
    this.productId = const Value.absent(),
    required int quantity,
    required String condition,
    required bool restocked,
    required String refundAmount,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       returnId = Value(returnId),
       saleItemId = Value(saleItemId),
       quantity = Value(quantity),
       condition = Value(condition),
       restocked = Value(restocked),
       refundAmount = Value(refundAmount);
  static Insertable<SaleReturnItem> custom({
    Expression<String>? id,
    Expression<String>? returnId,
    Expression<String>? saleItemId,
    Expression<String>? productId,
    Expression<int>? quantity,
    Expression<String>? condition,
    Expression<bool>? restocked,
    Expression<String>? refundAmount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (returnId != null) 'return_id': returnId,
      if (saleItemId != null) 'sale_item_id': saleItemId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (condition != null) 'condition': condition,
      if (restocked != null) 'restocked': restocked,
      if (refundAmount != null) 'refund_amount': refundAmount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaleReturnItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? returnId,
    Value<String>? saleItemId,
    Value<String?>? productId,
    Value<int>? quantity,
    Value<String>? condition,
    Value<bool>? restocked,
    Value<String>? refundAmount,
    Value<int>? rowid,
  }) {
    return SaleReturnItemsCompanion(
      id: id ?? this.id,
      returnId: returnId ?? this.returnId,
      saleItemId: saleItemId ?? this.saleItemId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      condition: condition ?? this.condition,
      restocked: restocked ?? this.restocked,
      refundAmount: refundAmount ?? this.refundAmount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (returnId.present) {
      map['return_id'] = Variable<String>(returnId.value);
    }
    if (saleItemId.present) {
      map['sale_item_id'] = Variable<String>(saleItemId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(condition.value);
    }
    if (restocked.present) {
      map['restocked'] = Variable<bool>(restocked.value);
    }
    if (refundAmount.present) {
      map['refund_amount'] = Variable<String>(refundAmount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleReturnItemsCompanion(')
          ..write('id: $id, ')
          ..write('returnId: $returnId, ')
          ..write('saleItemId: $saleItemId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('condition: $condition, ')
          ..write('restocked: $restocked, ')
          ..write('refundAmount: $refundAmount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CashSessionsTable extends CashSessions
    with TableInfo<$CashSessionsTable, CashSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openingAmountMeta = const VerificationMeta(
    'openingAmount',
  );
  @override
  late final GeneratedColumn<String> openingAmount = GeneratedColumn<String>(
    'opening_amount',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openingNoteMeta = const VerificationMeta(
    'openingNote',
  );
  @override
  late final GeneratedColumn<String> openingNote = GeneratedColumn<String>(
    'opening_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _openedAtMeta = const VerificationMeta(
    'openedAt',
  );
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
    'opened_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expectedAmountMeta = const VerificationMeta(
    'expectedAmount',
  );
  @override
  late final GeneratedColumn<String> expectedAmount = GeneratedColumn<String>(
    'expected_amount',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientExpectedAmountMeta =
      const VerificationMeta('clientExpectedAmount');
  @override
  late final GeneratedColumn<String> clientExpectedAmount =
      GeneratedColumn<String>(
        'client_expected_amount',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _countedAmountMeta = const VerificationMeta(
    'countedAmount',
  );
  @override
  late final GeneratedColumn<String> countedAmount = GeneratedColumn<String>(
    'counted_amount',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discrepancyAmountMeta = const VerificationMeta(
    'discrepancyAmount',
  );
  @override
  late final GeneratedColumn<String> discrepancyAmount =
      GeneratedColumn<String>(
        'discrepancy_amount',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _closingNoteMeta = const VerificationMeta(
    'closingNote',
  );
  @override
  late final GeneratedColumn<String> closingNote = GeneratedColumn<String>(
    'closing_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
    'closed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverRecalculatedMeta =
      const VerificationMeta('serverRecalculated');
  @override
  late final GeneratedColumn<bool> serverRecalculated = GeneratedColumn<bool>(
    'server_recalculated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("server_recalculated" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _rejectionCodeMeta = const VerificationMeta(
    'rejectionCode',
  );
  @override
  late final GeneratedColumn<String> rejectionCode = GeneratedColumn<String>(
    'rejection_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceId,
    status,
    openingAmount,
    openingNote,
    openedAt,
    expectedAmount,
    clientExpectedAmount,
    countedAmount,
    discrepancyAmount,
    closingNote,
    closedAt,
    serverRecalculated,
    syncStatus,
    rejectionCode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CashSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('opening_amount')) {
      context.handle(
        _openingAmountMeta,
        openingAmount.isAcceptableOrUnknown(
          data['opening_amount']!,
          _openingAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_openingAmountMeta);
    }
    if (data.containsKey('opening_note')) {
      context.handle(
        _openingNoteMeta,
        openingNote.isAcceptableOrUnknown(
          data['opening_note']!,
          _openingNoteMeta,
        ),
      );
    }
    if (data.containsKey('opened_at')) {
      context.handle(
        _openedAtMeta,
        openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_openedAtMeta);
    }
    if (data.containsKey('expected_amount')) {
      context.handle(
        _expectedAmountMeta,
        expectedAmount.isAcceptableOrUnknown(
          data['expected_amount']!,
          _expectedAmountMeta,
        ),
      );
    }
    if (data.containsKey('client_expected_amount')) {
      context.handle(
        _clientExpectedAmountMeta,
        clientExpectedAmount.isAcceptableOrUnknown(
          data['client_expected_amount']!,
          _clientExpectedAmountMeta,
        ),
      );
    }
    if (data.containsKey('counted_amount')) {
      context.handle(
        _countedAmountMeta,
        countedAmount.isAcceptableOrUnknown(
          data['counted_amount']!,
          _countedAmountMeta,
        ),
      );
    }
    if (data.containsKey('discrepancy_amount')) {
      context.handle(
        _discrepancyAmountMeta,
        discrepancyAmount.isAcceptableOrUnknown(
          data['discrepancy_amount']!,
          _discrepancyAmountMeta,
        ),
      );
    }
    if (data.containsKey('closing_note')) {
      context.handle(
        _closingNoteMeta,
        closingNote.isAcceptableOrUnknown(
          data['closing_note']!,
          _closingNoteMeta,
        ),
      );
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    }
    if (data.containsKey('server_recalculated')) {
      context.handle(
        _serverRecalculatedMeta,
        serverRecalculated.isAcceptableOrUnknown(
          data['server_recalculated']!,
          _serverRecalculatedMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('rejection_code')) {
      context.handle(
        _rejectionCodeMeta,
        rejectionCode.isAcceptableOrUnknown(
          data['rejection_code']!,
          _rejectionCodeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      openingAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opening_amount'],
      )!,
      openingNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opening_note'],
      ),
      openedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}opened_at'],
      )!,
      expectedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expected_amount'],
      ),
      clientExpectedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_expected_amount'],
      ),
      countedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}counted_amount'],
      ),
      discrepancyAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discrepancy_amount'],
      ),
      closingNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}closing_note'],
      ),
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}closed_at'],
      ),
      serverRecalculated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}server_recalculated'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      rejectionCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rejection_code'],
      ),
    );
  }

  @override
  $CashSessionsTable createAlias(String alias) {
    return $CashSessionsTable(attachedDatabase, alias);
  }
}

class CashSession extends DataClass implements Insertable<CashSession> {
  /// UUID v4 généré côté client (idempotence sync).
  final String id;

  /// Appareil qui a ouvert la session.
  final String deviceId;

  /// `open` ou `closed`.
  final String status;

  /// Fond de caisse à l'ouverture en FCFA (string).
  final String openingAmount;

  /// Commentaire d'ouverture.
  final String? openingNote;

  /// Date d'ouverture (UTC).
  final DateTime openedAt;

  /// Solde théorique retenu par le serveur en FCFA, null avant clôture.
  final String? expectedAmount;

  /// Solde théorique calculé sur l'appareil à la clôture en FCFA.
  final String? clientExpectedAmount;

  /// Montant compté à la clôture en FCFA.
  final String? countedAmount;

  /// Écart (compté − théorique) en FCFA.
  final String? discrepancyAmount;

  /// Commentaire de clôture.
  final String? closingNote;

  /// Date de clôture (UTC), renvoyée à l'identique à chaque retry.
  final DateTime? closedAt;

  /// Le serveur a recalculé le solde théorique (différent de celui de
  /// l'appareil).
  final bool serverRecalculated;

  /// `pending` (à envoyer), `synced`, `rejected` (refus définitif).
  final String syncStatus;

  /// Code du refus serveur, null sinon.
  final String? rejectionCode;
  const CashSession({
    required this.id,
    required this.deviceId,
    required this.status,
    required this.openingAmount,
    this.openingNote,
    required this.openedAt,
    this.expectedAmount,
    this.clientExpectedAmount,
    this.countedAmount,
    this.discrepancyAmount,
    this.closingNote,
    this.closedAt,
    required this.serverRecalculated,
    required this.syncStatus,
    this.rejectionCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['status'] = Variable<String>(status);
    map['opening_amount'] = Variable<String>(openingAmount);
    if (!nullToAbsent || openingNote != null) {
      map['opening_note'] = Variable<String>(openingNote);
    }
    map['opened_at'] = Variable<DateTime>(openedAt);
    if (!nullToAbsent || expectedAmount != null) {
      map['expected_amount'] = Variable<String>(expectedAmount);
    }
    if (!nullToAbsent || clientExpectedAmount != null) {
      map['client_expected_amount'] = Variable<String>(clientExpectedAmount);
    }
    if (!nullToAbsent || countedAmount != null) {
      map['counted_amount'] = Variable<String>(countedAmount);
    }
    if (!nullToAbsent || discrepancyAmount != null) {
      map['discrepancy_amount'] = Variable<String>(discrepancyAmount);
    }
    if (!nullToAbsent || closingNote != null) {
      map['closing_note'] = Variable<String>(closingNote);
    }
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    map['server_recalculated'] = Variable<bool>(serverRecalculated);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || rejectionCode != null) {
      map['rejection_code'] = Variable<String>(rejectionCode);
    }
    return map;
  }

  CashSessionsCompanion toCompanion(bool nullToAbsent) {
    return CashSessionsCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      status: Value(status),
      openingAmount: Value(openingAmount),
      openingNote: openingNote == null && nullToAbsent
          ? const Value.absent()
          : Value(openingNote),
      openedAt: Value(openedAt),
      expectedAmount: expectedAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedAmount),
      clientExpectedAmount: clientExpectedAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(clientExpectedAmount),
      countedAmount: countedAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(countedAmount),
      discrepancyAmount: discrepancyAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(discrepancyAmount),
      closingNote: closingNote == null && nullToAbsent
          ? const Value.absent()
          : Value(closingNote),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
      serverRecalculated: Value(serverRecalculated),
      syncStatus: Value(syncStatus),
      rejectionCode: rejectionCode == null && nullToAbsent
          ? const Value.absent()
          : Value(rejectionCode),
    );
  }

  factory CashSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashSession(
      id: serializer.fromJson<String>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      status: serializer.fromJson<String>(json['status']),
      openingAmount: serializer.fromJson<String>(json['openingAmount']),
      openingNote: serializer.fromJson<String?>(json['openingNote']),
      openedAt: serializer.fromJson<DateTime>(json['openedAt']),
      expectedAmount: serializer.fromJson<String?>(json['expectedAmount']),
      clientExpectedAmount: serializer.fromJson<String?>(
        json['clientExpectedAmount'],
      ),
      countedAmount: serializer.fromJson<String?>(json['countedAmount']),
      discrepancyAmount: serializer.fromJson<String?>(
        json['discrepancyAmount'],
      ),
      closingNote: serializer.fromJson<String?>(json['closingNote']),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
      serverRecalculated: serializer.fromJson<bool>(json['serverRecalculated']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      rejectionCode: serializer.fromJson<String?>(json['rejectionCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'status': serializer.toJson<String>(status),
      'openingAmount': serializer.toJson<String>(openingAmount),
      'openingNote': serializer.toJson<String?>(openingNote),
      'openedAt': serializer.toJson<DateTime>(openedAt),
      'expectedAmount': serializer.toJson<String?>(expectedAmount),
      'clientExpectedAmount': serializer.toJson<String?>(clientExpectedAmount),
      'countedAmount': serializer.toJson<String?>(countedAmount),
      'discrepancyAmount': serializer.toJson<String?>(discrepancyAmount),
      'closingNote': serializer.toJson<String?>(closingNote),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
      'serverRecalculated': serializer.toJson<bool>(serverRecalculated),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'rejectionCode': serializer.toJson<String?>(rejectionCode),
    };
  }

  CashSession copyWith({
    String? id,
    String? deviceId,
    String? status,
    String? openingAmount,
    Value<String?> openingNote = const Value.absent(),
    DateTime? openedAt,
    Value<String?> expectedAmount = const Value.absent(),
    Value<String?> clientExpectedAmount = const Value.absent(),
    Value<String?> countedAmount = const Value.absent(),
    Value<String?> discrepancyAmount = const Value.absent(),
    Value<String?> closingNote = const Value.absent(),
    Value<DateTime?> closedAt = const Value.absent(),
    bool? serverRecalculated,
    String? syncStatus,
    Value<String?> rejectionCode = const Value.absent(),
  }) => CashSession(
    id: id ?? this.id,
    deviceId: deviceId ?? this.deviceId,
    status: status ?? this.status,
    openingAmount: openingAmount ?? this.openingAmount,
    openingNote: openingNote.present ? openingNote.value : this.openingNote,
    openedAt: openedAt ?? this.openedAt,
    expectedAmount: expectedAmount.present
        ? expectedAmount.value
        : this.expectedAmount,
    clientExpectedAmount: clientExpectedAmount.present
        ? clientExpectedAmount.value
        : this.clientExpectedAmount,
    countedAmount: countedAmount.present
        ? countedAmount.value
        : this.countedAmount,
    discrepancyAmount: discrepancyAmount.present
        ? discrepancyAmount.value
        : this.discrepancyAmount,
    closingNote: closingNote.present ? closingNote.value : this.closingNote,
    closedAt: closedAt.present ? closedAt.value : this.closedAt,
    serverRecalculated: serverRecalculated ?? this.serverRecalculated,
    syncStatus: syncStatus ?? this.syncStatus,
    rejectionCode: rejectionCode.present
        ? rejectionCode.value
        : this.rejectionCode,
  );
  CashSession copyWithCompanion(CashSessionsCompanion data) {
    return CashSession(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      status: data.status.present ? data.status.value : this.status,
      openingAmount: data.openingAmount.present
          ? data.openingAmount.value
          : this.openingAmount,
      openingNote: data.openingNote.present
          ? data.openingNote.value
          : this.openingNote,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
      expectedAmount: data.expectedAmount.present
          ? data.expectedAmount.value
          : this.expectedAmount,
      clientExpectedAmount: data.clientExpectedAmount.present
          ? data.clientExpectedAmount.value
          : this.clientExpectedAmount,
      countedAmount: data.countedAmount.present
          ? data.countedAmount.value
          : this.countedAmount,
      discrepancyAmount: data.discrepancyAmount.present
          ? data.discrepancyAmount.value
          : this.discrepancyAmount,
      closingNote: data.closingNote.present
          ? data.closingNote.value
          : this.closingNote,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      serverRecalculated: data.serverRecalculated.present
          ? data.serverRecalculated.value
          : this.serverRecalculated,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      rejectionCode: data.rejectionCode.present
          ? data.rejectionCode.value
          : this.rejectionCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashSession(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('status: $status, ')
          ..write('openingAmount: $openingAmount, ')
          ..write('openingNote: $openingNote, ')
          ..write('openedAt: $openedAt, ')
          ..write('expectedAmount: $expectedAmount, ')
          ..write('clientExpectedAmount: $clientExpectedAmount, ')
          ..write('countedAmount: $countedAmount, ')
          ..write('discrepancyAmount: $discrepancyAmount, ')
          ..write('closingNote: $closingNote, ')
          ..write('closedAt: $closedAt, ')
          ..write('serverRecalculated: $serverRecalculated, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rejectionCode: $rejectionCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deviceId,
    status,
    openingAmount,
    openingNote,
    openedAt,
    expectedAmount,
    clientExpectedAmount,
    countedAmount,
    discrepancyAmount,
    closingNote,
    closedAt,
    serverRecalculated,
    syncStatus,
    rejectionCode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashSession &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.status == this.status &&
          other.openingAmount == this.openingAmount &&
          other.openingNote == this.openingNote &&
          other.openedAt == this.openedAt &&
          other.expectedAmount == this.expectedAmount &&
          other.clientExpectedAmount == this.clientExpectedAmount &&
          other.countedAmount == this.countedAmount &&
          other.discrepancyAmount == this.discrepancyAmount &&
          other.closingNote == this.closingNote &&
          other.closedAt == this.closedAt &&
          other.serverRecalculated == this.serverRecalculated &&
          other.syncStatus == this.syncStatus &&
          other.rejectionCode == this.rejectionCode);
}

class CashSessionsCompanion extends UpdateCompanion<CashSession> {
  final Value<String> id;
  final Value<String> deviceId;
  final Value<String> status;
  final Value<String> openingAmount;
  final Value<String?> openingNote;
  final Value<DateTime> openedAt;
  final Value<String?> expectedAmount;
  final Value<String?> clientExpectedAmount;
  final Value<String?> countedAmount;
  final Value<String?> discrepancyAmount;
  final Value<String?> closingNote;
  final Value<DateTime?> closedAt;
  final Value<bool> serverRecalculated;
  final Value<String> syncStatus;
  final Value<String?> rejectionCode;
  final Value<int> rowid;
  const CashSessionsCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.status = const Value.absent(),
    this.openingAmount = const Value.absent(),
    this.openingNote = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.expectedAmount = const Value.absent(),
    this.clientExpectedAmount = const Value.absent(),
    this.countedAmount = const Value.absent(),
    this.discrepancyAmount = const Value.absent(),
    this.closingNote = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.serverRecalculated = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rejectionCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CashSessionsCompanion.insert({
    required String id,
    required String deviceId,
    required String status,
    required String openingAmount,
    this.openingNote = const Value.absent(),
    required DateTime openedAt,
    this.expectedAmount = const Value.absent(),
    this.clientExpectedAmount = const Value.absent(),
    this.countedAmount = const Value.absent(),
    this.discrepancyAmount = const Value.absent(),
    this.closingNote = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.serverRecalculated = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rejectionCode = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       deviceId = Value(deviceId),
       status = Value(status),
       openingAmount = Value(openingAmount),
       openedAt = Value(openedAt);
  static Insertable<CashSession> custom({
    Expression<String>? id,
    Expression<String>? deviceId,
    Expression<String>? status,
    Expression<String>? openingAmount,
    Expression<String>? openingNote,
    Expression<DateTime>? openedAt,
    Expression<String>? expectedAmount,
    Expression<String>? clientExpectedAmount,
    Expression<String>? countedAmount,
    Expression<String>? discrepancyAmount,
    Expression<String>? closingNote,
    Expression<DateTime>? closedAt,
    Expression<bool>? serverRecalculated,
    Expression<String>? syncStatus,
    Expression<String>? rejectionCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (status != null) 'status': status,
      if (openingAmount != null) 'opening_amount': openingAmount,
      if (openingNote != null) 'opening_note': openingNote,
      if (openedAt != null) 'opened_at': openedAt,
      if (expectedAmount != null) 'expected_amount': expectedAmount,
      if (clientExpectedAmount != null)
        'client_expected_amount': clientExpectedAmount,
      if (countedAmount != null) 'counted_amount': countedAmount,
      if (discrepancyAmount != null) 'discrepancy_amount': discrepancyAmount,
      if (closingNote != null) 'closing_note': closingNote,
      if (closedAt != null) 'closed_at': closedAt,
      if (serverRecalculated != null) 'server_recalculated': serverRecalculated,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rejectionCode != null) 'rejection_code': rejectionCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CashSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? deviceId,
    Value<String>? status,
    Value<String>? openingAmount,
    Value<String?>? openingNote,
    Value<DateTime>? openedAt,
    Value<String?>? expectedAmount,
    Value<String?>? clientExpectedAmount,
    Value<String?>? countedAmount,
    Value<String?>? discrepancyAmount,
    Value<String?>? closingNote,
    Value<DateTime?>? closedAt,
    Value<bool>? serverRecalculated,
    Value<String>? syncStatus,
    Value<String?>? rejectionCode,
    Value<int>? rowid,
  }) {
    return CashSessionsCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      status: status ?? this.status,
      openingAmount: openingAmount ?? this.openingAmount,
      openingNote: openingNote ?? this.openingNote,
      openedAt: openedAt ?? this.openedAt,
      expectedAmount: expectedAmount ?? this.expectedAmount,
      clientExpectedAmount: clientExpectedAmount ?? this.clientExpectedAmount,
      countedAmount: countedAmount ?? this.countedAmount,
      discrepancyAmount: discrepancyAmount ?? this.discrepancyAmount,
      closingNote: closingNote ?? this.closingNote,
      closedAt: closedAt ?? this.closedAt,
      serverRecalculated: serverRecalculated ?? this.serverRecalculated,
      syncStatus: syncStatus ?? this.syncStatus,
      rejectionCode: rejectionCode ?? this.rejectionCode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (openingAmount.present) {
      map['opening_amount'] = Variable<String>(openingAmount.value);
    }
    if (openingNote.present) {
      map['opening_note'] = Variable<String>(openingNote.value);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.value);
    }
    if (expectedAmount.present) {
      map['expected_amount'] = Variable<String>(expectedAmount.value);
    }
    if (clientExpectedAmount.present) {
      map['client_expected_amount'] = Variable<String>(
        clientExpectedAmount.value,
      );
    }
    if (countedAmount.present) {
      map['counted_amount'] = Variable<String>(countedAmount.value);
    }
    if (discrepancyAmount.present) {
      map['discrepancy_amount'] = Variable<String>(discrepancyAmount.value);
    }
    if (closingNote.present) {
      map['closing_note'] = Variable<String>(closingNote.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    if (serverRecalculated.present) {
      map['server_recalculated'] = Variable<bool>(serverRecalculated.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rejectionCode.present) {
      map['rejection_code'] = Variable<String>(rejectionCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashSessionsCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('status: $status, ')
          ..write('openingAmount: $openingAmount, ')
          ..write('openingNote: $openingNote, ')
          ..write('openedAt: $openedAt, ')
          ..write('expectedAmount: $expectedAmount, ')
          ..write('clientExpectedAmount: $clientExpectedAmount, ')
          ..write('countedAmount: $countedAmount, ')
          ..write('discrepancyAmount: $discrepancyAmount, ')
          ..write('closingNote: $closingNote, ')
          ..write('closedAt: $closedAt, ')
          ..write('serverRecalculated: $serverRecalculated, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rejectionCode: $rejectionCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CashMovementsTable extends CashMovements
    with TableInfo<$CashMovementsTable, CashMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<String> amount = GeneratedColumn<String>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rejectionCodeMeta = const VerificationMeta(
    'rejectionCode',
  );
  @override
  late final GeneratedColumn<String> rejectionCode = GeneratedColumn<String>(
    'rejection_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    type,
    reason,
    amount,
    note,
    createdAt,
    syncStatus,
    rejectionCode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_movements';
  @override
  VerificationContext validateIntegrity(
    Insertable<CashMovement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('rejection_code')) {
      context.handle(
        _rejectionCodeMeta,
        rejectionCode.isAcceptableOrUnknown(
          data['rejection_code']!,
          _rejectionCodeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashMovement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}amount'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      rejectionCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rejection_code'],
      ),
    );
  }

  @override
  $CashMovementsTable createAlias(String alias) {
    return $CashMovementsTable(attachedDatabase, alias);
  }
}

class CashMovement extends DataClass implements Insertable<CashMovement> {
  /// UUID v4 généré côté client (idempotence sync).
  final String id;

  /// Session de caisse parente.
  final String sessionId;

  /// `cash_in` ou `cash_out`.
  final String type;

  /// Motif, valeur de l'API.
  final String reason;

  /// Montant en FCFA (string).
  final String amount;

  /// Commentaire.
  final String? note;

  /// Date du mouvement (UTC).
  final DateTime createdAt;

  /// `pending` (à envoyer), `synced`, `rejected` (refus définitif).
  final String syncStatus;

  /// Code du refus serveur, null sinon.
  final String? rejectionCode;
  const CashMovement({
    required this.id,
    required this.sessionId,
    required this.type,
    required this.reason,
    required this.amount,
    this.note,
    required this.createdAt,
    required this.syncStatus,
    this.rejectionCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['type'] = Variable<String>(type);
    map['reason'] = Variable<String>(reason);
    map['amount'] = Variable<String>(amount);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || rejectionCode != null) {
      map['rejection_code'] = Variable<String>(rejectionCode);
    }
    return map;
  }

  CashMovementsCompanion toCompanion(bool nullToAbsent) {
    return CashMovementsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      type: Value(type),
      reason: Value(reason),
      amount: Value(amount),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
      rejectionCode: rejectionCode == null && nullToAbsent
          ? const Value.absent()
          : Value(rejectionCode),
    );
  }

  factory CashMovement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashMovement(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      type: serializer.fromJson<String>(json['type']),
      reason: serializer.fromJson<String>(json['reason']),
      amount: serializer.fromJson<String>(json['amount']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      rejectionCode: serializer.fromJson<String?>(json['rejectionCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'type': serializer.toJson<String>(type),
      'reason': serializer.toJson<String>(reason),
      'amount': serializer.toJson<String>(amount),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'rejectionCode': serializer.toJson<String?>(rejectionCode),
    };
  }

  CashMovement copyWith({
    String? id,
    String? sessionId,
    String? type,
    String? reason,
    String? amount,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    String? syncStatus,
    Value<String?> rejectionCode = const Value.absent(),
  }) => CashMovement(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    type: type ?? this.type,
    reason: reason ?? this.reason,
    amount: amount ?? this.amount,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    syncStatus: syncStatus ?? this.syncStatus,
    rejectionCode: rejectionCode.present
        ? rejectionCode.value
        : this.rejectionCode,
  );
  CashMovement copyWithCompanion(CashMovementsCompanion data) {
    return CashMovement(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      type: data.type.present ? data.type.value : this.type,
      reason: data.reason.present ? data.reason.value : this.reason,
      amount: data.amount.present ? data.amount.value : this.amount,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      rejectionCode: data.rejectionCode.present
          ? data.rejectionCode.value
          : this.rejectionCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashMovement(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('type: $type, ')
          ..write('reason: $reason, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rejectionCode: $rejectionCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    type,
    reason,
    amount,
    note,
    createdAt,
    syncStatus,
    rejectionCode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashMovement &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.type == this.type &&
          other.reason == this.reason &&
          other.amount == this.amount &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.syncStatus == this.syncStatus &&
          other.rejectionCode == this.rejectionCode);
}

class CashMovementsCompanion extends UpdateCompanion<CashMovement> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> type;
  final Value<String> reason;
  final Value<String> amount;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<String> syncStatus;
  final Value<String?> rejectionCode;
  final Value<int> rowid;
  const CashMovementsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.type = const Value.absent(),
    this.reason = const Value.absent(),
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rejectionCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CashMovementsCompanion.insert({
    required String id,
    required String sessionId,
    required String type,
    required String reason,
    required String amount,
    this.note = const Value.absent(),
    required DateTime createdAt,
    required String syncStatus,
    this.rejectionCode = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       type = Value(type),
       reason = Value(reason),
       amount = Value(amount),
       createdAt = Value(createdAt),
       syncStatus = Value(syncStatus);
  static Insertable<CashMovement> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? type,
    Expression<String>? reason,
    Expression<String>? amount,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<String>? syncStatus,
    Expression<String>? rejectionCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (type != null) 'type': type,
      if (reason != null) 'reason': reason,
      if (amount != null) 'amount': amount,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rejectionCode != null) 'rejection_code': rejectionCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CashMovementsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? type,
    Value<String>? reason,
    Value<String>? amount,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<String>? syncStatus,
    Value<String?>? rejectionCode,
    Value<int>? rowid,
  }) {
    return CashMovementsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      type: type ?? this.type,
      reason: reason ?? this.reason,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rejectionCode: rejectionCode ?? this.rejectionCode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (amount.present) {
      map['amount'] = Variable<String>(amount.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rejectionCode.present) {
      map['rejection_code'] = Variable<String>(rejectionCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashMovementsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('type: $type, ')
          ..write('reason: $reason, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rejectionCode: $rejectionCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastAttemptAtMeta = const VerificationMeta(
    'lastAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>(
        'last_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    payload,
    status,
    retryCount,
    lastError,
    createdAt,
    lastAttemptAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
        _lastAttemptAtMeta,
        lastAttemptAt.isAcceptableOrUnknown(
          data['last_attempt_at']!,
          _lastAttemptAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt_at'],
      ),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  /// Auto-incrémenté.
  final int id;

  /// Type d'entité (sale, product, etc.).
  final String entityType;

  /// UUID de l'entité concernée.
  final String entityId;

  /// Payload JSON sérialisé.
  final String payload;

  /// pending, syncing, synced, failed (réessayé), rejected (refus définitif).
  final String status;

  /// Nombre de tentatives.
  final int retryCount;

  /// Dernière erreur rencontrée.
  final String? lastError;

  /// Horodatage de création.
  final DateTime createdAt;

  /// Horodatage de la dernière tentative de sync.
  final DateTime? lastAttemptAt;
  const SyncQueueData({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.payload,
    required this.status,
    required this.retryCount,
    this.lastError,
    required this.createdAt,
    this.lastAttemptAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['payload'] = Variable<String>(payload);
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      payload: Value(payload),
      status: Value(status),
      retryCount: Value(retryCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      payload: serializer.fromJson<String>(json['payload']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'payload': serializer.toJson<String>(payload),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
    };
  }

  SyncQueueData copyWith({
    int? id,
    String? entityType,
    String? entityId,
    String? payload,
    String? status,
    int? retryCount,
    Value<String?> lastError = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> lastAttemptAt = const Value.absent(),
  }) => SyncQueueData(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    payload: payload ?? this.payload,
    status: status ?? this.status,
    retryCount: retryCount ?? this.retryCount,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
    lastAttemptAt: lastAttemptAt.present
        ? lastAttemptAt.value
        : this.lastAttemptAt,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      payload: data.payload.present ? data.payload.value : this.payload,
      status: data.status.present ? data.status.value : this.status,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttemptAt: $lastAttemptAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    payload,
    status,
    retryCount,
    lastError,
    createdAt,
    lastAttemptAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.payload == this.payload &&
          other.status == this.status &&
          other.retryCount == this.retryCount &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.lastAttemptAt == this.lastAttemptAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> payload;
  final Value<String> status;
  final Value<int> retryCount;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastAttemptAt;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.payload = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required String entityId,
    required String payload,
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    required DateTime createdAt,
    this.lastAttemptAt = const Value.absent(),
  }) : entityType = Value(entityType),
       entityId = Value(entityId),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? payload,
    Expression<String>? status,
    Expression<int>? retryCount,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastAttemptAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (payload != null) 'payload': payload,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? payload,
    Value<String>? status,
    Value<int>? retryCount,
    Value<String?>? lastError,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastAttemptAt,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttemptAt: $lastAttemptAt')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTable extends SyncMetadata
    with TableInfo<$SyncMetadataTable, SyncMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SyncMetadataTable createAlias(String alias) {
    return $SyncMetadataTable(attachedDatabase, alias);
  }
}

class SyncMetadataData extends DataClass
    implements Insertable<SyncMetadataData> {
  /// Clé unique (ex: 'last_pull').
  final String key;

  /// Valeur du timestamp (ISO 8601).
  final String value;

  /// Dernière mise à jour.
  final DateTime updatedAt;
  const SyncMetadataData({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncMetadataData copyWith({
    String? key,
    String? value,
    DateTime? updatedAt,
  }) => SyncMetadataData(
    key: key ?? this.key,
    value: value ?? this.value,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncMetadataData copyWithCompanion(SyncMetadataCompanion data) {
    return SyncMetadataData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataData &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class SyncMetadataCompanion extends UpdateCompanion<SyncMetadataData> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncMetadataCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataCompanion.insert({
    required String key,
    required String value,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SyncMetadataData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncMetadataCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleItemsTable saleItems = $SaleItemsTable(this);
  late final $SaleReturnsTable saleReturns = $SaleReturnsTable(this);
  late final $SaleReturnItemsTable saleReturnItems = $SaleReturnItemsTable(
    this,
  );
  late final $CashSessionsTable cashSessions = $CashSessionsTable(this);
  late final $CashMovementsTable cashMovements = $CashMovementsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $SyncMetadataTable syncMetadata = $SyncMetadataTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    categories,
    sales,
    saleItems,
    saleReturns,
    saleReturnItems,
    cashSessions,
    cashMovements,
    syncQueue,
    syncMetadata,
  ];
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String name,
      Value<String?> barcode,
      required String sellingPrice,
      Value<String?> purchasePrice,
      Value<int?> currentStock,
      Value<int?> minStock,
      Value<String?> categoryId,
      Value<String?> imageVersion,
      Value<bool> dirty,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> barcode,
      Value<String> sellingPrice,
      Value<String?> purchasePrice,
      Value<int?> currentStock,
      Value<int?> minStock,
      Value<String?> categoryId,
      Value<String?> imageVersion,
      Value<bool> dirty,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minStock => $composableBuilder(
    column: $table.minStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageVersion => $composableBuilder(
    column: $table.imageVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minStock => $composableBuilder(
    column: $table.minStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageVersion => $composableBuilder(
    column: $table.imageVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get sellingPrice => $composableBuilder(
    column: $table.sellingPrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minStock =>
      $composableBuilder(column: $table.minStock, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageVersion => $composableBuilder(
    column: $table.imageVersion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
          Product,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String> sellingPrice = const Value.absent(),
                Value<String?> purchasePrice = const Value.absent(),
                Value<int?> currentStock = const Value.absent(),
                Value<int?> minStock = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> imageVersion = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                barcode: barcode,
                sellingPrice: sellingPrice,
                purchasePrice: purchasePrice,
                currentStock: currentStock,
                minStock: minStock,
                categoryId: categoryId,
                imageVersion: imageVersion,
                dirty: dirty,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> barcode = const Value.absent(),
                required String sellingPrice,
                Value<String?> purchasePrice = const Value.absent(),
                Value<int?> currentStock = const Value.absent(),
                Value<int?> minStock = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> imageVersion = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                barcode: barcode,
                sellingPrice: sellingPrice,
                purchasePrice: purchasePrice,
                currentStock: currentStock,
                minStock: minStock,
                categoryId: categoryId,
                imageVersion: imageVersion,
                dirty: dirty,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProductsTable, Product>(table),
                  BaseReferences<_$AppDatabase, $ProductsTable, Product>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
      Product,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      required String name,
      Value<bool> dirty,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<bool> dirty,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                dirty: dirty,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<bool> dirty = const Value.absent(),
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                dirty: dirty,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, Category>(table),
                  BaseReferences<_$AppDatabase, $CategoriesTable, Category>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$SalesTableCreateCompanionBuilder =
    SalesCompanion Function({
      required String id,
      required int receiptNumber,
      required String totalAmount,
      required String vatAmount,
      required String paymentMethod,
      Value<String?> discountType,
      Value<String?> discountValue,
      Value<String> discountAmount,
      Value<String?> cashAmount,
      Value<String?> mobileMoneyAmount,
      Value<String?> cashSessionId,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SalesTableUpdateCompanionBuilder =
    SalesCompanion Function({
      Value<String> id,
      Value<int> receiptNumber,
      Value<String> totalAmount,
      Value<String> vatAmount,
      Value<String> paymentMethod,
      Value<String?> discountType,
      Value<String?> discountValue,
      Value<String> discountAmount,
      Value<String?> cashAmount,
      Value<String?> mobileMoneyAmount,
      Value<String?> cashSessionId,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vatAmount => $composableBuilder(
    column: $table.vatAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discountType => $composableBuilder(
    column: $table.discountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discountValue => $composableBuilder(
    column: $table.discountValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cashAmount => $composableBuilder(
    column: $table.cashAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mobileMoneyAmount => $composableBuilder(
    column: $table.mobileMoneyAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cashSessionId => $composableBuilder(
    column: $table.cashSessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vatAmount => $composableBuilder(
    column: $table.vatAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discountType => $composableBuilder(
    column: $table.discountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discountValue => $composableBuilder(
    column: $table.discountValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cashAmount => $composableBuilder(
    column: $table.cashAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mobileMoneyAmount => $composableBuilder(
    column: $table.mobileMoneyAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cashSessionId => $composableBuilder(
    column: $table.cashSessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get receiptNumber => $composableBuilder(
    column: $table.receiptNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get vatAmount =>
      $composableBuilder(column: $table.vatAmount, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get discountType => $composableBuilder(
    column: $table.discountType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get discountValue => $composableBuilder(
    column: $table.discountValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cashAmount => $composableBuilder(
    column: $table.cashAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mobileMoneyAmount => $composableBuilder(
    column: $table.mobileMoneyAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cashSessionId => $composableBuilder(
    column: $table.cashSessionId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesTable,
          Sale,
          $$SalesTableFilterComposer,
          $$SalesTableOrderingComposer,
          $$SalesTableAnnotationComposer,
          $$SalesTableCreateCompanionBuilder,
          $$SalesTableUpdateCompanionBuilder,
          (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
          Sale,
          PrefetchHooks Function()
        > {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> receiptNumber = const Value.absent(),
                Value<String> totalAmount = const Value.absent(),
                Value<String> vatAmount = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<String?> discountType = const Value.absent(),
                Value<String?> discountValue = const Value.absent(),
                Value<String> discountAmount = const Value.absent(),
                Value<String?> cashAmount = const Value.absent(),
                Value<String?> mobileMoneyAmount = const Value.absent(),
                Value<String?> cashSessionId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion(
                id: id,
                receiptNumber: receiptNumber,
                totalAmount: totalAmount,
                vatAmount: vatAmount,
                paymentMethod: paymentMethod,
                discountType: discountType,
                discountValue: discountValue,
                discountAmount: discountAmount,
                cashAmount: cashAmount,
                mobileMoneyAmount: mobileMoneyAmount,
                cashSessionId: cashSessionId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int receiptNumber,
                required String totalAmount,
                required String vatAmount,
                required String paymentMethod,
                Value<String?> discountType = const Value.absent(),
                Value<String?> discountValue = const Value.absent(),
                Value<String> discountAmount = const Value.absent(),
                Value<String?> cashAmount = const Value.absent(),
                Value<String?> mobileMoneyAmount = const Value.absent(),
                Value<String?> cashSessionId = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion.insert(
                id: id,
                receiptNumber: receiptNumber,
                totalAmount: totalAmount,
                vatAmount: vatAmount,
                paymentMethod: paymentMethod,
                discountType: discountType,
                discountValue: discountValue,
                discountAmount: discountAmount,
                cashAmount: cashAmount,
                mobileMoneyAmount: mobileMoneyAmount,
                cashSessionId: cashSessionId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SalesTable, Sale>(table),
                  BaseReferences<_$AppDatabase, $SalesTable, Sale>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesTable,
      Sale,
      $$SalesTableFilterComposer,
      $$SalesTableOrderingComposer,
      $$SalesTableAnnotationComposer,
      $$SalesTableCreateCompanionBuilder,
      $$SalesTableUpdateCompanionBuilder,
      (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
      Sale,
      PrefetchHooks Function()
    >;
typedef $$SaleItemsTableCreateCompanionBuilder =
    SaleItemsCompanion Function({
      required String id,
      required String saleId,
      required String productId,
      required String productName,
      required String unitPrice,
      required int quantity,
      required String lineTotal,
      Value<String?> purchaseUnitPrice,
      Value<String?> discountType,
      Value<String?> discountValue,
      Value<String> discountAmount,
      Value<int> rowid,
    });
typedef $$SaleItemsTableUpdateCompanionBuilder =
    SaleItemsCompanion Function({
      Value<String> id,
      Value<String> saleId,
      Value<String> productId,
      Value<String> productName,
      Value<String> unitPrice,
      Value<int> quantity,
      Value<String> lineTotal,
      Value<String?> purchaseUnitPrice,
      Value<String?> discountType,
      Value<String?> discountValue,
      Value<String> discountAmount,
      Value<int> rowid,
    });

class $$SaleItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseUnitPrice => $composableBuilder(
    column: $table.purchaseUnitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discountType => $composableBuilder(
    column: $table.discountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discountValue => $composableBuilder(
    column: $table.discountValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SaleItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lineTotal => $composableBuilder(
    column: $table.lineTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseUnitPrice => $composableBuilder(
    column: $table.purchaseUnitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discountType => $composableBuilder(
    column: $table.discountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discountValue => $composableBuilder(
    column: $table.discountValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SaleItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);

  GeneratedColumn<String> get purchaseUnitPrice => $composableBuilder(
    column: $table.purchaseUnitPrice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get discountType => $composableBuilder(
    column: $table.discountType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get discountValue => $composableBuilder(
    column: $table.discountValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => column,
  );
}

class $$SaleItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SaleItemsTable,
          SaleItem,
          $$SaleItemsTableFilterComposer,
          $$SaleItemsTableOrderingComposer,
          $$SaleItemsTableAnnotationComposer,
          $$SaleItemsTableCreateCompanionBuilder,
          $$SaleItemsTableUpdateCompanionBuilder,
          (SaleItem, BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem>),
          SaleItem,
          PrefetchHooks Function()
        > {
  $$SaleItemsTableTableManager(_$AppDatabase db, $SaleItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> saleId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<String> unitPrice = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String> lineTotal = const Value.absent(),
                Value<String?> purchaseUnitPrice = const Value.absent(),
                Value<String?> discountType = const Value.absent(),
                Value<String?> discountValue = const Value.absent(),
                Value<String> discountAmount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SaleItemsCompanion(
                id: id,
                saleId: saleId,
                productId: productId,
                productName: productName,
                unitPrice: unitPrice,
                quantity: quantity,
                lineTotal: lineTotal,
                purchaseUnitPrice: purchaseUnitPrice,
                discountType: discountType,
                discountValue: discountValue,
                discountAmount: discountAmount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String saleId,
                required String productId,
                required String productName,
                required String unitPrice,
                required int quantity,
                required String lineTotal,
                Value<String?> purchaseUnitPrice = const Value.absent(),
                Value<String?> discountType = const Value.absent(),
                Value<String?> discountValue = const Value.absent(),
                Value<String> discountAmount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SaleItemsCompanion.insert(
                id: id,
                saleId: saleId,
                productId: productId,
                productName: productName,
                unitPrice: unitPrice,
                quantity: quantity,
                lineTotal: lineTotal,
                purchaseUnitPrice: purchaseUnitPrice,
                discountType: discountType,
                discountValue: discountValue,
                discountAmount: discountAmount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SaleItemsTable, SaleItem>(table),
                  BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SaleItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SaleItemsTable,
      SaleItem,
      $$SaleItemsTableFilterComposer,
      $$SaleItemsTableOrderingComposer,
      $$SaleItemsTableAnnotationComposer,
      $$SaleItemsTableCreateCompanionBuilder,
      $$SaleItemsTableUpdateCompanionBuilder,
      (SaleItem, BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem>),
      SaleItem,
      PrefetchHooks Function()
    >;
typedef $$SaleReturnsTableCreateCompanionBuilder =
    SaleReturnsCompanion Function({
      required String id,
      required String saleId,
      Value<int> returnNumber,
      required String reason,
      Value<String?> note,
      required String refundMethod,
      required String refundAmount,
      required DateTime createdAt,
      Value<String> syncStatus,
      Value<String?> rejectionCode,
      Value<String?> cashSessionId,
      Value<int> rowid,
    });
typedef $$SaleReturnsTableUpdateCompanionBuilder =
    SaleReturnsCompanion Function({
      Value<String> id,
      Value<String> saleId,
      Value<int> returnNumber,
      Value<String> reason,
      Value<String?> note,
      Value<String> refundMethod,
      Value<String> refundAmount,
      Value<DateTime> createdAt,
      Value<String> syncStatus,
      Value<String?> rejectionCode,
      Value<String?> cashSessionId,
      Value<int> rowid,
    });

class $$SaleReturnsTableFilterComposer
    extends Composer<_$AppDatabase, $SaleReturnsTable> {
  $$SaleReturnsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get returnNumber => $composableBuilder(
    column: $table.returnNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refundMethod => $composableBuilder(
    column: $table.refundMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refundAmount => $composableBuilder(
    column: $table.refundAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rejectionCode => $composableBuilder(
    column: $table.rejectionCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cashSessionId => $composableBuilder(
    column: $table.cashSessionId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SaleReturnsTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleReturnsTable> {
  $$SaleReturnsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get returnNumber => $composableBuilder(
    column: $table.returnNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refundMethod => $composableBuilder(
    column: $table.refundMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refundAmount => $composableBuilder(
    column: $table.refundAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rejectionCode => $composableBuilder(
    column: $table.rejectionCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cashSessionId => $composableBuilder(
    column: $table.cashSessionId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SaleReturnsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleReturnsTable> {
  $$SaleReturnsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<int> get returnNumber => $composableBuilder(
    column: $table.returnNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get refundMethod => $composableBuilder(
    column: $table.refundMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get refundAmount => $composableBuilder(
    column: $table.refundAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rejectionCode => $composableBuilder(
    column: $table.rejectionCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cashSessionId => $composableBuilder(
    column: $table.cashSessionId,
    builder: (column) => column,
  );
}

class $$SaleReturnsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SaleReturnsTable,
          SaleReturn,
          $$SaleReturnsTableFilterComposer,
          $$SaleReturnsTableOrderingComposer,
          $$SaleReturnsTableAnnotationComposer,
          $$SaleReturnsTableCreateCompanionBuilder,
          $$SaleReturnsTableUpdateCompanionBuilder,
          (
            SaleReturn,
            BaseReferences<_$AppDatabase, $SaleReturnsTable, SaleReturn>,
          ),
          SaleReturn,
          PrefetchHooks Function()
        > {
  $$SaleReturnsTableTableManager(_$AppDatabase db, $SaleReturnsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleReturnsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleReturnsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleReturnsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> saleId = const Value.absent(),
                Value<int> returnNumber = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> refundMethod = const Value.absent(),
                Value<String> refundAmount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> rejectionCode = const Value.absent(),
                Value<String?> cashSessionId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SaleReturnsCompanion(
                id: id,
                saleId: saleId,
                returnNumber: returnNumber,
                reason: reason,
                note: note,
                refundMethod: refundMethod,
                refundAmount: refundAmount,
                createdAt: createdAt,
                syncStatus: syncStatus,
                rejectionCode: rejectionCode,
                cashSessionId: cashSessionId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String saleId,
                Value<int> returnNumber = const Value.absent(),
                required String reason,
                Value<String?> note = const Value.absent(),
                required String refundMethod,
                required String refundAmount,
                required DateTime createdAt,
                Value<String> syncStatus = const Value.absent(),
                Value<String?> rejectionCode = const Value.absent(),
                Value<String?> cashSessionId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SaleReturnsCompanion.insert(
                id: id,
                saleId: saleId,
                returnNumber: returnNumber,
                reason: reason,
                note: note,
                refundMethod: refundMethod,
                refundAmount: refundAmount,
                createdAt: createdAt,
                syncStatus: syncStatus,
                rejectionCode: rejectionCode,
                cashSessionId: cashSessionId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SaleReturnsTable, SaleReturn>(table),
                  BaseReferences<_$AppDatabase, $SaleReturnsTable, SaleReturn>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SaleReturnsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SaleReturnsTable,
      SaleReturn,
      $$SaleReturnsTableFilterComposer,
      $$SaleReturnsTableOrderingComposer,
      $$SaleReturnsTableAnnotationComposer,
      $$SaleReturnsTableCreateCompanionBuilder,
      $$SaleReturnsTableUpdateCompanionBuilder,
      (
        SaleReturn,
        BaseReferences<_$AppDatabase, $SaleReturnsTable, SaleReturn>,
      ),
      SaleReturn,
      PrefetchHooks Function()
    >;
typedef $$SaleReturnItemsTableCreateCompanionBuilder =
    SaleReturnItemsCompanion Function({
      required String id,
      required String returnId,
      required String saleItemId,
      Value<String?> productId,
      required int quantity,
      required String condition,
      required bool restocked,
      required String refundAmount,
      Value<int> rowid,
    });
typedef $$SaleReturnItemsTableUpdateCompanionBuilder =
    SaleReturnItemsCompanion Function({
      Value<String> id,
      Value<String> returnId,
      Value<String> saleItemId,
      Value<String?> productId,
      Value<int> quantity,
      Value<String> condition,
      Value<bool> restocked,
      Value<String> refundAmount,
      Value<int> rowid,
    });

class $$SaleReturnItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SaleReturnItemsTable> {
  $$SaleReturnItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get returnId => $composableBuilder(
    column: $table.returnId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get saleItemId => $composableBuilder(
    column: $table.saleItemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get restocked => $composableBuilder(
    column: $table.restocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refundAmount => $composableBuilder(
    column: $table.refundAmount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SaleReturnItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleReturnItemsTable> {
  $$SaleReturnItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get returnId => $composableBuilder(
    column: $table.returnId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saleItemId => $composableBuilder(
    column: $table.saleItemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get restocked => $composableBuilder(
    column: $table.restocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refundAmount => $composableBuilder(
    column: $table.refundAmount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SaleReturnItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleReturnItemsTable> {
  $$SaleReturnItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get returnId =>
      $composableBuilder(column: $table.returnId, builder: (column) => column);

  GeneratedColumn<String> get saleItemId => $composableBuilder(
    column: $table.saleItemId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<bool> get restocked =>
      $composableBuilder(column: $table.restocked, builder: (column) => column);

  GeneratedColumn<String> get refundAmount => $composableBuilder(
    column: $table.refundAmount,
    builder: (column) => column,
  );
}

class $$SaleReturnItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SaleReturnItemsTable,
          SaleReturnItem,
          $$SaleReturnItemsTableFilterComposer,
          $$SaleReturnItemsTableOrderingComposer,
          $$SaleReturnItemsTableAnnotationComposer,
          $$SaleReturnItemsTableCreateCompanionBuilder,
          $$SaleReturnItemsTableUpdateCompanionBuilder,
          (
            SaleReturnItem,
            BaseReferences<
              _$AppDatabase,
              $SaleReturnItemsTable,
              SaleReturnItem
            >,
          ),
          SaleReturnItem,
          PrefetchHooks Function()
        > {
  $$SaleReturnItemsTableTableManager(
    _$AppDatabase db,
    $SaleReturnItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleReturnItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleReturnItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleReturnItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> returnId = const Value.absent(),
                Value<String> saleItemId = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String> condition = const Value.absent(),
                Value<bool> restocked = const Value.absent(),
                Value<String> refundAmount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SaleReturnItemsCompanion(
                id: id,
                returnId: returnId,
                saleItemId: saleItemId,
                productId: productId,
                quantity: quantity,
                condition: condition,
                restocked: restocked,
                refundAmount: refundAmount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String returnId,
                required String saleItemId,
                Value<String?> productId = const Value.absent(),
                required int quantity,
                required String condition,
                required bool restocked,
                required String refundAmount,
                Value<int> rowid = const Value.absent(),
              }) => SaleReturnItemsCompanion.insert(
                id: id,
                returnId: returnId,
                saleItemId: saleItemId,
                productId: productId,
                quantity: quantity,
                condition: condition,
                restocked: restocked,
                refundAmount: refundAmount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SaleReturnItemsTable, SaleReturnItem>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SaleReturnItemsTable,
                    SaleReturnItem
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SaleReturnItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SaleReturnItemsTable,
      SaleReturnItem,
      $$SaleReturnItemsTableFilterComposer,
      $$SaleReturnItemsTableOrderingComposer,
      $$SaleReturnItemsTableAnnotationComposer,
      $$SaleReturnItemsTableCreateCompanionBuilder,
      $$SaleReturnItemsTableUpdateCompanionBuilder,
      (
        SaleReturnItem,
        BaseReferences<_$AppDatabase, $SaleReturnItemsTable, SaleReturnItem>,
      ),
      SaleReturnItem,
      PrefetchHooks Function()
    >;
typedef $$CashSessionsTableCreateCompanionBuilder =
    CashSessionsCompanion Function({
      required String id,
      required String deviceId,
      required String status,
      required String openingAmount,
      Value<String?> openingNote,
      required DateTime openedAt,
      Value<String?> expectedAmount,
      Value<String?> clientExpectedAmount,
      Value<String?> countedAmount,
      Value<String?> discrepancyAmount,
      Value<String?> closingNote,
      Value<DateTime?> closedAt,
      Value<bool> serverRecalculated,
      Value<String> syncStatus,
      Value<String?> rejectionCode,
      Value<int> rowid,
    });
typedef $$CashSessionsTableUpdateCompanionBuilder =
    CashSessionsCompanion Function({
      Value<String> id,
      Value<String> deviceId,
      Value<String> status,
      Value<String> openingAmount,
      Value<String?> openingNote,
      Value<DateTime> openedAt,
      Value<String?> expectedAmount,
      Value<String?> clientExpectedAmount,
      Value<String?> countedAmount,
      Value<String?> discrepancyAmount,
      Value<String?> closingNote,
      Value<DateTime?> closedAt,
      Value<bool> serverRecalculated,
      Value<String> syncStatus,
      Value<String?> rejectionCode,
      Value<int> rowid,
    });

class $$CashSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $CashSessionsTable> {
  $$CashSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get openingAmount => $composableBuilder(
    column: $table.openingAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get openingNote => $composableBuilder(
    column: $table.openingNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expectedAmount => $composableBuilder(
    column: $table.expectedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientExpectedAmount => $composableBuilder(
    column: $table.clientExpectedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get countedAmount => $composableBuilder(
    column: $table.countedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discrepancyAmount => $composableBuilder(
    column: $table.discrepancyAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get closingNote => $composableBuilder(
    column: $table.closingNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get serverRecalculated => $composableBuilder(
    column: $table.serverRecalculated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rejectionCode => $composableBuilder(
    column: $table.rejectionCode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CashSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CashSessionsTable> {
  $$CashSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get openingAmount => $composableBuilder(
    column: $table.openingAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get openingNote => $composableBuilder(
    column: $table.openingNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expectedAmount => $composableBuilder(
    column: $table.expectedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientExpectedAmount => $composableBuilder(
    column: $table.clientExpectedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get countedAmount => $composableBuilder(
    column: $table.countedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discrepancyAmount => $composableBuilder(
    column: $table.discrepancyAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get closingNote => $composableBuilder(
    column: $table.closingNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get serverRecalculated => $composableBuilder(
    column: $table.serverRecalculated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rejectionCode => $composableBuilder(
    column: $table.rejectionCode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CashSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashSessionsTable> {
  $$CashSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get openingAmount => $composableBuilder(
    column: $table.openingAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get openingNote => $composableBuilder(
    column: $table.openingNote,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);

  GeneratedColumn<String> get expectedAmount => $composableBuilder(
    column: $table.expectedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientExpectedAmount => $composableBuilder(
    column: $table.clientExpectedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get countedAmount => $composableBuilder(
    column: $table.countedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get discrepancyAmount => $composableBuilder(
    column: $table.discrepancyAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get closingNote => $composableBuilder(
    column: $table.closingNote,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<bool> get serverRecalculated => $composableBuilder(
    column: $table.serverRecalculated,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rejectionCode => $composableBuilder(
    column: $table.rejectionCode,
    builder: (column) => column,
  );
}

class $$CashSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CashSessionsTable,
          CashSession,
          $$CashSessionsTableFilterComposer,
          $$CashSessionsTableOrderingComposer,
          $$CashSessionsTableAnnotationComposer,
          $$CashSessionsTableCreateCompanionBuilder,
          $$CashSessionsTableUpdateCompanionBuilder,
          (
            CashSession,
            BaseReferences<_$AppDatabase, $CashSessionsTable, CashSession>,
          ),
          CashSession,
          PrefetchHooks Function()
        > {
  $$CashSessionsTableTableManager(_$AppDatabase db, $CashSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> openingAmount = const Value.absent(),
                Value<String?> openingNote = const Value.absent(),
                Value<DateTime> openedAt = const Value.absent(),
                Value<String?> expectedAmount = const Value.absent(),
                Value<String?> clientExpectedAmount = const Value.absent(),
                Value<String?> countedAmount = const Value.absent(),
                Value<String?> discrepancyAmount = const Value.absent(),
                Value<String?> closingNote = const Value.absent(),
                Value<DateTime?> closedAt = const Value.absent(),
                Value<bool> serverRecalculated = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> rejectionCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CashSessionsCompanion(
                id: id,
                deviceId: deviceId,
                status: status,
                openingAmount: openingAmount,
                openingNote: openingNote,
                openedAt: openedAt,
                expectedAmount: expectedAmount,
                clientExpectedAmount: clientExpectedAmount,
                countedAmount: countedAmount,
                discrepancyAmount: discrepancyAmount,
                closingNote: closingNote,
                closedAt: closedAt,
                serverRecalculated: serverRecalculated,
                syncStatus: syncStatus,
                rejectionCode: rejectionCode,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String deviceId,
                required String status,
                required String openingAmount,
                Value<String?> openingNote = const Value.absent(),
                required DateTime openedAt,
                Value<String?> expectedAmount = const Value.absent(),
                Value<String?> clientExpectedAmount = const Value.absent(),
                Value<String?> countedAmount = const Value.absent(),
                Value<String?> discrepancyAmount = const Value.absent(),
                Value<String?> closingNote = const Value.absent(),
                Value<DateTime?> closedAt = const Value.absent(),
                Value<bool> serverRecalculated = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> rejectionCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CashSessionsCompanion.insert(
                id: id,
                deviceId: deviceId,
                status: status,
                openingAmount: openingAmount,
                openingNote: openingNote,
                openedAt: openedAt,
                expectedAmount: expectedAmount,
                clientExpectedAmount: clientExpectedAmount,
                countedAmount: countedAmount,
                discrepancyAmount: discrepancyAmount,
                closingNote: closingNote,
                closedAt: closedAt,
                serverRecalculated: serverRecalculated,
                syncStatus: syncStatus,
                rejectionCode: rejectionCode,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CashSessionsTable, CashSession>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CashSessionsTable,
                    CashSession
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CashSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CashSessionsTable,
      CashSession,
      $$CashSessionsTableFilterComposer,
      $$CashSessionsTableOrderingComposer,
      $$CashSessionsTableAnnotationComposer,
      $$CashSessionsTableCreateCompanionBuilder,
      $$CashSessionsTableUpdateCompanionBuilder,
      (
        CashSession,
        BaseReferences<_$AppDatabase, $CashSessionsTable, CashSession>,
      ),
      CashSession,
      PrefetchHooks Function()
    >;
typedef $$CashMovementsTableCreateCompanionBuilder =
    CashMovementsCompanion Function({
      required String id,
      required String sessionId,
      required String type,
      required String reason,
      required String amount,
      Value<String?> note,
      required DateTime createdAt,
      required String syncStatus,
      Value<String?> rejectionCode,
      Value<int> rowid,
    });
typedef $$CashMovementsTableUpdateCompanionBuilder =
    CashMovementsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> type,
      Value<String> reason,
      Value<String> amount,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<String> syncStatus,
      Value<String?> rejectionCode,
      Value<int> rowid,
    });

class $$CashMovementsTableFilterComposer
    extends Composer<_$AppDatabase, $CashMovementsTable> {
  $$CashMovementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rejectionCode => $composableBuilder(
    column: $table.rejectionCode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CashMovementsTableOrderingComposer
    extends Composer<_$AppDatabase, $CashMovementsTable> {
  $$CashMovementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rejectionCode => $composableBuilder(
    column: $table.rejectionCode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CashMovementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashMovementsTable> {
  $$CashMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rejectionCode => $composableBuilder(
    column: $table.rejectionCode,
    builder: (column) => column,
  );
}

class $$CashMovementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CashMovementsTable,
          CashMovement,
          $$CashMovementsTableFilterComposer,
          $$CashMovementsTableOrderingComposer,
          $$CashMovementsTableAnnotationComposer,
          $$CashMovementsTableCreateCompanionBuilder,
          $$CashMovementsTableUpdateCompanionBuilder,
          (
            CashMovement,
            BaseReferences<_$AppDatabase, $CashMovementsTable, CashMovement>,
          ),
          CashMovement,
          PrefetchHooks Function()
        > {
  $$CashMovementsTableTableManager(_$AppDatabase db, $CashMovementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashMovementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashMovementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String> amount = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> rejectionCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CashMovementsCompanion(
                id: id,
                sessionId: sessionId,
                type: type,
                reason: reason,
                amount: amount,
                note: note,
                createdAt: createdAt,
                syncStatus: syncStatus,
                rejectionCode: rejectionCode,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String type,
                required String reason,
                required String amount,
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                required String syncStatus,
                Value<String?> rejectionCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CashMovementsCompanion.insert(
                id: id,
                sessionId: sessionId,
                type: type,
                reason: reason,
                amount: amount,
                note: note,
                createdAt: createdAt,
                syncStatus: syncStatus,
                rejectionCode: rejectionCode,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CashMovementsTable, CashMovement>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CashMovementsTable,
                    CashMovement
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CashMovementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CashMovementsTable,
      CashMovement,
      $$CashMovementsTableFilterComposer,
      $$CashMovementsTableOrderingComposer,
      $$CashMovementsTableAnnotationComposer,
      $$CashMovementsTableCreateCompanionBuilder,
      $$CashMovementsTableUpdateCompanionBuilder,
      (
        CashMovement,
        BaseReferences<_$AppDatabase, $CashMovementsTable, CashMovement>,
      ),
      CashMovement,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      required String entityType,
      required String entityId,
      required String payload,
      Value<String> status,
      Value<int> retryCount,
      Value<String?> lastError,
      required DateTime createdAt,
      Value<DateTime?> lastAttemptAt,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> payload,
      Value<String> status,
      Value<int> retryCount,
      Value<String?> lastError,
      Value<DateTime> createdAt,
      Value<DateTime?> lastAttemptAt,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
    column: $table.lastAttemptAt,
    builder: (column) => column,
  );
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastAttemptAt = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                payload: payload,
                status: status,
                retryCount: retryCount,
                lastError: lastError,
                createdAt: createdAt,
                lastAttemptAt: lastAttemptAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityType,
                required String entityId,
                required String payload,
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> lastAttemptAt = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                payload: payload,
                status: status,
                retryCount: retryCount,
                lastError: lastError,
                createdAt: createdAt,
                lastAttemptAt: lastAttemptAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncQueueTable, SyncQueueData>(table),
                  BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$SyncMetadataTableCreateCompanionBuilder =
    SyncMetadataCompanion Function({
      required String key,
      required String value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$SyncMetadataTableUpdateCompanionBuilder =
    SyncMetadataCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SyncMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetadataTable,
          SyncMetadataData,
          $$SyncMetadataTableFilterComposer,
          $$SyncMetadataTableOrderingComposer,
          $$SyncMetadataTableAnnotationComposer,
          $$SyncMetadataTableCreateCompanionBuilder,
          $$SyncMetadataTableUpdateCompanionBuilder,
          (
            SyncMetadataData,
            BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>,
          ),
          SyncMetadataData,
          PrefetchHooks Function()
        > {
  $$SyncMetadataTableTableManager(_$AppDatabase db, $SyncMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncMetadataTable, SyncMetadataData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SyncMetadataTable,
                    SyncMetadataData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetadataTable,
      SyncMetadataData,
      $$SyncMetadataTableFilterComposer,
      $$SyncMetadataTableOrderingComposer,
      $$SyncMetadataTableAnnotationComposer,
      $$SyncMetadataTableCreateCompanionBuilder,
      $$SyncMetadataTableUpdateCompanionBuilder,
      (
        SyncMetadataData,
        BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>,
      ),
      SyncMetadataData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleItemsTableTableManager get saleItems =>
      $$SaleItemsTableTableManager(_db, _db.saleItems);
  $$SaleReturnsTableTableManager get saleReturns =>
      $$SaleReturnsTableTableManager(_db, _db.saleReturns);
  $$SaleReturnItemsTableTableManager get saleReturnItems =>
      $$SaleReturnItemsTableTableManager(_db, _db.saleReturnItems);
  $$CashSessionsTableTableManager get cashSessions =>
      $$CashSessionsTableTableManager(_db, _db.cashSessions);
  $$CashMovementsTableTableManager get cashMovements =>
      $$CashMovementsTableTableManager(_db, _db.cashMovements);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db, _db.syncMetadata);
}
