/// User API client for handling profile and address management
///
/// This client handles all user-related API calls including profile operations,
/// address management, and file uploads for profile pictures.

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../config/api_endpoints.dart';
import '../../models/user/user_models.dart';
import '../log_service.dart';

/// Exception thrown when user API operations fail
class UserApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const UserApiException(this.message, {this.statusCode, this.errorCode});

  @override
  String toString() =>
      'UserApiException: $message (Status: $statusCode, Code: $errorCode)';
}

/// API client for user operations
///
/// Handles all HTTP communications with the user service,
/// including profile management, address operations, and file uploads.
class UserApiClient {
  static const String _logTag = 'UserApiClient';
  static const Duration _timeout = Duration(seconds: 30);

  /// Get authenticated user's profile
  ///
  /// Retrieves the complete profile information for the authenticated user.
  ///
  /// [accessToken] - Valid access token for authentication
  /// Returns: [UserProfile] containing user information
  /// Throws: [UserApiException] on failure
  static Future<UserProfile> getUserProfile(String accessToken) async {
    try {
      LogService.info('$_logTag: Fetching user profile');

      final response = await http
          .get(
            Uri.parse(ApiEndpoints.getUserProfile),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Accept': 'application/json',
            },
          )
          .timeout(_timeout);

      LogService.debug(
        '$_logTag: Get profile response status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final profile = UserProfile.fromJson(responseData);

        LogService.info('$_logTag: Profile fetched successfully');
        return profile;
      } else {
        final errorData = _parseErrorResponse(response);
        LogService.error(
          '$_logTag: Get profile failed: ${errorData['message']}',
        );
        throw UserApiException(
          errorData['message'] ?? 'Failed to fetch profile',
          statusCode: response.statusCode,
          errorCode: errorData['code'],
        );
      }
    } on SocketException catch (e) {
      LogService.error('$_logTag: Network error during profile fetch: $e');
      throw const UserApiException(
        'Network connection failed. Please check your internet connection.',
      );
    } on HttpException catch (e) {
      LogService.error('$_logTag: HTTP error during profile fetch: $e');
      throw UserApiException('Request failed: ${e.message}');
    } on FormatException catch (e) {
      LogService.error(
        '$_logTag: Response parsing error during profile fetch: $e',
      );
      throw const UserApiException(
        'Invalid response format received from server',
      );
    } catch (e) {
      LogService.error('$_logTag: Unexpected error during profile fetch: $e');
      throw UserApiException('Unexpected error occurred: ${e.toString()}');
    }
  }

  /// Update authenticated user's profile
  ///
  /// Updates specific fields in the user's profile. Only provided fields will be updated.
  ///
  /// [accessToken] - Valid access token for authentication
  /// [updateDto] - DTO containing fields to update
  /// Returns: Updated [UserProfile]
  /// Throws: [UserApiException] on failure
  static Future<UserProfile> updateUserProfile(
    String accessToken,
    UpdateUserProfileDto updateDto,
  ) async {
    try {
      LogService.info('$_logTag: Updating user profile');

      if (!updateDto.hasUpdates) {
        throw const UserApiException('No updates provided');
      }

      final response = await http
          .patch(
            Uri.parse(ApiEndpoints.updateUserProfile),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(updateDto.toJson()),
          )
          .timeout(_timeout);

      LogService.debug(
        '$_logTag: Update profile response status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final profile = UserProfile.fromJson(responseData);

        LogService.info('$_logTag: Profile updated successfully');
        return profile;
      } else {
        final errorData = _parseErrorResponse(response);
        LogService.error(
          '$_logTag: Update profile failed: ${errorData['message']}',
        );
        throw UserApiException(
          errorData['message'] ?? 'Failed to update profile',
          statusCode: response.statusCode,
          errorCode: errorData['code'],
        );
      }
    } on SocketException catch (e) {
      LogService.error('$_logTag: Network error during profile update: $e');
      throw const UserApiException(
        'Network connection failed. Please check your internet connection.',
      );
    } on HttpException catch (e) {
      LogService.error('$_logTag: HTTP error during profile update: $e');
      throw UserApiException('Request failed: ${e.message}');
    } on FormatException catch (e) {
      LogService.error(
        '$_logTag: Response parsing error during profile update: $e',
      );
      throw const UserApiException(
        'Invalid response format received from server',
      );
    } catch (e) {
      LogService.error('$_logTag: Unexpected error during profile update: $e');
      throw UserApiException('Unexpected error occurred: ${e.toString()}');
    }
  }

  /// Upload user profile picture
  ///
  /// Uploads a new profile picture for the authenticated user.
  ///
  /// [accessToken] - Valid access token for authentication
  /// [imageFile] - Image file to upload
  /// Returns: Updated [UserProfile] with new profile picture URL
  /// Throws: [UserApiException] on failure
  static Future<UserProfile> uploadProfilePicture(
    String accessToken,
    File imageFile,
  ) async {
    try {
      LogService.info('$_logTag: Uploading profile picture');

      // Check if file exists
      if (!await imageFile.exists()) {
        throw const UserApiException('Image file does not exist');
      }

      // Check file size (limit to 5MB)
      final fileSize = await imageFile.length();
      if (fileSize > 5 * 1024 * 1024) {
        throw const UserApiException(
          'Image file is too large. Maximum size is 5MB.',
        );
      }

      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiEndpoints.uploadProfilePicture),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      });

      // Add file
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      // Send request
      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      LogService.debug(
        '$_logTag: Upload profile picture response status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final profile = UserProfile.fromJson(responseData);

        LogService.info('$_logTag: Profile picture uploaded successfully');
        return profile;
      } else {
        final errorData = _parseErrorResponse(response);
        LogService.error(
          '$_logTag: Upload profile picture failed: ${errorData['message']}',
        );
        throw UserApiException(
          errorData['message'] ?? 'Failed to upload profile picture',
          statusCode: response.statusCode,
          errorCode: errorData['code'],
        );
      }
    } on SocketException catch (e) {
      LogService.error(
        '$_logTag: Network error during profile picture upload: $e',
      );
      throw const UserApiException(
        'Network connection failed. Please check your internet connection.',
      );
    } on HttpException catch (e) {
      LogService.error(
        '$_logTag: HTTP error during profile picture upload: $e',
      );
      throw UserApiException('Request failed: ${e.message}');
    } on FormatException catch (e) {
      LogService.error(
        '$_logTag: Response parsing error during profile picture upload: $e',
      );
      throw const UserApiException(
        'Invalid response format received from server',
      );
    } catch (e) {
      LogService.error(
        '$_logTag: Unexpected error during profile picture upload: $e',
      );
      throw UserApiException('Unexpected error occurred: ${e.toString()}');
    }
  }

  /// Get all addresses for authenticated user
  ///
  /// Retrieves all addresses associated with the authenticated user's account.
  ///
  /// [accessToken] - Valid access token for authentication
  /// Returns: List of [Address] objects
  /// Throws: [UserApiException] on failure
  static Future<List<Address>> getAllAddresses(String accessToken) async {
    try {
      LogService.info('$_logTag: Fetching all addresses');

      final response = await http
          .get(
            Uri.parse(ApiEndpoints.getAllAddresses),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Accept': 'application/json',
            },
          )
          .timeout(_timeout);

      LogService.debug(
        '$_logTag: Get addresses response status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as List<dynamic>;
        final addresses = responseData
            .map(
              (addressJson) =>
                  Address.fromJson(addressJson as Map<String, dynamic>),
            )
            .toList();

        LogService.info(
          '$_logTag: Addresses fetched successfully - Count: ${addresses.length}',
        );
        return addresses;
      } else {
        final errorData = _parseErrorResponse(response);
        LogService.error(
          '$_logTag: Get addresses failed: ${errorData['message']}',
        );
        throw UserApiException(
          errorData['message'] ?? 'Failed to fetch addresses',
          statusCode: response.statusCode,
          errorCode: errorData['code'],
        );
      }
    } on SocketException catch (e) {
      LogService.error('$_logTag: Network error during addresses fetch: $e');
      throw const UserApiException(
        'Network connection failed. Please check your internet connection.',
      );
    } on HttpException catch (e) {
      LogService.error('$_logTag: HTTP error during addresses fetch: $e');
      throw UserApiException('Request failed: ${e.message}');
    } on FormatException catch (e) {
      LogService.error(
        '$_logTag: Response parsing error during addresses fetch: $e',
      );
      throw const UserApiException(
        'Invalid response format received from server',
      );
    } catch (e) {
      LogService.error('$_logTag: Unexpected error during addresses fetch: $e');
      throw UserApiException('Unexpected error occurred: ${e.toString()}');
    }
  }

  /// Add new address for authenticated user
  ///
  /// Creates a new address for the authenticated user's account.
  ///
  /// [accessToken] - Valid access token for authentication
  /// [createDto] - DTO containing address information
  /// Returns: Created [Address] object
  /// Throws: [UserApiException] on failure
  static Future<Address> addAddress(
    String accessToken,
    CreateAddressDto createDto,
  ) async {
    try {
      LogService.info('$_logTag: Adding new address');

      final response = await http
          .post(
            Uri.parse(ApiEndpoints.addAddress),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(createDto.toJson()),
          )
          .timeout(_timeout);

      LogService.debug(
        '$_logTag: Add address response status: ${response.statusCode}',
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final address = Address.fromJson(responseData);

        LogService.info('$_logTag: Address added successfully');
        return address;
      } else {
        final errorData = _parseErrorResponse(response);
        LogService.error(
          '$_logTag: Add address failed: ${errorData['message']}',
        );
        throw UserApiException(
          errorData['message'] ?? 'Failed to add address',
          statusCode: response.statusCode,
          errorCode: errorData['code'],
        );
      }
    } on SocketException catch (e) {
      LogService.error('$_logTag: Network error during address add: $e');
      throw const UserApiException(
        'Network connection failed. Please check your internet connection.',
      );
    } on HttpException catch (e) {
      LogService.error('$_logTag: HTTP error during address add: $e');
      throw UserApiException('Request failed: ${e.message}');
    } on FormatException catch (e) {
      LogService.error(
        '$_logTag: Response parsing error during address add: $e',
      );
      throw const UserApiException(
        'Invalid response format received from server',
      );
    } catch (e) {
      LogService.error('$_logTag: Unexpected error during address add: $e');
      throw UserApiException('Unexpected error occurred: ${e.toString()}');
    }
  }

  /// Update specific address by ID
  ///
  /// Updates an existing address with new information.
  ///
  /// [accessToken] - Valid access token for authentication
  /// [addressId] - ID of the address to update
  /// [updateDto] - DTO containing fields to update
  /// Returns: Updated [Address] object
  /// Throws: [UserApiException] on failure
  static Future<Address> updateAddress(
    String accessToken,
    String addressId,
    UpdateAddressDto updateDto,
  ) async {
    try {
      LogService.info('$_logTag: Updating address: $addressId');

      if (!updateDto.hasUpdates) {
        throw const UserApiException('No updates provided');
      }

      final response = await http
          .patch(
            Uri.parse(ApiEndpoints.updateAddress(addressId)),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(updateDto.toJson()),
          )
          .timeout(_timeout);

      LogService.debug(
        '$_logTag: Update address response status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final address = Address.fromJson(responseData);

        LogService.info('$_logTag: Address updated successfully');
        return address;
      } else {
        final errorData = _parseErrorResponse(response);
        LogService.error(
          '$_logTag: Update address failed: ${errorData['message']}',
        );
        throw UserApiException(
          errorData['message'] ?? 'Failed to update address',
          statusCode: response.statusCode,
          errorCode: errorData['code'],
        );
      }
    } on SocketException catch (e) {
      LogService.error('$_logTag: Network error during address update: $e');
      throw const UserApiException(
        'Network connection failed. Please check your internet connection.',
      );
    } on HttpException catch (e) {
      LogService.error('$_logTag: HTTP error during address update: $e');
      throw UserApiException('Request failed: ${e.message}');
    } on FormatException catch (e) {
      LogService.error(
        '$_logTag: Response parsing error during address update: $e',
      );
      throw const UserApiException(
        'Invalid response format received from server',
      );
    } catch (e) {
      LogService.error('$_logTag: Unexpected error during address update: $e');
      throw UserApiException('Unexpected error occurred: ${e.toString()}');
    }
  }

  /// Delete specific address by ID
  ///
  /// Removes an address from the authenticated user's account.
  ///
  /// [accessToken] - Valid access token for authentication
  /// [addressId] - ID of the address to delete
  /// Returns: Success indicator
  /// Throws: [UserApiException] on failure
  static Future<bool> deleteAddress(
    String accessToken,
    String addressId,
  ) async {
    try {
      LogService.info('$_logTag: Deleting address: $addressId');

      final response = await http
          .delete(
            Uri.parse(ApiEndpoints.deleteAddress(addressId)),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Accept': 'application/json',
            },
          )
          .timeout(_timeout);

      LogService.debug(
        '$_logTag: Delete address response status: ${response.statusCode}',
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        LogService.info('$_logTag: Address deleted successfully');
        return true;
      } else {
        final errorData = _parseErrorResponse(response);
        LogService.error(
          '$_logTag: Delete address failed: ${errorData['message']}',
        );
        throw UserApiException(
          errorData['message'] ?? 'Failed to delete address',
          statusCode: response.statusCode,
          errorCode: errorData['code'],
        );
      }
    } on SocketException catch (e) {
      LogService.error('$_logTag: Network error during address delete: $e');
      throw const UserApiException(
        'Network connection failed. Please check your internet connection.',
      );
    } on HttpException catch (e) {
      LogService.error('$_logTag: HTTP error during address delete: $e');
      throw UserApiException('Request failed: ${e.message}');
    } on FormatException catch (e) {
      LogService.error(
        '$_logTag: Response parsing error during address delete: $e',
      );
      throw const UserApiException(
        'Invalid response format received from server',
      );
    } catch (e) {
      LogService.error('$_logTag: Unexpected error during address delete: $e');
      throw UserApiException('Unexpected error occurred: ${e.toString()}');
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

  /// Check if an error indicates authorization failure
  ///
  /// Determines if the error is related to authentication/authorization.
  ///
  /// [exception] - The user API exception to check
  /// Returns: true if the error indicates auth failure
  static bool isAuthorizationError(UserApiException exception) {
    return exception.statusCode == 401 || exception.statusCode == 403;
  }

  /// Check if an error indicates a validation failure
  ///
  /// Determines if the error is related to input validation.
  ///
  /// [exception] - The user API exception to check
  /// Returns: true if the error indicates validation failure
  static bool isValidationError(UserApiException exception) {
    return exception.statusCode == 400 ||
        exception.message.toLowerCase().contains('validation') ||
        exception.message.toLowerCase().contains('invalid');
  }

  /// Check if an error indicates a not found resource
  ///
  /// Determines if the error is related to a missing resource.
  ///
  /// [exception] - The user API exception to check
  /// Returns: true if the error indicates resource not found
  static bool isNotFoundError(UserApiException exception) {
    return exception.statusCode == 404;
  }
}
