import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrestaHubTheme {
  // Light Mode Colors
  static const Color primary = Color(0xFF651BE4);
  static const Color primaryHover = Color(0xFF5316C2);
  static const Color primaryContent = Color(0xFFFFFFFF);

  static const Color secondary = Color(0xFF8B5CF6);
  static const Color secondaryContent = Color(0xFFFFFFFF);

  static const Color accent = Color(0xFF6D28D9);
  static const Color accentContent = Color(0xFFFFFFFF);

  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF9FAFB);
  static const Color surface2Light = Color(0xFFF3F4F6);

  static const Color textLight = Color(0xFF111827);
  static const Color textMutedLight = Color(0xFF4B5563);
  static const Color textInverseLight = Color(0xFFFFFFFF);

  // Dark Mode Colors
  static const Color backgroundDark = Color(0xFF0B0B0F);
  static const Color surfaceDark = Color(0xFF111827);
  static const Color surface2Dark = Color(0xFF1F2937);

  static const Color primaryDark = Color(0xFFA78BFA);
  static const Color textDark = Color(0xFFF9FAFB);
  static const Color textMutedDark = Color(0xFFD1D5DB);

  // Common Semantic Colors
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  static const Color border = Color(0xFFE5E7EB);
  static const Color borderStrong = Color(0xFFD1D5DB);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      onPrimary: primaryContent,
      secondary: secondary,
      onSecondary: secondaryContent,
      surface: surfaceLight,
      onSurface: textLight,
      error: danger,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: backgroundLight,
    fontFamily: GoogleFonts.inter().fontFamily,
    textTheme: GoogleFonts.interTextTheme().apply(
      bodyColor: textLight,
      displayColor: primary,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundLight,
      foregroundColor: textLight,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: primaryContent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceLight,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryDark,
      primary: primaryDark,
      onPrimary: backgroundDark,
      secondary: secondary,
      onSecondary: Colors.white,
      surface: surfaceDark,
      onSurface: textDark,
      error: danger,
      onError: Colors.white,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: backgroundDark,
    fontFamily: GoogleFonts.inter().fontFamily,
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: textDark, displayColor: primaryDark),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundDark,
      foregroundColor: textDark,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: backgroundDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
