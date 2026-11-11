import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Fabrique du thème Material 3 pour POS Mobile CI.
///
/// Deux méthodes publiques : [light] et [dark].
class AppTheme {
  /// Empêche l'instanciation.
  AppTheme._();

  /// Construit le thème clair Material 3 complet.
  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF92400E), // cacao — 7,1:1 sur blanc
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFFEF3C7),
      onPrimaryContainer: Color(0xFF78350F),
      // Or : jamais en couleur de texte (2,9:1), seulement en fond.
      secondary: Color(0xFFCA8A04),
      onSecondary: Color(0xFF1C1107),
      secondaryContainer: Color(0xFFFEFCE8),
      onSecondaryContainer: Color(0xFF8A5A00),
      // Alerte / stock bas : #C2410C (l'ancien #EA580C échouait à 3,6:1).
      tertiary: Color(0xFFC2410C),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFFFEDD5),
      onTertiaryContainer: Color(0xFF9A3412),
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF93000A),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF1C1107),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFFEF9EE), // surfaceVariant
      surfaceContainer: Color(0xFFFEF9EE),
      // Squelettes, fonds désactivés.
      surfaceContainerHigh: Color(0xFFF0EBE3),
      surfaceContainerHighest: Color(0xFFF0EBE3),
      onSurfaceVariant: Color(0xFF57534E), // 7,5:1 sur ivoire
      outline: Color(0xFF8A817C), // bordures de champ ≥ 3:1
      outlineVariant: Color(0xFFF0EBE3), // séparateurs
      inverseSurface: Color(0xFF1C1107),
      onInverseSurface: Color(0xFFFFFBF5),
      inversePrimary: Color(0xFFF5C99B),
      scrim: Color(0x801C1107),
      shadow: Color(0xFF000000),
      surfaceTint: Colors.transparent,
    );

    return _build(
      colorScheme,
      background: const Color(0xFFFFFBF5), // ivoire chaud
      semantic: AppSemanticColors.light,
    );
  }

  /// Construit le thème sombre Material 3 complet : surfaces cacao
  /// réchauffées, primaire sable ; l'élévation se lit par le ton de surface,
  /// pas par l'ombre.
  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFF5C99B), // sable
      onPrimary: Color(0xFF3A1A04),
      primaryContainer: Color(0xFF5A2A0A),
      onPrimaryContainer: Color(0xFFFFE3C2),
      secondary: Color(0xFFEAB308),
      onSecondary: Color(0xFF1C1107),
      secondaryContainer: Color(0xFF3A2E0A),
      onSecondaryContainer: Color(0xFFF5D77A),
      tertiary: Color(0xFFFFA94D),
      onTertiary: Color(0xFF3A1A04),
      tertiaryContainer: Color(0xFF3D2210),
      onTertiaryContainer: Color(0xFFFFCF9E),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF5C1714),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: Color(0xFF211912),
      onSurface: Color(0xFFF7EFE6),
      surfaceContainerLowest: Color(0xFF17110C),
      surfaceContainerLow: Color(0xFF2C2219), // surfaceVariant
      surfaceContainer: Color(0xFF2C2219),
      surfaceContainerHigh: Color(0xFF33281F),
      surfaceContainerHighest: Color(0xFF33281F),
      onSurfaceVariant: Color(0xFFCBBFB2),
      outline: Color(0xFF7D6E61),
      outlineVariant: Color(0xFF33281F),
      inverseSurface: Color(0xFFF7EFE6),
      onInverseSurface: Color(0xFF17110C),
      inversePrimary: Color(0xFF92400E),
      scrim: Color(0x99000000),
      shadow: Color(0xFF000000),
      surfaceTint: Colors.transparent,
    );

    return _build(
      colorScheme,
      background: const Color(0xFF17110C),
      semantic: AppSemanticColors.dark,
    );
  }

  static ThemeData _build(
    ColorScheme colorScheme, {
    required Color background,
    required AppSemanticColors semantic,
  }) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTypography.fontFamily,
      colorScheme: colorScheme,
      extensions: [semantic],
      scaffoldBackgroundColor: background,
      textTheme: _buildTextTheme(colorScheme),
      appBarTheme: _buildAppBarTheme(colorScheme),
      cardTheme: _buildCardTheme(colorScheme),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme, background),
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      chipTheme: _buildChipTheme(colorScheme),
      dividerTheme: _buildDividerTheme(colorScheme),
      snackBarTheme: _buildSnackBarTheme(colorScheme),
      dialogTheme: _buildDialogTheme(colorScheme),
      bottomSheetTheme: _buildBottomSheetTheme(colorScheme),
      navigationBarTheme: _buildNavigationBarTheme(colorScheme),
      floatingActionButtonTheme: _buildFabTheme(colorScheme),
      progressIndicatorTheme: _buildProgressIndicatorTheme(colorScheme),
      switchTheme: _buildSwitchTheme(colorScheme),
      checkboxTheme: _buildCheckboxTheme(colorScheme),
    );
  }

  static TextTheme _buildTextTheme(ColorScheme cs) {
    final primary = cs.onSurface;
    final secondary = cs.onSurfaceVariant;
    return TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(color: primary),
      displayMedium: AppTypography.displayMedium.copyWith(color: primary),
      headlineLarge: AppTypography.titleLarge.copyWith(color: primary),
      headlineMedium: AppTypography.titleMedium.copyWith(color: primary),
      titleLarge: AppTypography.titleLarge.copyWith(color: primary),
      titleMedium: AppTypography.titleMedium.copyWith(color: primary),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: primary),
      bodyMedium: AppTypography.bodyMedium.copyWith(color: primary),
      bodySmall: AppTypography.bodySmall.copyWith(color: secondary),
      labelLarge: AppTypography.labelLarge.copyWith(color: primary),
      labelMedium: AppTypography.labelMedium.copyWith(color: primary),
      labelSmall: AppTypography.labelSmall.copyWith(color: secondary),
    );
  }

  static AppBarTheme _buildAppBarTheme(ColorScheme cs) {
    return AppBarTheme(
      backgroundColor: cs.surface,
      foregroundColor: cs.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: AppTypography.appBarTitle.copyWith(color: cs.onSurface),
      toolbarTextStyle: AppTypography.bodyMedium.copyWith(color: cs.onSurface),
      centerTitle: false,
      iconTheme: IconThemeData(color: cs.onSurface),
    );
  }

  static CardThemeData _buildCardTheme(ColorScheme cs) {
    return CardThemeData(
      color: cs.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(
    ColorScheme cs,
    Color background,
  ) {
    return InputDecorationTheme(
      filled: true,
      // Champ sur le fond de l'écran, bordure outline ≥ 3:1.
      fillColor: background,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide(color: cs.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide(color: cs.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide(color: cs.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide(color: cs.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide(color: cs.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        borderSide: BorderSide(color: cs.outlineVariant),
      ),
      labelStyle: AppTypography.labelMedium.copyWith(
        color: cs.onSurfaceVariant,
      ),
      hintStyle: AppTypography.hintText.copyWith(color: cs.onSurfaceVariant),
      helperStyle: AppTypography.captionText.copyWith(
        color: cs.onSurfaceVariant,
      ),
      // Erreur sous le champ en 16 sp : c'est elle qui débloque la saisie.
      errorStyle: AppTypography.bodyMedium.copyWith(color: cs.error),
      errorMaxLines: 2,
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(ColorScheme cs) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        textStyle: AppTypography.labelLarge,
        elevation: 0,
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(ColorScheme cs) {
    return OutlinedButtonThemeData(
      style:
          OutlinedButton.styleFrom(
            foregroundColor: cs.primary,
            minimumSize: const Size(double.infinity, AppSpacing.buttonHeightSm),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            textStyle: AppTypography.labelLarge,
          ).copyWith(
            // Désactivé : bordure grise, sinon le bouton semble encore actif.
            side: WidgetStateProperty.resolveWith(
              (states) => BorderSide(
                color: states.contains(WidgetState.disabled)
                    ? cs.outlineVariant
                    : cs.outline,
              ),
            ),
            // Pressé : fond primaryContainer plutôt qu'une simple encre.
            overlayColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.pressed)
                  ? cs.primaryContainer
                  : null,
            ),
          ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(ColorScheme cs) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: cs.primary,
        textStyle: AppTypography.labelLarge,
      ),
    );
  }

  /// Chips de filtre et de montant : 40 dp visibles (48 dp de cible),
  /// bordure outline ; sélection = fond primaryContainer, sans bordure.
  static ChipThemeData _buildChipTheme(ColorScheme cs) {
    return ChipThemeData(
      backgroundColor: Colors.transparent,
      selectedColor: cs.primaryContainer,
      checkmarkColor: cs.onPrimaryContainer,
      deleteIconColor: cs.onSurfaceVariant,
      disabledColor: cs.surfaceContainerHigh,
      labelStyle: WidgetStateTextStyle.resolveWith(
        (states) => AppTypography.bodyMedium.copyWith(
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w600
              : FontWeight.w500,
          fontFeatures: AppTypography.tabularFigures,
          color: states.contains(WidgetState.selected)
              ? cs.onPrimaryContainer
              : cs.onSurface,
        ),
      ),
      secondaryLabelStyle: AppTypography.bodyMedium.copyWith(
        color: cs.onPrimaryContainer,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      side: WidgetStateBorderSide.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? BorderSide(color: cs.primaryContainer)
            : BorderSide(color: cs.outline),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
    );
  }

  static DividerThemeData _buildDividerTheme(ColorScheme cs) {
    return DividerThemeData(
      color: cs.outlineVariant,
      thickness: 1,
      space: AppSpacing.md,
    );
  }

  /// Boîtes de dialogue (actions destructrices ou bloquantes seulement) :
  /// coins 24, titre en gras comme les titres de l'app.
  static DialogThemeData _buildDialogTheme(ColorScheme cs) {
    return DialogThemeData(
      backgroundColor: cs.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      titleTextStyle: AppTypography.titleMedium.copyWith(
        color: cs.onSurface,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: AppTypography.bodyMedium.copyWith(color: cs.onSurface),
    );
  }

  static SnackBarThemeData _buildSnackBarTheme(ColorScheme cs) {
    return SnackBarThemeData(
      backgroundColor: cs.onSurface,
      contentTextStyle: AppTypography.bodyMedium.copyWith(color: cs.surface),
      actionTextColor: cs.primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
    );
  }

  /// Panier, paiement, ouverture de caisse, confirmation de vente : surface,
  /// coins hauts 24, poignée visible.
  static BottomSheetThemeData _buildBottomSheetTheme(ColorScheme cs) {
    return BottomSheetThemeData(
      backgroundColor: cs.surface,
      modalBackgroundColor: cs.surface,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: cs.outline,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
    );
  }

  static NavigationBarThemeData _buildNavigationBarTheme(ColorScheme cs) {
    return NavigationBarThemeData(
      backgroundColor: cs.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: cs.primaryContainer,
      elevation: 0,
      height: 80,
      // Libellés toujours visibles : pas d'icône seule pour naviguer.
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return AppTypography.labelSmall.copyWith(
          color: selected ? cs.onSurface : cs.onSurfaceVariant,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? cs.onPrimaryContainer : cs.onSurfaceVariant,
        );
      }),
    );
  }

  static FloatingActionButtonThemeData _buildFabTheme(ColorScheme cs) {
    return FloatingActionButtonThemeData(
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
    );
  }

  static ProgressIndicatorThemeData _buildProgressIndicatorTheme(
    ColorScheme cs,
  ) {
    final track = cs.surfaceContainer;
    return ProgressIndicatorThemeData(
      color: cs.primary,
      linearTrackColor: track,
      circularTrackColor: track,
    );
  }

  static SwitchThemeData _buildSwitchTheme(ColorScheme cs) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return cs.onPrimary;
        return cs.outline;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return cs.primary;
        return cs.surfaceContainer;
      }),
    );
  }

  static CheckboxThemeData _buildCheckboxTheme(ColorScheme cs) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return cs.primary;
        return cs.surface;
      }),
      side: BorderSide(color: cs.outline, width: 2),
    );
  }
}
