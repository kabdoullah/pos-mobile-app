import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/sync/sync_orchestrator.dart';
import '../../../../core/widgets/index.dart';
import '../../../printing/domain/repositories/printer_repository.dart';
import '../../../printing/presentation/providers/printer_provider.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/sale.dart';
import '../payment_method_label.dart';
import '../providers/sales_providers.dart';
import '../receipt_pdf.dart';

/// Affiche la confirmation d'une vente enregistrée par-dessus la caisse.
///
/// Le panier est déjà vidé : fermer la feuille (bouton, glissement ou tap
/// extérieur) revient directement à une nouvelle vente.
Future<void> showSaleConfirmationSheet(
  BuildContext context, {
  required Sale sale,
  required List<CartItem> items,
  required Decimal change,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) =>
        SaleConfirmationSheet(sale: sale, items: items, change: change),
  );
}

/// Confirmation de vente : montant, monnaie à rendre, état de synchro et
/// actions reçu (secondaires) ; « Nouvelle vente » est l'action principale.
class SaleConfirmationSheet extends ConsumerStatefulWidget {
  /// Crée la feuille de confirmation.
  const SaleConfirmationSheet({
    required this.sale,
    required this.items,
    required this.change,
    super.key,
  });

  /// Vente enregistrée (version locale ; le numéro de reçu arrive via drift).
  final Sale sale;

  /// Articles vendus (pour l'impression du ticket).
  final List<CartItem> items;

  /// Monnaie à rendre en espèces.
  final Decimal change;

  @override
  ConsumerState<SaleConfirmationSheet> createState() =>
      _SaleConfirmationSheetState();
}

/// Retour de l'action d'impression, affiché dans la feuille (un SnackBar
/// serait masqué par la feuille modale).
sealed class _PrintFeedback {
  const _PrintFeedback();
}

class _Printing extends _PrintFeedback {
  const _Printing();
}

class _Printed extends _PrintFeedback {
  const _Printed();
}

class _NoPrinter extends _PrintFeedback {
  const _NoPrinter();
}

class _PrintFailed extends _PrintFeedback {
  const _PrintFailed(this.message);
  final String message;
}

class _SaleConfirmationSheetState extends ConsumerState<SaleConfirmationSheet> {
  _PrintFeedback? _printFeedback;
  String? _pdfError;

  Future<void> _print(Sale sale) async {
    setState(() => _printFeedback = const _Printing());
    _PrintFeedback feedback;
    try {
      await ref
          .read(printerProvider.notifier)
          .print(sale: sale, items: widget.items);
      feedback = const _Printed();
    } on PrintException catch (e) {
      feedback = e.reason == PrintFailureReason.noPrinterConfigured
          ? const _NoPrinter()
          : _PrintFailed(e.details);
    } catch (e) {
      feedback = _PrintFailed(errorToFrench(e));
    }
    if (mounted) setState(() => _printFeedback = feedback);
  }

  Future<void> _sharePdf(Sale sale) async {
    setState(() => _pdfError = null);
    try {
      await shareSaleReceiptPdf(ref, sale);
    } catch (e) {
      if (mounted) setState(() => _pdfError = errorToFrench(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Version drift en direct : le numéro de reçu apparaît dès la synchro.
    final sale =
        ref.watch(saleByIdProvider(widget.sale.id)).value ?? widget.sale;
    final isOnline = ref.watch(isOnlineProvider).value ?? true;
    final isSyncing = ref.watch(syncOrchestratorProvider) is SyncStatusSyncing;
    final isSynced = sale.receiptNumber > 0;
    final units = widget.items.fold(0, (sum, item) => sum + item.quantity);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: _SuccessBadge()),
            const SizedBox(height: AppSpacing.sm),
            Text(
              isSynced ? 'Vente synchronisée' : 'Vente enregistrée',
              textAlign: TextAlign.center,
              style: AppTypography.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Center(
              child: AmountDisplay(
                amount: sale.totalAmount,
                size: AmountSize.hero,
              ),
            ),
            Text(
              '${units <= 1 ? '$units article' : '$units articles'} · '
              '${sale.paymentMethod.label}',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            if (widget.change > Decimal.zero) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Row(
                  children: [
                    Text(
                      'Monnaie à rendre',
                      style: AppTypography.titleMedium.copyWith(
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                    const Spacer(),
                    AmountDisplay(
                      amount: widget.change,
                      size: AmountSize.large,
                      color: cs.onPrimaryContainer,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            _SyncStatusLine(
              receiptNumber: sale.receiptNumber,
              isOnline: isOnline,
              isSyncing: isSyncing,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _printFeedback is _Printing
                        ? null
                        : () => _print(sale),
                    icon: const Icon(Icons.print_outlined),
                    label: const Text('Imprimer'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    // Le PDF est généré par le serveur : il faut le réseau et
                    // une vente déjà synchronisée.
                    onPressed: isSynced && isOnline
                        ? () => _sharePdf(sale)
                        : null,
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    label: const Text('Reçu PDF'),
                  ),
                ),
              ],
            ),
            _ActionFeedback(
              printFeedback: _printFeedback,
              pdfError: _pdfError,
              pdfHint: switch ((isSynced, isOnline)) {
                (_, false) =>
                  'Reçu PDF disponible lorsque la connexion sera rétablie.',
                (false, true) => 'Reçu PDF disponible après synchronisation.',
                _ => null,
              },
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: 'Nouvelle vente',
              icon: Icons.add,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Coche animée (≈ 250 ms).
class _SuccessBadge extends StatelessWidget {
  const _SuccessBadge();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(Icons.check_rounded, size: 40, color: cs.primary),
        ),
      ),
    );
  }
}

class _SyncStatusLine extends StatelessWidget {
  const _SyncStatusLine({
    required this.receiptNumber,
    required this.isOnline,
    required this.isSyncing,
  });

  final int receiptNumber;
  final bool isOnline;
  final bool isSyncing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // receiptNumber = 0 tant que le serveur n'a pas attribué de numéro : on
    // ne l'affiche jamais comme un vrai numéro.
    final (Widget leading, String text) = switch ((
      receiptNumber > 0,
      isOnline,
    )) {
      (true, _) => (
        Icon(Icons.cloud_done_outlined, size: 18, color: cs.primary),
        'Reçu #$receiptNumber',
      ),
      (false, false) => (
        Icon(Icons.cloud_off_outlined, size: 18, color: cs.tertiary),
        'Hors ligne · la synchronisation se fera automatiquement',
      ),
      (false, true) => (
        isSyncing
            ? SizedBox.square(
                dimension: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: cs.onSurfaceVariant,
                ),
              )
            : Icon(
                Icons.cloud_upload_outlined,
                size: 18,
                color: cs.onSurfaceVariant,
              ),
        'Reçu : en attente de synchronisation',
      ),
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      child: Row(
        key: ValueKey(text),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leading,
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionFeedback extends StatelessWidget {
  const _ActionFeedback({
    required this.printFeedback,
    required this.pdfError,
    required this.pdfHint,
  });

  final _PrintFeedback? printFeedback;
  final String? pdfError;
  final String? pdfHint;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final muted = AppTypography.bodySmall.copyWith(color: cs.onSurfaceVariant);
    final error = AppTypography.bodySmall.copyWith(color: cs.error);

    final lines = <Widget>[
      switch (printFeedback) {
        null => const SizedBox.shrink(),
        _Printing() => Text('Impression…', style: muted),
        _Printed() => Text('Reçu imprimé', style: muted),
        _NoPrinter() => Row(
          children: [
            Expanded(child: Text('Imprimante non configurée', style: muted)),
            TextButton(
              onPressed: () => context.push(Routes.bluetoothSetup),
              child: const Text('Configurer'),
            ),
          ],
        ),
        _PrintFailed(:final message) => Text(
          'Impression impossible : $message',
          style: error,
        ),
      },
      if (pdfError != null)
        Text(pdfError!, style: error)
      else if (pdfHint != null)
        Text(pdfHint!, style: muted),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines,
      ),
    );
  }
}
