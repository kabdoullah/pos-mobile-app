import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

/// Provider de flux de l'état de connectivité de l'app en temps réel.
///
/// Retourne true en ligne, false hors ligne. Utilise connectivity_plus pour
/// surveiller les changements de réseau.
@Riverpod(keepAlive: true)
Stream<bool> isOnline(Ref ref) async* {
  final connectivity = Connectivity();

  // Émet l'état initial.
  final initial = await connectivity.checkConnectivity();
  yield _isConnected(initial);

  // Diffuse les changements.
  yield* connectivity.onConnectivityChanged.map(_isConnected);
}

bool _isConnected(List<ConnectivityResult> results) =>
    results.any((r) => r != ConnectivityResult.none);
