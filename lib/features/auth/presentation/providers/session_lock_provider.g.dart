// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_lock_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Verrouille la session après `AppConfig.sessionLockMinutes` minutes sans
/// interaction : repasse en `AuthPinRequired` via [Auth.lock], le routeur
/// ouvre alors l'écran PIN.
///
/// L'activité est signalée par [recordActivity] (chaque toucher, voir
/// `PosMobileApp`). Le temps passé en arrière-plan compte : au retour, l'écart
/// à la dernière activité est comparé à l'horloge, les timers n'étant pas
/// fiables quand l'app est suspendue.

@ProviderFor(SessionLock)
final sessionLockProvider = SessionLockProvider._();

/// Verrouille la session après `AppConfig.sessionLockMinutes` minutes sans
/// interaction : repasse en `AuthPinRequired` via [Auth.lock], le routeur
/// ouvre alors l'écran PIN.
///
/// L'activité est signalée par [recordActivity] (chaque toucher, voir
/// `PosMobileApp`). Le temps passé en arrière-plan compte : au retour, l'écart
/// à la dernière activité est comparé à l'horloge, les timers n'étant pas
/// fiables quand l'app est suspendue.
final class SessionLockProvider extends $NotifierProvider<SessionLock, void> {
  /// Verrouille la session après `AppConfig.sessionLockMinutes` minutes sans
  /// interaction : repasse en `AuthPinRequired` via [Auth.lock], le routeur
  /// ouvre alors l'écran PIN.
  ///
  /// L'activité est signalée par [recordActivity] (chaque toucher, voir
  /// `PosMobileApp`). Le temps passé en arrière-plan compte : au retour, l'écart
  /// à la dernière activité est comparé à l'horloge, les timers n'étant pas
  /// fiables quand l'app est suspendue.
  SessionLockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionLockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionLockHash();

  @$internal
  @override
  SessionLock create() => SessionLock();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$sessionLockHash() => r'b7b0ed886c4ccaf5513fb473e0604310cff90352';

/// Verrouille la session après `AppConfig.sessionLockMinutes` minutes sans
/// interaction : repasse en `AuthPinRequired` via [Auth.lock], le routeur
/// ouvre alors l'écran PIN.
///
/// L'activité est signalée par [recordActivity] (chaque toucher, voir
/// `PosMobileApp`). Le temps passé en arrière-plan compte : au retour, l'écart
/// à la dernière activité est comparé à l'horloge, les timers n'étant pas
/// fiables quand l'app est suspendue.

abstract class _$SessionLock extends $Notifier<void> {
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
