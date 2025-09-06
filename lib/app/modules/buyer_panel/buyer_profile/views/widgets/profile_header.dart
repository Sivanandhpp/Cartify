import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../controllers/buyer_profile_controller.dart';

/// Widget responsible for displaying user profile information
class ProfileHeaderWidget extends StatelessWidget {
  final BuyerProfileController controller;

  const ProfileHeaderWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: _buildCardDecoration(),
      child: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingShimmer();
        }
        return _buildProfileContent();
      }),
    );
  }

  /// Creates the card decoration with shadow
  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  /// Builds shimmer loading effect
  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        children: [
          _buildShimmerAvatar(),
          const SizedBox(width: 16),
          Expanded(child: _buildShimmerContent()),
        ],
      ),
    );
  }

  /// Shimmer effect for avatar
  Widget _buildShimmerAvatar() {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }

  /// Shimmer effect for text content
  Widget _buildShimmerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShimmerLine(width: double.infinity, height: 20),
        const SizedBox(height: 8),
        _buildShimmerLine(width: 200, height: 14),
        const SizedBox(height: 6),
        _buildShimmerLine(width: 150, height: 14),
      ],
    );
  }

  /// Helper to create shimmer lines
  Widget _buildShimmerLine({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  /// Builds the actual profile content
  Widget _buildProfileContent() {
    return Row(
      children: [
        _buildProfileAvatar(),
        const SizedBox(width: 16),
        Expanded(child: _buildUserInfo()),
        _buildEditButton(),
      ],
    );
  }

  /// Builds user avatar with fallback
  Widget _buildProfileAvatar() {
    if (controller.hasProfilePhoto) {
      return ClipOval(
        child: AppImage.network(
          url: controller.displayProfilePhoto,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorWidget: _buildDefaultAvatar(),
        ),
      );
    }
    return _buildDefaultAvatar();
  }

  /// Default avatar when no profile photo exists
  Widget _buildDefaultAvatar() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.person, color: AppColors.primary, size: 36),
    );
  }

  /// Builds user information section
  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.displayName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          controller.displayEmail,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.grey.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          controller.displayPhoneNumber,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.grey.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  /// Edit profile button
  Widget _buildEditButton() {
    return IconButton(
      icon: const Icon(Icons.edit, color: AppColors.primary),
      onPressed: controller.editProfile,
    );
  }
}
