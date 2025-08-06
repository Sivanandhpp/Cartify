/// Authentication API client for handling OTP-based login and token management
///
/// This client handles all authentication-related API calls including
/// OTP requests, verification, token refresh, and logout operations.

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../config/api_endpoints.dart';
import '../../models/auth/auth_models.dart';
import '../log_service.dart';

/// Exception thrown when authentication API operations fail
class AuthApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const AuthApiException(this.message, {this.statusCode, this.errorCode});

  @override
  String toString() =>
      'AuthApiException: $message (Status: $statusCode, Code: $errorCode)';
}

/// API client for authentication operations
///
/// Handles all HTTP communications with the authentication service,
/// including proper error handling, logging, and response parsing.
class AuthApiClient {
  static const String _logTag = 'AuthApiClient';
  static const Duration _timeout = Duration(seconds: 30);

  /// Request OTP for phone number authentication
  ///
  /// Sends a POST request to initiate the OTP-based login process.
  /// If the user doesn't exist, they will be automatically created.
  ///
  /// [phoneNumber] - The phone number in international format
  /// Returns: Success indicator (true if OTP sent successfully)
  /// Throws: [AuthApiException] on failure
  static Future<bool> requestOtp(String phoneNumber) async {
    try {
      LogService.info(
        '$_logTag: Requesting OTP for phone number: ${phoneNumber.replaceRange(3, phoneNumber.length - 2, '****')}',
      );

      final requestDto = RequestOtpDto(phoneNumber: phoneNumber);

      final response = await http
          .post(
            Uri.parse(ApiEndpoints.requestOtp),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(requestDto.toJson()),
          )
          .timeout(_timeout);

      LogService.debug(
        '$_logTag: Request OTP response status: ${response.statusCode}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        LogService.info('$_logTag: OTP request successful');
        return true;
      } else {
        final errorData = _parseErrorResponse(response);
        LogService.error(
          '$_logTag: OTP request failed: ${errorData['message']}',
        );
        throw AuthApiException(
          errorData['message'] ?? 'Failed to send OTP',
          statusCode: response.statusCode,
          errorCode: errorData['code'],
        );
      }
    } on SocketException catch (e) {
      LogService.error('$_logTag: Network error during OTP request: $e');
      throw const AuthApiException(
        'Network connection failed. Please check your internet connection.',
      );
    } on HttpException catch (e) {
      LogService.error('$_logTag: HTTP error during OTP request: $e');
      throw AuthApiException('Request failed: ${e.message}');
    } on FormatException catch (e) {
      LogService.error(
        '$_logTag: Response parsing error during OTP request: $e',
      );
      throw const AuthApiException(
        'Invalid response format received from server',
      );
    } catch (e) {
      LogService.error('$_logTag: Unexpected error during OTP request: $e');
      throw AuthApiException('Unexpected error occurred: ${e.toString()}');
    }
  }

  /// Verify OTP and complete authentication
  ///
  /// Sends a POST request to verify the OTP code and obtain authentication tokens.
  /// On success, returns both access and refresh tokens with their validity periods.
  ///
  /// [phoneNumber] - The phone number that received the OTP
  /// [otpCode] - The 4-digit OTP code
  /// Returns: [AuthTokensResponse] containing access and refresh tokens
  /// Throws: [AuthApiException] on failure
  static Future<AuthTokensResponse> verifyOtp(
    String phoneNumber,
    String otpCode,
  ) async {
    try {
      LogService.info(
        '$_logTag: Verifying OTP for phone number: ${phoneNumber.replaceRange(3, phoneNumber.length - 2, '****')}',
      );

      final verifyDto = VerifyOtpDto(
        phoneNumber: phoneNumber,
        otpCode: otpCode,
      );

      final response = await http
          .post(
            Uri.parse(ApiEndpoints.verifyOtp),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(verifyDto.toJson()),
          )
          .timeout(_timeout);

      LogService.debug(
        '$_logTag: Verify OTP response status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final tokens = AuthTokensResponse.fromJson(responseData);

        LogService.info('$_logTag: OTP verification successful');
        LogService.debug(
          '$_logTag: Access token expires: ${tokens.accessTokenExpires}',
        );
        LogService.debug(
          '$_logTag: Refresh token expires: ${tokens.refreshTokenExpires}',
        );

        return tokens;
      } else {
        final errorData = _parseErrorResponse(response);
        LogService.error(
          '$_logTag: OTP verification failed: ${errorData['message']}',
        );
        throw AuthApiException(
          errorData['message'] ?? 'OTP verification failed',
          statusCode: response.statusCode,
          errorCode: errorData['code'],
        );
      }
    } on SocketException catch (e) {
      LogService.error('$_logTag: Network error during OTP verification: $e');
      throw const AuthApiException(
        'Network connection failed. Please check your internet connection.',
      );
    } on HttpException catch (e) {
      LogService.error('$_logTag: HTTP error during OTP verification: $e');
      throw AuthApiException('Request failed: ${e.message}');
    } on FormatException catch (e) {
      LogService.error(
        '$_logTag: Response parsing error during OTP verification: $e',
      );
      throw const AuthApiException(
        'Invalid response format received from server',
      );
    } catch (e) {
      LogService.error(
        '$_logTag: Unexpected error during OTP verification: $e',
      );
      throw AuthApiException('Unexpected error occurred: ${e.toString()}');
    }
  }

  /// Refresh authentication tokens
  ///
  /// Sends a GET request using the refresh token to obtain new access and refresh tokens.
  /// This should be called when the access token has expired but the refresh token is still valid.
  ///
  /// [refreshToken] - The valid refresh token
  /// Returns: [AuthTokensResponse] containing new access and refresh tokens
  /// Throws: [AuthApiException] on failure
  static Future<AuthTokensResponse> refreshTokens(String refreshToken) async {
    try {
      LogService.info('$_logTag: Refreshing authentication tokens');

      final response = await http
          .get(
            Uri.parse(ApiEndpoints.refreshToken),
            headers: {
              'Authorization': 'Bearer $refreshToken',
              'Accept': 'application/json',
            },
          )
          .timeout(_timeout);

      LogService.debug(
        '$_logTag: Refresh token response status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final tokens = AuthTokensResponse.fromJson(responseData);

        LogService.info('$_logTag: Token refresh successful');
        LogService.debug(
          '$_logTag: New access token expires: ${tokens.accessTokenExpires}',
        );
        LogService.debug(
          '$_logTag: New refresh token expires: ${tokens.refreshTokenExpires}',
        );

        return tokens;
      } else {
        final errorData = _parseErrorResponse(response);
        LogService.error(
          '$_logTag: Token refresh failed: ${errorData['message']}',
        );
        throw AuthApiException(
          errorData['message'] ?? 'Token refresh failed',
          statusCode: response.statusCode,
          errorCode: errorData['code'],
        );
      }
    } on SocketException catch (e) {
      LogService.error('$_logTag: Network error during token refresh: $e');
      throw const AuthApiException(
        'Network connection failed. Please check your internet connection.',
      );
    } on HttpException catch (e) {
      LogService.error('$_logTag: HTTP error during token refresh: $e');
      throw AuthApiException('Request failed: ${e.message}');
    } on FormatException catch (e) {
      LogService.error(
        '$_logTag: Response parsing error during token refresh: $e',
      );
      throw const AuthApiException(
        'Invalid response format received from server',
      );
    } catch (e) {
      LogService.error('$_logTag: Unexpected error during token refresh: $e');
      throw AuthApiException('Unexpected error occurred: ${e.toString()}');
    }
  }

  /// Logout and invalidate tokens
  ///
  /// Sends a POST request to securely log out the user and invalidate their refresh token.
  /// This ensures the refresh token cannot be used for future authentication.
  ///
  /// [accessToken] - The current valid access token
  /// Returns: Success indicator (true if logout successful)
  /// Throws: [AuthApiException] on failure
  static Future<bool> logout(String accessToken) async {
    try {
      LogService.info('$_logTag: Logging out user');

      final response = await http
          .post(
            Uri.parse(ApiEndpoints.logout),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Accept': 'application/json',
            },
          )
          .timeout(_timeout);

      LogService.debug(
        '$_logTag: Logout response status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        LogService.info('$_logTag: Logout successful');
        return true;
      } else {
        final errorData = _parseErrorResponse(response);
        LogService.error('$_logTag: Logout failed: ${errorData['message']}');
        throw AuthApiException(
          errorData['message'] ?? 'Logout failed',
          statusCode: response.statusCode,
          errorCode: errorData['code'],
        );
      }
    } on SocketException catch (e) {
      LogService.error('$_logTag: Network error during logout: $e');
      throw const AuthApiException(
        'Network connection failed. Please check your internet connection.',
      );
    } on HttpException catch (e) {
      LogService.error('$_logTag: HTTP error during logout: $e');
      throw AuthApiException('Request failed: ${e.message}');
    } on FormatException catch (e) {
      LogService.error('$_logTag: Response parsing error during logout: $e');
      throw const AuthApiException(
        'Invalid response format received from server',
      );
    } catch (e) {
      LogService.error('$_logTag: Unexpected error during logout: $e');
      throw AuthApiException('Unexpected error occurred: ${e.toString()}');
    }
  }

  /// Parse error response from API
  ///
  /// Attempts to extract error message and code from the API response.
  /// Provides fallback messages if the response format is unexpected.
  ///
  /// [response] - The HTTP response containing the error
  /// Returns: Map containing error message and optional error code
  static Map<String, dynamic> _parseErrorResponse(http.Response response) {
    try {
      final responseBody = response.body;
      if (responseBody.isEmpty) {
        return {'message': 'Server returned empty response'};
      }

      final errorData = jsonDecode(responseBody) as Map<String, dynamic>;

      return {
        'message':
            errorData['message'] ??
            errorData['error'] ??
            'Unknown error occurred',
        'code': errorData['code'] ?? errorData['error_code'],
      };
    } catch (e) {
      LogService.warning('$_logTag: Failed to parse error response: $e');
      return {
        'message':
            'Failed to parse error response (Status: ${response.statusCode})',
      };
    }
  }

  /// Validate phone number format
  ///
  /// Checks if the phone number is in a valid international format.
  /// This is a basic validation - the server will perform the final validation.
  ///
  /// [phoneNumber] - The phone number to validate
  /// Returns: true if the format appears valid
  static bool isValidPhoneNumber(String phoneNumber) {
    // Basic validation for international format
    final phoneRegex = RegExp(r'^\+[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  /// Validate OTP code format
  ///
  /// Checks if the OTP code is in the expected 4-digit format.
  ///
  /// [otpCode] - The OTP code to validate
  /// Returns: true if the format is valid
  static bool isValidOtpCode(String otpCode) {
    // Validate 4-digit OTP code
    final otpRegex = RegExp(r'^\d{4}$');
    return otpRegex.hasMatch(otpCode);
  }

  /// Check if an error indicates invalid credentials
  ///
  /// Determines if the error is related to invalid OTP or authentication failure.
  /// Useful for showing appropriate error messages to users.
  ///
  /// [exception] - The authentication exception to check
  /// Returns: true if the error indicates invalid credentials
  static bool isInvalidCredentialsError(AuthApiException exception) {
    return exception.statusCode == 401 ||
        exception.statusCode == 403 ||
        exception.message.toLowerCase().contains('invalid') ||
        exception.message.toLowerCase().contains('incorrect') ||
        exception.message.toLowerCase().contains('expired');
  }

  /// Check if an error indicates a network issue
  ///
  /// Determines if the error is related to network connectivity.
  ///
  /// [exception] - The authentication exception to check
  /// Returns: true if the error indicates a network issue
  static bool isNetworkError(AuthApiException exception) {
    return exception.message.toLowerCase().contains('network') ||
        exception.message.toLowerCase().contains('connection') ||
        exception.message.toLowerCase().contains('timeout');
  }
}
