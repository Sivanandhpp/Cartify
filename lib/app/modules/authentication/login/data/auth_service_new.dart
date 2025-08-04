// Authentication Service - Updated to use centralized API services
//
// This service now delegates to the centralized AuthApiService for better
// organization and maintainability.

import '../../../../core/services/api_services/auth_api_service.dart';

/// Authentication service for the login module
///
/// This service provides a clean interface for authentication operations
/// and delegates to the centralized AuthApiService.
class AuthService {
  /// Send OTP to phone number
  Future<Map<String, dynamic>> sendOtp(String phone) async {
    return AuthApiService.sendOtp(phone);
  }

  /// Verify OTP and authenticate user
  Future<Map<String, dynamic>> verifyOtp(String phone, String otpCode) async {
    return AuthApiService.verifyOtp(phone, otpCode);
  }

  /// Logout user and clear all stored data
  Future<Map<String, dynamic>> logout() async {
    return AuthApiService.logout();
  }

  /// Check if user is authenticated
  bool get isAuthenticated => AuthApiService.isAuthenticated;

  /// Get current access token
  String? get accessToken => AuthApiService.accessToken;

  /// Get authorization header for API requests
  String? get authorizationHeader => AuthApiService.authorizationHeader;
}
