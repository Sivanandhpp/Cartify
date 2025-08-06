/// Authentication API Service for Cartify
/// Handles all authentication-related API calls including OTP requests,
/// verification, token refresh, and logout functionality

import 'package:get/get.dart';

import '../../models/auth_models.dart';
import '../api_service.dart';
import '../log_service.dart';
import '../error_service.dart';

/// Service for authentication API calls
class AuthApiService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  /// Request OTP for phone number
  /// Creates a new user if phone number doesn't exist
  Future<bool> requestOtp(String phoneNumber) async {
    try {
      LogService.info('Requesting OTP for phone: $phoneNumber');

      final requestData = RequestOtpDto(phoneNumber: phoneNumber);
      final response = await _apiService.post(
        '/auth/request-otp',
        data: requestData.toJson(),
      );

      if (response.statusCode == 200) {
        LogService.info('OTP requested successfully');
        return true;
      } else {
        LogService.error('Failed to request OTP: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      LogService.error('Error requesting OTP: $e');
      ErrorService.showError('Failed to send OTP. Please try again.');
      return false;
    }
  }

  /// Verify OTP and complete login
  /// Returns authentication tokens on success
  Future<AuthTokenResponse?> verifyOtp(
    String phoneNumber,
    String otpCode,
  ) async {
    try {
      LogService.info('Verifying OTP for phone: $phoneNumber');

      final requestData = VerifyOtpDto(
        phoneNumber: phoneNumber,
        otpCode: otpCode,
      );

      final response = await _apiService.post(
        '/auth/verify-otp',
        data: requestData.toJson(),
      );

      if (response.statusCode == 200) {
        final tokenResponse = AuthTokenResponse.fromJson(response.data);
        LogService.info('OTP verified successfully');
        return tokenResponse;
      } else {
        LogService.error('Failed to verify OTP: ${response.statusCode}');
        ErrorService.showError('Invalid OTP. Please try again.');
        return null;
      }
    } catch (e) {
      LogService.error('Error verifying OTP: $e');
      ErrorService.showError('Failed to verify OTP. Please try again.');
      return null;
    }
  }

  /// Refresh authentication tokens
  /// Uses refresh token to get new access and refresh tokens
  Future<AuthTokenResponse?> refreshTokens() async {
    try {
      LogService.info('Refreshing authentication tokens');

      final response = await _apiService.get('/auth/refresh');

      if (response.statusCode == 200) {
        final tokenResponse = AuthTokenResponse.fromJson(response.data);
        LogService.info('Tokens refreshed successfully');
        return tokenResponse;
      } else {
        LogService.error('Failed to refresh tokens: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      LogService.error('Error refreshing tokens: $e');
      return null;
    }
  }

  /// Logout user and invalidate tokens
  /// Clears refresh token on server
  Future<bool> logout() async {
    try {
      LogService.info('Logging out user');

      final response = await _apiService.post('/auth/logout');

      if (response.statusCode == 200) {
        LogService.info('User logged out successfully');
        return true;
      } else {
        LogService.error('Failed to logout: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      LogService.error('Error during logout: $e');
      // Even if logout fails on server, we should clear local data
      return true;
    }
  }
}
