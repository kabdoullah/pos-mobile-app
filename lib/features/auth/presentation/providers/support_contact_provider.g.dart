// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_contact_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Coordonnées du support, lues sur le serveur à l'ouverture des écrans d'aide
/// (mot de passe oublié, lien de réinitialisation invalide).
///
/// autoDispose : relu à chaque ouverture, une config changée côté serveur est
/// visible sans redémarrer l'app.

@ProviderFor(supportContact)
final supportContactProvider = SupportContactProvider._();

/// Coordonnées du support, lues sur le serveur à l'ouverture des écrans d'aide
/// (mot de passe oublié, lien de réinitialisation invalide).
///
/// autoDispose : relu à chaque ouverture, une config changée côté serveur est
/// visible sans redémarrer l'app.

final class SupportContactProvider
    extends
        $FunctionalProvider<
          AsyncValue<SupportContact>,
          SupportContact,
          FutureOr<SupportContact>
        >
    with $FutureModifier<SupportContact>, $FutureProvider<SupportContact> {
  /// Coordonnées du support, lues sur le serveur à l'ouverture des écrans d'aide
  /// (mot de passe oublié, lien de réinitialisation invalide).
  ///
  /// autoDispose : relu à chaque ouverture, une config changée côté serveur est
  /// visible sans redémarrer l'app.
  SupportContactProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supportContactProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supportContactHash();

  @$internal
  @override
  $FutureProviderElement<SupportContact> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SupportContact> create(Ref ref) {
    return supportContact(ref);
  }
}

String _$supportContactHash() => r'734a822202bcc108511ba3f9cc9ea3c65337b347';
