import 'dart:convert';
import '../../config/api_endpoints.dart';
import '../log_service.dart';
import '../secure_storage_service.dart';
import 'base_api_service.dart';

/// Authentication API service
///
/// Handles all authentication-related API operations including
/// OTP sending, verification, logout, and token management.
class AuthApiService {
  static final SecureStorageService _secureStorage = SecureStorageService();

  /// Send OTP to phone number
  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      LogService.info('Sending OTP request to: $phone');

      // Format phone number with country code
      final phoneWithCountryCode = phone.startsWith('+91')
          ? phone
          : '+91$phone';

      final body = {'phone_number': phoneWithCountryCode};

      final response = await BaseApiService.publicPost(
        ApiEndpoints.requestOtp,
        body,
        timeout: const Duration(seconds: 10),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        LogService.info('OTP sent successfully: ${responseData['message']}');
        return {
          'success': true,
          'message':
              responseData['message'] ?? 'OTP has been sent successfully.',
        };
      } else {
        LogService.error(
          'Failed to send OTP: ${response.statusCode} - ${response.body}',
        );
        return {
          'success': false,
          'message':
              responseData['message'] ??
              'Failed to send OTP. Please try again.',
        };
      }
    } catch (e) {
      LogService.error('Error sending OTP request', e);
      return {
        'success': false,
        'message': 'Network error. Please check your connection and try again.',
      };
    }
  }

  /// Verify OTP and authenticate user
  static Future<Map<String, dynamic>> verifyOtp(
    String phone,
    String otpCode,
  ) async {
    try {
      LogService.info('Verifying OTP for phone: $phone');

      // Format phone number with country code
      final phoneWithCountryCode = phone.startsWith('+91')
          ? phone
          : '+91$phone';

      final body = {'phone_number': phoneWithCountryCode, 'otp_code': otpCode};

      final response = await BaseApiService.publicPost(
        ApiEndpoints.verifyOtp,
        body,
        timeout: const Duration(seconds: 10),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        LogService.info('OTP verified successfully');

        // Store access token
        final accessToken = responseData['accessToken'];
        if (accessToken != null) {
          await _secureStorage.storeAccessToken(accessToken);

          // Fetch and store user profile
          await _fetchUserProfile(accessToken);
        }

        return {
          'success': true,
          'accessToken': accessToken,
          'message': 'OTP verified successfully',
        };
      } else {
        LogService.error(
          'Failed to verify OTP: ${response.statusCode} - ${response.body}',
        );
        return {
          'success': false,
          'message':
              responseData['message'] ?? 'Invalid OTP. Please try again.',
        };
      }
    } catch (e) {
      LogService.error('Error verifying OTP', e);
      return {
        'success': false,
        'message': 'Network error. Please check your connection and try again.',
      };
    }
  }

  /// Fetch user profile after successful authentication
  static Future<void> _fetchUserProfile(String accessToken) async {
    try {
      LogService.info('Fetching user profile');

      final headers = BaseApiService.getHeaders();
      headers['Authorization'] = 'Bearer $accessToken';

      final response = await BaseApiService.get(
        ApiEndpoints.userProfile,
        headers: headers,
        timeout: const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final profileData = json.decode(response.body);
        await _secureStorage.storeUserProfile(profileData);
        LogService.info('User profile stored successfully');
      } else {
        LogService.error(
          'Failed to fetch user profile: ${response.statusCode}',
        );
      }
    } catch (e) {
      LogService.error('Error fetching user profile', e);
    }
  }

  /// Logout user and clear all stored data
  static Future<Map<String, dynamic>> logout() async {
    try {
      LogService.info('Logging out user');

      // Clear all stored authentication data
      await _secureStorage.clearAuthData();

      LogService.info('User logged out successfully');
      return {'success': true, 'message': 'Logged out successfully'};
    } catch (e) {
      LogService.error('Error during logout', e);
      return {'success': false, 'message': 'Failed to logout properly'};
    }
  }

  /// Check if user is authenticated
  static bool get isAuthenticated => _secureStorage.isAuthenticated;

  /// Get current access token
  static String? get accessToken => _secureStorage.getAccessToken();

  /// Get authorization header for API requests
  static String? get authorizationHeader =>
      _secureStorage.getAuthorizationHeader();

  /// Get user role from stored profile
  static String getUserRole() => _secureStorage.getUserRoleFromProfile();
}
