/// Dashboard API client for handling home screen content
///
/// This client manages all dashboard-related API calls including
/// fetching dynamic sections, banners, and promotional content
/// for the application's home screen.

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../config/api_endpoints.dart';
import '../../models/dashboard/dashboard_models.dart';
import '../log_service.dart';

/// Exception thrown when dashboard API operations fail
class DashboardApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const DashboardApiException(this.message, {this.statusCode, this.errorCode});

  @override
  String toString() =>
      'DashboardApiException: $message (Status: $statusCode, Code: $errorCode)';
}

/// API client for dashboard operations
///
/// Handles all HTTP communications with the dashboard service,
/// including fetching home screen content and promotional materials.
class DashboardApiClient {
  static const String _logTag = 'DashboardApiClient';
  static const Duration _timeout = Duration(seconds: 30);

  /// Get all dashboard content for the home screen
  ///
  /// Retrieves the complete dashboard configuration including
  /// all sections, banners, and promotional content.
  ///
  /// Returns: [DashboardResponse] containing all sections
  /// Throws: [DashboardApiException] on failure
  static Future<DashboardResponse> getDashboardContent() async {
    try {
      LogService.info('$_logTag: Fetching dashboard content');

      final response = await http
          .get(
            Uri.parse(ApiEndpoints.getDashboard),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          )
          .timeout(_timeout);

      LogService.debug(
        '$_logTag: Get dashboard response status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final dashboard = DashboardResponse.fromJson(responseData);

        LogService.info(
          '$_logTag: Dashboard content fetched successfully - Sections: ${dashboard.sections.length}',
        );
        return dashboard;
      } else {
        final errorData = _parseErrorResponse(response);
        LogService.error(
          '$_logTag: Get dashboard failed: ${errorData['message']}',
        );
        throw DashboardApiException(
          errorData['message'] ?? 'Failed to fetch dashboard content',
          statusCode: response.statusCode,
          errorCode: errorData['code'],
        );
      }
    } on SocketException catch (e) {
      LogService.error('$_logTag: Network error during dashboard fetch: $e');
      throw const DashboardApiException(
        'Network connection failed. Please check your internet connection.',
      );
    } on HttpException catch (e) {
      LogService.error('$_logTag: HTTP error during dashboard fetch: $e');
      throw DashboardApiException('Request failed: ${e.message}');
    } on FormatException catch (e) {
      LogService.error(
        '$_logTag: Response parsing error during dashboard fetch: $e',
      );
      throw const DashboardApiException(
        'Invalid response format received from server',
      );
    } catch (e) {
      LogService.error('$_logTag: Unexpected error during dashboard fetch: $e');
      throw DashboardApiException('Unexpected error occurred: ${e.toString()}');
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

  /// Check if an error indicates a server issue
  ///
  /// Determines if the error is related to server-side problems.
  ///
  /// [exception] - The dashboard API exception to check
  /// Returns: true if the error indicates server issue
  static bool isServerError(DashboardApiException exception) {
    return exception.statusCode != null && exception.statusCode! >= 500;
  }

  /// Check if an error indicates content not found
  ///
  /// Determines if the error is related to missing content.
  ///
  /// [exception] - The dashboard API exception to check
  /// Returns: true if the error indicates content not found
  static bool isNotFoundError(DashboardApiException exception) {
    return exception.statusCode == 404;
  }

  /// Check if an error indicates a client-side issue
  ///
  /// Determines if the error is related to client request problems.
  ///
  /// [exception] - The dashboard API exception to check
  /// Returns: true if the error indicates client issue
  static bool isClientError(DashboardApiException exception) {
    return exception.statusCode != null &&
        exception.statusCode! >= 400 &&
        exception.statusCode! < 500;
  }
}
