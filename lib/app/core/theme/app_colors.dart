import 'package:flutter/material.dart';

/// Application color palette for both light and dark themes
///
/// This class provides a comprehensive color system that adapts to different themes
/// while maintaining brand consistency and accessibility standards.
class AppColors {
  AppColors._();

  // Brand Colors (consistent across themes)
  static const Color primaryBrand = Color(0xFF005AE6);
  static const Color secondaryBrand = Color(0xFF00B8D9);
  static const Color accentBrand = Color(0xFF7B68EE);

  // Light Theme Colors
  static const Color lightPrimary = primaryBrand;
  static const Color lightPrimaryVariant = Color(0xFF003BB3);
  static const Color lightSecondary = secondaryBrand;
  static const Color lightSecondaryVariant = Color(0xFF008BA6);

  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightError = Color(0xFFD32F2F);
  static const Color lightSuccess = Color(0xFF388E3C);
  static const Color lightWarning = Color(0xFFF57C00);
  static const Color lightInfo = Color(0xFF1976D2);

  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF1A1A1A);
  static const Color lightOnSurface = Color(0xFF1A1A1A);
  static const Color lightOnError = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF4285F4);
  static const Color darkPrimaryVariant = Color(0xFF1565C0);
  static const Color darkSecondary = Color(0xFF26C6DA);
  static const Color darkSecondaryVariant = Color(0xFF00ACC1);

  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkError = Color(0xFFCF6679);
  static const Color darkSuccess = Color(0xFF81C784);
  static const Color darkWarning = Color(0xFFFFB74D);
  static const Color darkInfo = Color(0xFF64B5F6);

  static const Color darkOnPrimary = Color(0xFF000000);
  static const Color darkOnSecondary = Color(0xFF000000);
  static const Color darkOnBackground = Color(0xFFE0E0E0);
  static const Color darkOnSurface = Color(0xFFE0E0E0);
  static const Color darkOnError = Color(0xFF000000);

  // Neutral Colors (adapt to theme)
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Semantic Colors
  static const Color transparent = Colors.transparent;
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Legacy color aliases for backward compatibility
  static const Color primary = lightPrimary;
  static const Color background = lightBackground;
  static const Color grey = grey500;

  // Special Purpose Colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);

  // Shopping Specific Colors
  static const Color discount = Color(0xFFE53935);
  static const Color inStock = Color(0xFF4CAF50);
  static const Color outOfStock = Color(0xFFFF5722);
  static const Color rating = Color(0xFFFFC107);

  // Social Media Colors
  static const Color facebook = Color(0xFF1877F2);
  static const Color google = Color(0xFFDB4437);
  static const Color twitter = Color(0xFF1DA1F2);
  static const Color instagram = Color(0xFFE4405F);

  // Helper methods for theme-aware colors
  static Color getTextPrimary(bool isDark) =>
      isDark ? darkOnBackground : lightOnBackground;
  static Color getTextSecondary(bool isDark) => isDark ? grey400 : grey600;
  static Color getBackground(bool isDark) =>
      isDark ? darkBackground : lightBackground;
  static Color getSurface(bool isDark) => isDark ? darkSurface : lightSurface;
  static Color getBorder(bool isDark) => isDark ? grey700 : grey300;
  static Color getDisabled(bool isDark) => isDark ? grey600 : grey400;
}

