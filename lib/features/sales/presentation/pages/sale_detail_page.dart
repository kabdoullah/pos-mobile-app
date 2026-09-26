import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/network/error_mapper.dart';
import '../../../../core/router/app_router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../domain/entities/sale.dart';
import '../../../printing/presentation/providers/printer_provider.dart';
import '../../../printing/domain/repositories/printer_repository.dart';
import '../providers/sales_providers.dart';

/// Page de détail d'une vente — vue en lecture seule d'une vente terminée.
///
/// Reçoit la [Sale] via le extra de GoRouter — pas par recherche d'ID.
/// Les articles ne sont pas disponibles en dehors de la session d'origine.
class SaleDetailPage extends ConsumerWidget {
  /// Crée une [SaleDetailPage].
  const SaleDetailPage({required this.sale, super.key});

  /// Vente à afficher.
  final Sale sale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatter = DateFormat('EEEE d MMMM yyyy HH:mm', 'fr_FR');
    final receiptNumber = sale.receiptNumber > 0
        ? '#${sale.receiptNumber}'
        : 'Provisoire';

    final cs = Theme.of(context).colorScheme;

    return AppScaffold(
      title: 'Vente $receiptNumber',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Carte d'en-tête avec les infos de la vente
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Reçu N°',
                            style: AppTypography.captionText,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(receiptNumber, style: AppTypography.titleLarge),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Mode de paiement',
                            style: AppTypography.captionText,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            _paymentMethodLabel(sale.paymentMethod),
                            style: AppTypography.labelLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    dateFormatter.format(sale.createdAt),
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Divider(),
                  const SizedBox(height: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Montant total',
                        style: AppTypography.captionText,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AmountDisplay(
                        amount: sale.totalAmount,
                        size: AmountSize.large,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Carte d'information sur les articles indisponibles
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                // ✨ surfaceContainerHighest — info neutre, pas une alerte
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: cs.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Le détail des articles n\'est disponible que pendant la session de vente.',
                      style: AppTypography.bodySmall.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Bouton de réimpression
            PrimaryButton(
              label: 'Réimprimer le reçu',
              icon: Icons.print,
              onPressed: () => _handlePrint(context, ref),
            ),
            if (sale.receiptNumber > 0) ...[
              const SizedBox(height: AppSpacing.md),
              SecondaryButton(
                label: 'Télécharger le reçu (PDF)',
                icon: Icons.picture_as_pdf,
                onPressed: () => _handleDownloadPdf(context, ref),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Gère l'impression du reçu.
  Future<void> _handlePrint(BuildContext context, WidgetRef ref) async {
    try {
      // Les articles sont null lors d'une impression depuis l'historique (hors
      // session)
      await ref.read(printerProvider.notifier).print(sale: sale, items: null);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reçu imprimé avec succès'),
            duration: Duration(
              seconds: 2,
            ), // ✨ AppColors.secondary (#CA8A04)+blanc=3.4:1 fail WCAG — theme neutre
          ),
        );
      }
    } on PrintException catch (e) {
      if (context.mounted) {
        if (e.reason == PrintFailureReason.noPrinterConfigured) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Aucune imprimante configurée'),
              action: SnackBarAction(
                label: 'Configurer',
                onPressed: () => context.push(Routes.bluetoothSetup),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur d\'impression: ${e.details}'),
              backgroundColor: Theme.of(
                context,
              ).colorScheme.error, // ✨ cs.error — compatible mode sombre
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorToFrench(e)),
            backgroundColor: Theme.of(
              context,
            ).colorScheme.error, // ✨ cs.error — compatible mode sombre
          ),
        );
      }
    }
  }

  /// Gère le téléchargement et le partage du reçu PDF.
  Future<void> _handleDownloadPdf(BuildContext context, WidgetRef ref) async {
    try {
      final bytes = await ref.read(
        downloadSaleReceiptPdfProvider(sale.id).future,
      );
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/recu_${sale.receiptNumber}.pdf');
      await file.writeAsBytes(bytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/pdf')],
          subject: 'Reçu de vente',
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorToFrench(e)),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  static String _paymentMethodLabel(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cash => 'Espèces',
      PaymentMethod.orangeMoney => 'Orange Money',
      PaymentMethod.mtn => 'MTN',
      PaymentMethod.wave => 'Wave',
      PaymentMethod.mixed => 'Mixte',
    };
  }
}
