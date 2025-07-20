import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Collection of reusable button widgets for the application
class AppButtons {
  AppButtons._();

  /// Primary elevated button with app styling
  static Widget primary({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool enabled = true,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
    IconData? icon,
  }) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 60,
      child: ElevatedButton(
        onPressed: enabled && !isLoading ? onPressed : null,
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
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(text, style: AppTextStyles.labelLarge(Colors.white)),
                ],
              ),
      ),
    );
  }

  /// Secondary outlined button
  static Widget secondary({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool enabled = true,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
    IconData? icon,
  }) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56,
      child: OutlinedButton(
        onPressed: enabled && !isLoading ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: AppTextStyles.labelLarge(AppColors.primary),
                  ),
                ],
              ),
      ),
    );
  }

  /// Text button for subtle actions
  static Widget text({
    required String text,
    required VoidCallback onPressed,
    bool enabled = true,
    EdgeInsetsGeometry? padding,
    Color? textColor,
    IconData? icon,
  }) {
    return TextButton(
      onPressed: enabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? AppColors.primary,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 6)],
          Text(
            text,
            style: AppTextStyles.bodyMedium(
              textColor ?? AppColors.primary,
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  /// Icon button with background
  static Widget icon({
    required IconData icon,
    required VoidCallback onPressed,
    bool enabled = true,
    Color? backgroundColor,
    Color? iconColor,
    double? size,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.lightSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: enabled ? onPressed : null,
        icon: Icon(
          icon,
          color: iconColor ?? AppColors.lightOnSurface,
          size: size ?? 24,
        ),
        padding: padding ?? const EdgeInsets.all(8),
      ),
    );
  }

  /// Floating action button with app styling
  static Widget floating({
    required VoidCallback onPressed,
    IconData icon = Icons.add,
    bool mini = false,
    String? tooltip,
  }) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      mini: mini,
      tooltip: tooltip,
      child: Icon(icon),
    );
  }

  /// Chip button for tags/filters
  static Widget chip({
    required String label,
    VoidCallback? onPressed,
    bool selected = false,
    IconData? icon,
    VoidCallback? onDeleted,
  }) {
    if (onPressed != null) {
      return FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onPressed(),
        backgroundColor: AppColors.lightSurface,
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        checkmarkColor: AppColors.primary,
        labelStyle: AppTextStyles.bodySmall(
          selected ? AppColors.primary : AppColors.lightOnSurface,
        ),
        avatar: icon != null ? Icon(icon, size: 16) : null,
      );
    } else {
      return Chip(
        label: Text(label),
        backgroundColor: AppColors.lightSurface,
        labelStyle: AppTextStyles.bodySmall(AppColors.lightOnSurface),
        avatar: icon != null ? Icon(icon, size: 16) : null,
        onDeleted: onDeleted,
      );
    }
  }

  /// Toggle button group
  static Widget toggle({
    required List<String> labels,
    required List<bool> selections,
    required void Function(int) onPressed,
    bool multiSelect = false,
  }) {
    return ToggleButtons(
      isSelected: selections,
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(8),
      selectedColor: Colors.white,
      fillColor: AppColors.primary,
      color: AppColors.lightOnSurface,
      constraints: const BoxConstraints(minWidth: 80, minHeight: 40),
      children: labels
          .map(
            (label) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                label,
                style: AppTextStyles.bodyMedium(AppColors.lightOnSurface),
              ),
            ),
          )
          .toList(),
    );
  }
}
