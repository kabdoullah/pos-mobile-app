import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists whether the user has already seen the Home page spotlight tour.
///
/// `null` means "not yet loaded from storage" — distinct from `false` so the
/// tour never starts before we actually know a returning user has seen it.
class HomeShowcaseNotifier extends Notifier<bool?> {
  static const _key = 'home_showcase_seen';
  static const _storage = FlutterSecureStorage();

  @override
  bool? build() {
    unawaited(_load());
    return null;
  }

  Future<void> _load() async {
    try {
      final value = await _storage.read(key: _key);
      state = value == 'true';
    } catch (_) {}
  }

  /// Marks the tour as seen and persists it. No-op if already marked.
  Future<void> markSeen() async {
    if (state == true) return;
    state = true;
    try {
      await _storage.write(key: _key, value: 'true');
    } catch (_) {}
  }
}

/// Provider for [HomeShowcaseNotifier].
final homeShowcaseSeenProvider = NotifierProvider<HomeShowcaseNotifier, bool?>(
  HomeShowcaseNotifier.new,
);
