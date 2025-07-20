import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_sheet_controller.dart';

/// A helper function to easily show the bottom sheet from anywhere in your app.
void showProductSheet(BuildContext context) {
  Get.bottomSheet(
    const ProductSheetView(),
    isScrollControlled: true, // This is crucial for DraggableScrollableSheet
    backgroundColor: Colors.transparent,
  );
}

class ProductSheetView extends StatelessWidget {
  const ProductSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductSheetController controller = Get.put(ProductSheetController());

    return DraggableScrollableSheet(
      controller: controller.sheetController,
      initialChildSize: ProductSheetController.minSheetSize,
      minChildSize: ProductSheetController.minSheetSize,
      maxChildSize: ProductSheetController.maxSheetSize,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              _buildHeader(),
              _buildImageCarousel(),
              _buildProductInfo(),
              _buildExpandableSection(controller),
              _buildSellerDetails(),
            ],
          ),
        );
      },
    );
  }

  // Header with title and share button
  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.keyboard_arrow_down),
                SizedBox(width: 8),
                Text(
                  'Onion (Savala)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  // Image carousel section
  Widget _buildImageCarousel() {
    return SliverToBoxAdapter(
      child: Container(
        height: 250,
        color: Colors.grey[200],
        child: Center(
          child: Image.network(
            'https://placehold.co/600x400/EFEFEF/000000?text=Onion+Image',
            fit: BoxFit.cover,
          ),
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
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 8),
            const Text(
              'Onion (Savala)',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Rich flavor, high in antioxidants, perfect for everyday cooking',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  '1 kg',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Text(
                  '₹35',
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
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
                  child: const Text(
                    '20% OFF',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.shopping_bag_outlined, color: Colors.green),
                const SizedBox(width: 4),
                const Text(
                  '₹32',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                const Text(
                  'SHOP FOR ₹599',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'ADD',
                    style: TextStyle(color: Colors.white),
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
      child: TextButton(
        onPressed: controller.toggleDetails,
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'View product details',
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                controller.isDetailsExpanded.value
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.orange.shade700,
              ),
            ],
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




