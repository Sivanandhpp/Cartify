import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/services/log_service.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/config/api_endpoints.dart';

class AuthService {
  final SecureStorageService _secureStorage = SecureStorageService();
  Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      LogService.info('Sending OTP request to: $phone');

      final url = Uri.parse(ApiEndpoints.requestOtp);
      final headers = {'Content-Type': 'application/json'};

      // Format phone number with country code
      final phoneWithCountryCode = phone.startsWith('+91')
          ? phone
          : '+91$phone';

      final body = json.encode({'phone_number': phoneWithCountryCode});

      LogService.apiRequest('POST', url.toString(), headers, body);

      final response = await http
          .post(url, headers: headers, body: body)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception(
                'Request timeout - please check your server connection',
              );
            },
          );

      LogService.apiResponse(
        'POST',
        url.toString(),
        response.statusCode,
        response.body,
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
          'message': responseData['message'] ?? AppStrings.serverError,
        };
      }
    } catch (e) {
      LogService.error('Error sending OTP request', e);
      return {'success': false, 'message': AppStrings.networkError};
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otpCode) async {
    try {
      LogService.info('Verifying OTP for phone: $phone');

      final url = Uri.parse(ApiEndpoints.verifyOtp);
      final headers = {'Content-Type': 'application/json'};

      // Format phone number with country code
      final phoneWithCountryCode = phone.startsWith('+91')
          ? phone
          : '+91$phone';

      final body = json.encode({
        'phone_number': phoneWithCountryCode,
        'otp_code': otpCode,
      });

      LogService.apiRequest('POST', url.toString(), headers, body);

      final response = await http
          .post(url, headers: headers, body: body)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception(
                'Request timeout - please check your server connection',
              );
            },
          );

      LogService.apiResponse(
        'POST',
        url.toString(),
        response.statusCode,
        response.body,
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        LogService.info('OTP verified successfully');

        // Store tokens securely
        final accessToken = responseData['accessToken'];
        final refreshToken = responseData['refreshToken'];

        if (accessToken != null) {
          await _secureStorage.storeAccessToken(accessToken);
        }

        if (refreshToken != null) {
          await _secureStorage.storeRefreshToken(refreshToken);
        }

        // Store user data if provided
        final userData = responseData['user'];
        if (userData != null) {
          await _secureStorage.storeUserData(userData);
        }

        return {
          'success': true,
          'accessToken': accessToken,
          'refreshToken': refreshToken,
          'user': userData,
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
      return {'success': false, 'message': AppStrings.networkError};
    }
  }

  /// Logout user and clear all stored data
  Future<Map<String, dynamic>> logout() async {
    try {
      LogService.info('Logging out user');

      // Clear all authentication data
      await _secureStorage.clearAuthData();

      // Optional: Call logout API endpoint if available
      // final url = Uri.parse(ApiEndpoints.logout);
      // final token = _secureStorage.getAccessToken();
      // if (token != null) {
      //   await http.post(
      //     url,
      //     headers: {
      //       'Content-Type': 'application/json',
      //       'Authorization': 'Bearer $token',
      //     },
      //   );
      // }

      LogService.info('User logged out successfully');
      return {'success': true, 'message': 'Logged out successfully'};
    } catch (e) {
      LogService.error('Error during logout', e);
      return {'success': false, 'message': 'Failed to logout properly'};
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _secureStorage.isAuthenticated;

  /// Get current access token
  String? get accessToken => _secureStorage.getAccessToken();

  /// Get authorization header for API requests
  String? get authorizationHeader => _secureStorage.getAuthorizationHeader();
}
