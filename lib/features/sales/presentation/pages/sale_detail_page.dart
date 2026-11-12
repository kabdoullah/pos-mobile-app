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
import '../../domain/entities/margin_summary.dart';
import '../../domain/entities/sale.dart';
import '../../../printing/presentation/providers/printer_provider.dart';
import '../../../returns/presentation/providers/returns_providers.dart';
import '../../../returns/presentation/widgets/sale_returns_section.dart';
import '../../../printing/domain/repositories/printer_repository.dart';
import '../../domain/entities/payment_method_label.dart';
import '../providers/sales_providers.dart';
import '../receipt_pdf.dart';
import '../widgets/receipt_ticket.dart';
import '../../../catalog/presentation/widgets/product_thumbnail.dart';

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

    final returnable = ref.watch(returnableLinesProvider(sale)).value;
    final canReturn =
        isSynced &&
        (returnable ?? const []).any((l) => l.returnableQuantity > 0);

    return AppScaffold(
      title: isSynced ? 'Vente n° ${sale.receiptNumber}' : 'Vente',
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.md),
          child: isSynced
              ? const StatusPill(
                  label: 'Envoyée',
                  icon: Icons.cloud_done_outlined,
                  tone: StatusPillTone.success,
                )
              : const StatusPill(
                  label: 'En attente',
                  icon: Icons.schedule,
                  tone: StatusPillTone.warning,
                ),
        ),
      ],
      bottomActions: [
        PrimaryButton(
          label: 'Imprimer',
          icon: Icons.print_outlined,
          onPressed: () => _handlePrint(context, ref, sale, items),
        ),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: 'Partager PDF',
                // Le PDF est généré par le serveur : réseau + vente
                // synchronisée.
                onPressed: isSynced && isOnline
                    ? () => _handleDownloadPdf(context, ref, sale)
                    : null,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: SecondaryButton(
                label: 'Retour',
                onPressed: canReturn
                    ? () => context.push(Routes.saleReturn, extra: sale)
                    : null,
              ),
            ),
          ],
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          if (!isSynced) ...[
            _PendingBanner(),
            const SizedBox(height: AppSpacing.md),
          ],
          ReceiptTicket(
            title: isSynced
                ? 'Reçu n° ${sale.receiptNumber}'
                : 'Reçu en attente d’envoi',
            subtitle: toBeginningOfSentenceCase(
              DateFormat(
                "EEEE d MMMM yyyy '·' HH:mm",
                'fr_FR',
              ).format(sale.createdAt.toLocal()),
              'fr_FR',
            ),
            lines: [
              for (final item in items ?? const <CartItem>[])
                ReceiptTicketLine(
                  name: item.productName,
                  quantity: item.quantity,
                  unitPrice: item.unitPrice,
                  amount: item.grossTotal,
                  discount: item.discountAmount,
                  leading: ProductThumbnailById(productId: item.productId),
                ),
            ],
            linesPlaceholder: items == null
                ? const SkeletonBox(height: 40)
                : Text(
                    "Le détail des articles n'est pas disponible sur cet "
                    'appareil (vente enregistrée ailleurs).',
                    style: muted,
                  ),
            total: sale.totalAmount,
            discount: sale.discountAmount,
            footer: [('Paiement', sale.paymentMethod.label)],
          ),
          if (items != null &&
              items.any((item) => item.purchaseUnitPrice != null)) ...[
            const SizedBox(height: AppSpacing.md),
            _InternalMargin(sale: sale, items: items),
          ],
          if (isSynced && !isOnline) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Reçu PDF disponible lorsque la connexion sera rétablie.',
              textAlign: TextAlign.center,
              style: muted,
            ),
          ],
          // Retours déjà enregistrés ; l'action est dans la barre du bas.
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: SaleReturnsSection(sale: sale, showReturnAction: false),
          ),
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
            content: Text('Reçu imprimé'),
            duration: Duration(seconds: 2),
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
              content: Text(e.userMessage),
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

/// Prix d'achat et marge de la vente, repliés par défaut : donnée interne au
/// commerçant, jamais imprimée ni montrée au client (ADR-0009). Valeurs figées
/// à la vente, jamais relues depuis le produit actuel.
class _InternalMargin extends StatelessWidget {
  const _InternalMargin({required this.sale, required this.items});

  final Sale sale;
  final List<CartItem> items;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final summary = MarginSummary.fromSales([(sale: sale, items: items)]);
    final muted = AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: cs.outlineVariant),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Theme(
        // Pas de séparateurs ajoutés par ExpansionTile.
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: const Icon(Icons.lock_outline),
          title: const Text('Infos internes'),
          subtitle: Text('Non visibles par le client', style: muted),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          children: [
            for (final item in items)
              _InfoRow(
                label: item.productName,
                value: item.purchaseUnitPrice == null
                    ? "Prix d'achat inconnu"
                    : 'Achat ${formatAmount(item.purchaseUnitPrice!)} · '
                          'Marge ${formatFcfa(item.margin!)}',
              ),
            const Divider(),
            _InfoRow(label: "Coût d'achat", value: formatFcfa(summary.cost)),
            _InfoRow(label: 'Marge brute', value: formatFcfa(summary.margin)),
            if (summary.hasUnknownCost)
              Text(
                "Articles sans prix d'achat exclus de la marge.",
                style: muted,
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Valeur calée à droite, comme une colonne de ticket.
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTypography.labelLarge.copyWith(
                fontFeatures: AppTypography.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Vente pas encore envoyée : le retour attend l'envoi (règle inchangée).
class _PendingBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final style = AppTypography.bodyMedium.copyWith(
      color: cs.onTertiaryContainer,
    );
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Vente en attente d'envoi",
            style: style.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            'Le retour et le reçu PDF seront possibles dès qu’elle sera '
            'envoyée.',
            style: style,
          ),
        ],
      ),
    );
  }
}
