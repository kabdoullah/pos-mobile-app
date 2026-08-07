import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/network/error_mapper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/index.dart';
import '../../domain/entities/product_import_result.dart';
import '../providers/product_import_providers.dart';

/// Page for downloading a blank product import template and importing
/// products in bulk from a CSV or Excel file.
class ProductImportPage extends ConsumerStatefulWidget {
  /// Creates a [ProductImportPage].
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
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xlsx'],
    );
    final path = result?.files.single.path;
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
    final cs = Theme.of(context).colorScheme;

    return AppScaffold(
      title: 'Importer des produits',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '1. Télécharger le modèle',
              style: AppTypography.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Colonnes attendues : nom, code-barres, prix unitaire, stock',
              style: AppTypography.bodySmall.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: 'CSV',
                    icon: Icons.description_outlined,
                    isLoading: _downloadingFormat == 'csv',
                    onPressed: _downloadingFormat != null
                        ? null
                        : () => _downloadTemplate('csv'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: SecondaryButton(
                    label: 'Excel',
                    icon: Icons.grid_on_outlined,
                    isLoading: _downloadingFormat == 'xlsx',
                    onPressed: _downloadingFormat != null
                        ? null
                        : () => _downloadTemplate('xlsx'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            const Divider(),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              '2. Importer un fichier',
              style: AppTypography.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            SecondaryButton(
              label: _selectedFile == null
                  ? 'Choisir un fichier'
                  : _selectedFile!.uri.pathSegments.last,
              icon: Icons.folder_open_outlined,
              onPressed: _isImporting ? null : _pickFile,
            ),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Importer',
              isLoading: _isImporting,
              onPressed: (_selectedFile == null || _isImporting)
                  ? null
                  : _import,
            ),
            if (_result != null) ...[
              const SizedBox(height: AppSpacing.xl),
              _ImportResultCard(result: _result!),
            ],
          ],
        ),
      ),
    );
  }
}

class _ImportResultCard extends StatelessWidget {
  const _ImportResultCard({required this.result});

  final ProductImportResult result;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasFailures = result.failedCount > 0;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasFailures ? Icons.warning_amber_rounded : Icons.check_circle,
                color: hasFailures ? AppColors.warning : AppColors.success,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  '${result.createdCount} produit(s) créé(s), '
                  '${result.failedCount} échec(s)',
                  style: AppTypography.titleMedium,
                ),
              ),
            ],
          ),
          if (hasFailures) ...[
            const SizedBox(height: AppSpacing.md),
            ...result.items
                .where((item) => item.status == ProductImportItemStatus.failed)
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Text(
                      'Ligne ${item.index + 1}: ${item.error ?? 'Erreur inconnue'}',
                      style: AppTypography.bodySmall.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }
}
