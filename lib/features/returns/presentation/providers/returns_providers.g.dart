// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'returns_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Lignes de [sale] avec leurs quantités déjà rendues (drift, en direct).

@ProviderFor(returnableLines)
final returnableLinesProvider = ReturnableLinesFamily._();

/// Lignes de [sale] avec leurs quantités déjà rendues (drift, en direct).

final class ReturnableLinesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ReturnableLine>>,
          List<ReturnableLine>,
          Stream<List<ReturnableLine>>
        >
    with
        $FutureModifier<List<ReturnableLine>>,
        $StreamProvider<List<ReturnableLine>> {
  /// Lignes de [sale] avec leurs quantités déjà rendues (drift, en direct).
  ReturnableLinesProvider._({
    required ReturnableLinesFamily super.from,
    required Sale super.argument,
  }) : super(
         retry: null,
         name: r'returnableLinesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$returnableLinesHash();

  @override
  String toString() {
    return r'returnableLinesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ReturnableLine>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ReturnableLine>> create(Ref ref) {
    final argument = this.argument as Sale;
    return returnableLines(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ReturnableLinesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$returnableLinesHash() => r'fd6d869d81f37bea3ecf7d845d75f6c227dbbc0b';

/// Lignes de [sale] avec leurs quantités déjà rendues (drift, en direct).

final class ReturnableLinesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ReturnableLine>>, Sale> {
  ReturnableLinesFamily._()
    : super(
        retry: null,
        name: r'returnableLinesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Lignes de [sale] avec leurs quantités déjà rendues (drift, en direct).

  ReturnableLinesProvider call(Sale sale) =>
      ReturnableLinesProvider._(argument: sale, from: this);

  @override
  String toString() => r'returnableLinesProvider';
}

/// Retours d'une vente (drift, en direct).

@ProviderFor(saleReturns)
final saleReturnsProvider = SaleReturnsFamily._();

/// Retours d'une vente (drift, en direct).

final class SaleReturnsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SaleReturn>>,
          List<SaleReturn>,
          Stream<List<SaleReturn>>
        >
    with $FutureModifier<List<SaleReturn>>, $StreamProvider<List<SaleReturn>> {
  /// Retours d'une vente (drift, en direct).
  SaleReturnsProvider._({
    required SaleReturnsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'saleReturnsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$saleReturnsHash();

  @override
  String toString() {
    return r'saleReturnsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<SaleReturn>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SaleReturn>> create(Ref ref) {
    final argument = this.argument as String;
    return saleReturns(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SaleReturnsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$saleReturnsHash() => r'9c6cbca36b8b7740e2a942776330ccf999ee1f90';

/// Retours d'une vente (drift, en direct).

final class SaleReturnsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<SaleReturn>>, String> {
  SaleReturnsFamily._()
    : super(
        retry: null,
        name: r'saleReturnsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Retours d'une vente (drift, en direct).

  SaleReturnsProvider call(String saleId) =>
      SaleReturnsProvider._(argument: saleId, from: this);

  @override
  String toString() => r'saleReturnsProvider';
}

/// Saisie de l'écran de retour d'une vente ; libérée en quittant l'écran.

@ProviderFor(ReturnDraft)
final returnDraftProvider = ReturnDraftFamily._();

/// Saisie de l'écran de retour d'une vente ; libérée en quittant l'écran.
final class ReturnDraftProvider
    extends $NotifierProvider<ReturnDraft, ReturnDraftState> {
  /// Saisie de l'écran de retour d'une vente ; libérée en quittant l'écran.
  ReturnDraftProvider._({
    required ReturnDraftFamily super.from,
    required Sale super.argument,
  }) : super(
         retry: null,
         name: r'returnDraftProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$returnDraftHash();

  @override
  String toString() {
    return r'returnDraftProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ReturnDraft create() => ReturnDraft();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReturnDraftState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReturnDraftState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ReturnDraftProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$returnDraftHash() => r'939ac8d5f8a2de7f6714e12971d09b194fb701d3';

/// Saisie de l'écran de retour d'une vente ; libérée en quittant l'écran.

final class ReturnDraftFamily extends $Family
    with
        $ClassFamilyOverride<
          ReturnDraft,
          ReturnDraftState,
          ReturnDraftState,
          ReturnDraftState,
          Sale
        > {
  ReturnDraftFamily._()
    : super(
        retry: null,
        name: r'returnDraftProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Saisie de l'écran de retour d'une vente ; libérée en quittant l'écran.

  ReturnDraftProvider call(Sale sale) =>
      ReturnDraftProvider._(argument: sale, from: this);

  @override
  String toString() => r'returnDraftProvider';
}

/// Saisie de l'écran de retour d'une vente ; libérée en quittant l'écran.

abstract class _$ReturnDraft extends $Notifier<ReturnDraftState> {
  late final _$args = ref.$arg as Sale;
  Sale get sale => _$args;

  ReturnDraftState build(Sale sale);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ReturnDraftState, ReturnDraftState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReturnDraftState, ReturnDraftState>,
              ReturnDraftState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Enregistre un retour.
///
/// Maintenu en vie volontairement (voir `StockAdjustment`) : l'écran peut être
/// quitté pendant l'écriture ; un provider auto-dispose échouerait alors sur un
/// retour pourtant enregistré.

@ProviderFor(SaleReturnSubmission)
final saleReturnSubmissionProvider = SaleReturnSubmissionProvider._();

/// Enregistre un retour.
///
/// Maintenu en vie volontairement (voir `StockAdjustment`) : l'écran peut être
/// quitté pendant l'écriture ; un provider auto-dispose échouerait alors sur un
/// retour pourtant enregistré.
final class SaleReturnSubmissionProvider
    extends $NotifierProvider<SaleReturnSubmission, void> {
  /// Enregistre un retour.
  ///
  /// Maintenu en vie volontairement (voir `StockAdjustment`) : l'écran peut être
  /// quitté pendant l'écriture ; un provider auto-dispose échouerait alors sur un
  /// retour pourtant enregistré.
  SaleReturnSubmissionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saleReturnSubmissionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saleReturnSubmissionHash();

  @$internal
  @override
  SaleReturnSubmission create() => SaleReturnSubmission();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$saleReturnSubmissionHash() =>
    r'eb8d368df4d6a59f0af9f44edba4557fef712c01';

/// Enregistre un retour.
///
/// Maintenu en vie volontairement (voir `StockAdjustment`) : l'écran peut être
/// quitté pendant l'écriture ; un provider auto-dispose échouerait alors sur un
/// retour pourtant enregistré.

abstract class _$SaleReturnSubmission extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
