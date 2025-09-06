import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Reusable confirmation dialog widget with custom buttons
///
/// Usage:
/// ```dart
/// AppConfirmationDialog(
///   title: 'Mark as Shipped',
///   content: 'Are you sure you want to mark order #${order.id.substring(0, 8)} as shipped?',
///   confirmText: 'Mark Shipped',
///   onConfirm: () => controller.markAsShipped(order.id),
///   onCancel: () => Get.back(),
/// ).show();
/// ```
class AppDialog {
  final String title;
  final String content;
  final String? cancelText;
  final String? confirmText;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final Color? confirmButtonColor;
  final bool barrierDismissible;

  const AppDialog({
    required this.title,
    required this.content,
    this.cancelText = 'Cancel',
    this.confirmText = 'Confirm',
    this.onCancel,
    this.onConfirm,
    this.confirmButtonColor,
    this.barrierDismissible = true,
  });

  /// Shows the dialog using GetX
  void show() {
    Get.dialog(_buildDialog(), barrierDismissible: barrierDismissible);
  }

  Widget _buildDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      title: Text(title, style: AppTextStyles.headlineSmall(AppColors.black)),
      content: Text(
        content,
        style: AppTextStyles.bodyMedium(AppColors.grey700),
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: onCancel ?? () => Get.back(),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.grey600,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(
            cancelText!,
            style: AppTextStyles.labelLarge(AppColors.grey600),
          ),
        ),

        // Confirm Button (Custom Styled)
        _buildConfirmButton(),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      decoration: BoxDecoration(
        color: confirmButtonColor ?? AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: onConfirm,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          confirmText!,
          style: AppTextStyles.labelLarge(
            Colors.white,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
