import 'package:cartify/app/core/models/order/order_item_model.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';
import '../controllers/buyer_orders_controller.dart';

class BuyerOrdersView extends GetView<BuyerOrdersController> {
  const BuyerOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.buyerOrdersTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orders.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.noOrdersYet,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.orderHistoryMessage,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: AppStrings.startShopping,
                    onPressed: () => Get.offAllNamed(Routes.BUYER_DASHBOARD),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshOrders,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              final order = controller.orders[index];
              return _buildOrderCard(order);
            },
          ),
        );
      }),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
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
              Text(
                '${AppStrings.orderPrefix}${order.id.substring(0, 8)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${order.items.length} ${AppStrings.items}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          // show the list of orders here
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: order.items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(
                      '${item.quantity} x ${item.productName}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getItemStatusColor(
                          item.status,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.status.toString().split('.').last,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getItemStatusColor(item.status),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),

          Text(
            '${AppStrings.billTotalPrefix}${order.totalAmount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            '${AppStrings.orderedOnPrefix}${AppFormatters.formatDate(order.createdAt)}',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          // const SizedBox(height: 12),
          // Row(
          //   children: [
          //     Expanded(
          //       child: AppButton(
          //         text: 'View Details',
          //         onPressed: () => controller.viewOrderDetails(order.id),
          //       ),
          //     ),
          //     if (order.status == OrderStatus.PENDING) ...[
          //       const SizedBox(width: 12),
          //       Expanded(
          //         child: AppButton(
          //           text: 'Cancel',
          //           onPressed: () => controller.cancelOrder(order.id),
          //         ),
          //       ),
          //     ],
          //   ],
          // ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.PENDING:
        return Colors.orange;
      case OrderStatus.CONFIRMED:
        return Colors.blue;
      case OrderStatus.SHIPPED:
        return Colors.purple;
      case OrderStatus.DELIVERED:
        return Colors.green;
      case OrderStatus.CANCELLED:
        return Colors.red;
    }
  }

  Color _getItemStatusColor(OrderItemStatus status) {
    switch (status) {
      case OrderItemStatus.PENDING:
        return Colors.orange;
      case OrderItemStatus.ACCEPTED:
        return Colors.blue;
      case OrderItemStatus.SHIPPED:
        return Colors.purple;
      case OrderItemStatus.DELIVERED:
        return Colors.green;
      case OrderItemStatus.CANCELLED:
        return Colors.red;
      case OrderItemStatus.RETURNED:
        return Colors.brown;
    }
  }
}
