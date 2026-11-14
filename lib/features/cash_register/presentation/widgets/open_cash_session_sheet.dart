import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../sales/presentation/widgets/amount_input.dart';
import '../../domain/repositories/cash_register_repository.dart';
import '../cash_register_messages.dart';
import '../providers/cash_register_providers.dart';

/// Ouvre la feuille « Ouvrir la caisse ». Renvoie `true` si une session a
/// été ouverte.
///
/// [title] et [message] remplacent l'en-tête quand l'ouverture interrompt
/// une action (encaisser, rembourser) : on dit pourquoi la caisse est
/// demandée et que rien n'a été enregistré.
Future<bool> showOpenCashSessionSheet(
  BuildContext context, {
  String? title,
  String? message,
}) async {
  final opened = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (_) => OpenCashSessionSheet(title: title, message: message),
  );
  return opened ?? false;
}

/// Feuille d'ouverture de caisse : fond de caisse et commentaire facultatif.
class OpenCashSessionSheet extends ConsumerStatefulWidget {
  /// Crée une [OpenCashSessionSheet].
  const OpenCashSessionSheet({this.title, this.message, super.key});

  /// Titre contextuel, « Ouvrir la caisse » par défaut.
  final String? title;

  /// Explication contextuelle, consigne de comptage par défaut.
  final String? message;

  @override
  ConsumerState<OpenCashSessionSheet> createState() =>
      _OpenCashSessionSheetState();
}

class _OpenCashSessionSheetState extends ConsumerState<OpenCashSessionSheet> {
  final _noteController = TextEditingController();
  Decimal? _amount;
  String? _amountError;
  String? _noteError;
  String? _formError;
  bool _isLoading = false;

  /// Champ commentaire affiché (replié par défaut : facultatif).
  bool _showNote = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amount = _amount;
    if (amount == null) {
      setState(() => _amountError = 'Saisissez le fond de caisse.');
      return;
    }
    setState(() {
      _amountError = null;
      _noteError = null;
      _formError = null;
      _isLoading = true;
    });
    try {
      await ref
          .read(cashRegisterControllerProvider.notifier)
          .open(openingAmount: amount, note: _noteController.text);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      // Erreur de saisie sous son champ ; refus (caisse déjà ouverte, réseau)
      // au-dessus du bouton.
      final message = cashRegisterErrorMessage(e);
      final code = e is CashRegisterException ? e.code : null;
      setState(() {
        switch (code) {
          case CashRegisterException.invalidAmount:
            _amountError = message;
          case CashRegisterException.noteTooLong:
            _noteError = message;
          default:
            _formError = message;
        }
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _setAmount(Decimal? value) => setState(() {
    _amount = value;
    _amountError = null;
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final formError = _formError;
    final amount = _amount;
    // « Comme hier soir » : le montant compté à la dernière clôture.
    final lastCounted = lastClosedSession(
      ref.watch(localCashSessionHistoryProvider).value,
    )?.countedAmount;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.lg,
          bottom: AppSpacing.md + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.title ?? 'Ouvrir la caisse',
                style: AppTypography.sectionTitle,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                widget.message ??
                    'Comptez les espèces présentes dans le tiroir et '
                        'saisissez le total.',
                style: AppTypography.body.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
              AmountInput(
                label: 'Fond de caisse',
                hint: '0',
                value: amount,
                errorText: _amountError,
                large: true,
                onChanged: _setAmount,
              ),
              const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  if (lastCounted != null && lastCounted > Decimal.zero)
                    QuickChoiceButton(
                      label:
                          'Comme à la dernière clôture · '
                          '${formatAmount(lastCounted)}',
                      isSelected: amount == lastCounted,
                      onTap: () => _setAmount(lastCounted),
                    ),
                  QuickChoiceButton(
                    label: '0',
                    isSelected: amount == Decimal.zero,
                    onTap: () => _setAmount(Decimal.zero),
                  ),
                ],
              ),
              if (_showNote) ...[
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Commentaire (facultatif)',
                  controller: _noteController,
                  errorText: _noteError,
                  maxLines: 2,
                  maxLength: CashRegisterException.maxNoteLength,
                ),
              ] else
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => setState(() => _showNote = true),
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Ajouter un commentaire'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm,
                      ),
                    ),
                  ),
                ),
              if (formError != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  formError,
                  style: AppTypography.errorText.copyWith(color: colors.error),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: amount == null
                    ? 'Ouvrir la caisse'
                    : 'Ouvrir avec ${formatFcfa(amount)}',
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
