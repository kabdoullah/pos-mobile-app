import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/category.dart';
import '../providers/category_providers.dart';
import '../widgets/category_name_dialog.dart';

/// Gestion des catégories (menu de l'onglet Stock) : liste à plat avec le
/// nombre de produits ; « Modifier » renomme ou supprime, impact annoncé.
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

  /// « Modifier » : renommer ou supprimer (suppression confirmée).
  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    Category category,
    int productCount,
  ) async {
    final result = await showCategoryEditDialog(
      context,
      name: category.name,
      productCount: productCount,
    );
    if (!context.mounted) return;
    switch (result) {
      case CategoryRenamed(:final name) when name != category.name:
        await _run(
          context,
          () => ref
              .read(categoryEditorProvider.notifier)
              .rename(category.id, name),
        );
      case CategoryDeleteRequested():
        await _delete(context, ref, category, productCount);
      case _:
        break;
    }
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
    final categoriesAsync = ref.watch(categoriesProvider);
    final counts =
        ref.watch(categoryProductCountsProvider).value ?? const <String, int>{};

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Catégories'),
        actions: [
          TextButton.icon(
            onPressed: () => _add(context, ref),
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Catégorie'),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
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
          return ListView(
            padding: const EdgeInsets.only(
              top: AppSpacing.sm,
              bottom: AppSpacing.lg,
            ),
            children: [
              FlatList(
                children: [
                  for (final category in categories)
                    _CategoryRow(
                      name: category.name,
                      count: counts[category.id] ?? 0,
                      onEdit: () => _edit(
                        context,
                        ref,
                        category,
                        counts[category.id] ?? 0,
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Catégorie : nom, nombre de produits, « Modifier ».
class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.name,
    required this.count,
    required this.onEdit,
  });

  final String name;
  final int count;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return InkWell(
      onTap: onEdit,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 60),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.xs,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTypography.bodyStrong),
                    Text(
                      count <= 1 ? '$count produit' : '$count produits',
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Semantics(
                label: 'Modifier $name',
                button: true,
                excludeSemantics: true,
                child: TextButton(
                  onPressed: onEdit,
                  child: const Text('Modifier'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
