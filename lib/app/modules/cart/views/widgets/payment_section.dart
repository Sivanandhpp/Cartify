import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';
import '../../controllers/cart_controller.dart';

class PaymentSection extends StatelessWidget {
  const PaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Payment method
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.blue[700],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pay using',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      'Paytm UPI',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showPaymentMethods(context);
                },
                child: Text(
                  'Change',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.grey[600], size: 20),
            ],
          ),

          const SizedBox(height: 16),

          // Pay button
          Obx(
            () => GestureDetector(
              onTap: controller.isProcessingPayment.value
                  ? null
                  : controller.processPayment,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (controller.isProcessingPayment.value) ...[
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      controller.isProcessingPayment.value
                          ? 'Processing...'
                          : 'Pay Now | ₹${controller.finalTotal.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Safe area padding for bottom
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  void _showPaymentMethods(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 20),

            // Payment options
            _buildPaymentOption(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Paytm UPI',
              subtitle: 'Pay using Paytm wallet',
              isSelected: true,
            ),

            _buildPaymentOption(
              icon: Icons.g_mobiledata,
              title: 'Google Pay',
              subtitle: 'Pay using Google Pay',
              isSelected: false,
            ),

            _buildPaymentOption(
              icon: Icons.phone_android,
              title: 'PhonePe',
              subtitle: 'Pay using PhonePe',
              isSelected: false,
            ),

            _buildPaymentOption(
              icon: Icons.credit_card,
              title: 'Credit/Debit Card',
              subtitle: 'Pay using card',
              isSelected: false,
            ),

            _buildPaymentOption(
              icon: Icons.money,
              title: 'Cash on Delivery',
              subtitle: 'Pay when order arrives',
              isSelected: false,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        Get.back();
        NotificationService.showSuccess(
          title: 'Payment Method Updated',
          message: 'Payment method changed to $title',
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.lightPrimary : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? AppColors.lightPrimary.withValues(alpha: 0.1)
              : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.lightPrimary : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppColors.lightPrimary : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.lightPrimary, size: 20),
          ],
        ),
      ),
    );
  }
}
