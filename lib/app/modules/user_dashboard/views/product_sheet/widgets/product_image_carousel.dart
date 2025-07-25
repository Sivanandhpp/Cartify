import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                      image: controller.productImages[index].startsWith('http')
                          ? NetworkImage(controller.productImages[index])
                          : AssetImage(controller.productImages[index])
                                as ImageProvider,
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

          // Page indicators
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
        ],
      ),
    );
  }
}
