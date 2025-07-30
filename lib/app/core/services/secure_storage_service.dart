import 'package:get_storage/get_storage.dart';
import '../config/app_config.dart';
import 'log_service.dart';

/// Secure storage service for handling sensitive data like tokens
///
/// This service provides methods to securely store and retrieve
/// authentication tokens and other sensitive user data.
class SecureStorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';

  final GetStorage _storage = GetStorage();

  /// Store access token securely
  Future<void> storeAccessToken(String token) async {
    try {
      await _storage.write(_accessTokenKey, token);
      LogService.info('Access token stored securely');
    } catch (e) {
      LogService.error('Failed to store access token', e);
      throw Exception('Failed to store access token');
    }
  }

  /// Retrieve access token
  String? getAccessToken() {
    try {
      return _storage.read<String>(_accessTokenKey);
    } catch (e) {
      LogService.error('Failed to retrieve access token', e);
      return null;
    }
  }

  /// Store refresh token securely
  Future<void> storeRefreshToken(String token) async {
    try {
      await _storage.write(_refreshTokenKey, token);
      LogService.info('Refresh token stored securely');
    } catch (e) {
      LogService.error('Failed to store refresh token', e);
      throw Exception('Failed to store refresh token');
    }
  }

  /// Retrieve refresh token
  String? getRefreshToken() {
    try {
      return _storage.read<String>(_refreshTokenKey);
    } catch (e) {
      LogService.error('Failed to retrieve refresh token', e);
      return null;
    }
  }

  /// Store user data
  Future<void> storeUserData(Map<String, dynamic> userData) async {
    try {
      await _storage.write(_userDataKey, userData);
      LogService.info('User data stored securely');
    } catch (e) {
      LogService.error('Failed to store user data', e);
      throw Exception('Failed to store user data');
    }
  }

  /// Retrieve user data
  Map<String, dynamic>? getUserData() {
    try {
      return _storage.read<Map<String, dynamic>>(_userDataKey);
    } catch (e) {
      LogService.error('Failed to retrieve user data', e);
      return null;
    }
  }

  /// Check if user is authenticated (has valid access token)
  bool get isAuthenticated {
    final token = getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all stored authentication data
  Future<void> clearAuthData() async {
    try {
      await _storage.remove(_accessTokenKey);
      await _storage.remove(_refreshTokenKey);
      await _storage.remove(_userDataKey);
      LogService.info('All authentication data cleared');
    } catch (e) {
      LogService.error('Failed to clear authentication data', e);
      throw Exception('Failed to clear authentication data');
    }
  }

  /// Clear all storage data (for logout)
  Future<void> clearAll() async {
    try {
      await _storage.erase();
      LogService.info('All storage data cleared');
    } catch (e) {
      LogService.error('Failed to clear all storage data', e);
      throw Exception('Failed to clear all storage data');
    }
  }

  /// Get authorization header for API requests
  String? getAuthorizationHeader() {
    final token = getAccessToken();
    if (token != null && token.isNotEmpty) {
      return 'Bearer $token';
    }
    return null;
  }

  /// Store login status and user role
  Future<void> storeLoginStatus({
    required bool isLoggedIn,
    required String userRole,
  }) async {
    try {
      await _storage.write(AppConfig.loginStatusKey, isLoggedIn);
      await _storage.write(AppConfig.userRoleKey, userRole);
      LogService.info('Login status stored: $userRole');
    } catch (e) {
      LogService.error('Failed to store login status', e);
      throw Exception('Failed to store login status');
    }
  }

  /// Get login status
  bool get isLoggedIn {
    try {
      return _storage.read<bool>(AppConfig.loginStatusKey) ?? false;
    } catch (e) {
      LogService.error('Failed to retrieve login status', e);
      return false;
    }
  }

  /// Get user role
  String get userRole {
    try {
      return _storage.read<String>(AppConfig.userRoleKey) ?? 'user';
    } catch (e) {
      LogService.error('Failed to retrieve user role', e);
      return 'user';
    }
  }
}
