import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Fabrique du thème (refonte v2 « Cacao & Sauge »).
///
/// Material 3 reste le socle technique ; c'est le thème qui efface
/// l'esthétique Material : pas d'ondulation (le retour de pression est un
/// fond), pas d'élévation sur ce qui est posé, contrôles à 8 pt de rayon,
/// onglets soulignés. Le [ColorScheme] est dérivé des jetons [AppColors].
///
/// Deux méthodes publiques : [light] et [dark].
class AppTheme {
  /// Empêche l'instanciation.
  AppTheme._();

  /// Construit le thème clair.
  static ThemeData light() => _build(AppColors.light, Brightness.light);

  /// Construit le thème sombre.
  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);

  /// Correspondance jetons v2 → [ColorScheme].
  ///
  /// Les conteneurs secondaire et tertiaire sont la surface elle-même, avec
  /// le texte dans la couleur de statut : la v2 n'a pas de pastilles tonales,
  /// un statut se dit par un mot coloré (et passe l'AA sur la surface).
  static ColorScheme _colorScheme(AppColors c, Brightness brightness) {
    return ColorScheme(
      brightness: brightness,
      primary: c.action,
      onPrimary: c.onAction,
      primaryContainer: c.actionSubtle,
      onPrimaryContainer: c.onActionSubtle,
      secondary: c.success,
      onSecondary: c.surface,
      secondaryContainer: c.surface,
      onSecondaryContainer: c.success,
      tertiary: c.warning,
      onTertiary: c.surface,
      tertiaryContainer: c.surface,
      onTertiaryContainer: c.warning,
      error: c.error,
      onError: c.surface,
      errorContainer: c.errorSubtle,
      onErrorContainer: c.onErrorSubtle,
      surface: c.surface,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textSecondary,
      surfaceContainerLowest: c.surface,
      surfaceContainerLow: c.surfaceSunken,
      surfaceContainer: c.surfaceSunken,
      surfaceContainerHigh: c.surfaceSunken,
      surfaceContainerHighest: c.surfaceSunken,
      surfaceTint: Colors.transparent,
      outline: c.borderStrong,
      outlineVariant: c.border,
      inverseSurface: c.textPrimary,
      onInverseSurface: c.canvas,
      inversePrimary: c.brand,
      scrim: c.textPrimary.withValues(alpha: 0.5),
      shadow: c.elevationShadow,
    );
  }

  static ThemeData _build(AppColors c, Brightness brightness) {
    final cs = _colorScheme(c, brightness);
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AppTypography.fontFamily,
      colorScheme: cs,
      extensions: [c],
      scaffoldBackgroundColor: c.canvas,
      canvasColor: c.canvas,
      // Pas d'ondulation : le retour de pression passe par `overlayColor`.
      splashFactory: NoSplash.splashFactory,
      highlightColor: c.surfaceSunken,
      hoverColor: Colors.transparent,
      dividerColor: c.border,
      textTheme: _buildTextTheme(c),
      iconTheme: IconThemeData(color: c.textPrimary, size: 24),
      appBarTheme: _buildAppBarTheme(c),
      cardTheme: _buildCardTheme(c),
      listTileTheme: _buildListTileTheme(c),
      inputDecorationTheme: _buildInputDecorationTheme(c),
      filledButtonTheme: FilledButtonThemeData(style: _primaryStyle(c)),
      elevatedButtonTheme: ElevatedButtonThemeData(style: _primaryStyle(c)),
      outlinedButtonTheme: _buildOutlinedButtonTheme(c),
      textButtonTheme: _buildTextButtonTheme(c),
      iconButtonTheme: _buildIconButtonTheme(c),
      segmentedButtonTheme: _buildSegmentedButtonTheme(c),
      tabBarTheme: _buildTabBarTheme(c),
      chipTheme: _buildChipTheme(c),
      dividerTheme: DividerThemeData(
        color: c.border,
        thickness: 1,
        space: AppSpacing.md,
      ),
      snackBarTheme: _buildSnackBarTheme(c),
      dialogTheme: _buildDialogTheme(c),
      bottomSheetTheme: _buildBottomSheetTheme(c),
      popupMenuTheme: _buildPopupMenuTheme(c),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.action,
        foregroundColor: c.onAction,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.action,
        linearTrackColor: c.surfaceSunken,
        circularTrackColor: c.surfaceSunken,
      ),
      switchTheme: _buildSwitchTheme(c),
      checkboxTheme: _buildCheckboxTheme(c),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? c.action : c.borderStrong,
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(AppColors c) {
    final primary = c.textPrimary;
    final secondary = c.textSecondary;
    return TextTheme(
      displayLarge: AppTypography.displayLarge.copyWith(color: primary),
      displayMedium: AppTypography.displayMedium.copyWith(color: primary),
      headlineLarge: AppTypography.screenTitle.copyWith(color: primary),
      headlineMedium: AppTypography.sectionTitle.copyWith(color: primary),
      titleLarge: AppTypography.screenTitle.copyWith(color: primary),
      titleMedium: AppTypography.sectionTitle.copyWith(color: primary),
      titleSmall: AppTypography.bodyStrong.copyWith(color: primary),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: primary),
      bodyMedium: AppTypography.body.copyWith(color: primary),
      bodySmall: AppTypography.bodySmall.copyWith(color: secondary),
      labelLarge: AppTypography.labelLarge.copyWith(color: primary),
      labelMedium: AppTypography.meta.copyWith(color: primary),
      labelSmall: AppTypography.labelSmall.copyWith(color: secondary),
    );
  }

  /// Barre d'application posée sur le fond d'écran, sans ombre ni teinte au
  /// défilement.
  static AppBarTheme _buildAppBarTheme(AppColors c) {
    return AppBarTheme(
      backgroundColor: c.canvas,
      foregroundColor: c.textPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: AppTypography.screenTitle.copyWith(color: c.textPrimary),
      toolbarTextStyle: AppTypography.body.copyWith(color: c.textPrimary),
      centerTitle: false,
      iconTheme: IconThemeData(color: c.textPrimary),
      actionsIconTheme: IconThemeData(color: c.textPrimary),
    );
  }

  /// Encadré plat : surface, filet, rayon de surface. Réservé à un groupe
  /// qui doit se détacher (l'état de la caisse).
  static CardThemeData _buildCardTheme(AppColors c) {
    return CardThemeData(
      color: c.surface,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        side: BorderSide(color: c.border),
      ),
    );
  }

  static ListTileThemeData _buildListTileTheme(AppColors c) {
    return ListTileThemeData(
      iconColor: c.textSecondary,
      textColor: c.textPrimary,
      titleTextStyle: AppTypography.bodyStrong.copyWith(color: c.textPrimary),
      subtitleTextStyle: AppTypography.meta.copyWith(color: c.textSecondary),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      minVerticalPadding: 10,
    );
  }

  /// Champ : surface, filet `borderStrong` (3:1), focus 2 dp `action`,
  /// erreur 2 dp `error`, rayon 8, 48 dp de haut.
  static InputDecorationTheme _buildInputDecorationTheme(AppColors c) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(color: color, width: width),
        );
    return InputDecorationTheme(
      filled: true,
      fillColor: c.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: border(c.borderStrong),
      enabledBorder: border(c.borderStrong),
      focusedBorder: border(c.action, 2),
      errorBorder: border(c.error, 2),
      focusedErrorBorder: border(c.error, 2),
      disabledBorder: border(c.border),
      labelStyle: AppTypography.bodyStrong.copyWith(color: c.textSecondary),
      floatingLabelStyle: AppTypography.meta.copyWith(color: c.textPrimary),
      hintStyle: AppTypography.hintText.copyWith(color: c.textSecondary),
      helperStyle: AppTypography.meta.copyWith(color: c.textSecondary),
      errorStyle: AppTypography.errorText.copyWith(color: c.error),
      prefixIconColor: c.textSecondary,
      suffixIconColor: c.textSecondary,
      suffixStyle: AppTypography.bodyStrong.copyWith(color: c.textSecondary),
    );
  }

  /// Bouton principal (Filled/Elevated) : `action`, 48 dp, rayon 8, sans
  /// ombre ; pressé = `actionPressed` ; désactivé = `surfaceSunken`.
  static ButtonStyle _primaryStyle(AppColors c) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return c.surfaceSunken;
        if (states.contains(WidgetState.pressed)) return c.actionPressed;
        return c.action;
      }),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.disabled) ? c.textDisabled : c.onAction,
      ),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      elevation: const WidgetStatePropertyAll(0),
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      minimumSize: const WidgetStatePropertyAll(
        Size(double.infinity, AppSpacing.buttonHeightSm),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 20),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
      textStyle: const WidgetStatePropertyAll(AppTypography.labelLarge),
    );
  }

  /// Bouton secondaire : filet `borderStrong`, fond `surface`, texte
  /// `textPrimary` 16/500 ; pressé = `surfaceSunken`.
  static OutlinedButtonThemeData _buildOutlinedButtonTheme(AppColors c) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return c.surfaceSunken;
          if (states.contains(WidgetState.pressed)) return c.surfaceSunken;
          return c.surface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? c.textDisabled
              : c.textPrimary,
        ),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        side: WidgetStateProperty.resolveWith(
          (states) => BorderSide(
            color: states.contains(WidgetState.disabled)
                ? c.border
                : c.borderStrong,
          ),
        ),
        minimumSize: const WidgetStatePropertyAll(
          Size(double.infinity, AppSpacing.buttonHeightSm),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
        textStyle: const WidgetStatePropertyAll(AppTypography.bodyStrong),
      ),
    );
  }

  /// Action tertiaire (Voir tout, Vider) : texte `action` 16/600, 48 dp.
  static TextButtonThemeData _buildTextButtonTheme(AppColors c) {
    return TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.disabled) ? c.textDisabled : c.action,
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.pressed)
              ? c.surfaceSunken
              : Colors.transparent,
        ),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        minimumSize: const WidgetStatePropertyAll(
          Size(48, AppSpacing.buttonHeightSm),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 10),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
        textStyle: const WidgetStatePropertyAll(AppTypography.labelLarge),
      ),
    );
  }

  static IconButtonThemeData _buildIconButtonTheme(AppColors c) {
    return IconButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.pressed)
              ? c.surfaceSunken
              : Colors.transparent,
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
      ),
    );
  }

  /// Contrôle segmenté : piste `surfaceSunken`, segment actif `surface` avec
  /// filet, pas de contour Material. Les appelants passent
  /// `showSelectedIcon: false` (aucune coche).
  static SegmentedButtonThemeData _buildSegmentedButtonTheme(AppColors c) {
    return SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? c.surface
              : c.surfaceSunken,
        ),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return c.textDisabled;
          return states.contains(WidgetState.selected)
              ? c.textPrimary
              : c.textSecondary;
        }),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        side: WidgetStatePropertyAll(BorderSide(color: c.border)),
        minimumSize: const WidgetStatePropertyAll(Size(0, 44)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
        textStyle: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppTypography.meta.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                )
              : AppTypography.meta.copyWith(fontSize: 15),
        ),
      ),
    );
  }

  /// Onglets : soulignement 2 dp `action`, filet `border`.
  static TabBarThemeData _buildTabBarTheme(AppColors c) {
    return TabBarThemeData(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: c.action, width: 2),
      ),
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: c.border,
      dividerHeight: 1,
      labelColor: c.textPrimary,
      unselectedLabelColor: c.textSecondary,
      labelStyle: AppTypography.meta.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: AppTypography.meta.copyWith(fontSize: 15),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
    );
  }

  static ChipThemeData _buildChipTheme(AppColors c) {
    return ChipThemeData(
      backgroundColor: c.surface,
      selectedColor: c.actionSubtle,
      disabledColor: c.surfaceSunken,
      deleteIconColor: c.textSecondary,
      checkmarkColor: c.onActionSubtle,
      labelStyle: AppTypography.meta.copyWith(
        fontSize: 15,
        color: c.textPrimary,
      ),
      secondaryLabelStyle: AppTypography.meta.copyWith(
        fontSize: 15,
        color: c.onActionSubtle,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      elevation: 0,
      pressElevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      side: WidgetStateBorderSide.resolveWith(
        (states) => BorderSide(
          color: states.contains(WidgetState.selected) ? c.action : c.border,
        ),
      ),
    );
  }

  /// Dialogue : surface, rayon 12, ombre niveau 1 (filet en sombre).
  static DialogThemeData _buildDialogTheme(AppColors c) {
    return DialogThemeData(
      backgroundColor: c.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: c.elevationShadow.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        side: BorderSide(color: c.border),
      ),
      titleTextStyle: AppTypography.sectionTitle.copyWith(color: c.textPrimary),
      contentTextStyle: AppTypography.body.copyWith(color: c.textPrimary),
    );
  }

  /// Feuille : surface, rayon 12 en haut, sans poignée, ombre niveau 1.
  static BottomSheetThemeData _buildBottomSheetTheme(AppColors c) {
    return BottomSheetThemeData(
      backgroundColor: c.surface,
      modalBackgroundColor: c.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      modalElevation: 8,
      shadowColor: c.elevationShadow.withValues(alpha: 0.12),
      showDragHandle: false,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
        side: BorderSide(color: c.border),
      ),
    );
  }

  static PopupMenuThemeData _buildPopupMenuTheme(AppColors c) {
    return PopupMenuThemeData(
      color: c.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: c.elevationShadow.withValues(alpha: 0.12),
      textStyle: AppTypography.body.copyWith(color: c.textPrimary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        side: BorderSide(color: c.border),
      ),
    );
  }

  /// Toast : fond `textPrimary`, texte `canvas`, rayon 8.
  static SnackBarThemeData _buildSnackBarTheme(AppColors c) {
    return SnackBarThemeData(
      backgroundColor: c.textPrimary,
      contentTextStyle: AppTypography.bodyStrong.copyWith(
        fontSize: 15,
        color: c.canvas,
      ),
      actionTextColor: c.canvas,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
    );
  }

  static SwitchThemeData _buildSwitchTheme(AppColors c) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.selected) ? c.onAction : c.borderStrong,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.selected) ? c.action : c.surfaceSunken,
      ),
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.selected) ? c.action : c.borderStrong,
      ),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }

  static CheckboxThemeData _buildCheckboxTheme(AppColors c) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.selected) ? c.action : c.surface,
      ),
      checkColor: WidgetStatePropertyAll(c.onAction),
      side: BorderSide(color: c.borderStrong, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }
}
