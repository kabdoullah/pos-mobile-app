import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/index.dart';

/// Tutorial carousel for onboarding.
///
/// 4 slides introducing core features:
/// 1. Add products
/// 2. Make sales
/// 3. Print receipts
/// 4. View sales history
class TutorialPage extends StatefulWidget {
  /// Creates a tutorial page.
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  late PageController _pageController;
  int _currentPage = 0;

  static const List<TutorialSlide> _slides = [
    TutorialSlide(
      title: 'Ajouter des produits',
      description: 'Gérez votre catalogue directement dans l\'app.',
      iconPainter: _StockIcon.new,
    ),
    TutorialSlide(
      title: 'Faire une vente',
      description: 'Sélectionnez les articles et encaissez rapidement.',
      iconPainter: _SaleIcon.new,
    ),
    TutorialSlide(
      title: 'Imprimer le reçu',
      description: 'Connectez votre imprimante thermique sans fil.',
      iconPainter: _ReceiptIcon.new,
    ),
    TutorialSlide(
      title: 'Consulter mes ventes',
      description: 'Suivez vos revenus en temps réel et hors ligne.',
      iconPainter: _TrendIcon.new,
      isAccent: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextSlide() {
    if (_currentPage < _slides.length - 1) {
      unawaited(
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        ),
      );
    } else {
      if (mounted) {
        context.go(Routes.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✨ un seul lookup — partagé par bouton Passer et dots
    final cs = Theme.of(context).colorScheme;
    final padding = responsiveValue(
      context,
      small: AppSpacing.md,
      medium: AppSpacing.lg,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Dismiss button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: TextButton.icon(
                  onPressed: () => context.go(Routes.home),
                  // ✨ foregroundColor héritée par icon et label — supprime 3 Theme.of calls
                  style: TextButton.styleFrom(
                    foregroundColor: cs.onSurfaceVariant,
                  ),
                  icon: const Icon(Icons.close),
                  label: const Text('Passer'),
                ),
              ),
            ),

            // Carousel
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return _SlideBuilder(
                    slide: slide,
                    padding: padding,
                    step: index + 1,
                    totalSteps: _slides.length,
                  );
                },
              ),
            ),

            // Page indicators
            Padding(
              padding: EdgeInsets.symmetric(vertical: padding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => Semantics(
                    // ✨ annonce la position pour le lecteur d'écran
                    label: 'Diapositive ${index + 1} sur ${_slides.length}',
                    selected: _currentPage == index,
                    excludeSemantics: true,
                    child: AnimatedContainer(
                      // ✨ transition fluide 8→28px au lieu d'un saut instantané
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: _currentPage == index ? 28 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentPage == index ? cs.primary : cs.outline,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: EdgeInsets.all(padding),
              child: PrimaryButton(
                label: _currentPage == _slides.length - 1
                    ? 'Commencer'
                    : 'Suivant',
                onPressed: _nextSlide,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tutorial slide widget.
class _SlideBuilder extends StatelessWidget {
  const _SlideBuilder({
    required this.slide,
    required this.padding,
    required this.step,
    required this.totalSteps,
  });

  final TutorialSlide slide;
  final double padding;

  /// 1-indexed position of this slide in the workflow (e.g. `2`).
  final int step;

  /// Total number of slides — the workflow's step count.
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final color = slide.isAccent ? cs.secondary : cs.primary;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Hand-drawn line icon — one per real POS action, not a stock glyph.
        Container(
          width: 120,
          height: 120,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: CustomPaint(
            size: const Size(60, 60),
            painter: slide.iconPainter(color),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Eyebrow — these slides ARE the real order a merchant works in,
        // so the step count carries real information, not decoration.
        Text(
          'ÉTAPE $step SUR $totalSteps',
          style: textTheme.labelSmall?.copyWith(
            color: color,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Title — the one place onboarding is allowed to be louder than
        // the app's restrained daily-use screens.
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Text(
            slide.title,
            style: textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Description
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Text(
            slide.description,
            style: textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

/// Represents a single tutorial slide.
class TutorialSlide {
  /// Constructor.
  const TutorialSlide({
    required this.title,
    required this.description,
    required this.iconPainter,
    this.isAccent = false,
  });

  /// Slide title.
  final String title;

  /// Slide description.
  final String description;

  /// Builds the slide's hand-drawn line icon, tinted [Color].
  final CustomPainter Function(Color color) iconPainter;

  /// Whether to use secondary (accent) color instead of primary.
  final bool isAccent;
}

/// Base for the tutorial's hand-drawn line icons — one visual language,
/// distinct from the app's default Material icon set.
abstract class _LineIcon extends CustomPainter {
  const _LineIcon(this.color);

  /// Stroke color, driven by the slide's theme color (primary or accent).
  final Color color;

  Paint get _stroke => Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.75
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  Paint get _fill => Paint()
    ..color = color
    ..style = PaintingStyle.fill;

  @override
  bool shouldRepaint(covariant _LineIcon oldDelegate) =>
      oldDelegate.color != color;
}

/// Stock icon — an open crate, mid-unpack, with a small "add" mark.
class _StockIcon extends _LineIcon {
  const _StockIcon(super.color);

  @override
  void paint(Canvas canvas, Size size) {
    final crate = Path()
      ..moveTo(10, 22)
      ..lineTo(18, 12)
      ..moveTo(36, 22)
      ..lineTo(28, 12)
      ..moveTo(8, 22)
      ..lineTo(38, 22)
      ..lineTo(38, 42)
      ..lineTo(8, 42)
      ..close()
      ..moveTo(8, 30)
      ..lineTo(38, 30);
    canvas.drawPath(crate, _stroke);

    canvas.drawCircle(const Offset(48, 14), 8, _stroke);
    canvas.drawLine(const Offset(44, 14), const Offset(52, 14), _stroke);
    canvas.drawLine(const Offset(48, 10), const Offset(48, 18), _stroke);
  }
}

/// Sale icon — a hand-held terminal with a payment signal.
class _SaleIcon extends _LineIcon {
  const _SaleIcon(super.color);

  @override
  void paint(Canvas canvas, Size size) {
    final body = RRect.fromRectAndRadius(
      const Rect.fromLTRB(14, 8, 38, 50),
      const Radius.circular(6),
    );
    canvas.drawRRect(body, _stroke);
    canvas.drawLine(const Offset(18, 18), const Offset(34, 18), _stroke);
    canvas.drawCircle(const Offset(26, 42), 2, _fill);

    for (final radius in [6.0, 11.0]) {
      canvas.drawArc(
        Rect.fromCircle(center: const Offset(44, 8), radius: radius),
        -1.0,
        1.4,
        false,
        _stroke,
      );
    }
  }
}

/// Receipt icon — a printer with the paper strip curling out.
class _ReceiptIcon extends _LineIcon {
  const _ReceiptIcon(super.color);

  @override
  void paint(Canvas canvas, Size size) {
    final printer = RRect.fromRectAndCorners(
      const Rect.fromLTRB(9, 14, 43, 28),
      topLeft: const Radius.circular(5),
      topRight: const Radius.circular(5),
    );
    canvas.drawRRect(printer, _stroke);

    final receipt = Path()
      ..moveTo(15, 28)
      ..lineTo(15, 40)
      ..lineTo(20, 45)
      ..lineTo(25, 40)
      ..lineTo(30, 45)
      ..lineTo(37, 40)
      ..lineTo(37, 28);
    canvas.drawPath(receipt, _stroke);

    canvas.drawLine(const Offset(19, 33), const Offset(33, 33), _stroke);
    canvas.drawLine(const Offset(19, 37), const Offset(29, 37), _stroke);
  }
}

/// Sales-trend icon — three rising bars, the payoff slide.
class _TrendIcon extends _LineIcon {
  const _TrendIcon(super.color);

  @override
  void paint(Canvas canvas, Size size) {
    const baseline = 46.0;
    final bars = [
      const Rect.fromLTRB(10, 34, 20, baseline),
      const Rect.fromLTRB(25, 24, 35, baseline),
      const Rect.fromLTRB(40, 12, 50, baseline),
    ];
    for (final bar in bars) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(bar, const Radius.circular(2)),
        _stroke,
      );
    }
    canvas.drawCircle(const Offset(45, 8), 2.5, _fill);
  }
}
