import 'package:cartify/app/modules/buyer_panel/buyer_dashboard/views/widgets/quantity_selector_widget.dart';
import 'package:flutter/material.dart';
import '../../../../../core/index.dart'; // For AppColors and CartItem

class ExpandedCartView extends StatelessWidget {
  final List<CartItem> cartItems;
  final int totalQuantity;
  final double totalSavings;
  final void Function(String) onIncrement;
  final void Function(String) onDecrement;
  final VoidCallback onGoToCart;
  final VoidCallback onClose;

  const ExpandedCartView({
    super.key,
    required this.cartItems,
    required this.totalQuantity,
    required this.totalSavings,
    required this.onIncrement,
    required this.onDecrement,
    required this.onGoToCart,
    required this.onClose,
  });

  // This dynamic height calculation is preserved from the original logic
  // to ensure the bottom sheet size is identical.
  double _calculateSheetHeight(BuildContext context) {
    const double headerHeight = 120;
    const double footerHeight = 100;
    const double itemHeight = 80;
    const double maxHeightRatio = 0.7;

    final double calculatedHeight =
        headerHeight + (cartItems.length * itemHeight) + footerHeight;
    final double maxScreenHeight =
        MediaQuery.of(context).size.height * maxHeightRatio;

    return (calculatedHeight > maxScreenHeight)
        ? maxScreenHeight
        : calculatedHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _calculateSheetHeight(context),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return _ExpandedCartItem(
                  item: item,
                  onIncrement: () => onIncrement(item.productId),
                  onDecrement: () => onDecrement(item.productId),
                );
              },
            ),
          ),
          _buildFooter(), // Replicated the original footer
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Review Items',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close, color: Colors.grey),
              ),
            ],
          ),
          // Delivery info row from original UI restored here
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(
                  'Delivery in',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(width: 8),
                const Text(
                  '9 Mins',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Superfast',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '$totalQuantity items',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    // This footer is a 1:1 replication of the original's bottom summary
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        // The original didn't have a bottom radius here, so it's removed
      ),
      child: Row(
        children: [
          _buildCartIconWithBadge(totalQuantity),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '$totalQuantity Items',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
              if (totalSavings > 0)
                Text(
                  'You save ₹${totalSavings.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: onGoToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Go to cart',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartIconWithBadge(int count) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(
                Icons.shopping_bag_outlined,
                color: Colors.orange,
                size: 20,
              ),
            ),
          ),
          if (count > 0)
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  count > 9 ? '9+' : count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ExpandedCartItem extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _ExpandedCartItem({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: item.product.imageUrls.isNotEmpty
                  ? Image.network(item.product.imageUrls.first, fit: BoxFit.cover)
                  : Icon(Icons.image_outlined, color: Colors.grey[400]),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // if (item.discountPrice != null) ...[
                    //   Text(
                    //     '₹${item.discountPrice!.toStringAsFixed(0)}',
                    //     style: const TextStyle(
                    //       fontSize: 13,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    //   const SizedBox(width: 4),
                    //   Text(
                    //     '₹${item.price.toStringAsFixed(0)}',
                    //     style: TextStyle(
                    //       fontSize: 11,
                    //       decoration: TextDecoration.lineThrough,
                    //       color: Colors.grey[600],
                    //     ),
                    //   ),
                    // ] else
                    //   Text(
                    //     '₹${item.price.toStringAsFixed(0)}',
                    //     style: const TextStyle(
                    //       fontSize: 13,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.black,
                    //     ),
                    //   ),
                  ],
                ),
              ],
            ),
          ),
          // Quantity controls using reusable widget
          QuantitySelectorWidget(
            quantity: item.quantity,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
            isCompact: true,
          ),
          const SizedBox(width: 12),
          Text(
            '₹${item.totalPrice.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
