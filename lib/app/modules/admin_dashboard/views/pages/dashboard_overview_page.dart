import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin_dashboard_controller.dart';
import '../../widgets/stats_cards_widget.dart';
import '../../widgets/quick_actions_widget.dart';
import '../../widgets/recent_products_widget.dart';
import '../../models/product_model.dart';

class DashboardOverviewPage extends GetView<AdminDashboardController> {
  const DashboardOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            // Responsive padding and spacing
            double padding = constraints.maxWidth > 600 ? 24 : 16;
            double sectionSpacing = constraints.maxWidth > 600 ? 32 : 24;

            return SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome message
                  _buildWelcomeSection(),
                  SizedBox(height: sectionSpacing),

                  // Stats Cards
                  _buildStatsCards(constraints),
                  SizedBox(height: sectionSpacing),

                  // Quick Actions
                  _buildQuickActions(constraints),
                  SizedBox(height: sectionSpacing),

                  // Recent Products
                  _buildRecentProducts(),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Good Morning! 👋',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Here\'s what\'s happening with your store today.',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildStatsCards(BoxConstraints constraints) {
    final statsCards = [
      StatsCardData(
        title: 'Total Products',
        value: controller.dashboardStats.value.totalProducts.toString(),
        icon: Icons.inventory_2_rounded,
        color: Colors.blue,
        subtitle: '+12 this month',
        onTap: () => controller.selectMenuItem(1),
      ),
      StatsCardData(
        title: 'Total Orders',
        value: controller.dashboardStats.value.totalOrders.toString(),
        icon: Icons.shopping_bag_rounded,
        color: Colors.green,
        subtitle: '+${controller.dashboardStats.value.pendingOrders} pending',
        onTap: () => controller.selectMenuItem(2),
      ),
      StatsCardData(
        title: 'Customers',
        value: controller.dashboardStats.value.totalUsers.toString(),
        icon: Icons.people_rounded,
        color: Colors.purple,
        subtitle: '+156 this week',
        onTap: () => controller.selectMenuItem(3),
      ),
      StatsCardData(
        title: 'Revenue',
        value:
            '\$${(controller.dashboardStats.value.totalRevenue / 1000).toStringAsFixed(0)}K',
        icon: Icons.attach_money_rounded,
        color: Colors.orange,
        subtitle:
            '+${controller.dashboardStats.value.growthPercentage.toStringAsFixed(1)}% growth',
      ),
    ];

    return StatsCardsWidget(
      cards: statsCards,
      isLoading: controller.isLoading.value,
    );
  }

  Widget _buildQuickActions(BoxConstraints constraints) {
    final quickActions = [
      QuickActionData(
        title: 'Add Product',
        icon: Icons.add_box_rounded,
        color: Colors.blue,
        onTap: () => controller.selectMenuItem(1),
      ),
      QuickActionData(
        title: 'View Orders',
        icon: Icons.list_alt_rounded,
        color: Colors.green,
        onTap: () => controller.selectMenuItem(2),
      ),
      QuickActionData(
        title: 'Analytics',
        icon: Icons.analytics_rounded,
        color: Colors.purple,
        onTap: () => controller.selectMenuItem(4),
      ),
    ];

    return QuickActionsWidget(
      title: 'Quick Actions',
      actions: quickActions,
      isLoading: controller.isLoading.value,
    );
  }

  Widget _buildRecentProducts() {
    return RecentProductsWidget<Product>(
      title: 'Recent Products',
      products: controller.products,
      isLoading: controller.isLoading.value,
      hasError: false, // You can add error handling in controller
      errorMessage: '',
      getName: (product) => product.name,
      getBrand: (product) => product.brand,
      getCategory: (product) => product.category,
      getPrice: (product) => product.price,
      getStockQuantity: (product) => product.stockQuantity,
      getImageUrl: (product) =>
          product.images.isNotEmpty ? product.images.first : null,
      onSeeAllPressed: () => controller.selectMenuItem(1),
      onRetryPressed: () {
        // Add retry logic in controller if needed
      },
      onProductTap: (product) {
        // Handle product tap
      },
      maxItems: 3,
    );
  }
}
