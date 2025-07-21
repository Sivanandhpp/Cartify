import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

import '../../../controllers/product_sheet_controller.dart';

class ProductImageCarousel extends StatelessWidget {
  final ProductSheetController controller;

  const ProductImageCarousel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          // Main product image container
          Container(
            height: 300,
            width: double.infinity,
            child: PageView.builder(
              controller: controller.imagePageController,
              onPageChanged: controller.onImagePageChanged,
              itemCount: controller.productImages.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: AssetImage(controller.productImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Frosted glass close button at top left - only show when header is not visible
          Obx(
            () => !controller.isAppBarVisible.value
                ? Positioned(
                    top: 16,
                    left: 16,
                    child: GestureDetector(
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
                  )
                : const SizedBox.shrink(),
          ),

          // Page indicators at bottom right of image
          Positioned(
            bottom: 16,
            right: 16,
            child: Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '${controller.currentImageIndex.value + 1}/${controller.productImages.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          // Vegetarian indicator
          Positioned(
            bottom: 16,
            left: 16,
            child: Obx(
              () => controller.isVegetarian.value
                  ? Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.eco,
                        color: Colors.white,
                        size: 16,
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
