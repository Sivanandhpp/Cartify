import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

import '../../../../core/constants/app_images.dart';
import '../../controllers/product_sheet_controller.dart';

/// A helper function to easily show the bottom sheet from anywhere in your app.
void showProductSheet(BuildContext context) {
  Get.bottomSheet(
    const ProductSheetWidget(),
    isScrollControlled: true, // This is crucial for DraggableScrollableSheet
    backgroundColor: Colors.transparent,
  );
}

class ProductSheetWidget extends StatelessWidget {
  const ProductSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductSheetController controller = Get.put(ProductSheetController());

    return DraggableScrollableSheet(
      controller: controller.sheetController,
      initialChildSize: ProductSheetController.initialSheetSize,
      minChildSize: ProductSheetController.minSheetSize,
      maxChildSize: ProductSheetController.maxSheetSize,
      builder: (BuildContext context, ScrollController scrollController) {
        return Obx(
          () => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                // Main content
                CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    // Full-screen image carousel at top
                    _buildFullScreenImageCarousel(),
                    // App bar - only show when expanded, positioned below safe area
                    if (controller.isDetailsExpanded.value) _buildSafeAppBar(),
                    // Drag handle - only show when not expanded
                    if (!controller.isDetailsExpanded.value) _buildDragHandle(),
                    _buildProductInfo(),
                    _buildExpandableSection(controller),
                    _buildSellerDetails(),
                  ],
                ),
                // Frosted glass close button - always visible
                _buildFrostedCloseButton(controller),
              ],
            ),
          ),
        );
      },
    );
  }

  // Drag handle at the top of the sheet
  Widget _buildDragHandle() {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 12, bottom: 8),
          height: 4,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  // Full-screen image carousel that covers the entire top portion
  Widget _buildFullScreenImageCarousel() {
    return SliverToBoxAdapter(
      child: Container(
        height: 400, // Increased height for full coverage
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Main image covering entire area
              Image.asset(AppImages.product1, fit: BoxFit.cover),
              // Gradient overlay for better text visibility
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
              // Page indicators
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              // Vegetarian indicator
              Positioned(
                bottom: 20,
                left: 20,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Frosted glass close button positioned at top-left
  Widget _buildFrostedCloseButton(ProductSheetController controller) {
    return Positioned(
      top: MediaQuery.of(Get.context!).padding.top + 10,
      left: 16,
      child: GestureDetector(
        onTap: () {
          if (controller.isDetailsExpanded.value) {
            controller.toggleDetails();
          } else {
            Get.back();
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
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
    );
  }

  // Safe app bar positioned below the safe area when expanded
  Widget _buildSafeAppBar() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(
          top:
              MediaQuery.of(Get.context!).padding.top +
              60, // Below safe area + button
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 48), // Space for close button alignment
            const Expanded(
              child: Text(
                'Onion (Savala)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.share_outlined, size: 24),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  // Product information section
  Widget _buildProductInfo() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '10 MINS',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Onion (Savala)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Rich flavor, high in antioxidants, perfect for everyday cooking',
              style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  '1 kg',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Text(
                      '₹35',
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '20% OFF',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock, color: Colors.green.shade700, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '₹32',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'SHOP FOR ₹599',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'ADD',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // "View product details" button
  Widget _buildExpandableSection(ProductSheetController controller) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextButton(
          onPressed: controller.toggleDetails,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View product details',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  controller.isDetailsExpanded.value
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.orange.shade700,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // The content that appears when the sheet is expanded
  Widget _buildSellerDetails() {
    final controller = Get.find<ProductSheetController>();
    return Obx(
      () => SliverVisibility(
        visible: controller.isDetailsExpanded.value,
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            const Divider(),
            const ListTile(
              leading: Icon(Icons.store_outlined),
              title: Text('Explore all Fruits and Vegetables Category...'),
              trailing: Icon(Icons.chevron_right),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Seller Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Add more seller details here
            const ListTile(title: Text('Sold by: Reliance Retail')),
            const ListTile(title: Text('FSSAI License: 100120220002 Reliance')),
            const SizedBox(height: 50), // Extra space at the bottom
          ]),
        ),
      ),
    );
  }
}
