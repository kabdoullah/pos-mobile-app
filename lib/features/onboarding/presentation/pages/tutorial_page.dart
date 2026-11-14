import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/index.dart';

/// Une diapositive du tutoriel : un vrai morceau de l'app en miniature, une
/// phrase utile et une astuce.
typedef _Slide = ({
  Widget Function() illustration,
  String title,
  String body,
  String tipTitle,
  String tip,
});

/// Tutoriel en 4 écrans concrets (produits, vente, reçu, suivi) : passable à
/// tout moment, « Précédent » pour revenir. Revu depuis les Paramètres, il se
/// termine par « Fermer » ; sinon il mène à l'accueil.
class TutorialPage extends StatefulWidget {
  /// Crée le tutoriel.
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final _controller = PageController();
  int _page = 0;

  static final List<_Slide> _slides = [
    (
      illustration: () => const _ProductIllustration(),
      title: 'Ajoutez vos produits',
      body:
          'Un nom et un prix suffisent. Le stock et le code-barres sont '
          'facultatifs.',
      tipTitle: 'Beaucoup de produits ?',
      tip: 'Importez-les d’un coup depuis un fichier Excel (Stock › Importer).',
    ),
    (
      illustration: () => const _SaleIllustration(),
      title: 'Ouvrez la caisse, puis vendez',
      body:
          'Chaque jour, ouvrez la caisse avec votre fond. Touchez un produit '
          'pour l’ajouter, puis encaissez.',
      tipTitle: 'Pas de réseau ?',
      tip:
          'Vous vendez quand même. Les ventes sont envoyées dès le retour de '
          'la connexion.',
    ),
    (
      illustration: () => const _ReceiptIllustration(),
      title: 'Remettez le reçu',
      body:
          'Imprimez-le sur votre imprimante Bluetooth, ou envoyez-le en PDF au '
          'client.',
      tipTitle: 'Le reçu est facultatif.',
      tip: 'Touchez « Nouvelle vente » pour servir le client suivant.',
    ),
    (
      illustration: () => const _FollowIllustration(),
      title: 'Suivez vos ventes',
      body:
          'L’Accueil résume la journée. L’Historique garde chaque vente : '
          'réimprimez un reçu ou enregistrez un retour.',
      tipTitle: 'Le soir,',
      tip:
          'clôturez la caisse : l’app compare les espèces comptées au solde '
          'attendu.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Revu depuis les Paramètres : on revient ; sinon, l'accueil.
  void _finish() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.home);
    }
  }

  void _goTo(int page) => unawaited(
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final total = _slides.length;
    final isLast = _page == total - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.xs,
                AppSpacing.xs,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${_page + 1} sur $total',
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textSecondary,
                        fontFeatures: AppTypography.tabularFigures,
                      ),
                    ),
                  ),
                  TextButton(onPressed: _finish, child: const Text('Passer')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Semantics(
                label: 'Écran ${_page + 1} sur $total',
                excludeSemantics: true,
                child: Row(
                  children: [
                    for (var i = 0; i < total; i++) ...[
                      if (i > 0) const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          height: 3,
                          decoration: BoxDecoration(
                            color: i <= _page ? colors.action : colors.border,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: total,
                onPageChanged: (page) => setState(() => _page = page),
                itemBuilder: (context, index) =>
                    _SlideView(slide: _slides[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  if (_page > 0) ...[
                    Expanded(
                      child: SecondaryButton(
                        label: 'Précédent',
                        onPressed: () => _goTo(_page - 1),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Expanded(
                    child: PrimaryButton(
                      label: !isLast
                          ? 'Suivant'
                          : context.canPop()
                          ? 'Fermer'
                          : 'Terminer',
                      onPressed: isLast ? _finish : () => _goTo(_page + 1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});

  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Miniature décorative : le texte dit l'essentiel.
          ExcludeSemantics(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surfaceSunken,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: slide.illustration(),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Semantics(
            header: true,
            child: Text(slide.title, style: AppTypography.figureLarge),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            slide.body,
            style: AppTypography.body.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border.all(color: colors.border),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm + 4),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${slide.tipTitle} ',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: slide.tip),
                  ],
                ),
                style: AppTypography.body.copyWith(fontSize: 15, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _fcfa(int amount) => formatFcfa(Decimal.fromInt(amount));

/// Carte blanche d'une miniature, lignes séparées par des filets.
class _MiniCard extends StatelessWidget {
  const _MiniCard({required this.rows});

  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Column(
        children: [
          for (final (i, row) in rows.indexed)
            DecoratedBox(
              decoration: BoxDecoration(
                border: i == rows.length - 1
                    ? null
                    : Border(bottom: BorderSide(color: colors.border)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm + 4,
                  vertical: AppSpacing.sm + 2,
                ),
                child: row,
              ),
            ),
        ],
      ),
    );
  }
}

/// Ligne libellé / valeur d'une miniature.
class _MiniRow extends StatelessWidget {
  const _MiniRow(this.label, this.value, {this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: AppTypography.meta.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor ?? colors.textPrimary,
            fontFeatures: AppTypography.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _ProductIllustration extends StatelessWidget {
  const _ProductIllustration();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return _MiniCard(
      rows: [
        const _MiniRow('Nom', 'Eau Awa 1.5L'),
        _MiniRow('Prix de vente', _fcfa(325)),
        const _MiniRow('Stock', '24'),
        _MiniRow('Code-barres', 'Scanner', valueColor: colors.action),
      ],
    );
  }
}

class _SaleIllustration extends StatelessWidget {
  const _SaleIllustration();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StatusIndicator(
          label: 'Caisse ouverte · fond ${_fcfa(10000)}',
          tone: StatusTone.success,
        ),
        const SizedBox(height: AppSpacing.sm),
        const _MiniCard(
          rows: [
            _MiniRow('Bacteril', '− 2 +'),
            _MiniRow('Eau Awa 1.5L', '− 3 +'),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.action,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
            child: Text(
              'Encaisser · ${_fcfa(2975)}',
              textAlign: TextAlign.center,
              style: AppTypography.labelLarge.copyWith(
                color: colors.onAction,
                fontFeatures: AppTypography.tabularFigures,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReceiptIllustration extends StatelessWidget {
  const _ReceiptIllustration();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    Widget outlined(String label) => Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(color: colors.borderStrong),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.meta.copyWith(color: colors.textPrimary),
          ),
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MiniCard(
          rows: [
            const _MiniRow('Reçu n° 1', ''),
            _MiniRow('Bacteril × 2', _fcfa(2000)),
            _MiniRow('Eau Awa × 3', _fcfa(975)),
            _MiniRow('Total', _fcfa(2975)),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            outlined('Imprimer'),
            const SizedBox(width: AppSpacing.sm),
            outlined('Reçu PDF'),
          ],
        ),
      ],
    );
  }
}

class _FollowIllustration extends StatelessWidget {
  const _FollowIllustration();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border.all(color: colors.border),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm + 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aujourd’hui · 2 ventes',
                  style: AppTypography.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                Text(_fcfa(14475), style: AppTypography.figureLarge),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _MiniCard(
          rows: [
            _MiniRow('Vente n° 2 · 10:35', _fcfa(11500)),
            _MiniRow('Vente n° 1 · 10:33', _fcfa(2975)),
          ],
        ),
      ],
    );
  }
}
