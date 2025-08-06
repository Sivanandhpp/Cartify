/// Authentication Storage Service for Cartify
/// Handles secure storage and retrieval of authentication tokens,
/// user sessions, and login state management

import 'package:get/get.dart';

import '../../models/auth_models.dart';
import '../../models/user_models.dart';
import '../secure_storage_service.dart';
import '../log_service.dart';

/// Service for authentication storage and state management
class AuthStorageService extends GetxService {
  final SecureStorageService _secureStorage = SecureStorageService();

  // Observable authentication state
  final RxBool _isLoggedIn = false.obs;
  final Rx<UserProfile?> _currentUser = Rx<UserProfile?>(null);
  final Rx<AuthTokenResponse?> _currentTokens = Rx<AuthTokenResponse?>(null);

  // Getters for reactive state
  bool get isLoggedIn => _isLoggedIn.value;
  UserProfile? get currentUser => _currentUser.value;
  AuthTokenResponse? get currentTokens => _currentTokens.value;

  // Reactive getters
  RxBool get isLoggedInRx => _isLoggedIn;
  Rx<UserProfile?> get currentUserRx => _currentUser;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadStoredAuthData();
  }

  /// Load stored authentication data on app start
  Future<void> _loadStoredAuthData() async {
    try {
      LogService.info('Loading stored authentication data');

      // Check if user has stored tokens
      final accessToken = _secureStorage.getAccessToken();
      final refreshToken = _secureStorage.getRefreshToken();

      if (accessToken != null && refreshToken != null) {
        // Create token response object
        _currentTokens.value = AuthTokenResponse(
          accessToken: accessToken,
          refreshToken: refreshToken,
          accessTokenExpires: '60m', // Default values
          refreshTokenExpires: '30d',
        );

        // Load user profile if available
        final userProfileData = _secureStorage.getUserProfile();
        if (userProfileData != null) {
          _currentUser.value = UserProfile.fromJson(userProfileData);
        }

        _isLoggedIn.value = true;
        LogService.info('User authentication restored from storage');
      } else {
        LogService.info('No stored authentication found');
        _isLoggedIn.value = false;
      }
    } catch (e) {
      LogService.error('Error loading stored auth data: $e');
      _isLoggedIn.value = false;
    }
  }

  /// Save authentication tokens securely
  Future<void> saveAuthTokens(AuthTokenResponse tokens) async {
    try {
      LogService.info('Saving authentication tokens');

      await _secureStorage.storeAccessToken(tokens.accessToken);
      await _secureStorage.storeRefreshToken(tokens.refreshToken);

      _currentTokens.value = tokens;
      _isLoggedIn.value = true;

      LogService.info('Authentication tokens saved successfully');
    } catch (e) {
      LogService.error('Error saving auth tokens: $e');
      throw Exception('Failed to save authentication tokens');
    }
  }

  /// Save user profile data
  Future<void> saveUserProfile(UserProfile userProfile) async {
    try {
      LogService.info('Saving user profile');

      await _secureStorage.storeUserProfile(userProfile.toJson());
      _currentUser.value = userProfile;

      LogService.info('User profile saved successfully');
    } catch (e) {
      LogService.error('Error saving user profile: $e');
      throw Exception('Failed to save user profile');
    }
  }

  /// Update stored tokens (used during token refresh)
  Future<void> updateTokens(AuthTokenResponse newTokens) async {
    try {
      LogService.info('Updating authentication tokens');

      await _secureStorage.storeAccessToken(newTokens.accessToken);
      await _secureStorage.storeRefreshToken(newTokens.refreshToken);

      _currentTokens.value = newTokens;

      LogService.info('Authentication tokens updated successfully');
    } catch (e) {
      LogService.error('Error updating tokens: $e');
      throw Exception('Failed to update authentication tokens');
    }
  }

  /// Get current access token
  String? getAccessToken() {
    return _secureStorage.getAccessToken();
  }

  /// Get current refresh token
  String? getRefreshToken() {
    return _secureStorage.getRefreshToken();
  }

  /// Get authorization header for API requests
  String? getAuthorizationHeader() {
    return _secureStorage.getAuthorizationHeader();
  }

  /// Check if access token is expired (basic implementation)
  bool isAccessTokenExpired() {
    final token = currentTokens?.accessToken;
    if (token == null) return true;

    // In a real implementation, you would decode the JWT and check the exp claim
    // For now, we'll use a simple approach
    return currentTokens?.isAccessTokenExpired ?? true;
  }

  /// Check if user has valid authentication
  bool hasValidAuthentication() {
    return isLoggedIn && !isAccessTokenExpired();
  }

  /// Get user role from stored profile
  String getUserRole() {
    return _currentUser.value?.role ?? 'BUYER';
  }

  /// Check if current user is admin
  bool isAdmin() {
    return getUserRole().toUpperCase() == 'ADMIN';
  }

  /// Check if current user is seller
  bool isSeller() {
    return getUserRole().toUpperCase() == 'SELLER';
  }

  /// Check if current user is buyer
  bool isBuyer() {
    return getUserRole().toUpperCase() == 'BUYER';
  }

  /// Clear all authentication data (logout)
  Future<void> clearAuthData() async {
    try {
      LogService.info('Clearing authentication data');

      await _secureStorage.clearAuthData();

      _isLoggedIn.value = false;
      _currentUser.value = null;
      _currentTokens.value = null;

      LogService.info('Authentication data cleared successfully');
    } catch (e) {
      LogService.error('Error clearing auth data: $e');
      throw Exception('Failed to clear authentication data');
    }
  }

  /// Get formatted login status for debugging
  String getLoginStatus() {
    if (!isLoggedIn) return 'Not logged in';
    if (isAccessTokenExpired()) return 'Token expired';
    return 'Logged in as ${currentUser?.name ?? currentUser?.phoneNumber ?? 'Unknown'}';
  }

  /// Validate stored authentication data
  Future<bool> validateStoredAuth() async {
    try {
      if (!isLoggedIn) return false;

      final accessToken = getAccessToken();
      final refreshToken = getRefreshToken();

      return accessToken != null && refreshToken != null;
    } catch (e) {
      LogService.error('Error validating stored auth: $e');
      return false;
    }
  }
}
