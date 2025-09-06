import 'dart:io';
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/core/models/user/update_address_dto.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';

/// Service for managing user profile and addresses.
class UserService {
  final ApiClient _apiClient;
  UserService(this._apiClient);

  /// Retrieves the profile of the currently authenticated user.
  /// Backend endpoint: GET /users/profile
  Future<UserModel?> getUserProfile() async {
    try {
      LogService.info('Fetching user profile');
      final response = await _apiClient.dio.get('/users/profile');

      final user = UserModel.fromJson(response.data);
      LogService.info('User profile fetched successfully', {
        'userId': user.id,
        'userName': user.name,
      });
      return user;
    } on DioException catch (e) {
      LogService.error('Error getting user profile', {
        'statusCode': e.response?.statusCode,
        'error': e.response?.data,
      });
      return null;
    } catch (e) {
      LogService.error('Unexpected error getting user profile', e);
      return null;
    }
  }

  /// Updates the user's profile.
  /// Backend endpoint: PATCH /users/profile
  Future<UserModel?> updateUserProfile(UpdateUserDto dto) async {
    try {
      LogService.info('Updating user profile', {
        'name': dto.name,
        'email': dto.email,
      });

      final response = await _apiClient.dio.patch(
        '/users/profile',
        data: dto.toJson(),
      );

      final updatedUser = UserModel.fromJson(response.data);
      LogService.info('User profile updated successfully', {
        'userId': updatedUser.id,
        'updatedName': updatedUser.name,
        'updatedEmail': updatedUser.email,
      });
      return updatedUser;
    } on DioException catch (e) {
      LogService.error('Error updating user profile', {
        'statusCode': e.response?.statusCode,
        'error': e.response?.data,
      });
      return null;
    } catch (e) {
      LogService.error('Unexpected error updating user profile', e);
      return null;
    }
  }

  /// Uploads a profile picture for the user with proper mime type and size.
  /// Backend endpoint: POST /users/:id/profile/picture
  Future<UserModel?> uploadProfilePicture(
    File image, {
    String? mimeType,
    int? fileSize,
  }) async {
    try {
      // Get current user profile to retrieve user ID
      final currentUser = await getUserProfile();
      if (currentUser == null) {
        LogService.error('Cannot upload profile picture: User not found');
        return null;
      }

      // Get file info
      final imageSize = fileSize ?? await image.length();
      final imageMimeType =
          mimeType ?? lookupMimeType(image.path) ?? 'image/jpeg';
      final fileName = image.path.split('/').last;

      LogService.info('Uploading profile picture', {
        'userId': currentUser.id,
        'imageSize': imageSize,
        'imagePath': image.path,
        'mimeType': imageMimeType,
        'originalname': fileName,
      });

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          image.path,
          filename: fileName,
          contentType: DioMediaType.parse(imageMimeType),
        ),
        'originalname': fileName,
        'mimetype': imageMimeType,
        'size': imageSize,
      });

      final response = await _apiClient.dio.post(
        '/users/${currentUser.id}/profile/picture',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final updatedUser = UserModel.fromJson(response.data);
      LogService.info('Profile picture uploaded successfully', {
        'userId': updatedUser.id,
        'newProfilePhotoUrl': updatedUser.profilePhotoUrl,
      });
      return updatedUser;
    } on DioException catch (e) {
      LogService.error('Error uploading profile picture', {
        'statusCode': e.response?.statusCode,
        'error': e.response?.data,
      });
      return null;
    } catch (e) {
      LogService.error('Unexpected error uploading profile picture', e);
      return null;
    }
  }

  /// Retrieves all of the user's shipping addresses.
  Future<List<Address>> getAddresses() async {
    try {
      final response = await _apiClient.dio.get('/address');
      return (response.data as List)
          .map((addr) => Address.fromJson(addr))
          .toList();
    } on DioException catch (e) {
      LogService.error('Error getting addresses', e.response?.data);
      return [];
    }
  }

  /// Creates a new shipping address for the user.
  Future<Address?> createAddress(CreateAddressDto dto) async {
    try {
      final response = await _apiClient.dio.post(
        '/address',
        data: dto.toJson(),
      );
      return Address.fromJson(response.data);
    } on DioException catch (e) {
      LogService.error('Error creating address', e.response?.data);
      return null;
    }
  }

  /// Updates an existing shipping address.
  Future<Address?> updateAddress(String addressId, UpdateAddressDto dto) async {
    try {
      final response = await _apiClient.dio.patch(
        '/address/$addressId',
        data: dto.toJson(),
      );
      return Address.fromJson(response.data);
    } on DioException catch (e) {
      LogService.error('Error updating address', e.response?.data);
      return null;
    }
  }

  /// Deletes a shipping address.
  Future<bool> deleteAddress(String addressId) async {
    try {
      await _apiClient.dio.delete('/address/$addressId');
      return true;
    } on DioException catch (e) {
      LogService.error('Error deleting address', e.response?.data);
      return false;
    }
  }
}
