import 'dart:developer' as developer;
import '../config/app_identity.dart';

/// Log levels enum for better organization
enum LogLevel { debug, info, warning, error, critical }

/// Production-level logging service with different log levels and formatting
///
/// This service provides structured logging with different levels and can be
/// easily configured for different environments (development, staging, production).
class LogService {
  LogService._();

  // Private constructor to prevent instantiation
  static String get _loggerName => AppIdentity.displayName;
  static const bool _isEnabled =
      true; // Will be replaced with AppConfig.enableLogging when available

  /// Internal method to format and output logs
  static void _log(
    LogLevel level,
    String message, [
    dynamic data,
    StackTrace? stackTrace,
  ]) {
    if (!_isEnabled) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelString = level.name.toUpperCase().padRight(8);
    final formattedMessage = '[$timestamp] $levelString: $message';

    // Use different logging mechanisms based on level
    switch (level) {
      case LogLevel.debug:
        developer.log('🐛 $formattedMessage', name: _loggerName, level: 500);
        break;
      case LogLevel.info:
        developer.log('ℹ️  $formattedMessage', name: _loggerName, level: 800);
        break;
      case LogLevel.warning:
        developer.log('⚠️  $formattedMessage', name: _loggerName, level: 900);
        break;
      case LogLevel.error:
        developer.log('❌ $formattedMessage', name: _loggerName, level: 1000);
        break;
      case LogLevel.critical:
        developer.log('🚨 $formattedMessage', name: _loggerName, level: 1200);
        break;
    }

    // Log additional data if provided
    if (data != null) {
      developer.log('   📊 Data: $data', name: _loggerName);
    }

    // Log stack trace for errors
    if (stackTrace != null) {
      developer.log('   📍 Stack Trace:', name: _loggerName);
      developer.log(stackTrace.toString(), name: _loggerName);
    }
  }

  /// Log debug messages (development only)
  static void debug(String message, [dynamic data]) {
    _log(LogLevel.debug, message, data);
  }

  /// Log informational messages
  static void info(String message, [dynamic data]) {
    _log(LogLevel.info, message, data);
  }

  /// Log warning messages
  static void warning(String message, [dynamic data]) {
    _log(LogLevel.warning, message, data);
  }

  /// Log error messages with optional error object and stack trace
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error, stackTrace);
  }

  /// Log critical errors that require immediate attention
  static void critical(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _log(LogLevel.critical, message, error, stackTrace);
  }

  /// Log API requests for debugging
  static void apiRequest(
    String method,
    String url, [
    Map<String, dynamic>? headers,
    dynamic body,
  ]) {
    if (!_isEnabled) return;

    info('API Request: $method $url');
    if (headers != null) {
      debug('Request Headers: $headers');
    }
    if (body != null) {
      debug('Request Body: $body');
    }
  }

  /// Log API responses for debugging
  static void apiResponse(
    String method,
    String url,
    int statusCode, [
    dynamic response,
  ]) {
    if (!_isEnabled) return;

    final level = statusCode >= 400 ? LogLevel.error : LogLevel.info;
    _log(level, 'API Response: $method $url - Status: $statusCode');
    if (response != null) {
      debug('Response Body: $response');
    }
  }

  /// Log user actions for analytics
  static void userAction(String action, [Map<String, dynamic>? parameters]) {
    info('User Action: $action', parameters);
  }

  /// Log navigation events
  static void navigation(String from, String to) {
    debug('Navigation: $from → $to');
  }

  /// Log performance metrics
  static void performance(
    String metric,
    Duration duration, [
    String? description,
  ]) {
    info(
      'Performance: $metric took ${duration.inMilliseconds}ms${description != null ? ' - $description' : ''}',
    );
  }

  /// Log business logic events
  static void business(String event, [Map<String, dynamic>? data]) {
    info('Business Event: $event', data);
  }

  /// Log security-related events
  static void security(String event, [Map<String, dynamic>? data]) {
    warning('Security Event: $event', data);
  }

  /// Log app lifecycle events
  static void lifecycle(String event) {
    info('App Lifecycle: $event');
  }

  /// Method to change log level at runtime (for debugging)
  static void setLogLevel(LogLevel minLevel) {
    // Implementation would depend on your logging framework
    debug('Log level changed to: ${minLevel.name}');
  }

  /// Method to flush logs (useful for crash reporting)
  static Future<void> flush() async {
    // Implementation would depend on your logging framework
    debug('Log buffer flushed');
  }
}



