// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_required_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Vrai quand l'app doit être mise à jour avant toute utilisation.
///
/// Vérifié au lancement puis à chaque retour au premier plan : d'abord sur
/// le minimum mémorisé (le blocage tient hors ligne), puis sur celui du
/// serveur. Se débloque seul une fois l'app mise à jour (build installé ≥
/// minimum) ou si le serveur abaisse le minimum.

@ProviderFor(UpdateRequired)
final updateRequiredProvider = UpdateRequiredProvider._();

/// Vrai quand l'app doit être mise à jour avant toute utilisation.
///
/// Vérifié au lancement puis à chaque retour au premier plan : d'abord sur
/// le minimum mémorisé (le blocage tient hors ligne), puis sur celui du
/// serveur. Se débloque seul une fois l'app mise à jour (build installé ≥
/// minimum) ou si le serveur abaisse le minimum.
final class UpdateRequiredProvider
    extends $NotifierProvider<UpdateRequired, bool> {
  /// Vrai quand l'app doit être mise à jour avant toute utilisation.
  ///
  /// Vérifié au lancement puis à chaque retour au premier plan : d'abord sur
  /// le minimum mémorisé (le blocage tient hors ligne), puis sur celui du
  /// serveur. Se débloque seul une fois l'app mise à jour (build installé ≥
  /// minimum) ou si le serveur abaisse le minimum.
  UpdateRequiredProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateRequiredProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateRequiredHash();

  @$internal
  @override
  UpdateRequired create() => UpdateRequired();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$updateRequiredHash() => r'431745355bc108b0e60cf54f6e7ad57c2861d2e7';

/// Vrai quand l'app doit être mise à jour avant toute utilisation.
///
/// Vérifié au lancement puis à chaque retour au premier plan : d'abord sur
/// le minimum mémorisé (le blocage tient hors ligne), puis sur celui du
/// serveur. Se débloque seul une fois l'app mise à jour (build installé ≥
/// minimum) ou si le serveur abaisse le minimum.

abstract class _$UpdateRequired extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
