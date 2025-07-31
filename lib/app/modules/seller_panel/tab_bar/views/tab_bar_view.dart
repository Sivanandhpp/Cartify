import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tab_bar_controller.dart';
import '../widgets/ios_tab_bar.dart';

class TabBarView extends GetView<TabBarController> {
  const TabBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // Main content with scroll controller
          Obx(
            () => SingleChildScrollView(
              controller: controller.scrollController,
              padding: const EdgeInsets.only(bottom: 120),
              child: _buildContent(),
            ),
          ),

          // iOS Tab Bar overlay
          Obx(
            () => IOSTabBar(
              items: controller.tabItems,
              currentEvent: controller.currentEvent.value,
              scrollController: controller.scrollController,
              bottomPadding: MediaQuery.of(context).padding.bottom,
              backgroundColor: Colors.white.withValues(
                alpha: 0.1,
              ), // Frozen glass base
              selectedColor: Colors.white,
              unselectedColor: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Obx(() {
      switch (controller.selectedIndex.value) {
        case 0:
          return _buildHomeContent();
        case 1:
          return _buildOrdersContent();
        case 2:
          return _buildProductsContent();
        case 3:
          return _buildAddProductContent();
        default:
          return _buildHomeContent();
      }
    });
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        const SizedBox(height: 60),
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.home, color: Colors.blue, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Home Dashboard',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Welcome to your seller dashboard! This is where you can manage your store, view orders, and track your business performance.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
        // Add more content to test scrolling
        ...List.generate(
          20,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              'Dashboard Item ${index + 1}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrdersContent() {
    return Column(
      children: [
        const SizedBox(height: 60),
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.shopping_bag, color: Colors.green, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Orders Management',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Manage all your orders here. View pending orders, track shipments, and update order status.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => controller.showNewOrderEvent('1234', '₹1,299'),
                child: const Text('Simulate New Order Event'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductsContent() {
    return Column(
      children: [
        const SizedBox(height: 60),
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.inventory_2, color: Colors.purple, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Products Catalog',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Manage your product inventory, update prices, and monitor stock levels.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>
                    controller.showProductLowStockEvent('iPhone 15'),
                child: const Text('Simulate Low Stock Event'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddProductContent() {
    return Column(
      children: [
        const SizedBox(height: 60),
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.add_box, color: Colors.orange, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Add New Product',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Add new products to your store. Upload images, set prices, and create detailed descriptions.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => controller.showPaymentReceivedEvent('₹2,999'),
                child: const Text('Simulate Payment Event'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
