import 'package:flutter/material.dart';
import 'package:prestahub/core/theme/app_colors.dart';
import 'package:prestahub/core/theme/app_radius.dart';
import 'package:prestahub/core/theme/app_typography.dart';

/// Thèmes clair/sombre "Violet Ether" calqués sur le design system Stitch #1.
/// Primary seed : #651be4 — Police : Inter.
class PrestaHubTheme {
  static final ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.lightPrimary,
    onPrimary: AppColors.lightOnPrimary,
    primaryContainer: AppColors.lightPrimaryContainer,
    onPrimaryContainer: AppColors.lightOnPrimaryContainer,
    primaryFixed: AppColors.lightPrimaryFixed,
    primaryFixedDim: AppColors.lightPrimaryFixedDim,
    onPrimaryFixed: AppColors.lightOnPrimaryFixed,
    onPrimaryFixedVariant: AppColors.lightOnPrimaryFixedVariant,
    inversePrimary: AppColors.lightInversePrimary,
    secondary: AppColors.lightSecondary,
    onSecondary: AppColors.lightOnSecondary,
    secondaryContainer: AppColors.lightSecondaryContainer,
    onSecondaryContainer: AppColors.lightOnSecondaryContainer,
    secondaryFixed: AppColors.lightSecondaryFixed,
    secondaryFixedDim: AppColors.lightSecondaryFixedDim,
    onSecondaryFixed: AppColors.lightOnSecondaryFixed,
    onSecondaryFixedVariant: AppColors.lightOnSecondaryFixedVariant,
    tertiary: AppColors.lightTertiary,
    onTertiary: AppColors.lightOnTertiary,
    tertiaryContainer: AppColors.lightTertiaryContainer,
    onTertiaryContainer: AppColors.lightOnTertiaryContainer,
    tertiaryFixed: AppColors.lightTertiaryFixed,
    tertiaryFixedDim: AppColors.lightTertiaryFixedDim,
    onTertiaryFixed: AppColors.lightOnTertiaryFixed,
    onTertiaryFixedVariant: AppColors.lightOnTertiaryFixedVariant,
    error: AppColors.lightError,
    onError: AppColors.lightOnError,
    errorContainer: AppColors.lightErrorContainer,
    onErrorContainer: AppColors.lightOnErrorContainer,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightOnSurface,
    surfaceTint: AppColors.lightSurfaceTint,
    surfaceBright: AppColors.lightSurfaceBright,
    surfaceDim: AppColors.lightSurfaceDim,
    surfaceContainer: AppColors.lightSurfaceContainer,
    surfaceContainerLow: AppColors.lightSurfaceContainerLow,
    surfaceContainerLowest: AppColors.lightSurfaceContainerLowest,
    surfaceContainerHigh: AppColors.lightSurfaceContainerHigh,
    surfaceContainerHighest: AppColors.lightSurfaceVariant,
    outline: AppColors.lightOutline,
    outlineVariant: AppColors.lightOutlineVariant,
    inverseSurface: AppColors.lightInverseSurface,
    shadow: AppColors.lightInverseSurface.withValues(alpha: 0.08),
    scrim: AppColors.lightInverseSurface.withValues(alpha: 0.4),
  );

  static final ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.darkPrimary,
    onPrimary: AppColors.darkOnPrimary,
    primaryContainer: AppColors.darkPrimaryContainer,
    onPrimaryContainer: AppColors.darkOnPrimaryContainer,
    primaryFixed: AppColors.darkPrimaryFixed,
    primaryFixedDim: AppColors.darkPrimaryFixedDim,
    onPrimaryFixed: AppColors.darkOnPrimaryFixed,
    onPrimaryFixedVariant: AppColors.darkOnPrimaryFixedVariant,
    inversePrimary: AppColors.darkInversePrimary,
    secondary: AppColors.darkSecondary,
    onSecondary: AppColors.darkOnSecondary,
    secondaryContainer: AppColors.darkSecondaryContainer,
    onSecondaryContainer: AppColors.darkOnSecondaryContainer,
    secondaryFixed: AppColors.darkSecondaryFixed,
    secondaryFixedDim: AppColors.darkSecondaryFixedDim,
    onSecondaryFixed: AppColors.darkOnSecondaryFixed,
    onSecondaryFixedVariant: AppColors.darkOnSecondaryFixedVariant,
    tertiary: AppColors.darkTertiary,
    onTertiary: AppColors.darkOnTertiary,
    tertiaryContainer: AppColors.darkTertiaryContainer,
    onTertiaryContainer: AppColors.darkOnTertiaryContainer,
    tertiaryFixed: AppColors.darkTertiaryFixed,
    tertiaryFixedDim: AppColors.darkTertiaryFixedDim,
    onTertiaryFixed: AppColors.darkOnTertiaryFixed,
    onTertiaryFixedVariant: AppColors.darkOnTertiaryFixedVariant,
    error: AppColors.darkError,
    onError: AppColors.darkOnError,
    errorContainer: AppColors.darkErrorContainer,
    onErrorContainer: AppColors.darkOnErrorContainer,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkOnSurface,
    surfaceTint: AppColors.darkSurfaceTint,
    surfaceBright: AppColors.darkSurfaceBright,
    surfaceDim: AppColors.darkSurfaceDim,
    surfaceContainer: AppColors.darkSurfaceContainer,
    surfaceContainerLow: AppColors.darkSurfaceContainerLow,
    surfaceContainerLowest: AppColors.darkSurfaceContainerLowest,
    surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
    surfaceContainerHighest: AppColors.darkSurfaceVariant,
    outline: AppColors.darkOutline,
    outlineVariant: AppColors.darkOutlineVariant,
    inverseSurface: AppColors.darkInverseSurface,
    shadow: AppColors.darkInverseSurface.withValues(alpha: 0.2),
    scrim: AppColors.darkInverseSurface.withValues(alpha: 0.5),
  );

  static final RoundedRectangleBorder _roundedRectangleMd = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppRadius.md),
  );

  static final RoundedRectangleBorder _roundedRectangleSm = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppRadius.sm),
  );

  static final RoundedRectangleBorder _roundedRectangleFull = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppRadius.full),
  );

  static ThemeData get lightTheme => _buildTheme(_lightColorScheme, AppTypography.lightTextTheme);

  static ThemeData get darkTheme => _buildTheme(_darkColorScheme, AppTypography.darkTextTheme);

  static ThemeData _buildTheme(ColorScheme colorScheme, TextTheme textTheme) {
    final isLight = colorScheme.brightness == Brightness.light;
    final surface = colorScheme.surface;
    final onSurface = colorScheme.onSurface;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    final outline = colorScheme.outline;
    final inputFill = isLight ? AppColors.lightSurfaceVariant : AppColors.darkSurfaceVariant;

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surface,
      fontFamily: AppTypography.lightTextTheme.bodyLarge?.fontFamily,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: outline.withValues(alpha: 0.5),
          disabledForegroundColor: onSurfaceVariant,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: _roundedRectangleMd,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: outline),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: _roundedRectangleMd,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: _roundedRectangleSm,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: isLight ? 2 : 4,
        shadowColor: colorScheme.shadow,
        shape: _roundedRectangleMd,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: textTheme.bodyMedium?.copyWith(color: onSurfaceVariant),
        labelStyle: textTheme.bodyMedium?.copyWith(color: onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: textTheme.bodyMedium?.copyWith(color: onSurface),
        secondaryLabelStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimaryContainer),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: _roundedRectangleFull,
        side: BorderSide.none,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colorScheme.primary;
          return outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary.withValues(alpha: 0.5);
          }
          return outline.withValues(alpha: 0.5);
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colorScheme.primary;
          return surface;
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
        side: BorderSide(color: outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colorScheme.primary;
          return outline;
        }),
      ),
      dividerTheme: DividerThemeData(
        color: outline.withValues(alpha: 0.5),
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: onSurfaceVariant,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const CircleBorder(),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: _roundedRectangleMd,
        elevation: isLight ? 4 : 8,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Getters de compatibilité avec l'ancienne API PrestaHubTheme.
  // Ils redirigent vers les tokens du design system Violet Ether.
  // --------------------------------------------------------------------------
  static const Color primary = AppColors.lightPrimary;
  static const Color primaryContent = AppColors.lightOnPrimary;
  static const Color primaryHover = AppColors.lightOnPrimaryFixedVariant;
  static const Color secondary = AppColors.lightSecondary;
  static const Color secondaryContent = AppColors.lightOnSecondary;
  static const Color accent = AppColors.lightTertiary;
  static const Color accentContent = AppColors.lightOnTertiary;
  static const Color backgroundLight = AppColors.lightBackground;
  static const Color surfaceLight = AppColors.lightSurface;
  static const Color surface2Light = AppColors.lightSurfaceVariant;
  static const Color textLight = AppColors.lightOnSurface;
  static const Color textMutedLight = AppColors.lightOnSurfaceVariant;
  static const Color textInverseLight = AppColors.lightOnPrimary;
  static const Color backgroundDark = AppColors.darkBackground;
  static const Color surfaceDark = AppColors.darkSurface;
  static const Color surface2Dark = AppColors.darkSurfaceVariant;
  static const Color primaryDark = AppColors.darkPrimary;
  static const Color textDark = AppColors.darkOnSurface;
  static const Color textMutedDark = AppColors.darkOnSurfaceVariant;
  static const Color border = AppColors.lightOutline;
  static const Color borderStrong = AppColors.lightOutlineVariant;
  static const Color success = AppColors.success;
  static const Color warning = AppColors.warning;
  static const Color danger = AppColors.lightError;
  static const Color info = AppColors.info;
}
