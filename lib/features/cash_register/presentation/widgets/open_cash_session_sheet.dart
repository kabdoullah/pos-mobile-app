import 'package:clock/clock.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';
import '../../../sales/presentation/widgets/amount_input.dart';
import '../../domain/entities/cash_session.dart';
import '../../domain/repositories/cash_register_repository.dart';
import '../cash_register_messages.dart';
import '../providers/cash_register_providers.dart';

/// Ouvre la feuille « Ouvrir la caisse ». Renvoie `true` si une session a
/// été ouverte.
Future<bool> showOpenCashSessionSheet(BuildContext context) async {
  final opened = await showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const OpenCashSessionSheet(),
  );
  return opened ?? false;
}

/// Feuille d'ouverture de caisse : fond de caisse en grand (avec le montant
/// de la dernière clôture en raccourci) et commentaire facultatif.
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
  String? _amountError;
  String? _noteError;
  String? _formError;
  bool _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final formError = _formError;
    final amount = _amount;
    // Suggestions : le montant compté à la dernière clôture (le tiroir n'a en
    // principe pas bougé depuis) et 0.
    final lastClosed = ref
        .watch(localCashSessionHistoryProvider)
        .value
        ?.where((s) => s.status == CashSessionStatus.closed)
        .firstOrNull;
    final lastCounted = lastClosed?.countedAmount;
    final suggestions = <(String, Decimal)>[
      if (lastCounted != null && lastCounted > Decimal.zero)
        (
          '${_lastCloseLabel(lastClosed?.closedAt)} : '
              '${formatAmount(lastCounted)}',
          lastCounted,
        ),
      ('0', Decimal.zero),
    ];

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
                  'Ouvrir la caisse',
                  style: AppTypography.appBarTitle,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Comptez les espèces présentes dans le tiroir.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AmountInput(
                  label: 'Fond de caisse',
                  hint: '0',
                  large: true,
                  value: amount,
                  errorText: _amountError,
                  onChanged: (value) => setState(() {
                    _amount = value;
                    _amountError = null;
                  }),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final (label, value) in suggestions)
                      ChoiceChip(
                        label: Text(label),
                        selected: amount == value,
                        onSelected: (_) => setState(() {
                          _amount = value;
                          _amountError = null;
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (_showNote)
                  AppTextField(
                    label: 'Commentaire (facultatif)',
                    controller: _noteController,
                    errorText: _noteError,
                    maxLines: 2,
                    maxLength: CashRegisterException.maxNoteLength,
                  )
                else
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size(0, AppSpacing.buttonHeightSm),
                      ),
                      onPressed: () => setState(() => _showNote = true),
                      child: const Text('Ajouter un commentaire'),
                    ),
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
                  label: amount == null
                      ? 'Ouvrir la caisse'
                      : 'Ouvrir avec ${formatFcfa(amount)}',
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

/// « Comme hier soir » si la dernière clôture date de la veille, sinon
/// « Dernière clôture ».
String _lastCloseLabel(DateTime? closedAt) {
  if (closedAt == null) return 'Dernière clôture';
  final local = closedAt.toLocal();
  final now = clock.now();
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final isYesterday =
      local.year == yesterday.year &&
      local.month == yesterday.month &&
      local.day == yesterday.day;
  return isYesterday ? 'Comme hier soir' : 'Dernière clôture';
}
