import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_sheet_controller.dart';
import 'widgets/expandable_details_section.dart';
import 'widgets/product_image_carousel.dart';
import 'widgets/product_info_section.dart';
import 'widgets/product_sheet_header.dart';
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
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              // Product Sheet Header (App Bar + Close Button)
              ProductSheetHeader(controller: controller),

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
