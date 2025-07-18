import 'dart:developer' as developer;

/// Application-wide logging service for debugging and monitoring
class LogService {
  static const bool _isDebugMode = true; // Set to false in production

  /// Log debug messages
  static void debug(String message, [dynamic data]) {
    if (_isDebugMode) {
      developer.log('🐛 DEBUG: $message', name: 'Debug');
      if (data != null) {
        developer.log('   Data: $data', name: 'Debug');
      }
    }
  }

  /// Log info messages
  static void info(String message, [dynamic data]) {
    if (_isDebugMode) {
      developer.log('ℹ️ INFO: $message', name: 'Info');
      if (data != null) {
        developer.log('   Data: $data', name: 'Info');
      }
    }
  }

  /// Log warning messages
  static void warning(String message, [dynamic data]) {
    if (_isDebugMode) {
      developer.log('⚠️ WARNING: $message', name: 'Warning');
      if (data != null) {
        developer.log('   Data: $data', name: 'Warning');
      }
    }
  }

  /// Log error messages
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    developer.log('❌ ERROR: $message', name: 'Error');
    if (error != null) {
      developer.log('   Error: $error', name: 'Error');
    }
    if (stackTrace != null) {
      developer.log('   Stack trace: $stackTrace', name: 'Error');
    }
  }

  /// Log API requests
  static void apiRequest(String method, String url, [dynamic data]) {
    if (_isDebugMode) {
      developer.log('🌐 API $method: $url', name: 'API');
      if (data != null) {
        developer.log('   Request data: $data', name: 'API');
      }
    }
  }

  /// Log API responses
  static void apiResponse(String url, int statusCode, [dynamic data]) {
    if (_isDebugMode) {
      developer.log('📡 API Response ($statusCode): $url', name: 'API');
      if (data != null) {
        developer.log('   Response data: $data', name: 'API');
      }
    }
  }
}
