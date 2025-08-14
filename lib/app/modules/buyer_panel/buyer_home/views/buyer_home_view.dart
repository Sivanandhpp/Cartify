import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/buyer_home_controller.dart';
import '../../widgets/product_card.dart';

class BuyerHomeView extends GetView<BuyerHomeController> {
  const BuyerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home'),
      //   centerTitle: true,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.refresh),
      //       onPressed: controller.refreshDashboard,
      //     ),
      //   ],
      // ),
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

          child: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
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
                  // Categories Section - Horizontal scrolling at top
                  if (controller.hasCategories()) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: controller.getCategories().length,
                              itemBuilder: (context, index) {
                                final category = controller
                                    .getCategories()[index];
                                return Container(
                                  width: 80,
                                  margin: const EdgeInsets.only(right: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          border: Border.all(
                                            color: Colors.orange.withOpacity(
                                              0.3,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        child: AppImage.network(
                                          url: category.imageUrl!,
                                          width: 30,
                                          height: 30,
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          errorWidget: const Icon(
                                            Icons.category,
                                            size: 30,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        category.name,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Promotional Banners Section
                  if (controller.hasPromotionalBanners()) ...[
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.getPromotionalBanners().length,
                        itemBuilder: (context, index) {
                          final banner = controller
                              .getPromotionalBanners()[index];
                          return Container(
                            width: 380,
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
                            child: AppImage.network(
                              url: banner.imageUrl,
                              fit: BoxFit.cover,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Featured Products Section
                  if (controller.hasFeaturedProducts()) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        controller.getFeaturedProductsTitle(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height:
                          280, // Increased height for better ProductCard display
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.getFeaturedProducts().length,
                        itemBuilder: (context, index) {
                          final product = controller
                              .getFeaturedProducts()[index];
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
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
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
