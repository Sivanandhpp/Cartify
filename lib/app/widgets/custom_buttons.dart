import 'package:flutter/material.dart';
import '../core/themes/app_colors.dart';
import '../core/themes/app_text_styles.dart';

class CustomButtons {
  // Primary Elevated Button
  static Widget primary({
    required String text,
    required VoidCallback onPressed,
    double borderRadius = 8.0,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
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
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: padding,
        textStyle: textStyle ?? AppTextStyles.button,
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

  // // Outline Button
  // static Widget outline({
  //   required String text,
  //   required VoidCallback onPressed,
  //   double borderRadius = 12.0,
  //   EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  //   Color? borderColor,
  //   Color? textColor,
  //   TextStyle? textStyle,
  //   bool enabled = true,
  //   Widget? icon,
  // }) {
  //   return OutlinedButton(
  //     style: OutlinedButton.styleFrom(
  //       foregroundColor: textColor ?? AppColors.primary,
  //       side: BorderSide(color: borderColor ?? AppColors.primary),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(borderRadius),
  //       ),
  //       padding: padding,
  //       textStyle: textStyle ?? AppTextStyles.button,
  //     ),
  //     onPressed: enabled ? onPressed : null,
  //     child: icon == null
  //         ? Text(text)
  //         : Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(text),
  //               const SizedBox(width: 8),
  //               icon,
  //             ],
  //           ),
  //   );
  // }

  // // Text Button
  // static Widget text({
  //   required String text,
  //   required VoidCallback onPressed,
  //   Color? textColor,
  //   TextStyle? textStyle,
  //   bool enabled = true,
  // }) {
  //   return TextButton(
  //     onPressed: enabled ? onPressed : null,
  //     child: Text(
  //       text,
  //       style: textStyle ??
  //           AppTextStyles.button,
  //     ),
  //   );
  // }

  // // Icon Button
  // static Widget icon({
  //   required IconData icon,
  //   required VoidCallback onPressed,
  //   Color? iconColor,
  //   Color? backgroundColor,
  //   double size = 48.0,
  //   double radius = 12.0,
  //   bool enabled = true,
  // }) {
  //   return Ink(
  //     decoration: BoxDecoration(
  //       color: backgroundColor ?? AppColors.primary,
  //       borderRadius: BorderRadius.circular(radius),
  //     ),
  //     child: IconButton(
  //       icon: Icon(icon, color: iconColor ?? Colors.white),
  //       onPressed: enabled ? onPressed : null,
  //       iconSize: size * 0.5,
  //     ),
  //   );
  // }
}
