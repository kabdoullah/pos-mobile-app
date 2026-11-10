// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_register_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Observe la session de caisse ouverte sur l'appareil, null si aucune.

@ProviderFor(activeCashSession)
final activeCashSessionProvider = ActiveCashSessionProvider._();

/// Observe la session de caisse ouverte sur l'appareil, null si aucune.

final class ActiveCashSessionProvider
    extends
        $FunctionalProvider<
          AsyncValue<CashSession?>,
          CashSession?,
          Stream<CashSession?>
        >
    with $FutureModifier<CashSession?>, $StreamProvider<CashSession?> {
  /// Observe la session de caisse ouverte sur l'appareil, null si aucune.
  ActiveCashSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeCashSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeCashSessionHash();

  @$internal
  @override
  $StreamProviderElement<CashSession?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<CashSession?> create(Ref ref) {
    return activeCashSession(ref);
  }
}

String _$activeCashSessionHash() => r'71692e365d11f38b4280a6bfaebac5fd46b403a1';

/// Observe le récapitulatif du tiroir de la session [sessionId].

@ProviderFor(cashSummary)
final cashSummaryProvider = CashSummaryFamily._();

/// Observe le récapitulatif du tiroir de la session [sessionId].

final class CashSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<CashSummary>,
          CashSummary,
          Stream<CashSummary>
        >
    with $FutureModifier<CashSummary>, $StreamProvider<CashSummary> {
  /// Observe le récapitulatif du tiroir de la session [sessionId].
  CashSummaryProvider._({
    required CashSummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'cashSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cashSummaryHash();

  @override
  String toString() {
    return r'cashSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<CashSummary> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<CashSummary> create(Ref ref) {
    final argument = this.argument as String;
    return cashSummary(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CashSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cashSummaryHash() => r'f40ee8bda077beaca2b3cadfb683e70121e6d0a4';

/// Observe le récapitulatif du tiroir de la session [sessionId].

final class CashSummaryFamily extends $Family
    with $FunctionalFamilyOverride<Stream<CashSummary>, String> {
  CashSummaryFamily._()
    : super(
        retry: null,
        name: r'cashSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Observe le récapitulatif du tiroir de la session [sessionId].

  CashSummaryProvider call(String sessionId) =>
      CashSummaryProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'cashSummaryProvider';
}

/// Observe les mouvements de la session [sessionId], du plus récent au plus
/// ancien.

@ProviderFor(cashMovements)
final cashMovementsProvider = CashMovementsFamily._();

/// Observe les mouvements de la session [sessionId], du plus récent au plus
/// ancien.

final class CashMovementsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CashMovement>>,
          List<CashMovement>,
          Stream<List<CashMovement>>
        >
    with
        $FutureModifier<List<CashMovement>>,
        $StreamProvider<List<CashMovement>> {
  /// Observe les mouvements de la session [sessionId], du plus récent au plus
  /// ancien.
  CashMovementsProvider._({
    required CashMovementsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'cashMovementsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cashMovementsHash();

  @override
  String toString() {
    return r'cashMovementsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<CashMovement>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<CashMovement>> create(Ref ref) {
    final argument = this.argument as String;
    return cashMovements(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CashMovementsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cashMovementsHash() => r'a6351f417528a209e758c90fa7b307e7bf72f691';

/// Observe les mouvements de la session [sessionId], du plus récent au plus
/// ancien.

final class CashMovementsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<CashMovement>>, String> {
  CashMovementsFamily._()
    : super(
        retry: null,
        name: r'cashMovementsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Observe les mouvements de la session [sessionId], du plus récent au plus
  /// ancien.

  CashMovementsProvider call(String sessionId) =>
      CashMovementsProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'cashMovementsProvider';
}

/// Écritures de caisse déclenchées depuis l'UI : ouverture, mouvement,
/// clôture et renvoi d'une clôture avec commentaire.
///
/// `keepAlive` : l'écriture ne doit pas être interrompue par un dispose
/// pendant l'await (voir `SaleSubmission`). Chaque méthode propage la
/// `CashRegisterException` du domaine pour que l'écran affiche le message,
/// puis lance une synchro si l'appareil est en ligne.

@ProviderFor(CashRegisterController)
final cashRegisterControllerProvider = CashRegisterControllerProvider._();

/// Écritures de caisse déclenchées depuis l'UI : ouverture, mouvement,
/// clôture et renvoi d'une clôture avec commentaire.
///
/// `keepAlive` : l'écriture ne doit pas être interrompue par un dispose
/// pendant l'await (voir `SaleSubmission`). Chaque méthode propage la
/// `CashRegisterException` du domaine pour que l'écran affiche le message,
/// puis lance une synchro si l'appareil est en ligne.
final class CashRegisterControllerProvider
    extends $NotifierProvider<CashRegisterController, void> {
  /// Écritures de caisse déclenchées depuis l'UI : ouverture, mouvement,
  /// clôture et renvoi d'une clôture avec commentaire.
  ///
  /// `keepAlive` : l'écriture ne doit pas être interrompue par un dispose
  /// pendant l'await (voir `SaleSubmission`). Chaque méthode propage la
  /// `CashRegisterException` du domaine pour que l'écran affiche le message,
  /// puis lance une synchro si l'appareil est en ligne.
  CashRegisterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cashRegisterControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cashRegisterControllerHash();

  @$internal
  @override
  CashRegisterController create() => CashRegisterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$cashRegisterControllerHash() =>
    r'f6c3f33125bc7a6fe740fb7cf34f49d0e18c9fb0';

/// Écritures de caisse déclenchées depuis l'UI : ouverture, mouvement,
/// clôture et renvoi d'une clôture avec commentaire.
///
/// `keepAlive` : l'écriture ne doit pas être interrompue par un dispose
/// pendant l'await (voir `SaleSubmission`). Chaque méthode propage la
/// `CashRegisterException` du domaine pour que l'écran affiche le message,
/// puis lance une synchro si l'appareil est en ligne.

abstract class _$CashRegisterController extends $Notifier<void> {
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
