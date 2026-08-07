// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Real-time app connectivity status stream provider.
///
/// Returns true when online, false when offline.
/// Uses connectivity_plus to monitor network changes.

@ProviderFor(isOnline)
final isOnlineProvider = IsOnlineProvider._();

/// Real-time app connectivity status stream provider.
///
/// Returns true when online, false when offline.
/// Uses connectivity_plus to monitor network changes.

final class IsOnlineProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Real-time app connectivity status stream provider.
  ///
  /// Returns true when online, false when offline.
  /// Uses connectivity_plus to monitor network changes.
  IsOnlineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isOnlineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isOnlineHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return isOnline(ref);
  }
}

String _$isOnlineHash() => r'b51b0711d5782024726876ebf7c017ad17cd3916';
