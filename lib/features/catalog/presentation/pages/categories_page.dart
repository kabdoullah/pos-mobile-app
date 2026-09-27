import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/category.dart';
import '../providers/category_providers.dart';
import '../widgets/category_name_dialog.dart';

/// Gestion des catégories (ouverte depuis l'onglet Stock) : liste avec le
/// nombre de produits, ajout, renommage et suppression.
class CategoriesPage extends ConsumerWidget {
  /// Crée la page des catégories.
  const CategoriesPage({super.key});

  Future<void> _run(
    BuildContext context,
    Future<void> Function() action,
  ) async {
    try {
      await action();
    } on CategoryNameTakenException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final name = await showCategoryNameDialog(
      context,
      title: 'Nouvelle catégorie',
      confirmLabel: 'Créer',
    );
    if (name == null || !context.mounted) return;
    await _run(
      context,
      () => ref.read(categoryEditorProvider.notifier).create(name),
    );
  }

  Future<void> _rename(
    BuildContext context,
    WidgetRef ref,
    Category category,
  ) async {
    final name = await showCategoryNameDialog(
      context,
      title: 'Renommer',
      initialName: category.name,
    );
    if (name == null || name == category.name || !context.mounted) return;
    await _run(
      context,
      () => ref.read(categoryEditorProvider.notifier).rename(category.id, name),
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Category category,
    int productCount,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Supprimer « ${category.name} » ?',
      message: productCount == 0
          ? 'Cette catégorie ne contient aucun produit.'
          : 'Ses $productCount produit${productCount > 1 ? 's' : ''} '
                'passeront « sans catégorie ». Aucun produit n’est supprimé.',
      confirmLabel: 'Supprimer',
      isDangerous: true,
    );
    if (!confirmed) return;
    await ref.read(categoryEditorProvider.notifier).delete(category.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final categoriesAsync = ref.watch(categoriesProvider);
    final counts =
        ref.watch(categoryProductCountsProvider).value ?? const <String, int>{};

    return AppScaffold(
      title: 'Catégories',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Catégorie'),
      ),
      body: categoriesAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: SkeletonBox(height: 56),
        ),
        error: (_, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Impossible de charger les catégories',
          message: 'Réessayez dans un instant.',
          actionLabel: 'Réessayer',
          onAction: () => ref.invalidate(categoriesProvider),
        ),
        data: (categories) {
          if (categories.isEmpty) {
            return EmptyState(
              icon: Icons.label_outline,
              title: 'Aucune catégorie',
              message: 'Regroupez vos produits : Boissons, Alimentation…',
              actionLabel: 'Ajouter une catégorie',
              onAction: () => _add(context, ref),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: categories.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              indent: AppSpacing.md,
              endIndent: AppSpacing.md,
              color: cs.outlineVariant,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              final count = counts[category.id] ?? 0;
              return ListTile(
                title: Text(category.name, style: AppTypography.titleMedium),
                subtitle: Text(
                  count <= 1 ? '$count produit' : '$count produits',
                ),
                onTap: () => _rename(context, ref, category),
                trailing: IconButton(
                  tooltip: 'Supprimer ${category.name}',
                  icon: Icon(Icons.delete_outline, color: cs.error),
                  onPressed: () => _delete(context, ref, category, count),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
