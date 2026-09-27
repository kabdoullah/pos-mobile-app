import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

/// Champ de saisie accessible avec libellé permanent.
///
/// Le libellé reste toujours visible au-dessus du champ pour ne pas perdre les
/// utilisateurs peu à l'aise avec la lecture. Bordures épaisses et grande zone
/// tactile (56 dp minimum).
class AppTextField extends StatefulWidget {
  /// Crée un champ de saisie.
  const AppTextField({
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction,
    this.onSubmitted,
    this.autofillHints,
    this.helper,
    super.key,
  });

  /// Libellé affiché au-dessus du champ (toujours visible).
  final String label;

  /// Texte d'indice affiché dans le champ quand il est vide.
  final String? hint;

  /// Contrôleur d'édition du texte.
  final TextEditingController? controller;

  /// Type de clavier pour la saisie.
  final TextInputType keyboardType;

  /// Masque ou non le texte (pour les mots de passe).
  final bool obscureText;

  /// Message d'erreur affiché sous le champ. Si null, pas d'état d'erreur.
  final String? errorText;

  /// Icône affichée au début du champ.
  final IconData? prefixIcon;

  /// Icône affichée à la fin du champ.
  final IconData? suffixIcon;

  /// Formateurs de saisie appliqués au champ (ex.
  /// [FilteringTextInputFormatter.digitsOnly]).
  final List<TextInputFormatter>? inputFormatters;

  /// Callback quand le texte change.
  final ValueChanged<String>? onChanged;

  /// Nombre de lignes (1 par défaut pour une saisie sur une ligne).
  final int maxLines;

  /// Nombre minimal de lignes pour une saisie multiligne.
  final int? minLines;

  /// Action du bouton de validation du clavier (suivant, terminé…).
  final TextInputAction? textInputAction;

  /// Callback à la validation depuis le clavier.
  final ValueChanged<String>? onSubmitted;

  /// Indices de saisie automatique (gestionnaire de mots de passe).
  final Iterable<String>? autofillHints;

  /// Aide affichée sous le champ quand il n'y a pas d'erreur (règles de
  /// saisie, confirmation de validité).
  final Widget? helper;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
    _isObscured = widget.obscureText;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final borderColor = hasError ? cs.error : cs.outline;
    final activeBorderColor = hasError ? cs.error : cs.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTypography.labelMedium.copyWith(color: cs.onSurface),
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: widget.maxLines == 1 ? 56 : null,
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: _isObscured,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            textInputAction: widget.textInputAction,
            onSubmitted: widget.onSubmitted,
            autofillHints: widget.autofillHints,
            style: AppTypography.bodyMedium.copyWith(color: cs.onSurface),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTypography.hintText.copyWith(
                color: cs.onSurfaceVariant,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: cs.onSurfaceVariant)
                  : null,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      tooltip: _isObscured
                          ? 'Afficher le mot de passe'
                          : 'Masquer le mot de passe',
                      icon: Icon(
                        _isObscured
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: cs.onSurfaceVariant,
                      ),
                      onPressed: () =>
                          setState(() => _isObscured = !_isObscured),
                    )
                  : (widget.suffixIcon != null
                        ? Icon(widget.suffixIcon, color: cs.onSurfaceVariant)
                        : null),
              filled: true,
              fillColor: cs.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(color: activeBorderColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(color: cs.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(color: cs.error),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          // Icône + texte : l'erreur ne repose pas que sur la couleur.
          Semantics(
            liveRegion: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExcludeSemantics(
                  child: Icon(Icons.error_outline, size: 16, color: cs.error),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    widget.errorText!,
                    style: AppTypography.errorText.copyWith(color: cs.error),
                  ),
                ),
              ],
            ),
          ),
        ] else if (widget.helper != null) ...[
          const SizedBox(height: AppSpacing.xs),
          widget.helper!,
        ],
      ],
    );
  }
}
