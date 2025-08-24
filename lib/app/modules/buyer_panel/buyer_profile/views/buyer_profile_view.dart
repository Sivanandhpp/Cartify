// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_profile/views/widgets/profile_header.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_profile/views/widgets/profile_menu_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local imports
import '../controllers/buyer_profile_controller.dart';

/// Main profile view for buyers with clean separation of UI components
class BuyerProfileView extends GetView<BuyerProfileController> {
  const BuyerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshProfile,

      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: false, // Prevents app bar from floating
            pinned: true, // Keeps app bar visible at all times
            snap: false, // Ensures smooth behavior
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
                onPressed: () => controller.showLogoutDialog(context),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: ProfileHeaderWidget(controller: controller),
          ),
          _buildMenuSections(),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  /// Builds all menu sections
  Widget _buildMenuSections() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // Account section
            ProfileMenuSectionWidget(
              title: 'Account',
              items: controller.getAccountMenuItems(),
            ),

            const SizedBox(height: 24),

            // Preferences section
            ProfileMenuSectionWidget(
              title: 'Preferences',
              items: controller.getPreferencesMenuItems(),
            ),

            const SizedBox(height: 24),

            // Support section
            ProfileMenuSectionWidget(
              title: 'Support',
              items: controller.getSupportMenuItems(),
            ),
          ],
        ),
      ),
    );
  }
}
