import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_home/views/buyer_home_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/buyer_home_controller.dart';
import '../../widgets/product_card.dart';

class BuyerHomeView extends GetView<BuyerHomeController> {
  const BuyerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // Show loading state
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error state
        if (controller.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  AppStrings.errorLoadingDashboard,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refreshDashboard,
                  child: const Text(AppStrings.retry),
                ),
              ],
            ),
          );
        }

        // Show dashboard content with CustomScrollView
        return RefreshIndicator(
          onRefresh: controller.refreshDashboard,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              BuyerHomeSliverAppBar(
                categories: controller.getCategories(),
                selectedLocation: AppStrings.welcomeMessage,
                profilePhotoUrl: controller.userProfilePhotoUrl,
                selectedCategory: controller.selectedCategory.value,
                onLocationTap: () {
                  // Handle location tap
                },
                onProfileTap: () => controller.navigateToProfile(),
                onSearchChanged: (value) {
                  // Handle search
                },
                onCategoryTap: controller.onCategoryTap,
              ),
              // Promotional Banners Section
              if (controller.hasPromotionalBanners())
                SliverToBoxAdapter(
                  child: AppImage.network(
                    url: controller.getPromotionalBanners()[0].imageUrl,
                    fit: BoxFit.cover,
                    height: 100,
                    width: double.infinity,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 15)),

              // Featured Products Section
              if (controller.hasFeaturedProducts())
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          controller.getFeaturedProductsTitle(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 270,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: controller.getFeaturedProducts().length,
                          itemBuilder: (context, index) {
                            final product = controller
                                .getFeaturedProducts()[index];
                            return SizedBox(
                              width: 180,
                              // margin: const EdgeInsets.only(right: 4),
                              child: Obx(
                                () => ProductCard(
                                  product: product,
                                  currentQuantity: controller
                                      .getProductQuantityInCart(product.id),
                                  onTap: () {
                                    if (Get.context != null) {
                                      controller.showProductSheet(
                                        Get.context!,
                                        product,
                                      );
                                    }
                                  },
                                  onIncrement: () {
                                    controller.incrementProductQuantity(
                                      product.id,
                                    );
                                  },
                                  onDecrement: () {
                                    controller.decrementProductQuantity(
                                      product.id,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              
            ],
          ),
        );
      }),
    );
  }
}
