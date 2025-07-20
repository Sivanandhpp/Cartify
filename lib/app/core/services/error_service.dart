import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'log_service.dart';
import 'notification_service.dart';

/// Production-level error handling service
///
/// This service provides centralized error handling, reporting, and recovery
/// mechanisms for the entire application.
class ErrorService extends GetxService {
  static ErrorService get instance => Get.find<ErrorService>();

  // Error tracking
  final RxList<AppError> _recentErrors = <AppError>[].obs;
  final RxBool _hasConnectivity = true.obs;

  // Getters
  List<AppError> get recentErrors => _recentErrors.toList();
  bool get hasConnectivity => _hasConnectivity.value;

  @override
  void onInit() {
    super.onInit();
    LogService.info('ErrorService initialized');
    _setupGlobalErrorHandling();
  }

  /// Setup global error handling
  void _setupGlobalErrorHandling() {
    // Handle uncaught Flutter errors
    FlutterError.onError = (FlutterErrorDetails details) {
      handleError(
        AppError(
          type: ErrorType.ui,
          message: details.summary.toString(),
          details: details.toString(),
          stackTrace: details.stack,
          timestamp: DateTime.now(),
        ),
      );
    };

    // Handle uncaught async errors
    PlatformDispatcher.instance.onError = (error, stack) {
      handleError(
        AppError(
          type: ErrorType.platform,
          message: error.toString(),
          stackTrace: stack,
          timestamp: DateTime.now(),
        ),
      );
      return true;
    };
  }

  /// Handle any error that occurs in the app
  void handleError(AppError error) {
    // Log the error
    LogService.error(
      'Error occurred: ${error.message}',
      error.details,
      error.stackTrace,
    );

    // Add to recent errors (keep only last 50)
    _recentErrors.add(error);
    if (_recentErrors.length > 50) {
      _recentErrors.removeAt(0);
    }

    // Report to crash analytics in production
    _reportError(error);

    // Show user-friendly error message
    _showUserError(error);
  }

  /// Handle network errors specifically
  void handleNetworkError(String message, {int? statusCode, String? endpoint}) {
    final error = AppError(
      type: ErrorType.network,
      message: message,
      details: 'Status Code: $statusCode, Endpoint: $endpoint',
      timestamp: DateTime.now(),
    );

    if (statusCode == null || statusCode == 0) {
      _hasConnectivity.value = false;
    }

    handleError(error);
  }

  /// Handle API errors
  void handleApiError(
    String message, {
    required String endpoint,
    int? statusCode,
    dynamic response,
  }) {
    final error = AppError(
      type: ErrorType.api,
      message: message,
      details: 'Endpoint: $endpoint, Status: $statusCode, Response: $response',
      timestamp: DateTime.now(),
    );

    handleError(error);
  }

  /// Handle validation errors
  void handleValidationError(String field, String message) {
    final error = AppError(
      type: ErrorType.validation,
      message: 'Validation failed for $field: $message',
      timestamp: DateTime.now(),
    );

    handleError(error);
  }

  /// Handle business logic errors
  void handleBusinessError(String message, {String? context}) {
    final error = AppError(
      type: ErrorType.business,
      message: message,
      details: context,
      timestamp: DateTime.now(),
    );

    handleError(error);
  }

  /// Report error to analytics/crash reporting service
  void _reportError(AppError error) {
    try {
      // In production, you would integrate with services like:
      // - Firebase Crashlytics
      // - Sentry
      // - Bugsnag
      // For now, we'll just log it
      LogService.critical('Reporting error to analytics: ${error.message}');
    } catch (e) {
      LogService.error('Failed to report error to analytics: $e');
    }
  }

  /// Show user-friendly error message
  void _showUserError(AppError error) {
    String userMessage = _getUserFriendlyMessage(error);

    // Only show critical errors to users
    if (error.type == ErrorType.network ||
        error.type == ErrorType.api ||
        error.type == ErrorType.business) {
      NotificationService.showError(
        title: 'Error',
        message: userMessage,
        duration: const Duration(seconds: 4),
      );
    }
  }

  /// Convert technical error to user-friendly message
  String _getUserFriendlyMessage(AppError error) {
    switch (error.type) {
      case ErrorType.network:
        return hasConnectivity
            ? 'Unable to connect to our servers. Please try again.'
            : 'No internet connection. Please check your network settings.';

      case ErrorType.api:
        return 'Something went wrong on our end. Please try again later.';

      case ErrorType.validation:
        return error.message; // Validation messages are already user-friendly

      case ErrorType.business:
        return error.message; // Business messages are already user-friendly

      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Update connectivity status
  void updateConnectivity(bool isConnected) {
    _hasConnectivity.value = isConnected;
    if (isConnected) {
      LogService.info('Connectivity restored');
    } else {
      LogService.warning('Connectivity lost');
    }
  }

  /// Clear recent errors
  void clearRecentErrors() {
    _recentErrors.clear();
    LogService.info('Recent errors cleared');
  }

  /// Get errors by type
  List<AppError> getErrorsByType(ErrorType type) {
    return _recentErrors.where((error) => error.type == type).toList();
  }

  /// Check if there are any recent errors of a specific type
  bool hasRecentErrors(ErrorType type) {
    return _recentErrors.any((error) => error.type == type);
  }

  /// Static method to show error message
  static void showError(String message) {
    NotificationService.showError(
      title: 'Error',
      message: message,
      duration: const Duration(seconds: 3),
    );
    LogService.error('User shown error: $message');
  }

  /// Static method to show success message
  static void showSuccess(String message) {
    NotificationService.showSuccess(
      title: 'Success',
      message: message,
      duration: const Duration(seconds: 2),
    );
    LogService.info('User shown success: $message');
  }

  /// Static method to show info message
  static void showInfo(String message) {
    NotificationService.showInfo(
      title: 'Info',
      message: message,
      duration: const Duration(seconds: 2),
    );
    LogService.info('User shown info: $message');
  }
}

/// Error types for categorization
enum ErrorType { network, api, ui, platform, validation, business, unknown }

/// Error model class
class AppError {
  final ErrorType type;
  final String message;
  final String? details;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  AppError({
    required this.type,
    required this.message,
    this.details,
    this.stackTrace,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'AppError(type: $type, message: $message, timestamp: $timestamp)';
  }
}



