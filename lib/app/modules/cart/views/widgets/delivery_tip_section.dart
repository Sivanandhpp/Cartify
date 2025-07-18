import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';
import '../../controllers/cart_controller.dart';

class DeliveryTipSection extends StatelessWidget {
  const DeliveryTipSection({super.key});

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
          // Header with tip icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.thumb_up_outlined,
                  color: Colors.blue[700],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Add tip to thank your delivery partner for their hard work.',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tip options
          Obx(
            () => Row(
              children: [
                _buildTipOption(controller, 10, '₹10'),
                const SizedBox(width: 8),
                _buildTipOption(controller, 20, '₹20'),
                const SizedBox(width: 8),
                _buildTipOption(controller, 30, '₹30'),
                const SizedBox(width: 8),
                _buildTipOption(controller, 0, 'Other'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipOption(
    CartController controller,
    double amount,
    String label,
  ) {
    final isSelected = controller.deliveryTip.value == amount;
    final isMostTipped = amount == 20; // ₹20 is most tipped

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (label == 'Other') {
            _showCustomTipDialog(controller);
          } else {
            controller.setDeliveryTip(amount);
          }
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.lightPrimary : Colors.white,
            border: Border.all(
              color: isSelected ? AppColors.lightPrimary : Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
              if (isMostTipped && !isSelected)
                Positioned(
                  top: 2,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Most tipped',
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

  void _showCustomTipDialog(CartController controller) {
    final TextEditingController tipController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Enter Custom Tip'),
        content: TextField(
          controller: tipController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount (₹)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(tipController.text) ?? 0;
              controller.setDeliveryTip(amount);
              Get.back();
            },
            child: const Text('Add Tip'),
          ),
        ],
      ),
    );
  }
}
