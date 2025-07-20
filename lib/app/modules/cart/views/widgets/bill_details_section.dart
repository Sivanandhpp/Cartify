import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';

class BillDetailsSection extends StatelessWidget {
  const BillDetailsSection({super.key});

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
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Bill Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 16),

            // Item total
            _buildBillRow(
              'Item Total',
              '₹${controller.subtotal.toStringAsFixed(2)}',
              '₹${(controller.subtotal + controller.totalSavings).toStringAsFixed(2)}',
            ),

            // Handling fee
            _buildBillRow(
              'Handling Fee',
              '₹${CartController.handlingFee.toStringAsFixed(2)}',
            ),

            // Delivery tip
            if (controller.deliveryTip.value > 0)
              _buildBillRow(
                'Delivery Tip',
                null,
                null,
                GestureDetector(
                  onTap: () => _showTipDialog(controller),
                  child: Text(
                    'Add a tip',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            else
              _buildBillRow(
                'Delivery Tip',
                '₹${controller.deliveryTip.value.toStringAsFixed(0)}',
              ),

            // Delivery partner fee
            _buildBillRow(
              'Delivery Partner Fee',
              CartController.deliveryPartnerFee > 0
                  ? '₹${CartController.deliveryPartnerFee.toStringAsFixed(0)}'
                  : 'FREE',
              CartController.deliveryPartnerFee > 0 ? null : '₹30.00',
              null, // trailing
              false, // isTotal
              CartController.deliveryPartnerFee == 0, // isDeliveryFree
            ),

            // GST and charges
            _buildBillRow(
              'GST and Charges',
              '₹${controller.gstAmount.toStringAsFixed(2)}',
            ),

            const Divider(height: 24, thickness: 1),

            // Total
            _buildBillRow(
              'To Pay',
              '₹${controller.finalTotal.toStringAsFixed(0)}',
              '₹${(controller.finalTotal + controller.totalSavings).toStringAsFixed(0)}',
              null, // trailing
              true, // isTotal
              false, // isDeliveryFree
            ),

            const SizedBox(height: 16),

            // Cancellation policy note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[100]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NOTE: Orders cannot be cancelled and are non-refundable once packed for delivery.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      // Show cancellation policy
                    },
                    child: Text(
                      'Read cancellation policy',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
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

  Widget _buildBillRow(
    String title,
    String? price, [
    String? originalPrice,
    Widget? trailing,
    bool isTotal = false,
    bool isDeliveryFree = false,
  ]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              color: Colors.black87,
            ),
          ),

          if (trailing != null)
            trailing
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (originalPrice != null) ...[
                  Text(
                    originalPrice,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  price ?? '',
                  style: TextStyle(
                    fontSize: isTotal ? 16 : 14,
                    fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
                    color: isDeliveryFree
                        ? const Color(0xFF4CAF50)
                        : Colors.black,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showTipDialog(CartController controller) {
    // Navigate to tip section or show tip dialog
    // This could scroll to tip section or show a modal
  }
}



