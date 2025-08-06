// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local imports
import '../controllers/buyer_home_controller.dart';
import '../models/category_model.dart';
import '../models/deal_model.dart';
import 'widgets/horizontal_product_list.dart';

class BuyerHomeView extends GetView<BuyerHomeController> {
  const BuyerHomeView({super.key});
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
          _buildHomeAppBar(),
          // _buildCategorySection(controller.categories),
          SliverToBoxAdapter(
            child: Image.asset(AppImages.promoBanner, fit: BoxFit.fitWidth),
          ),
          // _buildDealCardsSection(controller.deals),
          const SliverToBoxAdapter(child: AppSpacing.spaceLarge),
          _buildExpiryBannerSection(),
          // _buildHotDealsSection(),
          const SliverToBoxAdapter(child: SizedBox(height: 180)),
        ],
      ),
    );
  }

  Widget _buildHomeAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.primary,
      pinned: true,
      floating: true,
      elevation: 0,
      title: const Row(
        children: [
          Icon(Icons.location_on, color: AppColors.white, size: 20),
          AppSpacing.spaceSmallW,
          Text(
            'Kozhikode Work',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          Icon(Icons.arrow_drop_down, color: AppColors.white),
        ],
      ),
      actions: [
        IconButton(
          icon: _buildCartIcon(),
          onPressed: () {
            Get.toNamed('/cart');
          },
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(64.0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for \'Products\'',
              hintStyle: TextStyle(color: AppColors.grey),
              prefixIcon: Icon(Icons.search, color: AppColors.grey),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: AppSpacing.radiusSmall,
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartIcon() {
    return Obx(() {
      final itemCount = controller.cartItemCount;
      return Stack(
        children: [
          const Icon(Icons.shopping_cart),
          if (itemCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.white, width: 1),
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  itemCount > 99 ? '99+' : itemCount.toString(),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildCategorySection(List<CategoryModel> categories) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(color: AppColors.primary),
        height: 84,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final category = categories[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.white,
                    child: Icon(category.icon, color: AppColors.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.label,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDealCardsSection(List<DealModel> deals) {
    return SliverToBoxAdapter(
      child: Container(
        color: const Color(0xFF192D8C),
        padding: const EdgeInsets.symmetric(vertical: 8),
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: deals.length,
          itemBuilder: (context, index) {
            final deal = deals[index];
            return Container(
              width: MediaQuery.of(context).size.width * 0.35,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: deal.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  if (deal.imageUrl != null)
                    Positioned(
                      right: -20,
                      bottom: 40,
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(deal.imageUrl!, fit: BoxFit.contain),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deal.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          deal.subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildExpiryBannerSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.timer, color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXPIRES IN 8 HOURS',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Claim your ₹100 FREE cash now!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'On your order above ₹249. T&C applied',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 50,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Claim',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildHotDealsSection() {
  //   final HotDealsController hotDealsController =
  //       Get.find<HotDealsController>();
  //   return Obx(() {
  //     return HorizontalProductListWidget(
  //       title: 'Hot deals',
  //       products: hotDealsController.products.take(10).toList(),
  //       isLoading: hotDealsController.isLoading.value,
  //       hasError: hotDealsController.hasError.value,
  //       errorMessage: hotDealsController.errorMessage.value,
  //       onSeeAllPressed: () {
  //         LogService.info('See All button pressed in Hot Deals');
  //       },
  //       onRetryPressed: () => hotDealsController.refreshHotDeals(),
  //     );
  //   });
  // }
}
