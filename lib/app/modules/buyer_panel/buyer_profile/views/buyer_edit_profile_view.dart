import 'dart:io';
import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/buyer_edit_profile_controller.dart';

class BuyerEditProfileView extends GetView<BuyerEditProfileController> {
  const BuyerEditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: _buildAppBar(),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProfilePictureSection(),
              const SizedBox(height: 32),
              _buildFormFields(),
              const SizedBox(height: 32),
              _buildUpdateButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.black),
        onPressed: () => Get.back(),
      ),
      title: Text(
        AppStrings.editProfileTitle,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProfilePictureSection() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Obx(() {
                return CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.grey200,
                  backgroundImage: _getProfileImage(),
                  child: _getProfileImage() == null
                      ? Icon(Icons.person, size: 60, color: AppColors.grey400)
                      : null,
                );
              }),
              Positioned(
                bottom: 0,
                right: 0,
                child: Obx(
                  () => GestureDetector(
                    onTap: controller.isUploadingPhoto.value
                        ? null
                        : controller.showImagePickerOptions,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                      child: controller.isUploadingPhoto.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                              color: AppColors.white,
                              size: 20,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.tapToChangeProfilePicture,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  ImageProvider? _getProfileImage() {
    // Show selected image first
    if (controller.selectedImage.value != null) {
      return FileImage(controller.selectedImage.value!);
    }

    // Show current profile photo
    if (controller.profilePhotoUrl.value.isNotEmpty) {
      return NetworkImage(controller.profilePhotoUrl.value);
    }

    return null;
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildTextField(
          controller: controller.nameController,
          label: AppStrings.fullNameLabel,
          hint: AppStrings.enterYourFullName,
          icon: Icons.person_outline,
          validator: controller.validateName,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: controller.emailController,
          label: AppStrings.emailAddressLabel,
          hint: AppStrings.enterYourEmailAddress,
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: controller.validateEmail,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: controller.phoneController,
          label: AppStrings.phoneNumberLabel,
          hint: AppStrings.yourPhoneNumber,
          icon: Icons.phone_outlined,
          enabled: false, // Phone number cannot be changed
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(
              icon,
              color: enabled ? AppColors.primary : Colors.grey,
            ),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.lightError,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return Obx(
      () => AppButton(
        text: AppStrings.updateProfile,
        onPressed: controller.updateProfile,
        isLoading: controller.isLoading.value,
        icon: Icons.save_outlined,
      ),
    );
  }
}
