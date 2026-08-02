// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Submit current cart as a sale (calls CreateSaleUseCase).

@ProviderFor(submitSale)
final submitSaleProvider = SubmitSaleFamily._();

/// Submit current cart as a sale (calls CreateSaleUseCase).

final class SubmitSaleProvider
    extends
        $FunctionalProvider<
          AsyncValue<sale_entity.Sale>,
          sale_entity.Sale,
          FutureOr<sale_entity.Sale>
        >
    with $FutureModifier<sale_entity.Sale>, $FutureProvider<sale_entity.Sale> {
  /// Submit current cart as a sale (calls CreateSaleUseCase).
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

String _$submitSaleHash() => r'12a4191801dde3f60aa4934cc19f48d2cfd5646e';

/// Submit current cart as a sale (calls CreateSaleUseCase).

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

  /// Submit current cart as a sale (calls CreateSaleUseCase).

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

/// Watches sales within a date range (inclusive) — re-emits on every drift
/// change.

@ProviderFor(salesHistory)
final salesHistoryProvider = SalesHistoryFamily._();

/// Watches sales within a date range (inclusive) — re-emits on every drift
/// change.

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
  /// Watches sales within a date range (inclusive) — re-emits on every drift
  /// change.
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

/// Watches sales within a date range (inclusive) — re-emits on every drift
/// change.

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

  /// Watches sales within a date range (inclusive) — re-emits on every drift
  /// change.

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
