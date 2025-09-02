import 'package:cartify/app/core/models/order/order_item_model.dart';
import 'package:flutter/material.dart';
import 'package:cartify/app/core/index.dart';

class OrderCard extends StatefulWidget {
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
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Header Section (Always visible)
          _buildExpandableHeader(),

          // Expandable Content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              children: [
                // Items Section
                _buildItemsSection(),

                // Customer Info Section
                _buildCustomerSection(),

                // Action Buttons Section
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableHeader() {
    final primaryStatus = _getPrimaryStatus();
    final statusColor = _getStatusColor(primaryStatus);

    return InkWell(
      onTap: _toggleExpansion,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
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
                        'Order #${widget.order.id.substring(0, 8)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppFormatters.formatDate(widget.order.createdAt),
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

                // Expand/Collapse Icon
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Order Summary (Always visible)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem(
                  icon: Icons.shopping_cart,
                  label: '${widget.order.items.length} Items',
                  color: Colors.blue,
                ),
                _buildSummaryItem(
                  icon: Icons.currency_rupee,
                  label: '₹${widget.order.sellerAmount.toStringAsFixed(2)}',
                  color: Colors.green,
                ),
                _buildSummaryItem(
                  icon: Icons.access_time,
                  label: _getTimeAgo(widget.order.createdAt),
                  color: Colors.orange,
                ),
              ],
            ),

            // Quick Action Hint (only when collapsed)
            if (!_isExpanded &&
                (widget.canAccept ||
                    widget.canMarkShipped ||
                    widget.canMarkDelivered))
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_getActionIcon(), size: 14, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      _getActionHint(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '• Tap to expand',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
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
          ...widget.order.items.map((item) => _buildItemRow(item)).toList(),
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

          // Item Status
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
                      widget.order.shippingAddress.recipientName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.order.shippingAddress.phone,
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
                  widget.order.shippingAddress.formattedAddress,
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
          if (widget.canAccept)
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Accept Order',
                onPressed: widget.onAccept,
                icon: Icons.check_circle_outline,
              ),
            )
          else if (widget.canMarkShipped)
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Mark as Shipped',
                onPressed: widget.onMarkShipped,
                icon: Icons.local_shipping_outlined,
              ),
            )
          else if (widget.canMarkDelivered)
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Mark as Delivered',
                onPressed: widget.onMarkDelivered,
                icon: Icons.done_all,
              ),
            ),

          // Secondary Actions
          if (widget.canAccept ||
              widget.canMarkShipped ||
              widget.canMarkDelivered)
            const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: AppButton.outlined(
                  text: 'View Details',
                  onPressed: widget.onViewDetails,
                  icon: Icons.visibility_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton.outlined(
                  text: 'Contact',
                  onPressed: () {
                    // Contact customer functionality
                  },
                  icon: Icons.message_outlined,
                ),
              ),
            ],
          ),
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

  // Helper Methods for Action Hints
  IconData _getActionIcon() {
    if (widget.canAccept) return Icons.check_circle_outline;
    if (widget.canMarkShipped) return Icons.local_shipping_outlined;
    if (widget.canMarkDelivered) return Icons.done_all;
    return Icons.info_outline;
  }

  String _getActionHint() {
    if (widget.canAccept) return 'Ready to Accept';
    if (widget.canMarkShipped) return 'Ready to Ship';
    if (widget.canMarkDelivered) return 'Ready to Deliver';
    return 'View Details';
  }

  // Status Helper Methods
  OrderStatus _getPrimaryStatus() {
    return widget.order.status;
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

  Color _getItemStatusColor(OrderItem item) {
    if (item.status != null) {
      return _getOrderItemStatusColor(item.status!);
    } else {
      return _getStatusColor(widget.order.status);
    }
  }

  String _getItemStatusText(OrderItem item) {
    if (item.status != null) {
      return _getOrderItemStatusText(item.status!);
    } else {
      return _getStatusText(widget.order.status);
    }
  }

  Color _getOrderItemStatusColor(dynamic status) {
    if (status == null) return Colors.grey;

    final statusString = status.toString().split('.').last;
    switch (statusString) {
      case 'PENDING':
        return Colors.orange;
      case 'ACCEPTED':
        return Colors.blue;
      case 'SHIPPED':
        return Colors.purple;
      case 'DELIVERED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      case 'RETURNED':
        return Colors.brown;
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
