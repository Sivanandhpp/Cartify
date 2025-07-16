import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,
    textTheme: AppTextStyless.textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      elevation: 0,
      titleTextStyle: AppTextStyless.title,
    ),
  );
}
