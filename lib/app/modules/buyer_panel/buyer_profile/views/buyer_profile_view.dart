import 'package:cartify/app/modules/buyer_panel/buyer_profile/views/saved_address_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartify/app/core/index.dart';
import '../controllers/buyer_profile_controller.dart';

class BuyerProfileView extends GetView<BuyerProfileController> {
  const BuyerProfileView({super.key});

  Widget _buildProfileCard() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.large),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      }

      final user = controller.user.value;
      final hasProfile = user != null;

      return Card(
        margin: const EdgeInsets.all(AppSpacing.medium),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: hasProfile && user.profilePhotoUrl != null 
                    ? NetworkImage(user.profilePhotoUrl!) 
                    : null,
                child: hasProfile && user.profilePhotoUrl == null
                    ? Text(
                       "A",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.primary,
                      ),
              ),
              const SizedBox(height: AppSpacing.medium),
              if (hasProfile) ...[
                Text(
                  user.name ?? 'User',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.small),
                Text(
                  user.email ?? 'No email provided',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                if (user.phoneNumber != null) ...[
                  const SizedBox(height: AppSpacing.small),
                  Text(
                    user.phoneNumber!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.medium),
                AppButton(
                  text: 'Edit Profile',
                  onPressed: () {
                    // TODO: Navigate to edit profile
                    Get.snackbar('Coming Soon', 'Profile editing will be available soon');
                  },
                ),
              ] else ...[
                Text(
                  'Complete Your Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: AppSpacing.small),
                Text(
                  'Add your details to personalize your experience',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.medium),
                AppButton(
                  text: 'Update Profile',
                  onPressed: () {
                    // TODO: Navigate to profile setup
                    Get.snackbar('Coming Soon', 'Profile setup will be available soon');
                  },
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.primary,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: trailing ?? Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: controller.refreshProfile,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileCard(),
            const SizedBox(height: AppSpacing.medium),
            _buildMenuOption(
              icon: Icons.location_on,
              title: 'Saved Addresses',
              onTap: () => Get.to(() => const SavedAddressesView()),
            ),
            _buildMenuOption(
              icon: Icons.shopping_bag,
              title: 'My Orders',
              onTap: () {
                // TODO: Navigate to orders
                Get.snackbar('Coming Soon', 'Order history will be available soon');
              },
            ),
            _buildMenuOption(
              icon: Icons.favorite,
              title: 'Wishlist',
              onTap: () {
                // TODO: Navigate to wishlist
                Get.snackbar('Coming Soon', 'Wishlist will be available soon');
              },
            ),
            _buildMenuOption(
              icon: Icons.notifications,
              title: 'Notifications',
              onTap: () {
                // TODO: Navigate to notifications
                Get.snackbar('Coming Soon', 'Notification settings will be available soon');
              },
            ),
            _buildMenuOption(
              icon: Icons.help,
              title: 'Help & Support',
              onTap: () {
                // TODO: Navigate to support
                Get.snackbar('Coming Soon', 'Help & Support will be available soon');
              },
            ),
            _buildMenuOption(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () async {
                final confirmed = await Get.dialog<bool>(
                  AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Get.back(result: true),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
                
                if (confirmed == true) {
                  controller.logout();
                }
              },
              trailing: const Icon(
                Icons.logout,
                size: 20,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: AppSpacing.xlarge),
          ],
        ),
      ),
    );
  }
}