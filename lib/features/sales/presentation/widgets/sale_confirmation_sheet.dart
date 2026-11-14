import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/providers/connectivity_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';
import '../../../printing/domain/repositories/printer_repository.dart';
import '../../../printing/presentation/providers/printer_provider.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/payment_method_label.dart';
import '../../domain/entities/sale.dart';
import '../providers/sales_providers.dart';
import '../receipt_pdf.dart';

/// Affiche la confirmation d'une vente enregistrée par-dessus l'écran Vendre.
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
    builder: (_) =>
        SaleConfirmationSheet(sale: sale, items: items, change: change),
  );
}

/// Feuille « Vente enregistrée » : reçu (numéro, paiement, total) ou attente
/// de synchro, monnaie à rendre, puis « Imprimer le reçu », « Reçu PDF » et
/// « Nouvelle vente ».
///
/// Si l'impression échoue, la feuille passe en « Reçu non imprimé » : la
/// vente reste enregistrée, avec 3 choix (Réessayer, Imprimer plus tard,
/// Pas de reçu).
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

class _SaleConfirmationSheetState extends ConsumerState<SaleConfirmationSheet> {
  bool _isPrinting = false;
  bool _isPrinted = false;

  /// Échec d'impression en cours d'affichage ; `null` = vue normale.
  PrintException? _printFailure;

  /// Erreur hors imprimante (inattendue) lors de l'impression.
  String? _printError;
  String? _pdfError;

  Future<void> _print(Sale sale) async {
    setState(() {
      _isPrinting = true;
      _printError = null;
    });
    PrintException? failure;
    String? error;
    try {
      await ref
          .read(printerProvider.notifier)
          .print(sale: sale, items: widget.items);
    } on PrintException catch (e) {
      failure = e;
    } catch (e) {
      error = errorToFrench(e);
    }
    if (!mounted) return;
    setState(() {
      _isPrinting = false;
      _isPrinted = failure == null && error == null;
      _printFailure = failure;
      _printError = error;
    });
  }

  Future<void> _sharePdf(Sale sale) async {
    setState(() => _pdfError = null);
    try {
      await shareSaleReceiptPdf(ref, sale);
    } catch (e) {
      if (mounted) setState(() => _pdfError = errorToFrench(e));
    }
  }

  void _close() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    // Version drift en direct : le numéro de reçu apparaît dès la synchro.
    final sale =
        ref.watch(saleByIdProvider(widget.sale.id)).value ?? widget.sale;
    final isOnline = ref.watch(isOnlineProvider).value ?? true;
    final failure = _printFailure;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 150),
          alignment: Alignment.topCenter,
          child: failure == null
              ? _confirmation(sale, isOnline)
              : _PrintFailureView(
                  failure: failure,
                  receiptNumber: sale.receiptNumber,
                  isPrinting: _isPrinting,
                  onRetry: () => _print(sale),
                  onConfigure: () {
                    _close();
                    unawaited(context.push(Routes.bluetoothSetup));
                  },
                  onLater: _close,
                  onNoReceipt: _close,
                ),
        ),
      ),
    );
  }

  Widget _confirmation(Sale sale, bool isOnline) {
    final colors = AppColors.of(context);
    final isSynced = sale.receiptNumber > 0;
    final canSharePdf = isSynced && isOnline;
    final hint = _pdfError != null
        ? null
        : !isOnline
        ? 'Le reçu PDF sera disponible au retour de la connexion.'
        : !isSynced
        ? 'Le reçu PDF sera disponible une fois la vente synchronisée.'
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Vente enregistrée', style: AppTypography.sectionTitle),
        const SizedBox(height: AppSpacing.sm),
        // receiptNumber = 0 tant que le serveur n'a pas attribué de numéro :
        // jamais affiché comme un vrai numéro.
        if (isSynced)
          Text(
            'Reçu n° ${sale.receiptNumber} · ${sale.paymentMethod.label} · '
            '${formatFcfa(sale.totalAmount)}',
            style: AppTypography.bodySmall.copyWith(
              color: colors.textSecondary,
              fontFeatures: AppTypography.tabularFigures,
            ),
          )
        else
          const StatusIndicator(
            label: 'En attente de synchro · n° de reçu au retour du réseau',
            tone: StatusTone.warning,
          ),
        if (widget.change > Decimal.zero) ...[
          const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: colors.border),
                bottom: BorderSide(color: colors.border),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'À rendre au client',
                      style: AppTypography.body.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                  Text(
                    formatFcfa(widget.change),
                    style: AppTypography.figureHero,
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        PrimaryButton(
          label: _isPrinted ? 'Imprimer de nouveau' : 'Imprimer le reçu',
          height: AppSpacing.buttonHeight,
          isLoading: _isPrinting,
          loadingLabel: 'Impression…',
          onPressed: _isPrinting ? null : () => _print(sale),
        ),
        if (_isPrinted || _printError != null) ...[
          const SizedBox(height: AppSpacing.xs),
          _isPrinted
              ? const StatusIndicator(
                  label: 'Reçu imprimé',
                  tone: StatusTone.success,
                )
              : Text(
                  _printError!,
                  style: AppTypography.meta.copyWith(color: colors.error),
                ),
        ],
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                // Le PDF est généré par le serveur : il faut le réseau et
                // une vente déjà synchronisée.
                label: 'Reçu PDF',
                onPressed: canSharePdf ? () => _sharePdf(sale) : null,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: SecondaryButton(
                label: 'Nouvelle vente',
                onPressed: _close,
              ),
            ),
          ],
        ),
        if (_pdfError != null || hint != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            _pdfError ?? hint!,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: _pdfError == null ? colors.textSecondary : colors.error,
            ),
          ),
        ],
      ],
    );
  }
}

/// « Reçu non imprimé » : cause, rappel que la vente est enregistrée, puis
/// Réessayer (ou Configurer sans imprimante), Imprimer plus tard, Pas de reçu.
class _PrintFailureView extends StatelessWidget {
  const _PrintFailureView({
    required this.failure,
    required this.receiptNumber,
    required this.isPrinting,
    required this.onRetry,
    required this.onConfigure,
    required this.onLater,
    required this.onNoReceipt,
  });

  final PrintException failure;
  final int receiptNumber;
  final bool isPrinting;
  final VoidCallback onRetry;
  final VoidCallback onConfigure;
  final VoidCallback onLater;
  final VoidCallback onNoReceipt;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final noPrinter = failure.reason == PrintFailureReason.noPrinterConfigured;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Reçu non imprimé', style: AppTypography.sectionTitle),
        const SizedBox(height: AppSpacing.sm),
        Text(
          failure.userMessage,
          style: AppTypography.body.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
        StatusIndicator(
          label: receiptNumber > 0
              ? 'La vente n° $receiptNumber est bien enregistrée'
              : 'La vente est bien enregistrée',
          tone: StatusTone.success,
        ),
        const SizedBox(height: AppSpacing.md),
        if (noPrinter)
          PrimaryButton(
            label: 'Configurer l’imprimante',
            height: AppSpacing.buttonHeight,
            onPressed: onConfigure,
          )
        else
          PrimaryButton(
            label: 'Réessayer',
            height: AppSpacing.buttonHeight,
            isLoading: isPrinting,
            onPressed: isPrinting ? null : onRetry,
          ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: 'Imprimer plus tard',
                onPressed: onLater,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: SecondaryButton(
                label: 'Pas de reçu',
                onPressed: onNoReceipt,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
