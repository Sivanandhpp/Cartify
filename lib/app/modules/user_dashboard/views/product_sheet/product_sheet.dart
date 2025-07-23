import 'dart:ui';

import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_sheet_controller.dart';
import 'widgets/expandable_details_section.dart';
import 'widgets/product_image_carousel.dart';
import 'widgets/product_info_section.dart';
import 'widgets/seller_details_section.dart';

class ProductSheetWidget extends StatelessWidget {
  const ProductSheetWidget({super.key});

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
                  ProductImageCarousel(controller: controller),

                  // Product Information Section
                  ProductInfoSection(controller: controller),

                  // Expandable Details Section
                  ExpandableDetailsSection(controller: controller),

                  // Seller Details Section
                  SellerDetailsSection(controller: controller),

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

// Helper function to show product sheet
void showProductSheet() {
  Get.bottomSheet(
    const ProductSheetWidget(),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enableDrag: true,
    ignoreSafeArea: false,
  );
}
