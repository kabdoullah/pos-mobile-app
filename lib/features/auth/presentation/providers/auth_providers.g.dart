// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages authentication state and actions (login, register, PIN setup/verify, logout).
///
/// State is `AsyncValue<AuthStatus>`:
/// - `AsyncLoading`: operation in progress (init, login, register, PIN verify, etc.)
/// - `AsyncData(status)`: operation succeeded, user is in `status`
/// - `AsyncError(exception)`: operation failed, exception is user-friendly message (see [_toUserFacingException])
///
/// Init sequence: On app launch, `build()` checks secure storage for tokens + PIN config, then routes accordingly.
/// Token expiry is handled via [authExpiredControllerProvider] stream — when server invalidates token,
/// this notifier transitions to `Unauthenticated`, router detects change and redirects to login.

@ProviderFor(Auth)
final authProvider = AuthProvider._();

/// Manages authentication state and actions (login, register, PIN setup/verify, logout).
///
/// State is `AsyncValue<AuthStatus>`:
/// - `AsyncLoading`: operation in progress (init, login, register, PIN verify, etc.)
/// - `AsyncData(status)`: operation succeeded, user is in `status`
/// - `AsyncError(exception)`: operation failed, exception is user-friendly message (see [_toUserFacingException])
///
/// Init sequence: On app launch, `build()` checks secure storage for tokens + PIN config, then routes accordingly.
/// Token expiry is handled via [authExpiredControllerProvider] stream — when server invalidates token,
/// this notifier transitions to `Unauthenticated`, router detects change and redirects to login.
final class AuthProvider extends $AsyncNotifierProvider<Auth, AuthStatus> {
  /// Manages authentication state and actions (login, register, PIN setup/verify, logout).
  ///
  /// State is `AsyncValue<AuthStatus>`:
  /// - `AsyncLoading`: operation in progress (init, login, register, PIN verify, etc.)
  /// - `AsyncData(status)`: operation succeeded, user is in `status`
  /// - `AsyncError(exception)`: operation failed, exception is user-friendly message (see [_toUserFacingException])
  ///
  /// Init sequence: On app launch, `build()` checks secure storage for tokens + PIN config, then routes accordingly.
  /// Token expiry is handled via [authExpiredControllerProvider] stream — when server invalidates token,
  /// this notifier transitions to `Unauthenticated`, router detects change and redirects to login.
  AuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authHash();

  @$internal
  @override
  Auth create() => Auth();
}

String _$authHash() => r'a0ecd49ed01fab563c0b62f1bd6499ab66306757';

/// Manages authentication state and actions (login, register, PIN setup/verify, logout).
///
/// State is `AsyncValue<AuthStatus>`:
/// - `AsyncLoading`: operation in progress (init, login, register, PIN verify, etc.)
/// - `AsyncData(status)`: operation succeeded, user is in `status`
/// - `AsyncError(exception)`: operation failed, exception is user-friendly message (see [_toUserFacingException])
///
/// Init sequence: On app launch, `build()` checks secure storage for tokens + PIN config, then routes accordingly.
/// Token expiry is handled via [authExpiredControllerProvider] stream — when server invalidates token,
/// this notifier transitions to `Unauthenticated`, router detects change and redirects to login.

abstract class _$Auth extends $AsyncNotifier<AuthStatus> {
  FutureOr<AuthStatus> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AuthStatus>, AuthStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthStatus>, AuthStatus>,
              AsyncValue<AuthStatus>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
