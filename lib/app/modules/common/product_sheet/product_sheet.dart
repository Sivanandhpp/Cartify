import 'dart:ui';

import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/product_sheet_controller.dart';
import 'widgets/expandable_details_section.dart';
import 'widgets/product_image_carousel.dart';

class ProductSheetWidget extends StatelessWidget {
  const ProductSheetWidget({super.key, this.product});

  final ProductModel? product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductSheetController());

    return DraggableScrollableSheet(
      controller: controller.draggableController,
      initialChildSize: ProductSheetController.initialSheetSize,
      minChildSize: ProductSheetController.minSheetSize,
      maxChildSize: ProductSheetController.maxSheetSize,
      snap: true,
      snapSizes: const [0.6, 0.95],
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Scrollable content
              CustomScrollView(
                controller: scrollController,
                slivers: [
                  // Product Image Carousel
                  Obx(
                    () => ProductImageCarousel(
                      images: controller.getProductImages(product!),
                      currentImageIndex: controller.currentImageIndex.value,
                      totalImages: product!.imageUrls.length,
                      pageController: controller.imagePageController,
                      onPageChanged: controller.onImagePageChanged,
                    ),
                  ),

                  // Product Information Section (inline)
                  if (product != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product!.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₹${product!.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product!.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => controller.addToCart(),
                                  child: const Text('Add to Cart'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => controller.removeFromCart(),
                                  child: const Text('Remove'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  // Expandable Details Section
                  if (product != null)
                    ExpandableDetailsSection(product: product!),

                  // Seller Details Section (inline)
                  if (product != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Product Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Stock: ${product!.stock} items'),
                          const SizedBox(height: 4),
                          Text('Product ID: ${product!.id}'),
                        ],
                      ),
                    ),

                  // Bottom Padding
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),

              // Fixed header overlay that stays on top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: AppSpacing.paddingMedium,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Close button
                      GestureDetector(
                        onTap: controller.closeSheet,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Wishlist button
                      GestureDetector(
                        onTap: controller.addToWishlist,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
