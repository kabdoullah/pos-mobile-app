import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/network/error_mapper.dart';
import '../../../../core/router/app_router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/sale.dart';
import '../../../printing/presentation/providers/printer_provider.dart';
import '../../../printing/domain/repositories/printer_repository.dart';
import '../payment_method_label.dart';
import '../providers/sales_providers.dart';
import '../receipt_pdf.dart';

/// Détail d'une vente, présenté comme un ticket : lignes, total, paiement,
/// statut de synchro, puis impression et reçu PDF.
///
/// Reçoit la [Sale] via le extra de GoRouter ; le numéro de reçu et les lignes
/// sont suivis en direct dans drift.
class SaleDetailPage extends ConsumerWidget {
  /// Crée une [SaleDetailPage].
  const SaleDetailPage({required this.sale, super.key});

  /// Vente à afficher.
  final Sale sale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    // Version drift en direct : le numéro de reçu apparaît dès la synchro.
    final sale = ref.watch(saleByIdProvider(this.sale.id)).value ?? this.sale;
    final items = ref.watch(saleItemsProvider(sale.id)).value;
    final isOnline = ref.watch(isOnlineProvider).value ?? true;
    final isSynced = sale.receiptNumber > 0;
    final muted = AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant);

    return AppScaffold(
      title: isSynced ? 'Vente #${sale.receiptNumber}' : 'Vente',
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    isSynced
                        ? 'Reçu #${sale.receiptNumber}'
                        : 'Reçu en attente de synchronisation',
                    textAlign: TextAlign.center,
                    style: AppTypography.titleMedium,
                  ),
                  Text(
                    toBeginningOfSentenceCase(
                      DateFormat(
                        "EEEE d MMMM yyyy 'à' HH:mm",
                        'fr_FR',
                      ).format(sale.createdAt),
                      'fr_FR',
                    ),
                    textAlign: TextAlign.center,
                    style: muted,
                  ),
                  const _TicketDivider(),
                  if (items == null)
                    const SkeletonBox(height: 40)
                  else if (items.isEmpty)
                    Text(
                      "Le détail des articles n'est pas disponible sur cet "
                      'appareil (vente enregistrée ailleurs).',
                      style: muted,
                    )
                  else
                    for (final item in items) _TicketLine(item: item),
                  const _TicketDivider(),
                  Row(
                    children: [
                      const Expanded(
                        child: Text('TOTAL', style: AppTypography.titleMedium),
                      ),
                      // Gros montant : réduit plutôt que de déborder.
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: AmountDisplay(
                            amount: sale.totalAmount,
                            size: AmountSize.large,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _InfoRow(label: 'Paiement', value: sale.paymentMethod.label),
                  _InfoRow(
                    label: 'Statut',
                    value: isSynced ? 'Synchronisée' : 'En attente de synchro',
                    icon: isSynced
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_upload_outlined,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Imprimer',
            icon: Icons.print_outlined,
            onPressed: () => _handlePrint(context, ref, sale, items),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            // Le PDF est généré par le serveur : réseau + vente synchronisée.
            onPressed: isSynced && isOnline
                ? () => _handleDownloadPdf(context, ref, sale)
                : null,
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: const Text('Reçu PDF'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(AppSpacing.buttonHeightSm),
            ),
          ),
          if (!isSynced || !isOnline) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              isOnline
                  ? 'Reçu PDF disponible après synchronisation.'
                  : 'Reçu PDF disponible lorsque la connexion sera rétablie.',
              textAlign: TextAlign.center,
              style: muted,
            ),
          ],
        ],
      ),
    );
  }

  /// Gère l'impression du reçu.
  Future<void> _handlePrint(
    BuildContext context,
    WidgetRef ref,
    Sale sale,
    List<CartItem>? items,
  ) async {
    try {
      // Sans lignes locales (vente reçue du serveur), le ticket n'imprime que
      // les totaux.
      await ref
          .read(printerProvider.notifier)
          .print(
            sale: sale,
            items: items == null || items.isEmpty ? null : items,
          );

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
  Future<void> _handleDownloadPdf(
    BuildContext context,
    WidgetRef ref,
    Sale sale,
  ) async {
    try {
      await shareSaleReceiptPdf(ref, sale);
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
}

/// Séparateur pointillé façon ticket de caisse.
class _TicketDivider extends StatelessWidget {
  const _TicketDivider();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.outlineVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dashes = (constraints.maxWidth / 8).floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < dashes; i++)
                SizedBox(width: 4, height: 1, child: ColoredBox(color: color)),
            ],
          );
        },
      ),
    );
  }
}

/// Ligne d'article : nom, puis « quantité × prix » et total de ligne.
class _TicketLine extends StatelessWidget {
  const _TicketLine({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.productName, style: AppTypography.bodyLarge),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${item.quantity} × ${formatAmount(item.unitPrice)}',
                  style: AppTypography.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                formatAmount(item.lineTotal),
                style: AppTypography.bodyLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final icon = this.icon;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          if (icon != null) ...[
            Icon(icon, size: 16, color: cs.onSurfaceVariant),
            const SizedBox(width: AppSpacing.xs),
          ],
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTypography.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}
