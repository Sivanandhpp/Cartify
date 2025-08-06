/// High-level authentication service providing simple, easy-to-use functions
///
/// This service provides a clean interface for authentication operations,
/// handling token management, caching, and state persistence automatically.
/// It offers single-function calls for complete authentication flows.

import 'dart:convert';
import 'dart:async';

import 'package:get_storage/get_storage.dart';

import '../../config/app_config.dart';
import '../../models/auth/auth_models.dart';
import '../log_service.dart';
import 'auth_api_client.dart';

/// Authentication service providing complete session management
///
/// This service handles the entire authentication flow with smart caching,
/// automatic token refresh, and persistent storage. All operations are
/// designed to be called with minimal parameters for maximum simplicity.
class AuthService {
  static const String _logTag = 'AuthService';

  // Singleton instance
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();

  // Private constructor
  AuthService._();

  // Stream controllers for authentication state
  final StreamController<AuthState> _authStateController =
      StreamController<AuthState>.broadcast();

  // Current authentication state
  AuthState _currentState = AuthState.unauthenticated();

  // Cache for quick access
  AuthTokensResponse? _cachedTokens;
  String? _cachedPhoneNumber;

  /// Stream of authentication state changes
  Stream<AuthState> get authStateStream => _authStateController.stream;

  /// Current authentication state
  AuthState get currentState => _currentState;

  /// Check if user is currently authenticated
  bool get isAuthenticated => _currentState.isAuthenticated;

  /// Check if user needs to re-authenticate
  bool get needsReauthentication => _currentState.needsReauthentication;

  /// Get current access token (null if not authenticated)
  String? get accessToken => _cachedTokens?.accessToken;

  /// Get current phone number (null if not authenticated)
  String? get phoneNumber => _cachedPhoneNumber;

  /// Initialize the service and restore authentication state
  ///
  /// This should be called during app startup to restore the user's
  /// authentication state from persistent storage.
  ///
  /// Returns: The restored authentication state
  Future<AuthState> initialize() async {
    try {
      LogService.info('$_logTag: Initializing authentication service');

      final storage = GetStorage();

      // Try to restore authentication state from storage
      final stateJson = storage.read<String>(AppConfig.userSessionKey);
      if (stateJson != null) {
        final stateData = jsonDecode(stateJson) as Map<String, dynamic>;
        final restoredState = AuthState.fromJson(stateData);

        // Validate the restored state
        if (restoredState.tokens != null) {
          _cachedTokens = restoredState.tokens;
          _cachedPhoneNumber = restoredState.phoneNumber;

          // Check if access token needs refresh
          if (restoredState.needsRefresh) {
            LogService.info(
              '$_logTag: Access token expired, attempting refresh',
            );
            try {
              await _refreshTokensInternal();
            } catch (e) {
              LogService.warning(
                '$_logTag: Token refresh failed during initialization: $e',
              );
              await _clearAuthenticationInternal();
            }
          } else {
            _updateState(restoredState);
          }
        } else {
          await _clearAuthenticationInternal();
        }
      }

      LogService.info(
        '$_logTag: Initialization complete - State: ${_currentState.state.name}',
      );
      return _currentState;
    } catch (e) {
      LogService.error('$_logTag: Initialization failed: $e');
      await _clearAuthenticationInternal();
      return _currentState;
    }
  }

  /// Send OTP to phone number for authentication
  ///
  /// Simple one-function call to initiate the authentication process.
  /// If the user doesn't exist, they will be automatically created.
  ///
  /// [phoneNumber] - Phone number in international format (e.g., +919876543210)
  /// Returns: Success indicator
  /// Throws: [AuthApiException] on failure
  Future<bool> sendOtp(String phoneNumber) async {
    try {
      LogService.info('$_logTag: Sending OTP to phone number');

      // Validate phone number format
      if (!AuthApiClient.isValidPhoneNumber(phoneNumber)) {
        throw const AuthApiException(
          'Invalid phone number format. Please use international format (e.g., +919876543210)',
        );
      }

      // Send OTP request
      final success = await AuthApiClient.requestOtp(phoneNumber);

      if (success) {
        // Update state to OTP sent
        _cachedPhoneNumber = phoneNumber;
        _updateState(AuthState.otpSent(phoneNumber));

        LogService.info('$_logTag: OTP sent successfully');
        return true;
      }

      return false;
    } catch (e) {
      LogService.error('$_logTag: Send OTP failed: $e');
      rethrow;
    }
  }

  /// Verify OTP and complete authentication
  ///
  /// Simple one-function call to verify OTP and complete the login process.
  /// Automatically handles token storage and state management.
  ///
  /// [otpCode] - The 4-digit OTP code received by the user
  /// Returns: Success indicator
  /// Throws: [AuthApiException] on failure
  Future<bool> verifyOtp(String otpCode) async {
    try {
      LogService.info('$_logTag: Verifying OTP');

      // Validate current state
      if (_currentState.state != AuthenticationState.otpSent ||
          _cachedPhoneNumber == null) {
        throw const AuthApiException(
          'Invalid state. Please request OTP first.',
        );
      }

      // Validate OTP format
      if (!AuthApiClient.isValidOtpCode(otpCode)) {
        throw const AuthApiException(
          'Invalid OTP format. Please enter a 4-digit code.',
        );
      }

      // Verify OTP
      final tokens = await AuthApiClient.verifyOtp(
        _cachedPhoneNumber!,
        otpCode,
      );

      // Store tokens and update state
      _cachedTokens = tokens;
      final newState = AuthState.authenticated(
        tokens: tokens,
        phoneNumber: _cachedPhoneNumber!,
      );

      await _persistAuthState(newState);
      _updateState(newState);

      LogService.info('$_logTag: Authentication successful');
      return true;
    } catch (e) {
      LogService.error('$_logTag: OTP verification failed: $e');
      rethrow;
    }
  }

  /// Complete authentication flow with phone number and OTP
  ///
  /// Convenience method that combines sendOtp and verifyOtp into a single call.
  /// Useful for automated testing or when both values are available.
  ///
  /// [phoneNumber] - Phone number in international format
  /// [otpCode] - The 4-digit OTP code
  /// Returns: Success indicator
  /// Throws: [AuthApiException] on failure
  Future<bool> authenticateWithOtp(String phoneNumber, String otpCode) async {
    try {
      LogService.info('$_logTag: Starting complete authentication flow');

      // Send OTP first
      await sendOtp(phoneNumber);

      // Small delay to ensure OTP is sent
      await Future.delayed(const Duration(milliseconds: 500));

      // Verify OTP
      return await verifyOtp(otpCode);
    } catch (e) {
      LogService.error('$_logTag: Complete authentication failed: $e');
      rethrow;
    }
  }

  /// Logout and clear all authentication data
  ///
  /// Simple one-function call to securely logout the user.
  /// Automatically handles token invalidation and data cleanup.
  ///
  /// Returns: Success indicator
  Future<bool> logout() async {
    try {
      LogService.info('$_logTag: Logging out user');

      // Call logout API if we have an access token
      if (_cachedTokens?.accessToken != null) {
        try {
          await AuthApiClient.logout(_cachedTokens!.accessToken);
        } catch (e) {
          LogService.warning(
            '$_logTag: API logout failed, proceeding with local cleanup: $e',
          );
        }
      }

      // Clear local authentication data
      await _clearAuthenticationInternal();

      LogService.info('$_logTag: Logout successful');
      return true;
    } catch (e) {
      LogService.error('$_logTag: Logout failed: $e');
      // Even if logout fails, clear local data
      await _clearAuthenticationInternal();
      return false;
    }
  }

  /// Get current access token with automatic refresh
  ///
  /// Simple one-function call to get a valid access token.
  /// Automatically refreshes the token if it has expired.
  ///
  /// Returns: Valid access token or null if not authenticated
  /// Throws: [AuthApiException] if refresh fails
  Future<String?> getValidAccessToken() async {
    try {
      if (!isAuthenticated || _cachedTokens == null) {
        return null;
      }

      // Check if token needs refresh
      if (_currentState.needsRefresh) {
        LogService.info('$_logTag: Access token expired, refreshing');
        await _refreshTokensInternal();
      }

      return _cachedTokens?.accessToken;
    } catch (e) {
      LogService.error('$_logTag: Failed to get valid access token: $e');
      await _clearAuthenticationInternal();
      rethrow;
    }
  }

  /// Check if the current session is valid
  ///
  /// Simple check to see if the user has a valid authentication session.
  /// This includes checking token validity and expiration.
  ///
  /// Returns: True if session is valid
  Future<bool> isSessionValid() async {
    try {
      if (!isAuthenticated || _cachedTokens == null) {
        return false;
      }

      // Try to get a valid access token
      final token = await getValidAccessToken();
      return token != null;
    } catch (e) {
      LogService.warning('$_logTag: Session validation failed: $e');
      return false;
    }
  }

  /// Force refresh authentication tokens
  ///
  /// Manually refresh the authentication tokens using the refresh token.
  /// Useful for proactive token management.
  ///
  /// Returns: Success indicator
  /// Throws: [AuthApiException] on failure
  Future<bool> refreshTokens() async {
    try {
      if (_cachedTokens?.refreshToken == null) {
        throw const AuthApiException('No refresh token available');
      }

      await _refreshTokensInternal();
      return true;
    } catch (e) {
      LogService.error('$_logTag: Manual token refresh failed: $e');
      rethrow;
    }
  }

  /// Clear all authentication data
  ///
  /// Force clear all authentication data without calling the logout API.
  /// Useful for handling authentication errors or testing.
  ///
  /// Returns: Success indicator
  Future<bool> clearAuthentication() async {
    try {
      await _clearAuthenticationInternal();
      return true;
    } catch (e) {
      LogService.error('$_logTag: Clear authentication failed: $e');
      return false;
    }
  }

  /// Get authentication state summary
  ///
  /// Returns a human-readable summary of the current authentication state.
  /// Useful for debugging and user interface display.
  ///
  /// Returns: Authentication state summary
  String getAuthStateSummary() {
    final state = _currentState;
    final buffer = StringBuffer('Authentication State: ${state.state.name}');

    if (state.phoneNumber != null) {
      buffer.write('\nPhone: ${state.phoneNumber}');
    }

    if (state.tokens != null) {
      buffer.write('\nHas Tokens: Yes');
      buffer.write(
        '\nAccess Token Expires: ${state.tokens!.accessTokenExpires}',
      );
      buffer.write(
        '\nRefresh Token Expires: ${state.tokens!.refreshTokenExpires}',
      );
    } else {
      buffer.write('\nHas Tokens: No');
    }

    buffer.write('\nLast Updated: ${state.lastUpdated}');

    return buffer.toString();
  }

  // Internal method to refresh tokens
  Future<void> _refreshTokensInternal() async {
    if (_cachedTokens?.refreshToken == null) {
      throw const AuthApiException('No refresh token available for refresh');
    }

    final newTokens = await AuthApiClient.refreshTokens(
      _cachedTokens!.refreshToken,
    );
    _cachedTokens = newTokens;

    final newState = AuthState.authenticated(
      tokens: newTokens,
      phoneNumber: _cachedPhoneNumber!,
    );

    await _persistAuthState(newState);
    _updateState(newState);
  }

  // Internal method to clear authentication
  Future<void> _clearAuthenticationInternal() async {
    _cachedTokens = null;
    _cachedPhoneNumber = null;

    final newState = AuthState.unauthenticated();
    await _persistAuthState(newState);
    _updateState(newState);
  }

  // Internal method to update state and notify listeners
  void _updateState(AuthState newState) {
    _currentState = newState;
    _authStateController.add(newState);
  }

  // Internal method to persist authentication state
  Future<void> _persistAuthState(AuthState state) async {
    try {
      final storage = GetStorage();
      final stateJson = jsonEncode(state.toJson());
      await storage.write(AppConfig.userSessionKey, stateJson);
    } catch (e) {
      LogService.error('$_logTag: Failed to persist auth state: $e');
    }
  }

  /// Dispose the service and clean up resources
  void dispose() {
    _authStateController.close();
  }
}
