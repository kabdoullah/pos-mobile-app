import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../providers/sales_di_providers.dart';

part 'sale_catalog_layout_provider.g.dart';

/// Affichage du catalogue de l'écran Vendre.
enum SaleCatalogLayout {
  /// Lignes pleine largeur (par défaut).
  list,

  /// Tuiles avec photo, 3 colonnes ou plus.
  grid,
}

/// Affichage choisi sur l'appareil (bouton Liste / Grille de l'en-tête),
/// gardé pour les prochaines ventes. Liste tant que la préférence n'est pas
/// lue.
@Riverpod(keepAlive: true)
class SaleCatalogLayoutPreference extends _$SaleCatalogLayoutPreference {
  @override
  Future<SaleCatalogLayout> build() async {
    final grid = await ref.read(saleCatalogLayoutStorageProvider).readGrid();
    return grid ? SaleCatalogLayout.grid : SaleCatalogLayout.list;
  }

  /// Applique [layout] tout de suite, puis l'enregistre.
  Future<void> set(SaleCatalogLayout layout) async {
    state = AsyncData(layout);
    await ref
        .read(saleCatalogLayoutStorageProvider)
        .writeGrid(layout == SaleCatalogLayout.grid);
  }
}
