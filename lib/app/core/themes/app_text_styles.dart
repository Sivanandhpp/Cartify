import 'package:bevco/app/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  // Display
  static const displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.bold,
    height: 1.1,
  );
  static const displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.bold,
  );
  static const displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w600,
  );

  // Headlines
  static const headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
  static const headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );
  static const headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  // Titles
  static const titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );
  static const titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  // Body
  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  static const bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
  static const bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Labels / Captions
  static const labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.textSecondary,
  );
  static const labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
  static const labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
}

class AppTextStyless {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  static const TextStyle error = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.red,
  );
  static final TextTheme textTheme = TextTheme(
    titleLarge: heading,
    bodyMedium: body,
  );
}
