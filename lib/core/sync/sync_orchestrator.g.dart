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

String _$syncOrchestratorHash() => r'bf1b3422d29ed4dff0b17de749f2f2269b7f1a27';

/// Orchestre la synchro bidirectionnelle : surveille la connectivité, déclenche
/// des synchros périodiques et enchaîne l'envoi avant la récupération pour
/// éviter les pertes de données.

abstract class _$SyncOrchestrator extends $Notifier<SyncStatus> {
  SyncStatus build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SyncStatus, SyncStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncStatus, SyncStatus>,
              SyncStatus,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
