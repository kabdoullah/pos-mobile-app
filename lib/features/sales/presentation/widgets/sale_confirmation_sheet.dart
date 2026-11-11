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
import '../../domain/entities/sale.dart';
import '../../domain/entities/payment_method_label.dart';
import '../providers/sales_providers.dart';
import '../receipt_pdf.dart';
import 'payment_result_box.dart';

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
    useRootNavigator: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) =>
        SaleConfirmationSheet(sale: sale, items: items, change: change),
  );
}

/// Confirmation de vente : coche, « Vente enregistrée », monnaie à rendre
/// rappelée, puis « Imprimer le reçu », « Partager le reçu » et « Pas de reçu ·
/// vente suivante ». Un échec d'impression remplace le contenu par trois
/// choix, sans blocage : la vente reste enregistrée.
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

/// État de l'impression, affiché dans la feuille (un SnackBar serait masqué
/// par la feuille modale).
sealed class _PrintState {
  const _PrintState();
}

class _Printing extends _PrintState {
  const _Printing();
}

class _Printed extends _PrintState {
  const _Printed();
}

class _PrintFailed extends _PrintState {
  const _PrintFailed(this.reason);
  final PrintFailureReason reason;
}

class _SaleConfirmationSheetState extends ConsumerState<SaleConfirmationSheet> {
  _PrintState? _printState;
  String? _pdfError;

  Future<void> _print(Sale sale) async {
    setState(() => _printState = const _Printing());
    _PrintState next;
    try {
      await ref
          .read(printerProvider.notifier)
          .print(sale: sale, items: widget.items);
      next = const _Printed();
    } on PrintException catch (e) {
      next = _PrintFailed(e.reason);
    } catch (_) {
      next = const _PrintFailed(PrintFailureReason.sendFailed);
    }
    if (mounted) setState(() => _printState = next);
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
    final printState = _printState;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: printState is _PrintFailed
            ? _PrintFailure(
                reason: printState.reason,
                receiptNumber: sale.receiptNumber,
                onRetry: () => _print(sale),
                onConfigure: () {
                  _close();
                  unawaited(context.push(Routes.bluetoothSetup));
                },
                onClose: _close,
              )
            : _confirmation(sale, isOnline, printState),
      ),
    );
  }

  Widget _confirmation(Sale sale, bool isOnline, _PrintState? printState) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final isSynced = sale.receiptNumber > 0;
    final muted = AppTypography.bodyMedium.copyWith(
      color: cs.onSurfaceVariant,
      height: 1.4,
    );
    // receiptNumber = 0 tant que le serveur n'a pas attribué de numéro : on
    // ne l'affiche jamais comme un vrai numéro.
    final summary = [
      if (isSynced) 'Reçu n° ${sale.receiptNumber}',
      sale.paymentMethod.label,
      formatFcfa(sale.totalAmount),
    ].join(' · ');
    final pdfHint = switch ((isSynced, isOnline)) {
      (_, false) => 'Reçu PDF disponible lorsque la connexion sera rétablie.',
      (false, true) => 'Reçu PDF disponible après synchronisation.',
      _ => null,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Ring(
          background: semantic.successContainer,
          foreground: semantic.onSuccessContainer,
          icon: Icons.check_rounded,
        ),
        const SizedBox(height: 14),
        const Text(
          'Vente enregistrée',
          textAlign: TextAlign.center,
          style: AppTypography.titleLarge,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          summary,
          textAlign: TextAlign.center,
          style: muted.copyWith(fontFeatures: AppTypography.tabularFigures),
        ),
        if (widget.change > Decimal.zero) ...[
          const SizedBox(height: 14),
          PaymentResultBox.change(widget.change, centered: true),
        ],
        const SizedBox(height: 14),
        PrimaryButton(
          label: printState is _Printed
              ? 'Réimprimer le reçu'
              : 'Imprimer le reçu',
          icon: Icons.print_outlined,
          isLoading: printState is _Printing,
          loadingLabel: 'Impression…',
          onPressed: () => _print(sale),
        ),
        if (printState is _Printed) ...[
          const SizedBox(height: AppSpacing.xs),
          Text('Reçu imprimé', textAlign: TextAlign.center, style: muted),
        ],
        const SizedBox(height: 14),
        // Le PDF est généré par le serveur : il faut le réseau et une vente
        // déjà synchronisée.
        SecondaryButton(
          label: 'Partager le reçu',
          icon: Icons.ios_share,
          onPressed: isSynced && isOnline ? () => _sharePdf(sale) : null,
        ),
        if (_pdfError != null || pdfHint != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            _pdfError ?? pdfHint!,
            textAlign: TextAlign.center,
            style: _pdfError != null ? muted.copyWith(color: cs.error) : muted,
          ),
        ],
        const SizedBox(height: AppSpacing.xs),
        Center(
          child: TextButton(
            onPressed: _close,
            child: const Text('Pas de reçu · vente suivante'),
          ),
        ),
      ],
    );
  }
}

/// Échec d'impression : la vente est confirmée enregistrée, puis Réessayer ·
/// Imprimer plus tard · Pas de reçu.
class _PrintFailure extends StatelessWidget {
  const _PrintFailure({
    required this.reason,
    required this.receiptNumber,
    required this.onRetry,
    required this.onConfigure,
    required this.onClose,
  });

  final PrintFailureReason reason;
  final int receiptNumber;
  final VoidCallback onRetry;
  final VoidCallback onConfigure;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final semantic = Theme.of(context).extension<AppSemanticColors>()!;
    final noPrinter = reason == PrintFailureReason.noPrinterConfigured;
    final message = switch (reason) {
      PrintFailureReason.noPrinterConfigured =>
        'Aucune imprimante appairée. Configurez-la une fois dans les '
            'paramètres.',
      PrintFailureReason.connectionFailed =>
        'L’imprimante ne répond pas. Vérifiez qu’elle est allumée, chargée '
            'et près du téléphone.',
      PrintFailureReason.sendFailed =>
        'L’impression a échoué. Réessayez dans un instant.',
    };
    final saved = receiptNumber > 0
        ? 'La vente n° $receiptNumber est bien enregistrée.'
        : 'La vente est bien enregistrée.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Ring(
          background: cs.errorContainer,
          foreground: cs.onErrorContainer,
          icon: Icons.print_disabled_outlined,
        ),
        const SizedBox(height: 14),
        const Text(
          'Reçu non imprimé',
          textAlign: TextAlign.center,
          style: AppTypography.titleLarge,
        ),
        const SizedBox(height: 6),
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(
            color: cs.onSurfaceVariant,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: semantic.successContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: semantic.onSuccessContainer,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  saved,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: semantic.onSuccessContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (noPrinter)
          PrimaryButton(
            label: 'Configurer l’imprimante',
            icon: Icons.settings_bluetooth,
            onPressed: onConfigure,
          )
        else
          PrimaryButton(
            label: 'Réessayer',
            icon: Icons.refresh,
            onPressed: onRetry,
          ),
        const SizedBox(height: 14),
        SecondaryButton(label: 'Imprimer plus tard', onPressed: onClose),
        const SizedBox(height: AppSpacing.xs),
        Center(
          child: TextButton(
            onPressed: onClose,
            child: const Text('Pas de reçu'),
          ),
        ),
      ],
    );
  }
}

/// Pastille d'icône 72 dp ; apparaît en 200 ms (0,8 → 1).
class _Ring extends StatelessWidget {
  const _Ring({
    required this.background,
    required this.foreground,
    required this.icon,
  });

  final Color background;
  final Color foreground;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.8, end: 1),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        builder: (context, scale, child) =>
            Transform.scale(scale: scale, child: child),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(color: background, shape: BoxShape.circle),
          child: Icon(icon, size: 40, color: foreground),
        ),
      ),
    );
  }
}
