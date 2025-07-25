// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Reusable product card widget for displaying API products
class ApiProductCard extends StatelessWidget {
  const ApiProductCard({super.key, required this.product});

  final ApiProduct product;

  @override
  Widget build(BuildContext context) {
    final CartService cartService = Get.find<CartService>();

    return GestureDetector(
      onTap: () {
        LogService.info('Product card tapped: ${product.name}');
        SheetService.showProductSheet(product: product);
      },
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Add Button
            Stack(
              children: [
                Container(
                  height: 120,
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

  Widget _buildAddButton(CartService cartService, ApiProduct product) {
    return GestureDetector(
      onTap: () async {
        LogService.info('Add button tapped for product: ${product.id}');

        // Convert the API product to a Product object
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
