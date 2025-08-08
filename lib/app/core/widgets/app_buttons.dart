import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Primary button widget with consistent styling, loading state, and optional icon.
///
/// Usage:
/// ```dart
/// AppButton(
///   text: 'Continue',
///   onPressed: () => handleContinue(),
///   isLoading: isSubmitting,
///   icon: Icons.arrow_forward,
/// )
/// ```
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.height = 60,
    this.icon,
    this.padding,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;
  final double? width;
  final double? height;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: _isInteractive ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.radiusLarge,
          ),
          elevation: 2,
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  /// Button is interactive when enabled and not loading
  bool get _isInteractive => enabled && !isLoading;

  /// Builds the button content - either loading indicator or text with optional icon
  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
        Text(text, style: AppTextStyles.labelLarge(Colors.white)),
      ],
    );
  }
}
