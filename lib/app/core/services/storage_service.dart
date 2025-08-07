import 'package:get_storage/get_storage.dart';
import 'package:cartify/app/core/index.dart';

/// Production-level secure storage service for authentication and user data
///
/// Handles all secure storage operations including tokens, user profiles,
/// and authentication state management with comprehensive error handling.
class StorageService {
  // Singleton pattern for consistent storage instance
  static final GetStorage _storage = GetStorage();

  // ============================================================================
  // USER PROFILE MANAGEMENT
  // ============================================================================

  /// Store complete user profile data
  Future<void> storeUserProfile(UserModel user) async {
    await _safeWrite(AppConfig.userProfileKey, user, 'User profile');
  }

  /// Get stored user profile
  UserModel? getUserProfile() {
    return _safeRead<UserModel>(AppConfig.userProfileKey);
  }

  Future<void> clearUserProfile() async {
    await _safeWrite(AppConfig.userProfileKey, null, 'User profile cleared');
  }

  bool get isBoarded => _safeRead<bool>(AppConfig.onboardingStatusKey) ?? false;
  Future<void> markBoarded() =>
      _safeWrite(AppConfig.onboardingStatusKey, true, 'Onboarding status');

  // ============================================================================
  // AUTHENTICATION STATE
  // ============================================================================
  Future<void> storeAuthStatus(bool isAuthenticated) async {
    await _safeWrite(
      AppConfig.onboardingStatusKey,
      isAuthenticated,
      'Authentication status',
    );
  }

  /// Check if user has authenticated
  bool get isAuthenticated {
    return _safeRead<bool>(AppConfig.onboardingStatusKey) ?? false;
  }

  // ============================================================================
  // DATA CLEANUP
  // ============================================================================

  /// Clear all authentication-related data (for logout)
  Future<void> clearAuthData() async {
    try {
      final operations = [
        _storage.remove(AppConfig.userProfileKey),
        _storage.remove(AppConfig.loginStatusKey),
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
