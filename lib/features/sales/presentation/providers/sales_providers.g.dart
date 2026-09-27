// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Enregistre le panier courant (lignes et remise globale) comme vente
/// (appelle CreateSaleUseCase).

@ProviderFor(submitSale)
final submitSaleProvider = SubmitSaleFamily._();

/// Enregistre le panier courant (lignes et remise globale) comme vente
/// (appelle CreateSaleUseCase).

final class SubmitSaleProvider
    extends
        $FunctionalProvider<
          AsyncValue<sale_entity.Sale>,
          sale_entity.Sale,
          FutureOr<sale_entity.Sale>
        >
    with $FutureModifier<sale_entity.Sale>, $FutureProvider<sale_entity.Sale> {
  /// Enregistre le panier courant (lignes et remise globale) comme vente
  /// (appelle CreateSaleUseCase).
  SubmitSaleProvider._({
    required SubmitSaleFamily super.from,
    required ({
      Decimal totalAmount,
      Decimal vatAmount,
      sale_entity.PaymentMethod paymentMethod,
      Decimal? cashAmount,
      Decimal? mobileMoneyAmount,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'submitSaleProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$submitSaleHash();

  @override
  String toString() {
    return r'submitSaleProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<sale_entity.Sale> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<sale_entity.Sale> create(Ref ref) {
    final argument =
        this.argument
            as ({
              Decimal totalAmount,
              Decimal vatAmount,
              sale_entity.PaymentMethod paymentMethod,
              Decimal? cashAmount,
              Decimal? mobileMoneyAmount,
            });
    return submitSale(
      ref,
      totalAmount: argument.totalAmount,
      vatAmount: argument.vatAmount,
      paymentMethod: argument.paymentMethod,
      cashAmount: argument.cashAmount,
      mobileMoneyAmount: argument.mobileMoneyAmount,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SubmitSaleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$submitSaleHash() => r'233091f9689c49a6ef30ae28d92bcc7ee9cab86f';

/// Enregistre le panier courant (lignes et remise globale) comme vente
/// (appelle CreateSaleUseCase).

final class SubmitSaleFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<sale_entity.Sale>,
          ({
            Decimal totalAmount,
            Decimal vatAmount,
            sale_entity.PaymentMethod paymentMethod,
            Decimal? cashAmount,
            Decimal? mobileMoneyAmount,
          })
        > {
  SubmitSaleFamily._()
    : super(
        retry: null,
        name: r'submitSaleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Enregistre le panier courant (lignes et remise globale) comme vente
  /// (appelle CreateSaleUseCase).

  SubmitSaleProvider call({
    required Decimal totalAmount,
    required Decimal vatAmount,
    required sale_entity.PaymentMethod paymentMethod,
    Decimal? cashAmount,
    Decimal? mobileMoneyAmount,
  }) => SubmitSaleProvider._(
    argument: (
      totalAmount: totalAmount,
      vatAmount: vatAmount,
      paymentMethod: paymentMethod,
      cashAmount: cashAmount,
      mobileMoneyAmount: mobileMoneyAmount,
    ),
    from: this,
  );

  @override
  String toString() => r'submitSaleProvider';
}

/// Observe les ventes d'une plage de dates (incluse) — réémet à chaque
/// changement drift.

@ProviderFor(salesHistory)
final salesHistoryProvider = SalesHistoryFamily._();

/// Observe les ventes d'une plage de dates (incluse) — réémet à chaque
/// changement drift.

final class SalesHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<sale_entity.Sale>>,
          List<sale_entity.Sale>,
          Stream<List<sale_entity.Sale>>
        >
    with
        $FutureModifier<List<sale_entity.Sale>>,
        $StreamProvider<List<sale_entity.Sale>> {
  /// Observe les ventes d'une plage de dates (incluse) — réémet à chaque
  /// changement drift.
  SalesHistoryProvider._({
    required SalesHistoryFamily super.from,
    required ({DateTime startDate, DateTime endDate}) super.argument,
  }) : super(
         retry: null,
         name: r'salesHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$salesHistoryHash();

  @override
  String toString() {
    return r'salesHistoryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<sale_entity.Sale>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<sale_entity.Sale>> create(Ref ref) {
    final argument = this.argument as ({DateTime startDate, DateTime endDate});
    return salesHistory(
      ref,
      startDate: argument.startDate,
      endDate: argument.endDate,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SalesHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$salesHistoryHash() => r'7887999f1aca8cf01b6b360163ef81cedb73826d';

/// Observe les ventes d'une plage de dates (incluse) — réémet à chaque
/// changement drift.

final class SalesHistoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<sale_entity.Sale>>,
          ({DateTime startDate, DateTime endDate})
        > {
  SalesHistoryFamily._()
    : super(
        retry: null,
        name: r'salesHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Observe les ventes d'une plage de dates (incluse) — réémet à chaque
  /// changement drift.

  SalesHistoryProvider call({
    required DateTime startDate,
    required DateTime endDate,
  }) => SalesHistoryProvider._(
    argument: (startDate: startDate, endDate: endDate),
    from: this,
  );

  @override
  String toString() => r'salesHistoryProvider';
}

/// Observe une vente — permet aux écrans ouverts d'afficher le numéro de reçu
/// dès que la synchro l'attribue.

@ProviderFor(saleById)
final saleByIdProvider = SaleByIdFamily._();

/// Observe une vente — permet aux écrans ouverts d'afficher le numéro de reçu
/// dès que la synchro l'attribue.

final class SaleByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<sale_entity.Sale?>,
          sale_entity.Sale?,
          Stream<sale_entity.Sale?>
        >
    with
        $FutureModifier<sale_entity.Sale?>,
        $StreamProvider<sale_entity.Sale?> {
  /// Observe une vente — permet aux écrans ouverts d'afficher le numéro de reçu
  /// dès que la synchro l'attribue.
  SaleByIdProvider._({
    required SaleByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'saleByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$saleByIdHash();

  @override
  String toString() {
    return r'saleByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<sale_entity.Sale?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<sale_entity.Sale?> create(Ref ref) {
    final argument = this.argument as String;
    return saleById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SaleByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$saleByIdHash() => r'61bd70a933b0bb7b8a72ea720bf2df507b8e5017';

/// Observe une vente — permet aux écrans ouverts d'afficher le numéro de reçu
/// dès que la synchro l'attribue.

final class SaleByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<sale_entity.Sale?>, String> {
  SaleByIdFamily._()
    : super(
        retry: null,
        name: r'saleByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Observe une vente — permet aux écrans ouverts d'afficher le numéro de reçu
  /// dès que la synchro l'attribue.

  SaleByIdProvider call(String id) =>
      SaleByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'saleByIdProvider';
}

/// Observe les lignes d'une vente (vide si la vente vient du serveur).

@ProviderFor(saleItems)
final saleItemsProvider = SaleItemsFamily._();

/// Observe les lignes d'une vente (vide si la vente vient du serveur).

final class SaleItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CartItem>>,
          List<CartItem>,
          Stream<List<CartItem>>
        >
    with $FutureModifier<List<CartItem>>, $StreamProvider<List<CartItem>> {
  /// Observe les lignes d'une vente (vide si la vente vient du serveur).
  SaleItemsProvider._({
    required SaleItemsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'saleItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$saleItemsHash();

  @override
  String toString() {
    return r'saleItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<CartItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CartItem>> create(Ref ref) {
    final argument = this.argument as String;
    return saleItems(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SaleItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$saleItemsHash() => r'8a8df4bb849c483153a38bd8aa099aa581b8382e';

/// Observe les lignes d'une vente (vide si la vente vient du serveur).

final class SaleItemsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<CartItem>>, String> {
  SaleItemsFamily._()
    : super(
        retry: null,
        name: r'saleItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Observe les lignes d'une vente (vide si la vente vient du serveur).

  SaleItemsProvider call(String saleId) =>
      SaleItemsProvider._(argument: saleId, from: this);

  @override
  String toString() => r'saleItemsProvider';
}

/// Télécharge le reçu PDF d'une vente.

@ProviderFor(downloadSaleReceiptPdf)
final downloadSaleReceiptPdfProvider = DownloadSaleReceiptPdfFamily._();

/// Télécharge le reçu PDF d'une vente.

final class DownloadSaleReceiptPdfProvider
    extends
        $FunctionalProvider<
          AsyncValue<Uint8List>,
          Uint8List,
          FutureOr<Uint8List>
        >
    with $FutureModifier<Uint8List>, $FutureProvider<Uint8List> {
  /// Télécharge le reçu PDF d'une vente.
  DownloadSaleReceiptPdfProvider._({
    required DownloadSaleReceiptPdfFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'downloadSaleReceiptPdfProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$downloadSaleReceiptPdfHash();

  @override
  String toString() {
    return r'downloadSaleReceiptPdfProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Uint8List> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Uint8List> create(Ref ref) {
    final argument = this.argument as String;
    return downloadSaleReceiptPdf(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DownloadSaleReceiptPdfProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$downloadSaleReceiptPdfHash() =>
    r'9fb8bed472356294a08c6e4a18fa9ab88e34baef';

/// Télécharge le reçu PDF d'une vente.

final class DownloadSaleReceiptPdfFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Uint8List>, String> {
  DownloadSaleReceiptPdfFamily._()
    : super(
        retry: null,
        name: r'downloadSaleReceiptPdfProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Télécharge le reçu PDF d'une vente.

  DownloadSaleReceiptPdfProvider call(String saleId) =>
      DownloadSaleReceiptPdfProvider._(argument: saleId, from: this);

  @override
  String toString() => r'downloadSaleReceiptPdfProvider';
}

/// Recherche de produits pour la caisse (nom ou code-barres, catalogue local).
///
/// Distincte de `catalogListProvider` : une recherche en caisse ne filtre pas
/// l'onglet Catalogue.

@ProviderFor(saleProductSearch)
final saleProductSearchProvider = SaleProductSearchFamily._();

/// Recherche de produits pour la caisse (nom ou code-barres, catalogue local).
///
/// Distincte de `catalogListProvider` : une recherche en caisse ne filtre pas
/// l'onglet Catalogue.

final class SaleProductSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  /// Recherche de produits pour la caisse (nom ou code-barres, catalogue local).
  ///
  /// Distincte de `catalogListProvider` : une recherche en caisse ne filtre pas
  /// l'onglet Catalogue.
  SaleProductSearchProvider._({
    required SaleProductSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'saleProductSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$saleProductSearchHash();

  @override
  String toString() {
    return r'saleProductSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    final argument = this.argument as String;
    return saleProductSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SaleProductSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$saleProductSearchHash() => r'135a3cacc5e860180f2919d86c6a359278850a33';

/// Recherche de produits pour la caisse (nom ou code-barres, catalogue local).
///
/// Distincte de `catalogListProvider` : une recherche en caisse ne filtre pas
/// l'onglet Catalogue.

final class SaleProductSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Product>>, String> {
  SaleProductSearchFamily._()
    : super(
        retry: null,
        name: r'saleProductSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Recherche de produits pour la caisse (nom ou code-barres, catalogue local).
  ///
  /// Distincte de `catalogListProvider` : une recherche en caisse ne filtre pas
  /// l'onglet Catalogue.

  SaleProductSearchProvider call(String query) =>
      SaleProductSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'saleProductSearchProvider';
}
