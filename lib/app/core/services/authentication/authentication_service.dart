// lib/app/core/services/authentication/authentication_service.dart

import 'package:cartify/app/core/models/authentication/request_otp_dto.dart';
import 'package:cartify/app/core/models/authentication/verify_otp_dto.dart';
import 'package:cartify/app/core/services/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A service for handling user authentication.
///
/// This class communicates with the backend's authentication endpoints.
class AuthenticationService {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage;

  AuthenticationService(this._apiClient, this._secureStorage);

  /// Requests an OTP for the given phone number.
  ///
  /// Returns `true` if the request was successful, `false` otherwise.
  Future<bool> requestOtp(RequestOtpDto dto) async {
    try {
      await _apiClient.dio.post('/auth/request-otp', data: dto.toJson());
      return true;
    } on DioException catch (e) {
      // Handle specific errors, e.g., invalid phone number
      print('Error requesting OTP: ${e.response?.data}');
      return false;
    }
  }

  /// Verifies the OTP and logs the user in.
  ///
  /// On successful verification, it saves the JWT token to secure storage.
  /// Returns `true` on success, `false` otherwise.
  Future<bool> verifyOtp(VerifyOtpDto dto) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/verify-otp',
        data: dto.toJson(),
      );
      if (response.statusCode == 200 && response.data['accessToken'] != null) {
        await _secureStorage.write(
          key: 'jwt_token',
          value: response.data['accessToken'],
        );
        return true;
      }
      return false;
    } on DioException catch (e) {
      // Handle specific errors, e.g., invalid OTP
      print('Error verifying OTP: ${e.response?.data}');
      return false;
    }
  }

  /// Logs the user out by deleting the stored JWT token.
  Future<void> logout() async {
    await _secureStorage.delete(key: 'jwt_token');
  }

  /// Checks if a user is currently logged in.
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: 'jwt_token');
    return token != null;
  }
}
