import 'package:flutter/material.dart';
import '../../../../../core/index.dart';

/// Production-level reusable payment section widget
///
/// Displays payment method selection and checkout button with loading states
class PaymentSectionWidget extends StatelessWidget {
  final String paymentMethodTitle;
  final String paymentMethodSubtitle;
  final IconData paymentIcon;
  final Color? paymentIconColor;
  final Color? paymentIconBackground;
  final double totalAmount;
  final String buttonText;
  final bool isProcessing;
  final VoidCallback? onPaymentMethodPressed;
  final VoidCallback? onPayPressed;

  const PaymentSectionWidget({
    super.key,
    required this.paymentMethodTitle,
    required this.paymentMethodSubtitle,
    required this.paymentIcon,
    this.paymentIconColor,
    this.paymentIconBackground,
    required this.totalAmount,
    required this.buttonText,
    required this.isProcessing,
    this.onPaymentMethodPressed,
    this.onPayPressed,
  });

  @override
  Widget build(BuildContext context) {
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
          GestureDetector(
            onTap: onPaymentMethodPressed,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: paymentIconBackground ?? Colors.blue[50],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    paymentIcon,
                    color: paymentIconColor ?? Colors.blue[700],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        paymentMethodTitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        paymentMethodSubtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.keyboard_arrow_right, color: Colors.grey[400]),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: '$buttonText ₹${totalAmount.toStringAsFixed(2)}',
            onPressed: onPayPressed ?? () {},
            isLoading: isProcessing,
            enabled: !isProcessing,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
