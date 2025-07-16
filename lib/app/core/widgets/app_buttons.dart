import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../themes/app_colors.dart';
import '../themes/app_text_styles.dart';

class AppButtons {
  static Widget primary({
    required String text,
    required VoidCallback onPressed,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 20,
    ),
    Color? backgroundColor,
    Color? textColor,
    TextStyle? textStyle,
    bool enabled = true,
    IconData? icon,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: textColor ?? AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.secondaryBorder,
        ),
        padding: padding,
        textStyle: textStyle ?? AppTextStyless.button,
        elevation: 0,
      ),

      onPressed: enabled ? onPressed : null,
      child: icon == null
          ? Text(text)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(text),
                const SizedBox(width: 8),
                Icon(icon, color: AppColors.background),
              ],
            ),
    );
  }
}
