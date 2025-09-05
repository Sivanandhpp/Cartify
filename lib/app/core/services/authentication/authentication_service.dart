// lib/app/core/services/authentication/authentication_service.dart

import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_dashboard/controllers/buyer_dashboard_controller.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

/// A service for handling user authentication.
///
/// This class communicates with the backend's authentication endpoints.
class AuthenticationService {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;

  AuthenticationService(this._apiClient, this._secureStorage);
  UserController userController = Get.find<UserController>();

  /// Requests an OTP for the given phone number.
  ///
  /// Returns `true` if the request was successful, `false` otherwise.
  Future<bool> requestOtp(RequestOtpDto dto) async {
    try {
      await _apiClient.dio.post('/auth/request-otp', data: dto.toJson());
      return true;
    } on DioException catch (e) {
      // Handle specific errors, e.g., invalid phone number
      LogService.error('Error requesting OTP: ${e.response?.data}');
      return false;
    }
  }

  /// Verifies the OTP and logs the user in.
  ///
  /// On successful verification, it saves the `accessToken` and `refreshToken` to secure storage.
  /// Returns `true` on success, `false` otherwise.
  Future<bool> verifyOtp(VerifyOtpDto dto) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/verify-otp',
        data: dto.toJson(),
      );
      if (response.statusCode == 200 && response.data['accessToken'] != null) {
        // Store both access and refresh tokens securely.
        await _secureStorage.write(
          key: 'access_token',
          value: response.data['accessToken'],
        );
        await _secureStorage.write(
          key: 'refresh_token',
          value: response.data['refreshToken'],
        );

        // Fetch and store user profile
        final userProfile = await UserService(_apiClient).getUserProfile();
        if (userProfile != null) {
          userController.updateUser(userProfile);
        } else {
          LogService.error(
            'Error: User profile is null after OTP verification.',
          );
          return false;
        }

        return true;
      }
      return false;
    } on DioException catch (e) {
      LogService.error('Error verifying OTP: ${e.response?.data}');
      return false;
    }
  }

  /// Logs the user out by calling the logout endpoint and always clearing local tokens/user data.
  Future<void> logout() async {
    bool networkFailed = false;
    try {
      // Try to inform the backend to invalidate the refresh token.
      await _apiClient.dio.post('/auth/logout');
    } on DioException catch (e) {
      LogService.error('Error logging out: ${e.response?.data}');
      networkFailed = true;
    }
    // Always clear local tokens and user data, regardless of network status.
    await _secureStorage.deleteAll();
    userController.clearUser();
    if (networkFailed) {
      NotificationService.showError(
        title: 'Logged out',
        message: 'Logged out locally. Could not reach server.',
      );
    }
    Get.offAllNamed(Routes.SPLASH);
  }

  /// Checks if a user is currently logged in by verifying the presence of an access token.
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: 'access_token');
    return token != null;
  }
}
