import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/seller_dashboard_controller.dart';
import '../../tab_bar/widgets/ios_tab_bar.dart';

class SellerDashboardView extends GetView<SellerDashboardController> {
  const SellerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          // Main content with scroll controller
          SingleChildScrollView(
            controller: controller.scrollController,
            padding: const EdgeInsets.only(bottom: 120),
            child: _buildContent(),
          ),

          // iOS Tab Bar overlay
          Obx(
            () => IOSTabBar(
              items: controller.tabItems,
              currentEvent: controller.currentEvent.value,
              scrollController: controller.scrollController,
              bottomPadding: MediaQuery.of(context).padding.bottom,
              backgroundColor: Colors.transparent,
              selectedColor: Colors.blue,
              unselectedColor: Colors.grey,
            ),
          ),
          // Obx(
          //   () => IOSTabBar(
          //     items: controller.tabItems,
          //     currentEvent: controller.currentEvent.value,
          //     scrollController: controller.scrollController,
          //     bottomPadding: MediaQuery.of(context).padding.bottom,
          //     backgroundColor: Colors.transparent,
          //     selectedColor: Colors.blue,
          //     unselectedColor: Colors.grey,
          //   ),
          // ),
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
          return _buildSearchContent();
        case 4:
          return _buildSearchContent();
        default:
          return _buildHomeContent();
      }
    });
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        // Header with logout
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(Get.context!).padding.top + 20,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade600, Colors.blue.shade800],
            ),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Seller Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Manage your store efficiently',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () => controller.logout(),
                tooltip: 'Logout',
              ),
            ],
          ),
        ),

        // Dashboard content
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
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
                  Icon(Icons.dashboard, color: Colors.blue, size: 32),
                  SizedBox(width: 12),
                  Text(
                    'Dashboard Overview',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Welcome to your seller dashboard! Navigate using the tab bar below to manage orders, products, and add new items to your store.',
                style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
              ),
            ],
          ),
        ),

        // Quick stats cards
        _buildQuickStats(),

        // Event simulation buttons
        _buildEventControls(),

        // Add more content to test scrolling
        ...List.generate(
          15,
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
            child: Row(
              children: [
                Icon(Icons.store, color: Colors.blue.shade300),
                const SizedBox(width: 12),
                Text(
                  'Store Activity ${index + 1}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Orders',
              '156',
              Icons.shopping_bag,
              Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Products',
              '89',
              Icons.inventory_2,
              Colors.purple,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Revenue',
              '₹45,230',
              Icons.trending_up,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
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
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEventControls() {
    return Container(
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
          const Text(
            'Event Simulation',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Test the tab bar event notifications:',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () => controller.showNewOrderEvent('5678', '₹2,499'),
                icon: const Icon(Icons.shopping_bag, size: 16),
                label: const Text('New Order'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () =>
                    controller.showProductLowStockEvent('MacBook Pro'),
                icon: const Icon(Icons.warning, size: 16),
                label: const Text('Low Stock'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => controller.showPaymentReceivedEvent('₹5,999'),
                icon: const Icon(Icons.payment, size: 16),
                label: const Text('Payment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => controller.clearEvent(),
                icon: const Icon(Icons.clear, size: 16),
                label: const Text('Clear'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
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
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.shopping_bag, color: Colors.green, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Orders Management',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Manage all your orders here. View pending orders, track shipments, and update order status.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
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
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.inventory_2, color: Colors.purple, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Products Catalog',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Manage your product inventory, update prices, and monitor stock levels.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchContent() {
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
                  Icon(Icons.search, color: Colors.purple, size: 28),
                  SizedBox(width: 12),
                  Text(
                    'Search & Discovery',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Search for products, orders, customers, and analytics. Discover insights about your store performance.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
        // Search interface placeholder
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
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
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey[400]),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search products, orders, customers...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
              ),
              Icon(Icons.filter_list, color: Colors.grey[400]),
            ],
          ),
        ),
      ],
    );
  }
}
