import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';
import '../../controllers/user_dashboard_controller.dart';
import 'widgets/category_section.dart';
import 'widgets/deal_cards_section.dart';
import 'widgets/expiry_banner_section.dart';
import 'widgets/home_appbar.dart';
import 'widgets/hot_deals_section.dart';

class HomePage extends GetView<UserDashboardController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller.fadeAnimation,
      child: CustomScrollView(
        slivers: [
          const HomeAppBar(),
          CategorySection(categories: controller.categories),
          SliverToBoxAdapter(
            child: Image.asset(AppImages.promoBanner, fit: BoxFit.fitWidth),
          ),
          DealCardsSection(deals: controller.deals),
          const SliverToBoxAdapter(child: AppSpacing.spaceLarge),
          const ExpiryBannerSection(),
          const HotDealsSection(),
          const HotDealsSection(),
          const HotDealsSection(),
          // Add bottom padding for safe area
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
