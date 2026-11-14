import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/index.dart';

/// Préréglage rapide de plage de dates.
enum _DatePreset { today, yesterday, last7Days, thisMonth, custom }

/// Libellé court d'une période (« Aujourd'hui », « Hier »…), ou ses dates
/// pour une période personnalisée.
String periodLabel(DateTimeRange range) {
  return switch (_DateRangeFilterSheetState._presetFor(range)) {
    _DatePreset.today => "Aujourd'hui",
    _DatePreset.yesterday => 'Hier',
    _DatePreset.last7Days => '7 derniers jours',
    _DatePreset.thisMonth => 'Ce mois-ci',
    _DatePreset.custom || null => _formatRange(range),
  };
}

String _formatRange(DateTimeRange range) {
  final format = DateFormat('d MMM', 'fr_FR');
  final start = format.format(range.start);
  final end = format.format(range.end);
  return start == end ? start : '$start – $end';
}

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
    final dateFormat = DateFormat('dd/MM/yyyy', 'fr_FR');
    const presets = [
      (preset: _DatePreset.today, label: 'Aujourd’hui'),
      (preset: _DatePreset.yesterday, label: 'Hier'),
      (preset: _DatePreset.last7Days, label: '7 derniers jours'),
      (preset: _DatePreset.thisMonth, label: 'Ce mois-ci'),
      (preset: _DatePreset.custom, label: 'Personnalisé'),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Période', style: AppTypography.sectionTitle),
              const SizedBox(height: AppSpacing.md),
              // Choix unique : liste à puces radio (pas de chips), une
              // période rapide s'applique dès qu'on la touche.
              AppListGroup(
                dividerIndent: 0,
                children: [
                  for (final p in presets)
                    _PeriodOption(
                      label: p.label,
                      isSelected: _preset == p.preset,
                      onTap: () => _selectPreset(p.preset),
                    ),
                ],
              ),
              if (_preset == _DatePreset.custom) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _DateField(
                        label: 'Du',
                        value: dateFormat.format(_customStart),
                        onTap: () => _pickCustomDate(isStart: true),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _DateField(
                        label: 'Au',
                        value: dateFormat.format(_customEnd),
                        onTap: () => _pickCustomDate(isStart: false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: 'Afficher les ventes',
                  onPressed: _applyCustomRange,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Ligne d'une liste à choix unique : puce radio dessinée (cercle à bord
/// fort, plein trait d'action quand choisi) et libellé.
class _PeriodOption extends StatelessWidget {
  const _PeriodOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Semantics(
      inMutuallyExclusiveGroup: true,
      selected: isSelected,
      button: true,
      excludeSemantics: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? colors.action : colors.borderStrong,
                      width: isSelected ? 6 : 2,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
                Expanded(
                  child: Text(
                    label,
                    style: isSelected
                        ? AppTypography.body.copyWith(
                            fontWeight: FontWeight.w600,
                          )
                        : AppTypography.body,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Champ de date : libellé au-dessus, boîte de champ 48 dp ; ouvre le
/// sélecteur de date.
class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final radius = BorderRadius.circular(AppSpacing.radiusSm);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppTypography.bodyStrong),
        const SizedBox(height: 6),
        Semantics(
          button: true,
          label: '$label : $value',
          excludeSemantics: true,
          child: Material(
            color: colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: radius,
              side: BorderSide(color: colors.borderStrong),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: radius,
              child: Container(
                height: AppSpacing.inputHeight,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: AppTypography.body.copyWith(
                    color: colors.textPrimary,
                    fontFeatures: AppTypography.tabularFigures,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
