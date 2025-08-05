// lib/app/core/services/user/user_service.dart

import 'dart:io';
import 'package:cartify/app/core/models/user/address_model.dart';
import 'package:cartify/app/core/models/user/create_address_dto.dart';
import 'package:cartify/app/core/models/user/update_user_dto.dart';
import 'package:cartify/app/core/models/user/user_model.dart';
import 'package:cartify/app/core/services/api_client.dart';
import 'package:dio/dio.dart';

/// Service for managing user profile and addresses.
class UserService {
  final ApiClient _apiClient;

  UserService(this._apiClient);

  /// Retrieves the profile of the currently authenticated user.
  Future<UserModel?> getUserProfile() async {
    try {
      final response = await _apiClient.dio.get('/user/profile');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      print('Error getting user profile: ${e.response?.data}');
      return null;
    }
  }

  /// Updates the user's profile.
  Future<UserModel?> updateUserProfile(UpdateUserDto dto) async {
    try {
      final response = await _apiClient.dio.patch(
        '/user/profile',
        data: dto.toJson(),
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      print('Error updating user profile: ${e.response?.data}');
      return null;
    }
  }

  /// Uploads a profile picture for the user.
  Future<UserModel?> uploadProfilePicture(File image) async {
    try {
      String fileName = image.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(image.path, filename: fileName),
      });

      final response = await _apiClient.dio.post(
        '/user/profile/picture',
        data: formData,
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      print('Error uploading profile picture: ${e.response?.data}');
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
      print('Error getting addresses: ${e.response?.data}');
      return [];
    }
  }

  /// Adds a new shipping address.
  Future<Address?> addAddress(CreateAddressDto dto) async {
    try {
      final response = await _apiClient.dio.post(
        '/address',
        data: dto.toJson(),
      );
      return Address.fromJson(response.data);
    } on DioException catch (e) {
      print('Error adding address: ${e.response?.data}');
      return null;
    }
  }

  /// Updates an existing shipping address.
  Future<Address?> updateAddress(String addressId, CreateAddressDto dto) async {
    try {
      final response = await _apiClient.dio.patch(
        '/address/$addressId',
        data: dto.toJson(),
      );
      return Address.fromJson(response.data);
    } on DioException catch (e) {
      print('Error updating address: ${e.response?.data}');
      return null;
    }
  }

  /// Deletes a shipping address.
  Future<bool> deleteAddress(String addressId) async {
    try {
      await _apiClient.dio.delete('/address/$addressId');
      return true;
    } on DioException catch (e) {
      print('Error deleting address: ${e.response?.data}');
      return false;
    }
  }
}
