import 'package:get/get.dart';
import '../constants/app_strings.dart';

/// Centralized error handling service for the application
class ErrorService extends GetxService {
  /// Show error snackbar
  static void showError(String message, {String? title}) {
    Get.snackbar(
      title ?? AppStrings.error,
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  /// Show success snackbar
  static void showSuccess(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Success',
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  /// Show info snackbar
  static void showInfo(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Info',
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  /// Handle common API errors
  static void handleApiError(dynamic error) {
    String message = 'An unexpected error occurred';

    if (error is String) {
      message = error;
    } else if (error.toString().isNotEmpty) {
      message = error.toString();
    }

    showError(message);
  }
}
