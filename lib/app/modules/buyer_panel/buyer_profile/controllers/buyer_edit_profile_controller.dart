import 'dart:io';
import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerEditProfileController extends GetxController {
  final UserService _userService = Get.find<UserService>();
  final UserController _userController = Get.find<UserController>();

  // Form controllers
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  // Observable states
  final RxBool isLoading = false.obs;
  final RxBool isUploadingPhoto = false.obs;
  final Rxn<File> selectedImage = Rxn<File>();
  final RxString profilePhotoUrl = ''.obs;

  // Store image metadata
  final RxString selectedImageMimeType = ''.obs;
  final RxInt selectedImageSize = 0.obs;

  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _loadUserData();
  }

  void _initializeControllers() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
  }

  /// Load current user data
  void _loadUserData() {
    final currentUser = _userController.user;
    if (currentUser != null) {
      nameController.text = currentUser.name ?? '';
      emailController.text = currentUser.email ?? '';
      phoneController.text = currentUser.phoneNumber;
      profilePhotoUrl.value = currentUser.profilePhotoUrl ?? '';
    }
  }

  /// Show image picker options using AppImagePicker
  Future<void> showImagePickerOptions() async {
    final result = await AppImagePicker.pickProfilePicture();

    if (result != null) {
      selectedImage.value = result.selectedImage;
      selectedImageMimeType.value = result.mimeType;
      selectedImageSize.value = result.size;

      LogService.info('Image selected via AppImagePicker', {
        'path': result.selectedImage.path,
        'size': result.size,
        'mimeType': result.mimeType,
      });

      NotificationService.showInfo(
        title: 'Image Selected',
        message: 'Profile picture updated. Tap "Update Profile" to save.',
      );
    }
  }

  /// Upload profile picture with proper metadata
  Future<void> uploadProfilePicture() async {
    if (selectedImage.value == null) return;

    try {
      isUploadingPhoto.value = true;
      LogService.info('Uploading profile picture');

      final updatedUser = await _userService.uploadProfilePicture(
        selectedImage.value!,
        mimeType: selectedImageMimeType.value,
        fileSize: selectedImageSize.value,
      );

      if (updatedUser != null) {
        _userController.updateUser(updatedUser);
        profilePhotoUrl.value = updatedUser.profilePhotoUrl ?? '';
        selectedImage.value = null;
        selectedImageMimeType.value = '';
        selectedImageSize.value = 0;

        NotificationService.showSuccess(
          title: 'Success',
          message: 'Profile picture updated successfully',
        );

        LogService.info('Profile picture uploaded successfully');
      } else {
        throw Exception('Failed to upload profile picture');
      }
    } catch (e) {
      LogService.error('Error uploading profile picture', e);
      NotificationService.showError(
        title: 'Error',
        message: 'Failed to update profile picture. Please try again.',
      );
    } finally {
      isUploadingPhoto.value = false;
    }
  }

  /// Update user profile
  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      LogService.info('Updating user profile');

      // First upload image if selected
      if (selectedImage.value != null) {
        await uploadProfilePicture();
      }

      // Then update profile data
      final updateDto = UpdateUserDto(
        name: nameController.text.trim().isEmpty
            ? null
            : nameController.text.trim(),
        email: emailController.text.trim().isEmpty
            ? null
            : emailController.text.trim(),
      );

      final updatedUser = await _userService.updateUserProfile(updateDto);

      if (updatedUser != null) {
        _userController.updateUser(updatedUser);

        NotificationService.showSuccess(
          title: 'Success',
          message: 'Profile updated successfully',
        );

        LogService.info('Profile updated successfully');
        Get.back();
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      LogService.error('Error updating profile', e);
      NotificationService.showError(
        title: 'Error',
        message: 'Failed to update profile. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Validate email using AppValidators
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return AppValidators.validateEmail(value);
  }

  /// Validate name using AppValidators
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return AppValidators.validateName(value);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}