import 'package:cartify/app/core/models/order/order_item_model.dart';
import 'package:flutter/material.dart';
import 'package:cartify/app/core/index.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onAccept;
  final VoidCallback? onMarkShipped;
  final VoidCallback? onMarkDelivered;
  final VoidCallback? onViewDetails;
  final bool canAccept;
  final bool canMarkShipped;
  final bool canMarkDelivered;

  const OrderCard({
    Key? key,
    required this.order,
    this.onAccept,
    this.onMarkShipped,
    this.onMarkDelivered,
    this.onViewDetails,
    this.canAccept = false,
    this.canMarkShipped = false,
    this.canMarkDelivered = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Header Section
          _buildHeader(),

          // Items Section
          _buildItemsSection(),

          // Customer Info Section
          _buildCustomerSection(),

          // Action Buttons Section
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final primaryStatus = _getPrimaryStatus();
    final statusColor = _getStatusColor(primaryStatus);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Order ID and Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.id.substring(0, 8)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppFormatters.formatDate(order.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(primaryStatus),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Order Summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem(
                icon: Icons.shopping_cart,
                label: '${order.items.length} Items',
                color: Colors.blue,
              ),
              _buildSummaryItem(
                icon: Icons.currency_rupee,
                label: '₹${order.sellerAmount.toStringAsFixed(2)}',
                color: Colors.green,
              ),
              _buildSummaryItem(
                icon: Icons.access_time,
                label: _getTimeAgo(order.createdAt),
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                'Order Items',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Items List
          ...order.items.map((item) => _buildItemRow(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildItemRow(OrderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Item Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item.quantity} × ₹${item.priceAtPurchase.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Item Status (using OrderItemStatus if available, otherwise use order status)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getItemStatusColor(item).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getItemStatusText(item),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: _getItemStatusColor(item),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Item Total
          Text(
            '₹${(item.quantity * item.priceAtPurchase).toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                'Customer Details',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Customer Name and Phone
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.shippingAddress.recipientName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.shippingAddress.phone,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  // Call customer functionality
                },
                icon: Icon(Icons.phone, color: Colors.green[700]),
                tooltip: 'Call Customer',
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Delivery Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  order.shippingAddress.formattedAddress,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Primary Action Button
          if (canAccept)
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Accept Order',
                onPressed: onAccept,
                icon: Icons.check_circle_outline,
              ),
            )
          else if (canMarkShipped)
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Mark as Shipped',
                onPressed: onMarkShipped,
                icon: Icons.local_shipping_outlined,
              ),
            )
          else if (canMarkDelivered)
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Mark as Delivered',
                onPressed: onMarkDelivered,
                icon: Icons.done_all,
              ),
            ),

          // Secondary Actions
          if (canAccept || canMarkShipped || canMarkDelivered)
            const SizedBox(height: 12),

          // Row(
          //   children: [
          //     Expanded(
          //       child: AppButton.outlined(
          //         text: 'View Details',
          //         onPressed: onViewDetails,
          //         icon: Icons.visibility_outlined,
          //       ),
          //     ),
          //     const SizedBox(width: 12),
          //     Expanded(
          //       child: AppButton.outlined(
          //         text: 'Contact',
          //         onPressed: () {
          //           // Contact customer functionality
          //         },
          //         icon: Icons.message_outlined,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  // Helper Methods
  OrderStatus _getPrimaryStatus() {
    // Use the order's overall status
    return order.status;
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

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.PENDING:
        return 'PENDING';
      case OrderStatus.CONFIRMED:
        return 'CONFIRMED';
      case OrderStatus.SHIPPED:
        return 'SHIPPED';
      case OrderStatus.DELIVERED:
        return 'DELIVERED';
      case OrderStatus.CANCELLED:
        return 'CANCELLED';
    }
  }

  // For individual items, check if OrderItem has its own status
  Color _getItemStatusColor(OrderItem item) {
    // If OrderItem has its own status property, use it
    // Otherwise, fall back to the order's overall status
    if (item.status != null) {
      return _getOrderItemStatusColor(item.status!);
    } else {
      return _getStatusColor(order.status);
    }
  }

  String _getItemStatusText(OrderItem item) {
    // If OrderItem has its own status property, use it
    // Otherwise, fall back to the order's overall status
    if (item.status != null) {
      return _getOrderItemStatusText(item.status!);
    } else {
      return _getStatusText(order.status);
    }
  }

  // Handle OrderItemStatus if it exists
  Color _getOrderItemStatusColor(dynamic status) {
    if (status == null) return Colors.grey;

    final statusString = status.toString().split('.').last;
    switch (statusString) {
      case 'PENDING':
        return Colors.orange;
      case 'CONFIRMED':
        return Colors.blue;
      case 'SHIPPED':
        return Colors.purple;
      case 'DELIVERED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getOrderItemStatusText(dynamic status) {
    if (status == null) return 'UNKNOWN';

    return status.toString().split('.').last;
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
