import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/network/error_mapper.dart';
import '../../../../core/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/margin_summary.dart';
import '../../domain/entities/sale.dart';
import '../../../printing/presentation/providers/printer_provider.dart';
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
    final colors = AppColors.of(context);
    // Version drift en direct : le numéro de reçu apparaît dès la synchro.
    final sale = ref.watch(saleByIdProvider(this.sale.id)).value ?? this.sale;
    final items = ref.watch(saleItemsProvider(sale.id)).value;
    final isOnline = ref.watch(isOnlineProvider).value ?? true;
    final isSynced = sale.receiptNumber > 0;
    // Aucune imprimante enregistrée : l'action utile devient « Configurer ».
    final noPrinter = switch (ref.watch(printerProvider)) {
      PrinterDisconnected(savedMac: null) => true,
      _ => false,
    };
    final meta = AppTypography.bodySmall.copyWith(color: colors.textSecondary);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(isSynced ? 'Vente n° ${sale.receiptNumber}' : 'Vente'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: StatusIndicator(
              label: isSynced ? 'Synchronisée' : 'En attente de synchro',
              tone: isSynced ? StatusTone.success : StatusTone.warning,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(
                top: AppSpacing.sm,
                bottom: AppSpacing.lg,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: ReceiptTicket(
                    title: isSynced
                        ? 'Reçu n° ${sale.receiptNumber}'
                        : 'Reçu en attente de synchronisation',
                    subtitle: toBeginningOfSentenceCase(
                      DateFormat(
                        "EEEE d MMMM yyyy 'à' HH:mm",
                        'fr_FR',
                      ).format(sale.createdAt),
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
                          leading: ProductThumbnailById(
                            productId: item.productId,
                          ),
                        ),
                    ],
                    linesPlaceholder: items == null
                        ? const SkeletonBox(height: 40)
                        : Text(
                            "Le détail des articles n'est pas disponible sur "
                            'cet appareil (vente enregistrée ailleurs).',
                            style: meta,
                          ),
                    total: sale.totalAmount,
                    discount: sale.discountAmount,
                    footer: [('Paiement', sale.paymentMethod.label)],
                  ),
                ),
                if (items != null &&
                    items.any((item) => item.purchaseUnitPrice != null))
                  _InternalMargin(sale: sale, items: items),
                // Retours enregistrés et action « Retourner des articles ».
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                    0,
                  ),
                  child: SaleReturnsSection(sale: sale),
                ),
              ],
            ),
          ),
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
                  children: [
                    if (noPrinter)
                      PrimaryButton(
                        label: 'Configurer l’imprimante',
                        onPressed: () => context.push(Routes.bluetoothSetup),
                      )
                    else
                      PrimaryButton(
                        label: 'Imprimer le reçu',
                        onPressed: () =>
                            _handlePrint(context, ref, sale, items),
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    SecondaryButton(
                      label: 'Reçu PDF',
                      // Le PDF est généré par le serveur : réseau + vente
                      // synchronisée.
                      onPressed: isSynced && isOnline
                          ? () => _handleDownloadPdf(context, ref, sale)
                          : null,
                    ),
                    if (!isSynced || !isOnline) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        isOnline
                            ? 'Reçu PDF disponible après synchronisation.'
                            : 'Reçu PDF disponible lorsque la connexion sera '
                                  'rétablie.',
                        textAlign: TextAlign.center,
                        style: meta,
                      ),
                    ],
                  ],
                ),
              ),
            ),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorToFrench(e))));
      }
    }
  }
}

/// Prix d'achat et marge de la vente : donnée interne au commerçant, jamais
/// imprimée ni montrée au client (ADR-0009). Valeurs figées à la vente,
/// jamais relues depuis le produit actuel.
class _InternalMargin extends StatelessWidget {
  const _InternalMargin({required this.sale, required this.items});

  final Sale sale;
  final List<CartItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final summary = MarginSummary.fromSales([(sale: sale, items: items)]);
    String signed(Decimal value) => value < Decimal.zero
        ? '− ${formatFcfa(value.abs())}'
        : '+ ${formatFcfa(value)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OverlineHeader('Infos internes · non visibles du client'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final item in items)
                DefinitionRow(
                  label: item.purchaseUnitPrice == null
                      ? "${item.productName} · prix d'achat inconnu"
                      : '${item.productName} · achat '
                            '${formatAmount(item.purchaseUnitPrice!)} · marge',
                  value: item.margin == null ? '—' : signed(item.margin!),
                ),
              DefinitionRow(
                label: "Coût d'achat",
                value: formatFcfa(summary.cost),
              ),
              DefinitionRow(
                label: 'Marge brute',
                value: signed(summary.margin),
                emphasized: true,
                color: summary.margin < Decimal.zero
                    ? colors.error
                    : colors.success,
                showDivider: false,
              ),
              if (summary.hasUnknownCost)
                Text(
                  "Articles sans prix d'achat exclus de la marge.",
                  style: AppTypography.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
