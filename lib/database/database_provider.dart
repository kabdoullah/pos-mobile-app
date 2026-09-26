import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_database.dart';

part 'database_provider.g.dart';

/// Fournit l'instance de la base de l'app (singleton, jamais libérée).
@Riverpod(keepAlive: true)
AppDatabase database(Ref ref) {
  return AppDatabase();
}
