import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';

/// Préréglage rapide de plage de dates.
enum _DatePreset { today, yesterday, last7Days, thisMonth, custom }

/// Bottom sheet de filtre des ventes par date — préréglages rapides plus une
/// plage personnalisée explicite « Du / Au » (évite le [showDateRangePicker]
/// intégré de Flutter, dont le calendrier plein écran en deux taps est peu
/// clair).
class DateRangeFilterSheet extends StatefulWidget {
  /// Crée une [DateRangeFilterSheet].
  const DateRangeFilterSheet({required this.initialRange, super.key});

  /// Plage actuellement appliquée, utilisée pour présélectionner un préréglage
  /// ou les champs personnalisés.
  final DateTimeRange initialRange;

  @override
  State<DateRangeFilterSheet> createState() => _DateRangeFilterSheetState();
}

class _DateRangeFilterSheetState extends State<DateRangeFilterSheet> {
  late _DatePreset _preset;
  late DateTime _customStart;
  late DateTime _customEnd;

  @override
  void initState() {
    super.initState();
    _customStart = widget.initialRange.start;
    _customEnd = widget.initialRange.end;
    _preset = _presetFor(widget.initialRange) ?? _DatePreset.custom;
  }

  static _DatePreset? _presetFor(DateTimeRange range) {
    final today = _dateOnly(DateTime.now());
    if (_isSameDay(range.start, today) && _isSameDay(range.end, today)) {
      return _DatePreset.today;
    }
    final yesterday = today.subtract(const Duration(days: 1));
    if (_isSameDay(range.start, yesterday) &&
        _isSameDay(range.end, yesterday)) {
      return _DatePreset.yesterday;
    }
    final last7Start = today.subtract(const Duration(days: 6));
    if (_isSameDay(range.start, last7Start) && _isSameDay(range.end, today)) {
      return _DatePreset.last7Days;
    }
    final monthStart = DateTime(today.year, today.month);
    if (_isSameDay(range.start, monthStart) && _isSameDay(range.end, today)) {
      return _DatePreset.thisMonth;
    }
    return null;
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _selectPreset(_DatePreset preset) {
    if (preset == _DatePreset.custom) {
      setState(() => _preset = preset);
      return;
    }
    final today = _dateOnly(DateTime.now());
    final range = switch (preset) {
      _DatePreset.today => DateTimeRange(start: today, end: today),
      _DatePreset.yesterday => DateTimeRange(
        start: today.subtract(const Duration(days: 1)),
        end: today.subtract(const Duration(days: 1)),
      ),
      _DatePreset.last7Days => DateTimeRange(
        start: today.subtract(const Duration(days: 6)),
        end: today,
      ),
      _DatePreset.thisMonth => DateTimeRange(
        start: DateTime(today.year, today.month),
        end: today,
      ),
      _DatePreset.custom => DateTimeRange(start: _customStart, end: _customEnd),
    };
    Navigator.of(context).pop(range);
  }

  Future<void> _pickCustomDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _customStart : _customEnd,
      firstDate: isStart
          ? now.subtract(const Duration(days: 90))
          : _customStart,
      lastDate: now,
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (isStart) {
        _customStart = picked;
        if (_customEnd.isBefore(_customStart)) _customEnd = _customStart;
      } else {
        _customEnd = picked;
      }
    });
  }

  void _applyCustomRange() {
    Navigator.of(
      context,
    ).pop(DateTimeRange(start: _customStart, end: _customEnd));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dateFormat = DateFormat('dd MMM yyyy', 'fr_FR');

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
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'Filtrer par période',
                style: AppTypography.titleMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _presetChip('Aujourd\'hui', _DatePreset.today),
                  _presetChip('Hier', _DatePreset.yesterday),
                  _presetChip('7 derniers jours', _DatePreset.last7Days),
                  _presetChip('Ce mois-ci', _DatePreset.thisMonth),
                  _presetChip('Personnalisé', _DatePreset.custom),
                ],
              ),
              if (_preset == _DatePreset.custom) ...[
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: _CustomDateField(
                        label: 'Du',
                        value: dateFormat.format(_customStart),
                        onTap: () => _pickCustomDate(isStart: true),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _CustomDateField(
                        label: 'Au',
                        value: dateFormat.format(_customEnd),
                        onTap: () => _pickCustomDate(isStart: false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(label: 'Appliquer', onPressed: _applyCustomRange),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _presetChip(String label, _DatePreset preset) {
    return ChoiceChip(
      label: Text(label),
      selected: _preset == preset,
      showCheckmark: false,
      onSelected: (_) => _selectPreset(preset),
    );
  }
}

class _CustomDateField extends StatelessWidget {
  const _CustomDateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: cs.outlineVariant),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today, size: 16, color: cs.primary),
                const SizedBox(width: AppSpacing.xs),
                Text(value, style: AppTypography.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
