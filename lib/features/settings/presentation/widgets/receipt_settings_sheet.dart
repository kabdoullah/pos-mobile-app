import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/widgets/index.dart';
import '../../../auth/domain/entities/store.dart';
import '../../../../core/utils/phone_formatter.dart';
import '../../../auth/providers/seller_profile_provider.dart';
import '../../../auth/providers/store_provider.dart';

/// Longueur maximale du pied de reçu (colonne `receipt_footer_text` côté
/// serveur : 200 caractères).
const receiptFooterMaxLength = 200;

/// Ouvre la feuille de réglage des reçus pour [store].
Future<void> showReceiptSettingsSheet(BuildContext context, Store store) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => ReceiptSettingsSheet(store: store),
  );
}

/// Réglage du pied de reçu, avec aperçu du ticket en direct.
class ReceiptSettingsSheet extends ConsumerStatefulWidget {
  /// Crée la feuille pour [store].
  const ReceiptSettingsSheet({required this.store, super.key});

  /// Boutique dont on règle les reçus.
  final Store store;

  @override
  ConsumerState<ReceiptSettingsSheet> createState() =>
      _ReceiptSettingsSheetState();
}

class _ReceiptSettingsSheetState extends ConsumerState<ReceiptSettingsSheet> {
  late final _footerController = TextEditingController(
    text: widget.store.receiptFooterText ?? '',
  );
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _footerController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final footer = _footerController.text.trim();
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      // StoreConfig est keepAlive : l'écriture survit à la fermeture de la
      // feuille. L'enregistrement nécessite le réseau (PATCH boutique).
      await ref
          .read(storeConfigProvider.notifier)
          .save(
            widget.store.copyWith(
              receiptFooterText: footer.isEmpty ? null : footer,
            ),
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = errorToFrench(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final error = _error;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
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
              const Text('Reçus', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Nom, adresse, téléphone et NCC viennent de « Mon magasin » ; '
                'le vendeur, de « Mon compte ».',
                style: AppTypography.bodySmall.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _footerController,
                maxLength: receiptFooterMaxLength,
                maxLines: 3,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Pied de page',
                  hintText: 'Ex. : Ouvert 7j/7 — Tél. 07 00 00 00 00',
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Aperçu',
                style: AppTypography.labelMedium.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              _TicketPreview(
                store: widget.store,
                footer: _footerController.text.trim(),
                sellerName: ref.watch(sellerProfileProvider).value,
              ),
              if (error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  error,
                  style: AppTypography.bodySmall.copyWith(color: cs.error),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: 'Enregistrer',
                isLoading: _saving,
                onPressed: _saving ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Aperçu simplifié du ticket 58 mm (police à chasse fixe, centré).
class _TicketPreview extends StatelessWidget {
  const _TicketPreview({
    required this.store,
    required this.footer,
    required this.sellerName,
  });

  final Store store;
  final String footer;
  final String? sellerName;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final style = AppTypography.bodySmall.copyWith(
      fontFamily: 'monospace',
      color: cs.onSurface,
    );
    const separator = '--------------------------------';
    final address = store.address;
    final ncc = store.ncc;
    final phone = store.phone;
    final sellerName = this.sellerName;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: DefaultTextStyle(
          style: style,
          textAlign: TextAlign.center,
          child: Column(
            children: [
              Text(
                store.name,
                style: style.copyWith(fontWeight: FontWeight.bold),
              ),
              if (ncc != null && ncc.isNotEmpty) Text('NCC: $ncc'),
              if (address != null && address.isNotEmpty) Text(address),
              if (phone != null && phone.isNotEmpty)
                Text('Tél. ${formatPhoneCiDisplay(phone)}'),
              const Text(separator, maxLines: 1, overflow: TextOverflow.clip),
              if (sellerName != null && sellerName.isNotEmpty)
                Text('Vendeur : $sellerName'),
              const Text('… articles et total …'),
              const Text(separator, maxLines: 1, overflow: TextOverflow.clip),
              if (footer.isNotEmpty) Text(footer),
              const Text('Merci de votre visite !'),
            ],
          ),
        ),
      ),
    );
  }
}
