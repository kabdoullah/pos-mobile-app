import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => CashMovementSheet(type: type),
  );
  return saved ?? false;
}

/// Feuille d'un mouvement d'espèces : sens (modifiable), montant, motif et
/// commentaire (obligatoire pour le motif « Autre »).
///
/// Une sortie supérieure au solde théorique du tiroir est refusée dès la
/// saisie : le message est sous le champ et le bouton est inactif (le use
/// case la refuse de toute façon).
class CashMovementSheet extends ConsumerStatefulWidget {
  /// Crée la feuille pour un mouvement de sens [type].
  const CashMovementSheet({required this.type, super.key});

  /// Sens présélectionné : entrée ou sortie.
  final CashMovementType type;

  @override
  ConsumerState<CashMovementSheet> createState() => _CashMovementSheetState();
}

class _CashMovementSheetState extends ConsumerState<CashMovementSheet> {
  final _noteController = TextEditingController();
  late CashMovementType _type = widget.type;
  Decimal? _amount;
  CashMovementReason? _reason;
  String? _amountError;
  String? _reasonError;
  String? _noteError;
  String? _formError;
  bool _isLoading = false;

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

  /// Solde théorique du tiroir, null tant qu'il n'est pas connu.
  Decimal? _drawerBalance() {
    final session = ref.watch(activeCashSessionProvider).value;
    if (session == null) return null;
    return ref.watch(cashSummaryProvider(session.id)).value?.expectedAmount;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final reasons = CashMovementReason.allowedFor(_type);
    final noteRequired = _reason == CashMovementReason.other;
    final formError = _formError;
    final reasonError = _reasonError;
    final amount = _amount;
    final balance = _drawerBalance();
    final exceedsDrawer =
        !_isIn && amount != null && balance != null && amount > balance;
    final amountError = exceedsDrawer
        ? 'Le tiroir ne contient que ${formatFcfa(balance)}.'
        : _amountError;
    final hasAmount = amount != null && amount > Decimal.zero;
    final submitLabel = switch ((_isIn, hasAmount)) {
      (true, true) => 'Ajouter ${formatFcfa(amount!)}',
      (false, true) => 'Retirer ${formatFcfa(amount!)}',
      (true, false) => "Enregistrer l'entrée",
      (false, false) => 'Enregistrer la sortie',
    };

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      child: SafeArea(
        top: false,
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
                  style: AppTypography.appBarTitle,
                ),
                const SizedBox(height: AppSpacing.md),
                SegmentedButton<CashMovementType>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: CashMovementType.cashIn,
                      label: Text('Entrée'),
                      icon: Icon(Icons.south_west),
                    ),
                    ButtonSegment(
                      value: CashMovementType.cashOut,
                      label: Text('Sortie'),
                      icon: Icon(Icons.north_east),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (selection) => setState(() {
                    _type = selection.single;
                    // Les motifs dépendent du sens.
                    if (!CashMovementReason.allowedFor(
                      _type,
                    ).contains(_reason)) {
                      _reason = null;
                    }
                    _amountError = null;
                    _reasonError = null;
                    _formError = null;
                  }),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _isIn
                      ? 'Argent ajouté dans le tiroir, hors ventes.'
                      : 'Argent retiré du tiroir, hors remboursements.',
                  style: AppTypography.bodySmall.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AmountInput(
                  label: 'Montant',
                  hint: '0',
                  large: true,
                  value: amount,
                  errorText: amountError,
                  onChanged: (value) => setState(() {
                    _amount = value;
                    _amountError = null;
                  }),
                ),
                const SizedBox(height: AppSpacing.md),
                const Text('Motif', style: AppTypography.labelLarge),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final reason in reasons)
                      ChoiceChip(
                        label: Text(cashMovementReasonLabel(reason)),
                        selected: _reason == reason,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        onSelected: (_) => setState(() {
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
                    style: AppTypography.errorText.copyWith(color: cs.error),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
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
                    style: AppTypography.errorText.copyWith(color: cs.error),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  label: submitLabel,
                  icon: _isIn ? Icons.south_west : Icons.north_east,
                  isLoading: _isLoading,
                  onPressed: _isLoading || exceedsDrawer ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
