import 'package:bevco/app/core/widgets/app_spacers.dart';
import 'package:bevco/app/modules/user_dashboard/views/widgets/video_banner_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/themes/app_colors.dart';
import '../controllers/user_dashboard_controller.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/category_section.dart';
import 'widgets/deal_cards_section.dart';
import 'widgets/expiry_banner_section.dart';
import 'widgets/home_appbar.dart';
import 'widgets/hot_deals_section.dart';

class UserDashboardView extends GetView<UserDashboardController> {
  const UserDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          const HomeAppBar(),
          const SliverToBoxAdapter(child: AppSpacers.smallHeight),
          CategorySection(categories: controller.categories),
          const SliverToBoxAdapter(child: AppSpacers.smallHeight),
          VideoBannerView(),

          DealCardsSection(deals: controller.deals),
          const SliverToBoxAdapter(child: AppSpacers.mediumHeight),
          const ExpiryBannerSection(),
          const SliverToBoxAdapter(child: AppSpacers.mediumHeight),
          const HotDealsSection(),
        ],
      ),
      bottomNavigationBar: buildBottomNavBar(),
    );
  }
}
