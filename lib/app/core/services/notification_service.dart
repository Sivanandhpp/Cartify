import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import 'log_service.dart';

/// Global notification service for consistent snackbar UI across the app
///
/// This service provides standardized notification methods with consistent
/// styling, animations, and behavior for different message types.
class NotificationService {
  NotificationService._();

  // Private constructor to prevent instantiation
  static const Duration _defaultDuration = Duration(seconds: 3);
  static const Duration _shortDuration = Duration(seconds: 2);
  static const Duration _longDuration = Duration(seconds: 5);

  /// Show a success notification (green theme)
  static void showSuccess({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition position = SnackPosition.TOP,
    bool logEvent = true,
  }) {
    if (logEvent) {
      LogService.info('Success notification: $title - $message');
    }

    Get.snackbar(
      title,
      message,
      snackPosition: position,
      duration: duration ?? _defaultDuration,
      backgroundColor: AppColors.lightSuccess,
      colorText: AppColors.white,
      icon: const Icon(
        Icons.check_circle_rounded,
        color: AppColors.white,
        size: 20,
      ),
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      boxShadows: [
        BoxShadow(
          color: AppColors.lightSuccess.withValues(alpha: 0.3),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  /// Show an error notification (red theme)
  static void showError({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition position = SnackPosition.TOP,
    bool logEvent = true,
  }) {
    if (logEvent) {
      LogService.warning('Error notification: $title - $message');
    }

    Get.snackbar(
      title,
      message,
      snackPosition: position,
      duration: duration ?? _longDuration,
      backgroundColor: AppColors.lightError,
      colorText: AppColors.white,
      icon: const Icon(Icons.error_rounded, color: AppColors.white, size: 20),
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      boxShadows: [
        BoxShadow(
          color: AppColors.lightError.withValues(alpha: 0.3),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  /// Show a warning notification (orange theme)
  static void showWarning({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition position = SnackPosition.TOP,
    bool logEvent = true,
  }) {
    if (logEvent) {
      LogService.warning('Warning notification: $title - $message');
    }

    Get.snackbar(
      title,
      message,
      snackPosition: position,
      duration: duration ?? _defaultDuration,
      backgroundColor: AppColors.lightWarning,
      colorText: AppColors.white,
      icon: const Icon(Icons.warning_rounded, color: AppColors.white, size: 20),
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      boxShadows: [
        BoxShadow(
          color: AppColors.lightWarning.withValues(alpha: 0.3),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  /// Show an info notification (blue theme)
  static void showInfo({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition position = SnackPosition.TOP,
    bool logEvent = true,
  }) {
    if (logEvent) {
      LogService.info('Info notification: $title - $message');
    }

    Get.snackbar(
      title,
      message,
      snackPosition: position,
      duration: duration ?? _defaultDuration,
      backgroundColor: AppColors.lightInfo,
      colorText: AppColors.white,
      icon: const Icon(Icons.info_rounded, color: AppColors.white, size: 20),
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      boxShadows: [
        BoxShadow(
          color: AppColors.lightInfo.withValues(alpha: 0.3),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  /// Show a primary notification (app theme colors)
  static void showPrimary({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition position = SnackPosition.TOP,
    IconData? icon,
    bool logEvent = true,
  }) {
    if (logEvent) {
      LogService.info('Primary notification: $title - $message');
    }

    Get.snackbar(
      title,
      message,
      snackPosition: position,
      duration: duration ?? _defaultDuration,
      backgroundColor: AppColors.lightPrimary,
      colorText: AppColors.lightOnPrimary,
      icon: icon != null
          ? Icon(icon, color: AppColors.lightOnPrimary, size: 20)
          : null,
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      boxShadows: [
        BoxShadow(
          color: AppColors.lightPrimary.withValues(alpha: 0.3),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  /// Show a loading notification (persists until dismissed)
  static void showLoading({
    required String title,
    String message = 'Please wait...',
    SnackPosition position = SnackPosition.TOP,
  }) {
    LogService.debug('Loading notification: $title');

    Get.snackbar(
      title,
      message,
      snackPosition: position,
      duration: const Duration(hours: 1), // Very long duration
      backgroundColor: AppColors.lightSurface,
      colorText: AppColors.lightOnSurface,
      icon: const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightPrimary),
        ),
      ),
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      showProgressIndicator: false,
      isDismissible: false,
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  /// Dismiss any currently showing snackbar
  static void dismiss() {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
      LogService.debug('Dismissed current notification');
    }
  }

  /// Show a custom notification with full control
  static void showCustom({
    required String title,
    required String message,
    required Color backgroundColor,
    required Color textColor,
    IconData? icon,
    Duration? duration,
    SnackPosition position = SnackPosition.TOP,
    bool logEvent = true,
  }) {
    if (logEvent) {
      LogService.info('Custom notification: $title - $message');
    }

    Get.snackbar(
      title,
      message,
      snackPosition: position,
      duration: duration ?? _defaultDuration,
      backgroundColor: backgroundColor,
      colorText: textColor,
      icon: icon != null ? Icon(icon, color: textColor, size: 20) : null,
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      boxShadows: [
        BoxShadow(
          color: backgroundColor.withValues(alpha: 0.3),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  // Convenience methods for common notifications

  /// Quick success message
  static void success(String message) =>
      showSuccess(title: 'Success', message: message, duration: _shortDuration);

  /// Quick error message
  static void error(String message) =>
      showError(title: 'Error', message: message);

  /// Quick info message
  static void info(String message) => showInfo(title: 'Info', message: message);

  /// Quick warning message
  static void warning(String message) =>
      showWarning(title: 'Warning', message: message);
}



