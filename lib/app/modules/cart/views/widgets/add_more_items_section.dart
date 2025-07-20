import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';

class AddMoreItemsSection extends StatelessWidget {
  const AddMoreItemsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

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
              const Text(
                'Missed Something?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: controller.addMoreItems,
                child: Text(
                  'Add more items',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Last minute add-ons section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Your last minute add-ons',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Suggestion items
                Row(
                  children: [
                    _buildSuggestionItem(
                      'Did you forget?',
                      'Enjoy some Maggi Moments',
                      'Cola',
                      Colors.orange,
                    ),
                    const SizedBox(width: 12),
                    _buildSuggestionItem('', '', '', Colors.orange),
                    const SizedBox(width: 12),
                    _buildSuggestionItem('', '', '', Colors.green),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(
    String title,
    String subtitle,
    String category,
    Color badgeColor,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Navigate to product or add to cart
        },
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Stack(
            children: [
              // Product image placeholder
              Center(
                child: Icon(
                  Icons.fastfood_outlined,
                  size: 30,
                  color: Colors.grey[400],
                ),
              ),

              // Add button
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                ),
              ),

              // Discount badge (if applicable)
              if (badgeColor == Colors.orange)
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '20%',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}



