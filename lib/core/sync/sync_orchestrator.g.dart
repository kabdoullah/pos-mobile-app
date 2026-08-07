// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_orchestrator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Orchestrates bidirectional sync: monitors connectivity, triggers periodic syncs,
/// and coordinates push-before-pull sequencing to prevent data loss.

@ProviderFor(SyncOrchestrator)
final syncOrchestratorProvider = SyncOrchestratorProvider._();

/// Orchestrates bidirectional sync: monitors connectivity, triggers periodic syncs,
/// and coordinates push-before-pull sequencing to prevent data loss.
final class SyncOrchestratorProvider
    extends $NotifierProvider<SyncOrchestrator, SyncStatus> {
  /// Orchestrates bidirectional sync: monitors connectivity, triggers periodic syncs,
  /// and coordinates push-before-pull sequencing to prevent data loss.
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

String _$syncOrchestratorHash() => r'f1be16c43c74d582fc2e8a6b394a2ba021f271cd';

/// Orchestrates bidirectional sync: monitors connectivity, triggers periodic syncs,
/// and coordinates push-before-pull sequencing to prevent data loss.

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
