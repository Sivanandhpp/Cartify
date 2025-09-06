import 'package:flutter/material.dart';
import '../../../../../core/index.dart';
import 'cart_item_card_widget.dart';

/// Production-level reusable review order section widget
///
/// Displays order review with delivery info, item count, and cart items list
class ReviewOrderSectionWidget extends StatelessWidget {
  final String title;
  final List<CartItem> cartItems;
  final int itemCount;
  final void Function(String productId)? onIncrementQuantity;
  final void Function(String productId)? onDecrementQuantity;
  final VoidCallback? onClearCart;

  const ReviewOrderSectionWidget({
    super.key,
    required this.title,
    required this.cartItems,
    required this.itemCount,
    this.onIncrementQuantity,
    this.onDecrementQuantity,
    this.onClearCart,
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
              const Spacer(),
              Text(
                '$itemCount items',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),

          // Cart items with safe access
          if (cartItems.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cartItems.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                // Safety check to prevent index out of bounds
                if (index >= cartItems.length) {
                  return const SizedBox.shrink();
                }

                final item = cartItems[index];
                return CartItemCardWidget(
                  item: item,
                  onIncrementQuantity: onIncrementQuantity != null
                      ? () => onIncrementQuantity!(item.productId)
                      : null,
                  onDecrementQuantity: onDecrementQuantity != null
                      ? () => onDecrementQuantity!(item.productId)
                      : null,
                  currentQuantity: item.quantity,
                );
              },
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No items in cart',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ),
          const SizedBox(height: 8),
          if (cartItems.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onClearCart,
                  child: const Text(
                    'Clear Cart',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
