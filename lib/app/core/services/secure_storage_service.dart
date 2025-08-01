import 'package:get_storage/get_storage.dart';
import '../config/app_config.dart';
import 'log_service.dart';

/// Production-level secure storage service for authentication and user data
///
/// Handles all secure storage operations including tokens, user profiles,
/// and authentication state management with comprehensive error handling.
class SecureStorageService {
  // Storage keys for different data types
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userProfileKey = 'user_profile';

  // Singleton pattern for consistent storage instance
  static final GetStorage _storage = GetStorage();

  // ============================================================================
  // TOKEN MANAGEMENT
  // ============================================================================

  /// Store access token securely
  Future<void> storeAccessToken(String token) async {
    await _safeWrite(_accessTokenKey, token, 'Access token');
  }

  /// Get current access token
  String? getAccessToken() {
    return _safeRead<String>(_accessTokenKey);
  }

  /// Store refresh token securely
  Future<void> storeRefreshToken(String token) async {
    await _safeWrite(_refreshTokenKey, token, 'Refresh token');
  }

  /// Get current refresh token
  String? getRefreshToken() {
    return _safeRead<String>(_refreshTokenKey);
  }

  /// Get authorization header for API requests
  String? getAuthorizationHeader() {
    final token = getAccessToken();
    return token?.isNotEmpty == true ? 'Bearer $token' : null;
  }

  // ============================================================================
  // USER PROFILE MANAGEMENT
  // ============================================================================

  /// Store complete user profile data
  Future<void> storeUserProfile(Map<String, dynamic> profile) async {
    await _safeWrite(_userProfileKey, profile, 'User profile');
  }

  /// Get stored user profile
  Map<String, dynamic>? getUserProfile() {
    return _safeRead<Map<String, dynamic>>(_userProfileKey);
  }

  /// Get user role from stored profile (with fallback)
  String getUserRoleFromProfile() {
    final profile = getUserProfile();
    return profile?['role']?.toString() ?? 'buyer';
  }

  // ============================================================================
  // AUTHENTICATION STATE
  // ============================================================================

  /// Check if user has valid authentication token
  bool get isAuthenticated {
    final token = getAccessToken();
    return token?.isNotEmpty == true;
  }

  // ============================================================================
  // DATA CLEANUP
  // ============================================================================

  /// Clear all authentication-related data (for logout)
  Future<void> clearAuthData() async {
    try {
      final operations = [
        _storage.remove(_accessTokenKey),
        _storage.remove(_refreshTokenKey),
        _storage.remove(_userProfileKey),
        _storage.remove(AppConfig.loginStatusKey),
        _storage.remove(AppConfig.userRoleKey),
      ];

      await Future.wait(operations);
      LogService.info('Authentication data cleared successfully');
    } catch (e) {
      LogService.error('Failed to clear authentication data', e);
      rethrow;
    }
  }

  /// Clear all storage data (complete reset)
  Future<void> clearAll() async {
    try {
      await _storage.erase();
      LogService.info('All storage data cleared');
    } catch (e) {
      LogService.error('Failed to clear all storage data', e);
      rethrow;
    }
  }

  // ============================================================================
  // PRIVATE UTILITY METHODS
  // ============================================================================

  /// Safe write operation with error handling
  Future<void> _safeWrite(String key, dynamic value, String dataType) async {
    try {
      await _storage.write(key, value);
      LogService.info('$dataType stored successfully');
    } catch (e) {
      LogService.error('Failed to store $dataType', e);
      throw Exception('Failed to store $dataType');
    }
  }

  /// Safe read operation with error handling
  T? _safeRead<T>(String key) {
    try {
      return _storage.read<T>(key);
    } catch (e) {
      LogService.error('Failed to read data for key: $key', e);
      return null;
    }
  }
}
