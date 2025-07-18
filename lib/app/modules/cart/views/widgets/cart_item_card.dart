import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';
import '../../controllers/cart_controller.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: item.productImage.isNotEmpty
                  ? Image.asset(item.productImage, fit: BoxFit.cover)
                  : Icon(
                      Icons.image_outlined,
                      color: Colors.grey[400],
                      size: 30,
                    ),
            ),
          ),

          const SizedBox(width: 12),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),

                // Product size/variant
                if (item.metadata['variant']?.toString().isNotEmpty == true)
                  Text(
                    item.metadata['variant'].toString(),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),

                const SizedBox(height: 8),

                // Quantity controls
                Row(
                  children: [
                    // Decrease button
                    GestureDetector(
                      onTap: () => controller.decrementQuantity(item.id),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.lightPrimary),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.remove,
                          size: 16,
                          color: AppColors.lightPrimary,
                        ),
                      ),
                    ),

                    // Quantity
                    Container(
                      width: 40,
                      height: 28,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.lightPrimary),
                      ),
                      child: Center(
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.lightPrimary,
                          ),
                        ),
                      ),
                    ),

                    // Increase button
                    GestureDetector(
                      onTap: () => controller.incrementQuantity(item.id),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.lightPrimary),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 16,
                          color: AppColors.lightPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${(item.effectivePrice * item.quantity).toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              // Show original price if there's a discount
              if (item.hasDiscount)
                Text(
                  '₹${(item.price * item.quantity).toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
