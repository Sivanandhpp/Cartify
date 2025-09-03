import 'package:cartify/app/core/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartify/app/core/index.dart';
import '../controllers/seller_orders_controller.dart';
import 'widgets/order_card.dart';

class SellerOrdersView extends GetView<SellerOrdersController> {
  const SellerOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Statistics Section
          // _buildStatisticsSection(),

          // Search Bar
          _buildSearchBar(),

          // Filter Tabs
          _buildFilterTabs(),

          // Orders List
          Expanded(child: _buildOrdersList()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      title: const Text(
        'My Orders',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      actions: [
        IconButton(
          onPressed: controller.refreshOrders,
          icon: Obx(
            () => controller.isRefreshing.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
          ),
          tooltip: 'Refresh Orders',
        ),
        IconButton(
          onPressed: () {
            // Show filter/sort options
          },
          icon: const Icon(Icons.filter_list),
          tooltip: 'Filter & Sort',
        ),
      ],
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            children: [
              Icon(Icons.analytics_outlined, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                'Order Statistics',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Obx(
                  () => _buildStatCard(
                    'Total Orders',
                    controller.totalOrdersCount.value.toString(),
                    Icons.shopping_cart_outlined,
                    Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => _buildStatCard(
                    'Pending',
                    controller.pendingOrdersCount.value.toString(),
                    Icons.pending_outlined,
                    Colors.orange,
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
                    'Today\'s Orders',
                    controller.todaysOrdersCount.value.toString(),
                    Icons.today_outlined,
                    Colors.green,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => _buildStatCard(
                    'Revenue',
                    '₹${controller.totalRevenue.value.toStringAsFixed(0)}',
                    Icons.currency_rupee,
                    Colors.purple,
                  ),
                ),
              ),
            ],
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
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
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: AppTextField(
        controller: TextEditingController(),
        label: 'Search Orders',
        hint: 'Search by order ID, customer name, or product',
        icon: Icons.search,
        onChanged: controller.searchOrders,
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['All', 'Pending', 'Confirmed', 'Shipped', 'Delivered'];

    return Container(
      margin: const EdgeInsets.all(16),
      child: Obx(
        () => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((filter) {
              final isSelected = controller.selectedFilter.value == filter;
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (_) => controller.changeFilter(filter),
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  checkmarkColor: AppColors.primary,
                  backgroundColor: Colors.grey[100],
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : Colors.grey[700],
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final filteredOrders = controller.filteredOrders;

      if (filteredOrders.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: controller.refreshOrders,
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: filteredOrders.length,
          itemBuilder: (context, index) {
            final order = filteredOrders[index];
            return OrderCard(
              order: order,
              canAccept: controller.canAcceptOrder(order),
              canMarkShipped: controller.canMarkAsShipped(order),
              canMarkDelivered: controller.canMarkAsDelivered(order),
              onAccept: () => _showAcceptConfirmation(order),
              onMarkShipped: () => _showShippedConfirmation(order),
              onMarkDelivered: () => _showDeliveredConfirmation(order),
              onViewDetails: () => controller.viewOrderDetails(order.id),
            );
          },
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Orders Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              controller.selectedFilter.value == 'All'
                  ? 'You don\'t have any orders yet'
                  : 'No ${controller.selectedFilter.value.toLowerCase()} orders found',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ),
          const SizedBox(height: 24),
          AppButton.outlined(
            width: 300,
            text: 'Refresh',
            onPressed: controller.refreshOrders,
            icon: Icons.refresh,
          ),
        ],
      ),
    );
  }

  // Confirmation Dialogs
  void _showAcceptConfirmation(OrderModel order) {
    Get.dialog(
      AlertDialog(
        title: const Text('Accept Order'),
        content: Text(
          'Are you sure you want to accept order #${order.id.substring(0, 8)}?\n\nThis will confirm the order and notify the customer.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          AppButton(
            text: 'Accept',
            onPressed: () {
              Get.back();
              controller.acceptOrder(order.id);
            },
            width: 100,
            height: 40,
          ),
        ],
      ),
    );
  }

  void _showShippedConfirmation(OrderModel order) {
    Get.dialog(
      AlertDialog(
        title: const Text('Mark as Shipped'),
        content: Text(
          'Are you sure you want to mark order #${order.id.substring(0, 8)} as shipped?\n\nThis will update the order status and notify the customer.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          AppButton(
            text: 'Mark Shipped',
            onPressed: () {
              Get.back();
              controller.markAsShipped(order.id);
            },
            width: 120,
            height: 40,
          ),
        ],
      ),
    );
  }

  void _showDeliveredConfirmation(OrderModel order) {
    Get.dialog(
      AlertDialog(
        title: const Text('Mark as Delivered'),
        content: Text(
          'Are you sure you want to mark order #${order.id.substring(0, 8)} as delivered?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          AppButton(
            text: 'Mark Delivered',
            onPressed: () {
              Get.back();
              controller.markAsDelivered(order.id);
            },
            width: 140,
            height: 40,
          ),
        ],
      ),
    );
  }
}
