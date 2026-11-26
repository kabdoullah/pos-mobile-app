// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_catalog_layout_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Affichage choisi sur l'appareil (bouton Liste / Grille de l'en-tête),
/// gardé pour les prochaines ventes. Liste tant que la préférence n'est pas
/// lue.

@ProviderFor(SaleCatalogLayoutPreference)
final saleCatalogLayoutPreferenceProvider =
    SaleCatalogLayoutPreferenceProvider._();

/// Affichage choisi sur l'appareil (bouton Liste / Grille de l'en-tête),
/// gardé pour les prochaines ventes. Liste tant que la préférence n'est pas
/// lue.
final class SaleCatalogLayoutPreferenceProvider
    extends
        $AsyncNotifierProvider<SaleCatalogLayoutPreference, SaleCatalogLayout> {
  /// Affichage choisi sur l'appareil (bouton Liste / Grille de l'en-tête),
  /// gardé pour les prochaines ventes. Liste tant que la préférence n'est pas
  /// lue.
  SaleCatalogLayoutPreferenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saleCatalogLayoutPreferenceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saleCatalogLayoutPreferenceHash();

  @$internal
  @override
  SaleCatalogLayoutPreference create() => SaleCatalogLayoutPreference();
}

String _$saleCatalogLayoutPreferenceHash() =>
    r'6dc0c89ccb1747f8777411bff3abac9ea0d7c07d';

/// Affichage choisi sur l'appareil (bouton Liste / Grille de l'en-tête),
/// gardé pour les prochaines ventes. Liste tant que la préférence n'est pas
/// lue.

abstract class _$SaleCatalogLayoutPreference
    extends $AsyncNotifier<SaleCatalogLayout> {
  FutureOr<SaleCatalogLayout> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<SaleCatalogLayout>, SaleCatalogLayout>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SaleCatalogLayout>, SaleCatalogLayout>,
              AsyncValue<SaleCatalogLayout>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
