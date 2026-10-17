// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_orchestrator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Orchestre la synchro bidirectionnelle : surveille la connectivité, déclenche
/// des synchros périodiques et enchaîne l'envoi avant la récupération pour
/// éviter les pertes de données.

@ProviderFor(SyncOrchestrator)
final syncOrchestratorProvider = SyncOrchestratorProvider._();

/// Orchestre la synchro bidirectionnelle : surveille la connectivité, déclenche
/// des synchros périodiques et enchaîne l'envoi avant la récupération pour
/// éviter les pertes de données.
final class SyncOrchestratorProvider
    extends $NotifierProvider<SyncOrchestrator, SyncStatus> {
  /// Orchestre la synchro bidirectionnelle : surveille la connectivité, déclenche
  /// des synchros périodiques et enchaîne l'envoi avant la récupération pour
  /// éviter les pertes de données.
  SyncOrchestratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncOrchestratorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncOrchestratorHash();

  @$internal
  @override
  SyncOrchestrator create() => SyncOrchestrator();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncStatus>(value),
    );
  }
}

String _$syncOrchestratorHash() => r'f4514bb0f1a3860bf45f6539707884f5b18b9346';

/// Orchestre la synchro bidirectionnelle : surveille la connectivité, déclenche
/// des synchros périodiques et enchaîne l'envoi avant la récupération pour
/// éviter les pertes de données.

abstract class _$SyncOrchestrator extends $Notifier<SyncStatus> {
  SyncStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SyncStatus, SyncStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncStatus, SyncStatus>,
              SyncStatus,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
