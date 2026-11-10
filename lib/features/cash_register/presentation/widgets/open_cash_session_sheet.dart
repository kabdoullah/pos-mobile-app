import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../sales/presentation/widgets/amount_input.dart';
import '../cash_register_messages.dart';
import '../providers/cash_register_providers.dart';

/// Ouvre la feuille « Ouvrir la caisse ». Renvoie `true` si une session a
/// été ouverte.
Future<bool> showOpenCashSessionSheet(BuildContext context) async {
  final opened = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const OpenCashSessionSheet(),
  );
  return opened ?? false;
}

/// Feuille d'ouverture de caisse : fond de caisse et commentaire facultatif.
class OpenCashSessionSheet extends ConsumerStatefulWidget {
  /// Crée une [OpenCashSessionSheet].
  const OpenCashSessionSheet({super.key});

  @override
  ConsumerState<OpenCashSessionSheet> createState() =>
      _OpenCashSessionSheetState();
}

class _OpenCashSessionSheetState extends ConsumerState<OpenCashSessionSheet> {
  final _noteController = TextEditingController();
  Decimal? _amount;
  String? _error;
  bool _isLoading = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amount = _amount;
    if (amount == null) {
      setState(() => _error = 'Saisissez le fond de caisse.');
      return;
    }
    setState(() {
      _error = null;
      _isLoading = true;
    });
    try {
      await ref
          .read(cashRegisterControllerProvider.notifier)
          .open(openingAmount: amount, note: _noteController.text);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) setState(() => _error = cashRegisterErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Ouvrir la caisse',
                  style: AppTypography.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Comptez les espèces présentes dans le tiroir.',
                  style: AppTypography.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AmountInput(
                  label: 'Fond de caisse',
                  hint: '0',
                  value: _amount,
                  errorText: _error,
                  onChanged: (value) => setState(() {
                    _amount = value;
                    _error = null;
                  }),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Commentaire (facultatif)',
                  controller: _noteController,
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: 'Ouvrir la caisse',
                  icon: Icons.lock_open_outlined,
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
