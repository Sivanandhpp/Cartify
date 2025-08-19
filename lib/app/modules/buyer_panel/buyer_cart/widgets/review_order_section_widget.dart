import 'package:flutter/material.dart';
import '../../../../core/index.dart';
import 'cart_item_card_widget.dart';

/// Production-level reusable review order section widget
///
/// Displays order review with delivery info, item count, and cart items list
class ReviewOrderSectionWidget extends StatelessWidget {
  final String title;
  final String deliveryTime;
  final String deliveryType;
  final List<CartItem> cartItems;
  final int itemCount;
  final Function(String productId)? onIncrementQuantity;
  final Function(String productId)? onDecrementQuantity;
  

  const ReviewOrderSectionWidget({
    super.key,
    required this.title,
    required this.deliveryTime,
    required this.deliveryType,
    required this.cartItems,
    required this.itemCount,
    this.onIncrementQuantity,
    this.onDecrementQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Delivery info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  deliveryTime,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.speed, size: 16, color: Color(0xFF4CAF50)),
              const SizedBox(width: 4),
              Text(
                deliveryType,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '$itemCount items',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Cart items
          ...cartItems.map(
            (item) => CartItemCardWidget(
              item: item,
              onIncrementQuantity: () => onIncrementQuantity?.call(item.productId),
              onDecrementQuantity: () => onDecrementQuantity?.call(item.productId),
              currentQuantity: item.quantity,
            ),
          ),
        ],
      ),
    );
  }
}
