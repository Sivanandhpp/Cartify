// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local widget imports (relative)
import '../../product_sheet/product_sheet.dart';
import '../../../controllers/hot_deals_controller.dart';

/// The main widget that includes the title and the horizontal list.
class HotDealsSection extends StatelessWidget {
  const HotDealsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final HotDealsController hotDealsController =
        Get.find<HotDealsController>();

    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Section header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hot deals',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      LogService.info('See All button pressed in Hot Deals');
                    },
                    child: const Row(
                      children: [
                        Text('See All', style: TextStyle(color: Colors.orange)),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Horizontal List with API data
            Obx(() {
              if (hotDealsController.isLoading.value) {
                return const SizedBox(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }

              if (hotDealsController.hasError.value) {
                return SizedBox(
                  height: 300,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          hotDealsController.errorMessage.value,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => hotDealsController.refreshHotDeals(),
                          child: const Text(
                            'Retry',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (!hotDealsController.hasProducts) {
                return const SizedBox(
                  height: 300,
                  child: Center(
                    child: Text(
                      'No hot deals available',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: hotDealsController.displayProducts.length,
                  padding: const EdgeInsets.only(left: 16.0),
                  itemBuilder: (BuildContext context, int index) {
                    final BeverageProduct product =
                        hotDealsController.displayProducts[index];
                    return BeverageProductCard(product: product);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// Individual beverage product card widget
class BeverageProductCard extends StatelessWidget {
  const BeverageProductCard({super.key, required this.product});

  final BeverageProduct product;

  @override
  Widget build(BuildContext context) {
    final CartService cartService = Get.find<CartService>();

    return GestureDetector(
      onTap: () {
        LogService.info('Product card tapped: ${product.name}');
        showProductSheet();
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Add Button
            Stack(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    image: DecorationImage(
                      image: NetworkImage(product.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Obx(() {
                    final int quantity = cartService.getQuantity(product.id);
                    return quantity == 0
                        ? _buildAddButton(cartService, product)
                        : _buildQuantitySelector(
                            cartService,
                            product.id,
                            quantity,
                          );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Product Details
            Text(
              product.formattedVolume,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.green, size: 16),
                const SizedBox(width: 4),
                Text(
                  product.formattedRating,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Pricing
            Row(
              children: [
                Text(
                  product.discountText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  product.formattedOriginalPrice,
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  product.formattedOfferPrice,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(CartService cartService, BeverageProduct product) {
    return GestureDetector(
      onTap: () async {
        LogService.info('Add button tapped for product: ${product.id}');

        // Convert the beverage product to a Product object
        final Product productObject = product.toProduct();

        // Add to cart using the cart service
        await cartService.addToCart(productObject, quantity: 1);
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildQuantitySelector(
    CartService cartService,
    String productId,
    int quantity,
  ) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30),
            icon: const Icon(Icons.remove, color: Colors.white, size: 16),
            onPressed: () async {
              LogService.info('Decrement quantity for product: $productId');
              await cartService.decrementQuantity(productId);
            },
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 20),
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30),
            icon: const Icon(Icons.add, color: Colors.white, size: 16),
            onPressed: () async {
              LogService.info('Increment quantity for product: $productId');
              await cartService.incrementQuantity(productId);
            },
          ),
        ],
      ),
    );
  }
}
