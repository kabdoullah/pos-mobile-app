import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../sales/presentation/widgets/amount_input.dart';
import '../../domain/entities/cash_labels.dart';
import '../../domain/entities/cash_movement.dart';
import '../../domain/repositories/cash_register_repository.dart';
import '../cash_register_messages.dart';
import '../providers/cash_register_providers.dart';

/// Ouvre la feuille d'entrée ou de sortie d'espèces selon [type]. Renvoie
/// `true` si le mouvement a été enregistré.
Future<bool> showCashMovementSheet(
  BuildContext context,
  CashMovementType type,
) async {
  final saved = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (_) => CashMovementSheet(type: type),
  );
  return saved ?? false;
}

/// Feuille « Mouvement d'espèces » : sens (Entrée / Sortie), montant, motif
/// et précision (obligatoire pour le motif « Autre »). Une sortie supérieure
/// au solde du tiroir est expliquée et bloquée dès la saisie.
class CashMovementSheet extends ConsumerStatefulWidget {
  /// Crée la feuille, ouverte sur le sens [type].
  const CashMovementSheet({required this.type, super.key});

  /// Sens proposé à l'ouverture (entrée ou sortie).
  final CashMovementType type;

  @override
  ConsumerState<CashMovementSheet> createState() => _CashMovementSheetState();
}

class _CashMovementSheetState extends ConsumerState<CashMovementSheet> {
  final _noteController = TextEditingController();
  Decimal? _amount;
  CashMovementReason? _reason;
  String? _amountError;
  String? _reasonError;
  String? _noteError;
  String? _formError;
  bool _isLoading = false;

  /// Sens choisi (modifiable dans la feuille).
  late CashMovementType _type = widget.type;

  bool get _isIn => _type == CashMovementType.cashIn;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amount = _amount;
    final reason = _reason;
    final noteRequired = reason == CashMovementReason.other;
    setState(() {
      _amountError = amount == null || amount <= Decimal.zero
          ? 'Saisissez un montant.'
          : null;
      _reasonError = reason == null ? 'Choisissez un motif.' : null;
      _noteError = noteRequired && _noteController.text.trim().isEmpty
          ? 'Précisez le motif.'
          : null;
      _formError = null;
    });
    if (_amountError != null || _reasonError != null || _noteError != null) {
      return;
    }
    setState(() => _isLoading = true);
    try {
      await ref
          .read(cashRegisterControllerProvider.notifier)
          .recordMovement(
            type: _type,
            reason: reason!,
            amount: amount!,
            note: _noteController.text,
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      final message = cashRegisterErrorMessage(e);
      final code = e is CashRegisterException ? e.code : null;
      setState(() {
        switch (code) {
          case CashRegisterException.invalidAmount ||
              CashRegisterException.insufficientCash:
            _amountError = message;
          case CashRegisterException.noteRequired ||
              CashRegisterException.noteTooLong:
            _noteError = message;
          case CashRegisterException.reasonTypeMismatch:
            _reasonError = message;
          default:
            _formError = message;
        }
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final reasons = CashMovementReason.allowedFor(_type);
    final noteRequired = _reason == CashMovementReason.other;
    final formError = _formError;
    final reasonError = _reasonError;
    final amount = _amount;
    // Solde du tiroir : une sortie ne peut pas le dépasser (même règle que le
    // use case, vérifiée ici pendant la saisie).
    final sessionId = ref.watch(activeCashSessionProvider).value?.id;
    final balance = sessionId == null
        ? null
        : ref.watch(cashSummaryProvider(sessionId)).value?.expectedAmount;
    final exceedsBalance =
        !_isIn && amount != null && balance != null && amount > balance;
    final amountError = exceedsBalance
        ? 'Le tiroir contient ${formatFcfa(balance)}. Une sortie ne peut pas '
              'dépasser ce montant.'
        : _amountError;

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
              const Text(
                "Mouvement d'espèces",
                style: AppTypography.sectionTitle,
              ),
              const SizedBox(height: AppSpacing.md),
              SegmentedControl<CashMovementType>(
                segments: const [
                  (value: CashMovementType.cashIn, label: 'Entrée'),
                  (value: CashMovementType.cashOut, label: 'Sortie'),
                ],
                selected: _type,
                onChanged: (type) => setState(() {
                  if (type == _type) return;
                  _type = type;
                  // Les motifs dépendent du sens.
                  _reason = null;
                  _reasonError = null;
                  _amountError = null;
                }),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _isIn
                    ? 'Argent ajouté dans le tiroir, hors ventes.'
                    : 'Argent retiré du tiroir, hors remboursements.',
                style: AppTypography.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AmountInput(
                label: 'Montant',
                hint: '0',
                value: amount,
                errorText: amountError,
                large: true,
                onChanged: (value) => setState(() {
                  _amount = value;
                  _amountError = null;
                }),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text('Motif', style: AppTypography.bodyStrong),
              const SizedBox(height: AppSpacing.xs + 2),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final reason in reasons)
                    QuickChoiceButton(
                      label: cashMovementReasonLabel(reason),
                      isSelected: _reason == reason,
                      onTap: () => setState(() {
                        _reason = reason;
                        _reasonError = null;
                        _noteError = null;
                      }),
                    ),
                ],
              ),
              if (reasonError != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  reasonError,
                  style: AppTypography.errorText.copyWith(color: colors.error),
                ),
              ],
              const SizedBox(height: AppSpacing.sm + AppSpacing.xs),
              AppTextField(
                label: noteRequired
                    ? 'Préciser (obligatoire)'
                    : 'Préciser (facultatif)',
                controller: _noteController,
                errorText: _noteError,
                maxLines: 2,
                maxLength: CashRegisterException.maxNoteLength,
                onChanged: (_) {
                  if (_noteError != null) setState(() => _noteError = null);
                },
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
                label: amount == null || amount <= Decimal.zero
                    ? (_isIn ? "Enregistrer l'entrée" : 'Enregistrer la sortie')
                    : _isIn
                    ? 'Ajouter ${formatFcfa(amount)}'
                    : 'Retirer ${formatFcfa(amount)}',
                isLoading: _isLoading,
                onPressed: _isLoading || exceedsBalance ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
