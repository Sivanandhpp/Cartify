/// User API Service for Cartify
/// Handles all user-related API calls including profile management,
/// address book operations, and profile picture uploads

import 'package:get/get.dart';

import '../../models/user_models.dart';
import '../api_service.dart';
import '../log_service.dart';
import '../error_service.dart';

/// Service for user profile and address API calls
class UserApiService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  // ============================================================================
  // USER PROFILE OPERATIONS
  // ============================================================================

  /// Get current user profile
  Future<UserProfile?> getUserProfile() async {
    try {
      LogService.info('Fetching user profile');

      final response = await _apiService.get('/user/profile');

      if (response.statusCode == 200) {
        final userProfile = UserProfile.fromJson(response.data);
        LogService.info('User profile fetched successfully');
        return userProfile;
      } else {
        LogService.error(
          'Failed to fetch user profile: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      LogService.error('Error fetching user profile: $e');
      ErrorService.showError('Failed to load profile. Please try again.');
      return null;
    }
  }

  /// Update user profile information
  Future<UserProfile?> updateUserProfile(
    UpdateUserProfileDto updateData,
  ) async {
    try {
      LogService.info('Updating user profile');

      final response = await _apiService.patch(
        '/user/profile',
        data: updateData.toJson(),
      );

      if (response.statusCode == 200) {
        final updatedProfile = UserProfile.fromJson(response.data);
        LogService.info('User profile updated successfully');
        ErrorService.showSuccess('Profile updated successfully');
        return updatedProfile;
      } else {
        LogService.error(
          'Failed to update user profile: ${response.statusCode}',
        );
        ErrorService.showError('Failed to update profile. Please try again.');
        return null;
      }
    } catch (e) {
      LogService.error('Error updating user profile: $e');
      ErrorService.showError('Failed to update profile. Please try again.');
      return null;
    }
  }

  /// Upload profile picture
  Future<String?> uploadProfilePicture(String imagePath) async {
    try {
      LogService.info('Uploading profile picture');

      final response = await _apiService.uploadFile(
        '/user/profile/picture',
        imagePath,
        fieldName: 'file',
      );

      if (response.statusCode == 200) {
        final imageUrl = response.data['profile_picture_url'] as String?;
        LogService.info('Profile picture uploaded successfully');
        ErrorService.showSuccess('Profile picture updated successfully');
        return imageUrl;
      } else {
        LogService.error(
          'Failed to upload profile picture: ${response.statusCode}',
        );
        ErrorService.showError('Failed to upload image. Please try again.');
        return null;
      }
    } catch (e) {
      LogService.error('Error uploading profile picture: $e');
      ErrorService.showError('Failed to upload image. Please try again.');
      return null;
    }
  }

  // ============================================================================
  // ADDRESS MANAGEMENT OPERATIONS
  // ============================================================================

  /// Get all user addresses
  Future<List<UserAddress>> getAllAddresses() async {
    try {
      LogService.info('Fetching user addresses');

      final response = await _apiService.get('/address');

      if (response.statusCode == 200) {
        final List<dynamic> addressesData = response.data ?? [];
        final addresses = addressesData
            .map((data) => UserAddress.fromJson(data))
            .toList();

        LogService.info('Fetched ${addresses.length} addresses');
        return addresses;
      } else {
        LogService.error('Failed to fetch addresses: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      LogService.error('Error fetching addresses: $e');
      ErrorService.showError('Failed to load addresses. Please try again.');
      return [];
    }
  }

  /// Add new address
  Future<UserAddress?> addAddress(CreateAddressDto addressData) async {
    try {
      LogService.info('Adding new address');

      final response = await _apiService.post(
        '/address',
        data: addressData.toJson(),
      );

      if (response.statusCode == 201) {
        final newAddress = UserAddress.fromJson(response.data);
        LogService.info('Address added successfully');
        ErrorService.showSuccess('Address added successfully');
        return newAddress;
      } else {
        LogService.error('Failed to add address: ${response.statusCode}');
        ErrorService.showError('Failed to add address. Please try again.');
        return null;
      }
    } catch (e) {
      LogService.error('Error adding address: $e');
      ErrorService.showError('Failed to add address. Please try again.');
      return null;
    }
  }

  /// Update existing address
  Future<UserAddress?> updateAddress(
    String addressId,
    CreateAddressDto addressData,
  ) async {
    try {
      LogService.info('Updating address: $addressId');

      final response = await _apiService.patch(
        '/address/$addressId',
        data: addressData.toJson(),
      );

      if (response.statusCode == 200) {
        final updatedAddress = UserAddress.fromJson(response.data);
        LogService.info('Address updated successfully');
        ErrorService.showSuccess('Address updated successfully');
        return updatedAddress;
      } else {
        LogService.error('Failed to update address: ${response.statusCode}');
        ErrorService.showError('Failed to update address. Please try again.');
        return null;
      }
    } catch (e) {
      LogService.error('Error updating address: $e');
      ErrorService.showError('Failed to update address. Please try again.');
      return null;
    }
  }

  /// Delete address
  Future<bool> deleteAddress(String addressId) async {
    try {
      LogService.info('Deleting address: $addressId');

      final response = await _apiService.delete('/address/$addressId');

      if (response.statusCode == 200) {
        LogService.info('Address deleted successfully');
        ErrorService.showSuccess('Address deleted successfully');
        return true;
      } else {
        LogService.error('Failed to delete address: ${response.statusCode}');
        ErrorService.showError('Failed to delete address. Please try again.');
        return false;
      }
    } catch (e) {
      LogService.error('Error deleting address: $e');
      ErrorService.showError('Failed to delete address. Please try again.');
      return false;
    }
  }

  /// Get single address by ID
  Future<UserAddress?> getAddressById(String addressId) async {
    try {
      LogService.info('Fetching address: $addressId');

      final response = await _apiService.get('/address/$addressId');

      if (response.statusCode == 200) {
        final address = UserAddress.fromJson(response.data);
        LogService.info('Address fetched successfully');
        return address;
      } else {
        LogService.error('Failed to fetch address: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      LogService.error('Error fetching address: $e');
      return null;
    }
  }
}
