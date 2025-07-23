import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';
import '../../controllers/user_dashboard_controller.dart';

class ProfilePage extends GetView<UserDashboardController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollUpdateNotification) {
          controller.handleScrollUpdate(scrollInfo.metrics.pixels);
        }
        return false;
      },
      child: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            pinned: false,
            backgroundColor: AppColors.primary,
            title: const Text(
              'Profile',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: AppColors.white),
                onPressed: () => _showLogoutDialog(context),
              ),
            ],
          ),

          // Profile Header
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Obx(
                () => Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        controller.userProfile['avatar'] ??
                            AppImages.userPlaceholder,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.userProfile['name'] ?? 'User Name',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.userProfile['email'] ??
                                'user@example.com',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.grey.withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.userProfile['phone'] ?? '+91 9876543210',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.grey.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.primary),
                      onPressed: () {
                        Get.snackbar(
                          'Edit Profile',
                          'Profile editing coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Stats Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Orders',
                        controller.userProfile['totalOrders']?.toString() ??
                            '0',
                        Icons.receipt_long,
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Spent',
                        '₹${controller.userProfile['totalSpent']?.toStringAsFixed(0) ?? '0'}',
                        Icons.account_balance_wallet,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Points',
                        controller.userProfile['loyaltyPoints']?.toString() ??
                            '0',
                        Icons.star,
                        Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Menu Items
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildMenuSection('Account', [
                    _buildMenuItem(
                      'My Orders',
                      'View your order history',
                      Icons.shopping_bag,
                      () =>
                          Get.snackbar('My Orders', 'Opening order history...'),
                    ),
                    _buildMenuItem(
                      'Addresses',
                      'Manage delivery addresses',
                      Icons.location_on,
                      () =>
                          Get.snackbar('Addresses', 'Opening address book...'),
                    ),
                    _buildMenuItem(
                      'Payment Methods',
                      'Manage cards and wallets',
                      Icons.payment,
                      () =>
                          Get.snackbar('Payment', 'Opening payment methods...'),
                    ),
                  ]),

                  const SizedBox(height: 24),
                  _buildMenuSection('Preferences', [
                    _buildMenuItem(
                      'Notifications',
                      'Manage notification settings',
                      Icons.notifications,
                      () => Get.snackbar(
                        'Notifications',
                        'Opening notification settings...',
                      ),
                    ),
                    _buildMenuItem(
                      'Language',
                      'Change app language',
                      Icons.language,
                      () => Get.snackbar(
                        'Language',
                        'Opening language settings...',
                      ),
                    ),
                    _buildMenuItem(
                      'Theme',
                      'Switch between light and dark',
                      Icons.palette,
                      () => Get.snackbar('Theme', 'Opening theme settings...'),
                    ),
                  ]),

                  const SizedBox(height: 24),
                  _buildMenuSection('Support', [
                    _buildMenuItem(
                      'Help Center',
                      'Get help and support',
                      Icons.help,
                      () => Get.snackbar('Help', 'Opening help center...'),
                    ),
                    _buildMenuItem(
                      'Contact Us',
                      'Reach out to customer support',
                      Icons.contact_support,
                      () =>
                          Get.snackbar('Contact', 'Opening contact options...'),
                    ),
                    _buildMenuItem(
                      'About',
                      'App version and legal info',
                      Icons.info,
                      () => Get.snackbar('About', 'Version 1.0.0'),
                    ),
                  ]),
                ],
              ),
            ),
          ),

          // Add bottom padding for safe area + cart widget + nav bar
          const SliverToBoxAdapter(child: SizedBox(height: 180)),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.grey.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.grey.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.logOut();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
