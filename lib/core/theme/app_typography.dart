import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prestahub/core/theme/app_colors.dart';

/// Échelle typographique du design system "Violet Ether" (Stitch #1).
/// Police exclusive : Inter.
abstract final class AppTypography {
  static final String? _fontFamily = GoogleFonts.inter().fontFamily;

  static TextTheme lightTextTheme = GoogleFonts.interTextTheme().apply(
    bodyColor: AppColors.lightOnSurface,
    displayColor: AppColors.lightOnSurface,
    decorationColor: AppColors.lightOutline,
  );

  static TextTheme darkTextTheme = GoogleFonts.interTextTheme(
    ThemeData.dark().textTheme,
  ).apply(
    bodyColor: AppColors.darkOnSurface,
    displayColor: AppColors.darkOnSurface,
    decorationColor: AppColors.darkOutline,
  );

  /// Micro-header : 11 px, uppercase, large letter-spacing (0.1 em).
  static TextStyle microHeader({required Color color}) => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.1,
    color: color,
  );

  /// Display scale : 18 px, bold, tight tracking.
  static TextStyle display({required Color color}) => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.45,
    color: color,
  );
}
