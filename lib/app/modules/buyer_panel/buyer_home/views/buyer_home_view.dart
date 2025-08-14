import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/buyer_home_controller.dart';
import '../../widgets/product_card.dart';
import '../../../../core/widgets/app_image.dart';

class BuyerHomeView extends GetView<BuyerHomeController> {
  const BuyerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshDashboard,
          ),
        ],
      ),
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
                  'Error Loading Dashboard',
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
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Show dashboard content
        return RefreshIndicator(
          onRefresh: controller.refreshDashboard,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Promotional Banners Section
                if (controller.hasPromotionalBanners()) ...[
                  const Text(
                    'Promotions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.getPromotionalBanners().length,
                      itemBuilder: (context, index) {
                        final banner = controller
                            .getPromotionalBanners()[index];
                        return Container(
                          width: 280,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: AppImages.network(
                            url: banner.imageUrl,
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(12),
                            errorWidget: Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Categories Section
                if (controller.hasCategories()) ...[
                  const Text(
                    'Categories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: controller.getCategories().length,
                    itemBuilder: (context, index) {
                      final category = controller.getCategories()[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              category.imageUrl != null
                                  ? AppImages.network(
                                      url: category.imageUrl!,
                                      height: 40,
                                      width: 40,
                                      errorWidget: const Icon(
                                        Icons.category,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.category,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                              const SizedBox(height: 8),
                              Text(
                                category.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],

                // Featured Products Section
                if (controller.hasFeaturedProducts()) ...[
                  Text(
                    controller.getFeaturedProductsTitle(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height:
                        280, // Increased height for better ProductCard display
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.getFeaturedProducts().length,
                      itemBuilder: (context, index) {
                        final product = controller.getFeaturedProducts()[index];
                        return Container(
                          width: 180, // Increased width for better display
                          margin: const EdgeInsets.only(right: 12),
                          child: ProductCard(
                            product: product,
                            isGridView: true,
                            currentQuantity:
                                0, // TODO: Connect to cart controller
                            onTap: () {
                              // TODO: Navigate to product details
                              print('Product tapped: ${product.name}');
                            },
                            onIncrement: () {
                              // TODO: Add to cart
                              print('Add to cart: ${product.name}');
                            },
                            onDecrement: () {
                              // TODO: Remove from cart
                              print('Remove from cart: ${product.name}');
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Debug info (you can remove this in production)
                if (Get.isLogEnable) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Debug Info',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Available sections: ${controller.getAvailableSectionTypes().join(', ')}',
                          ),
                          Text(
                            'Banners count: ${controller.getSectionItemCount('PROMOTIONAL_BANNERS')}',
                          ),
                          Text(
                            'Categories count: ${controller.getSectionItemCount('CATEGORIES_GRID')}',
                          ),
                          Text(
                            'Featured products count: ${controller.getSectionItemCount('FEATURED_PRODUCTS')}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}
