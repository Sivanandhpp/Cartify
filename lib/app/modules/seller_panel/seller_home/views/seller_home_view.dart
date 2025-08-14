import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../controllers/seller_home_controller.dart';

class SellerHomeView extends GetView<SellerHomeController> {
  const SellerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: false,
            pinned: true,
            backgroundColor: CupertinoColors.systemBlue,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text(
                'Seller Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: false,
              titlePadding: EdgeInsets.only(left: 16, bottom: 16),
            ),
            actions: [
              IconButton(
                icon: const Icon(CupertinoIcons.settings, color: Colors.white),
                onPressed: () {
                  controller.logout();
                },
              ),
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(CupertinoIcons.bell, color: Colors.white),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Cards
                  _buildStatsSection(),
                  const SizedBox(height: 20),

                  // Quick Actions
                  _buildQuickActionsSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Obx(
                () => _buildStatCard(
                  'Total Products',
                  controller.totalProducts.value.toString(),
                  CupertinoIcons.cube_box,
                  CupertinoColors.systemPurple,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(
                () => _buildStatCard(
                  'Total Orders',
                  controller.totalOrders.value.toString(),
                  CupertinoIcons.shopping_cart,
                  CupertinoColors.systemGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Obx(
                () => _buildStatCard(
                  'Revenue',
                  '₹${controller.totalRevenue.value.toStringAsFixed(2)}',
                  CupertinoIcons.money_dollar_circle,
                  CupertinoColors.systemOrange,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(
                () => _buildStatCard(
                  'Pending Orders',
                  controller.pendingOrders.value.toString(),
                  CupertinoIcons.clock,
                  CupertinoColors.systemRed,
                ),
              ),
            ),
          ],
        ),
      ],
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+12%',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Add Product',
                CupertinoIcons.add_circled,
                CupertinoColors.systemBlue,
                controller.navigateToAddProduct,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildActionCard(
                'View Products',
                CupertinoIcons.cube_box,
                CupertinoColors.systemPurple,
                controller.navigateToViewProducts,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildActionCard(
                'View Orders',
                CupertinoIcons.shopping_cart,
                CupertinoColors.systemGreen,
                controller.navigateToViewOrders,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
