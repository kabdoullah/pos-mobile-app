import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/network/error_mapper.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/product_import_result.dart';
import '../providers/product_import_providers.dart';

/// Import de produits en 3 étapes (modèle à partager, une ligne par produit,
/// fichier CSV ou Excel), puis rapport : produits importés et lignes à
/// corriger, une par une.
class ProductImportPage extends ConsumerStatefulWidget {
  /// Crée une [ProductImportPage].
  const ProductImportPage({super.key});

  @override
  ConsumerState<ProductImportPage> createState() => _ProductImportPageState();
}

class _ProductImportPageState extends ConsumerState<ProductImportPage> {
  File? _selectedFile;
  String? _downloadingFormat;
  bool _isImporting = false;
  ProductImportResult? _result;

  Future<void> _downloadTemplate(String format) async {
    setState(() => _downloadingFormat = format);
    try {
      final bytes = await ref.read(
        downloadProductImportTemplateProvider(format: format).future,
      );
      final dir = await getTemporaryDirectory();
      final filename = 'modele_import_produits.$format';
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(
              file.path,
              mimeType: format == 'csv'
                  ? 'text/csv'
                  : 'application/vnd.openxmlformats-officedocument'
                        '.spreadsheetml.sheet',
            ),
          ],
          subject: 'Modèle import produits',
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorToFrench(e))));
      }
    } finally {
      if (mounted) {
        setState(() => _downloadingFormat = null);
      }
    }
  }

  Future<void> _pickFile() async {
    final picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx'],
    );
    final path = picked?.path;
    if (path != null && mounted) {
      setState(() {
        _selectedFile = File(path);
        _result = null;
      });
    }
  }

  Future<void> _import() async {
    final file = _selectedFile;
    if (file == null) return;

    setState(() => _isImporting = true);
    try {
      final result = await ref.read(
        importProductsFromFileProvider(file).future,
      );
      if (mounted) {
        setState(() => _result = result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorToFrench(e))));
      }
    } finally {
      if (mounted) {
        setState(() => _isImporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final result = _result;
    final file = _selectedFile;

    final Widget body;
    final List<Widget> footer;
    if (result != null) {
      body = _ImportReport(result: result);
      footer = [
        PrimaryButton(
          label: 'Terminé',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        if (result.failedCount > 0) ...[
          const SizedBox(height: AppSpacing.sm),
          SecondaryButton(
            label: 'Corriger et réimporter',
            onPressed: _isImporting ? null : _pickFile,
          ),
        ],
      ];
    } else {
      body = ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        children: [
          _Step(
            number: 1,
            title: 'Récupérez le modèle',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SecondaryButton(
                  label: 'Partager le modèle Excel',
                  isLoading: _downloadingFormat == 'xlsx',
                  onPressed: _downloadingFormat != null
                      ? null
                      : () => _downloadTemplate('xlsx'),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: _downloadingFormat != null
                        ? null
                        : () => _downloadTemplate('csv'),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text('ou au format CSV'),
                  ),
                ),
              ],
            ),
          ),
          _Step(
            number: 2,
            title: 'Remplissez une ligne par produit',
            child: Text(
              'Colonnes : nom, code-barres, prix unitaire, stock',
              style: AppTypography.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          _Step(
            number: 3,
            title: 'Choisissez le fichier',
            child: file == null
                ? SecondaryButton(
                    label: 'Choisir un fichier',
                    onPressed: _isImporting ? null : _pickFile,
                  )
                : DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.surface,
                      border: Border.all(color: colors.borderStrong),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.sm + 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              file.uri.pathSegments.last,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.body,
                            ),
                          ),
                          TextButton(
                            onPressed: _isImporting ? null : _pickFile,
                            child: const Text('Changer'),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      );
      footer = [
        PrimaryButton(
          label: 'Importer les produits',
          isLoading: _isImporting,
          onPressed: (file == null || _isImporting) ? null : _import,
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Importer des produits'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: body),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(top: BorderSide(color: colors.border)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + AppSpacing.xs,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: footer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Étape numérotée : pastille, titre, contenu.
class _Step extends StatelessWidget {
  const _Step({required this.number, required this.title, required this.child});

  final int number;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surfaceSunken,
              shape: BoxShape.circle,
            ),
            child: SizedBox.square(
              dimension: 28,
              child: Center(
                child: Text(
                  '$number',
                  style: AppTypography.meta.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(title, style: AppTypography.bodyStrong),
                ),
                const SizedBox(height: AppSpacing.sm),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Rapport d'import : ce qui est passé, puis les lignes à corriger.
class _ImportReport extends StatelessWidget {
  const _ImportReport({required this.result});

  final ProductImportResult result;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final failures = result.items
        .where((item) => item.status == ProductImportItemStatus.failed)
        .toList();
    final created = result.createdCount;
    final failed = result.failedCount;
    return ListView(
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.lg),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusIndicator(
                label: created <= 1
                    ? '$created produit importé'
                    : '$created produits importés',
                tone: StatusTone.success,
                emphasized: true,
              ),
              if (failed > 0) ...[
                const SizedBox(height: AppSpacing.xs),
                StatusIndicator(
                  label: failed == 1
                      ? '1 ligne à corriger'
                      : '$failed lignes à corriger',
                  tone: StatusTone.error,
                  emphasized: true,
                ),
              ],
            ],
          ),
        ),
        if (failures.isNotEmpty) ...[
          const OverlineHeader('Lignes en erreur'),
          FlatList(
            children: [
              for (final item in failures)
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 56),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ligne ${item.index + 1}',
                          style: AppTypography.bodyStrong,
                        ),
                        Text(
                          item.error ?? 'Erreur inconnue',
                          style: AppTypography.bodySmall.copyWith(
                            color: colors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
