import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography system for the application
///
/// This class provides a comprehensive text styling system that works
/// with both light and dark themes while maintaining readability and hierarchy.
class AppTextStyles {
  AppTextStyles._();

  // Font Family
  static const String primaryFontFamily = 'Inter';
  static const String secondaryFontFamily = 'Roboto';

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Base Text Styles
  static const TextStyle _baseStyle = TextStyle(
    fontFamily: primaryFontFamily,
    letterSpacing: 0.0,
    height: 1.4,
  );

  // Display Styles (Large headlines)
  static TextStyle displayLarge(Color color) => _baseStyle.copyWith(
    fontSize: 57,
    fontWeight: extraBold,
    color: color,
    height: 1.12,
  );

  static TextStyle displayMedium(Color color) => _baseStyle.copyWith(
    fontSize: 45,
    fontWeight: bold,
    color: color,
    height: 1.16,
  );

  static TextStyle displaySmall(Color color) => _baseStyle.copyWith(
    fontSize: 36,
    fontWeight: bold,
    color: color,
    height: 1.22,
  );

  // Headline Styles
  static TextStyle headlineLarge(Color color) => _baseStyle.copyWith(
    fontSize: 32,
    fontWeight: bold,
    color: color,
    height: 1.25,
  );

  static TextStyle headlineMedium(Color color) => _baseStyle.copyWith(
    fontSize: 28,
    fontWeight: semiBold,
    color: color,
    height: 1.29,
  );

  static TextStyle headlineSmall(Color color) => _baseStyle.copyWith(
    fontSize: 24,
    fontWeight: semiBold,
    color: color,
    height: 1.33,
  );

  // Title Styles
  static TextStyle titleLarge(Color color) => _baseStyle.copyWith(
    fontSize: 22,
    fontWeight: semiBold,
    color: color,
    height: 1.27,
  );

  static TextStyle titleMedium(Color color) => _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: medium,
    color: color,
    height: 1.5,
    letterSpacing: 0.15,
  );

  static TextStyle titleSmall(Color color) => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: medium,
    color: color,
    height: 1.43,
    letterSpacing: 0.1,
  );

  // Body Styles
  static TextStyle bodyLarge(Color color) => _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: regular,
    color: color,
    height: 1.5,
    letterSpacing: 0.5,
  );

  static TextStyle bodyMedium(Color color) => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: regular,
    color: color,
    height: 1.43,
    letterSpacing: 0.25,
  );

  static TextStyle bodySmall(Color color) => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: regular,
    color: color,
    height: 1.33,
    letterSpacing: 0.4,
  );

  // Label Styles
  static TextStyle labelLarge(Color color) => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: medium,
    color: color,
    height: 1.43,
    letterSpacing: 0.1,
  );

  static TextStyle labelMedium(Color color) => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: medium,
    color: color,
    height: 1.33,
    letterSpacing: 0.5,
  );

  static TextStyle labelSmall(Color color) => _baseStyle.copyWith(
    fontSize: 11,
    fontWeight: medium,
    color: color,
    height: 1.45,
    letterSpacing: 0.5,
  );

  // Special Purpose Styles
  static TextStyle button(Color color) => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: medium,
    color: color,
    height: 1.43,
    letterSpacing: 0.1,
  );

  static TextStyle caption(Color color) => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: regular,
    color: color,
    height: 1.33,
    letterSpacing: 0.4,
  );

  static TextStyle overline(Color color) => _baseStyle.copyWith(
    fontSize: 10,
    fontWeight: regular,
    color: color,
    height: 1.6,
    letterSpacing: 1.5,
  );

  // App Specific Styles
  static TextStyle price(Color color) => _baseStyle.copyWith(
    fontSize: 18,
    fontWeight: bold,
    color: color,
    height: 1.22,
  );

  static TextStyle priceStrike(Color color) => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: regular,
    color: color,
    decoration: TextDecoration.lineThrough,
    height: 1.43,
  );

  static TextStyle discount(Color color) => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: semiBold,
    color: color,
    height: 1.33,
  );

  static TextStyle rating(Color color) => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: medium,
    color: color,
    height: 1.33,
  );

  // Helper method to create TextTheme for different themes
  static TextTheme createTextTheme(bool isDark) {
    final primaryColor = AppColors.getTextPrimary(isDark);
    final secondaryColor = AppColors.getTextSecondary(isDark);

    return TextTheme(
      displayLarge: displayLarge(primaryColor),
      displayMedium: displayMedium(primaryColor),
      displaySmall: displaySmall(primaryColor),
      headlineLarge: headlineLarge(primaryColor),
      headlineMedium: headlineMedium(primaryColor),
      headlineSmall: headlineSmall(primaryColor),
      titleLarge: titleLarge(primaryColor),
      titleMedium: titleMedium(primaryColor),
      titleSmall: titleSmall(primaryColor),
      bodyLarge: bodyLarge(primaryColor),
      bodyMedium: bodyMedium(primaryColor),
      bodySmall: bodySmall(secondaryColor),
      labelLarge: labelLarge(primaryColor),
      labelMedium: labelMedium(primaryColor),
      labelSmall: labelSmall(secondaryColor),
    );
  }
}




