import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/router/app_router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/index.dart';

/// Carrousel de tutoriel pour l'onboarding.
///
/// 4 écrans présentent les fonctionnalités principales :
/// 1. Ajouter des produits
/// 2. Faire des ventes
/// 3. Imprimer des reçus
/// 4. Consulter l'historique des ventes
class TutorialPage extends StatefulWidget {
  /// Crée une page de tutoriel.
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
            // Bouton pour passer
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

            // Carrousel
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

            // Indicateurs de page
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

            // Bouton du bas
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

/// Widget d'un écran du tutoriel.
class _SlideBuilder extends StatelessWidget {
  const _SlideBuilder({
    required this.slide,
    required this.padding,
    required this.step,
    required this.totalSteps,
  });

  final TutorialSlide slide;
  final double padding;

  /// Position (à partir de 1) de cet écran dans le parcours (ex. `2`).
  final int step;

  /// Nombre total d'écrans — le nombre d'étapes du parcours.
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final color = slide.isAccent ? cs.secondary : cs.primary;
    return Center(
      // Défile si la diapositive ne tient pas (petit écran, grande police).
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône dessinée à la main — une par vraie action de caisse, pas un
            // pictogramme générique.
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

            // Surtitre — ces écrans suivent VRAIMENT l'ordre de travail d'un
            // commerçant, donc le numéro d'étape apporte une vraie information, ce
            // n'est pas de la décoration.
            Text(
              'ÉTAPE $step SUR $totalSteps',
              style: textTheme.labelSmall?.copyWith(
                color: color,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Titre — le seul endroit où l'onboarding a le droit d'être plus
            // expressif que les écrans sobres de l'usage quotidien.
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
                style: textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Représente un écran du tutoriel.
class TutorialSlide {
  /// Constructeur.
  const TutorialSlide({
    required this.title,
    required this.description,
    required this.iconPainter,
    this.isAccent = false,
  });

  /// Titre de l'écran.
  final String title;

  /// Description de l'écran.
  final String description;

  /// Construit l'icône dessinée à la main de l'écran, teintée de [Color].
  final CustomPainter Function(Color color) iconPainter;

  /// Utilise la couleur secondaire (accent) au lieu de la principale.
  final bool isAccent;
}

/// Base des icônes dessinées à la main du tutoriel — un langage visuel propre,
/// distinct du jeu d'icônes Material par défaut de l'app.
abstract class _LineIcon extends CustomPainter {
  const _LineIcon(this.color);

  /// Couleur du trait, dictée par la couleur de thème de l'écran (principale ou
  /// accent).
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

/// Icône stock — une caisse ouverte, en cours de déballage, avec une petite
/// marque « ajouter ».
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

/// Icône vente — un terminal portatif avec un signal de paiement.
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

/// Icône reçu — une imprimante d'où sort un ticket qui s'enroule.
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

/// Icône tendance des ventes — trois barres croissantes, l'écran
/// d'aboutissement.
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
