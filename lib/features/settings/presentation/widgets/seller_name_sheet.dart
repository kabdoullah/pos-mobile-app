import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/error_mapper.dart';
import '../../../../core/widgets/index.dart';
import '../../../auth/providers/seller_profile_provider.dart';

/// Longueur maximale du nom du vendeur (colonne serveur : 80).
const sellerNameMaxLength = 80;

/// Ouvre la feuille de saisie du nom du vendeur imprimé sur les reçus.
Future<void> showSellerNameSheet(BuildContext context, String? current) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => SellerNameSheet(initialName: current),
  );
}

/// Nom affiché « Vendeur : … » sur les reçus (vide = ligne retirée).
class SellerNameSheet extends ConsumerStatefulWidget {
  /// Crée la feuille avec le nom actuel.
  const SellerNameSheet({required this.initialName, super.key});

  /// Nom actuellement enregistré.
  final String? initialName;

  @override
  ConsumerState<SellerNameSheet> createState() => _SellerNameSheetState();
}

class _SellerNameSheetState extends ConsumerState<SellerNameSheet> {
  late final _controller = TextEditingController(
    text: widget.initialName ?? '',
  );
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      // SellerProfile est keepAlive : l'écriture survit à la fermeture.
      await ref.read(sellerProfileProvider.notifier).save(_controller.text);
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
              const Text('Nom du vendeur', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Imprimé « Vendeur : … » sur les reçus. Laissez vide pour ne '
                'pas l’afficher.',
                style: AppTypography.bodySmall.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _controller,
                autofocus: true,
                maxLength: sellerNameMaxLength,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  hintText: 'Ex. : Awa',
                ),
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
