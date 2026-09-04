import 'package:flutter/material.dart';

/// Design system "Violet Ether" extrait du projet Stitch #1 (PrestaHub).
/// Primary seed : #651be4 — Police : Inter — Radius de base : 8 px.
abstract final class AppColors {
  // --------------------------------------------------------------------------
  // Light palette (valeurs exactes du design system Stitch)
  // --------------------------------------------------------------------------
  static const Color lightPrimary = Color(0xFF651BE4);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0x1A651BE4);
  static const Color lightOnPrimaryContainer = Color(0xFF651BE4);
  static const Color lightPrimaryFixed = Color(0xFFE9DDFF);
  static const Color lightPrimaryFixedDim = Color(0xFFD0BCFF);
  static const Color lightOnPrimaryFixed = Color(0xFF21005D);
  static const Color lightOnPrimaryFixedVariant = Color(0xFF4F378B);
  static const Color lightInversePrimary = Color(0xFFD0BCFF);

  static const Color lightSecondary = Color(0xFF4F46E5);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightSecondaryContainer = Color(0xFFE0E7FF);
  static const Color lightOnSecondaryContainer = Color(0xFF3730A3);
  static const Color lightSecondaryFixed = Color(0xFFE0E7FF);
  static const Color lightSecondaryFixedDim = Color(0xFFC7D2FE);
  static const Color lightOnSecondaryFixed = Color(0xFF1E1B4B);
  static const Color lightOnSecondaryFixedVariant = Color(0xFF3730A3);

  static const Color lightTertiary = Color(0xFFF97316);
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightTertiaryContainer = Color(0xFFFFEDD5);
  static const Color lightOnTertiaryContainer = Color(0xFF9A3412);
  static const Color lightTertiaryFixed = Color(0xFFFFEDD5);
  static const Color lightTertiaryFixedDim = Color(0xFFFED7AA);
  static const Color lightOnTertiaryFixed = Color(0xFF431407);
  static const Color lightOnTertiaryFixedVariant = Color(0xFF9A3412);

  static const Color lightError = Color(0xFFEF4444);
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightErrorContainer = Color(0xFFFEE2E2);
  static const Color lightOnErrorContainer = Color(0xFF991B1B);

  static const Color lightBackground = Color(0xFFF5F5F7);
  static const Color lightOnBackground = Color(0xFF0F172A);

  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF0F172A);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);
  static const Color lightOnSurfaceVariant = Color(0xFF64748B);
  static const Color lightSurfaceTint = Color(0xFF651BE4);
  static const Color lightSurfaceBright = Color(0xFFFFFFFF);
  static const Color lightSurfaceDim = Color(0xFFF5F5F7);
  static const Color lightSurfaceContainer = Color(0xFFF5F5F7);
  static const Color lightSurfaceContainerLow = Color(0xFFF5F5F7);
  static const Color lightSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainerHigh = Color(0xFFF5F5F7);
  static const Color lightSurfaceContainerHighest = Color(0xFFF5F5F7);

  static const Color lightOutline = Color(0xFFE2E8F0);
  static const Color lightOutlineVariant = Color(0xFFF1F5F9);

  static const Color lightInverseSurface = Color(0xFF1E293B);
  static const Color lightInverseOnSurface = Color(0xFFF8FAFC);

  // --------------------------------------------------------------------------
  // Dark palette (dérivée cohérente du design system light)
  // --------------------------------------------------------------------------
  static const Color darkPrimary = Color(0xFFB891FF);
  static const Color darkOnPrimary = Color(0xFF1A0A33);
  static const Color darkPrimaryContainer = Color(0xFF4F378B);
  static const Color darkOnPrimaryContainer = Color(0xFFE9DDFF);
  static const Color darkPrimaryFixed = Color(0xFFE9DDFF);
  static const Color darkPrimaryFixedDim = Color(0xFFD0BCFF);
  static const Color darkOnPrimaryFixed = Color(0xFF21005D);
  static const Color darkOnPrimaryFixedVariant = Color(0xFFD0BCFF);
  static const Color darkInversePrimary = Color(0xFF651BE4);

  static const Color darkSecondary = Color(0xFFA5B4FC);
  static const Color darkOnSecondary = Color(0xFF0F1225);
  static const Color darkSecondaryContainer = Color(0xFF3730A3);
  static const Color darkOnSecondaryContainer = Color(0xFFE0E7FF);
  static const Color darkSecondaryFixed = Color(0xFFE0E7FF);
  static const Color darkSecondaryFixedDim = Color(0xFFC7D2FE);
  static const Color darkOnSecondaryFixed = Color(0xFF1E1B4B);
  static const Color darkOnSecondaryFixedVariant = Color(0xFFC7D2FE);

  static const Color darkTertiary = Color(0xFFFDBA74);
  static const Color darkOnTertiary = Color(0xFF2A0F00);
  static const Color darkTertiaryContainer = Color(0xFF9A3412);
  static const Color darkOnTertiaryContainer = Color(0xFFFFEDD5);
  static const Color darkTertiaryFixed = Color(0xFFFFEDD5);
  static const Color darkTertiaryFixedDim = Color(0xFFFED7AA);
  static const Color darkOnTertiaryFixed = Color(0xFF431407);
  static const Color darkOnTertiaryFixedVariant = Color(0xFFFED7AA);

  static const Color darkError = Color(0xFFFCA5A5);
  static const Color darkOnError = Color(0xFF450A0A);
  static const Color darkErrorContainer = Color(0xFF7F1D1D);
  static const Color darkOnErrorContainer = Color(0xFFFEE2E2);

  static const Color darkBackground = Color(0xFF0B0B0F);
  static const Color darkOnBackground = Color(0xFFF1F5F9);

  static const Color darkSurface = Color(0xFF111827);
  static const Color darkOnSurface = Color(0xFFF9FAFB);
  static const Color darkSurfaceVariant = Color(0xFF1F2937);
  static const Color darkOnSurfaceVariant = Color(0xFF94A3B8);
  static const Color darkSurfaceTint = Color(0xFFB891FF);
  static const Color darkSurfaceBright = Color(0xFF1F2937);
  static const Color darkSurfaceDim = Color(0xFF0B0B0F);
  static const Color darkSurfaceContainer = Color(0xFF1F2937);
  static const Color darkSurfaceContainerLow = Color(0xFF111827);
  static const Color darkSurfaceContainerLowest = Color(0xFF0B0B0F);
  static const Color darkSurfaceContainerHigh = Color(0xFF273345);
  static const Color darkSurfaceContainerHighest = Color(0xFF334155);

  static const Color darkOutline = Color(0xFF334155);
  static const Color darkOutlineVariant = Color(0xFF1F2937);

  static const Color darkInverseSurface = Color(0xFFF1F5F9);
  static const Color darkInverseOnSurface = Color(0xFF0F172A);

  // --------------------------------------------------------------------------
  // Semantic colors communs
  // --------------------------------------------------------------------------
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color info = Color(0xFF2563EB);
}
