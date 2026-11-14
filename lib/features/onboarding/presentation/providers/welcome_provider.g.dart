// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'welcome_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// True si le compte connecté vient de s'inscrire et n'a pas encore vu
/// l'accueil « boutique prête ». Lu par l'Accueil, qui ouvre alors
/// `WelcomePage` une fois.

@ProviderFor(welcomePending)
final welcomePendingProvider = WelcomePendingProvider._();

/// True si le compte connecté vient de s'inscrire et n'a pas encore vu
/// l'accueil « boutique prête ». Lu par l'Accueil, qui ouvre alors
/// `WelcomePage` une fois.

final class WelcomePendingProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// True si le compte connecté vient de s'inscrire et n'a pas encore vu
  /// l'accueil « boutique prête ». Lu par l'Accueil, qui ouvre alors
  /// `WelcomePage` une fois.
  WelcomePendingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'welcomePendingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$welcomePendingHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return welcomePending(ref);
  }
}

String _$welcomePendingHash() => r'1de0c9e0488365560918562a40ec246306ecae43';
