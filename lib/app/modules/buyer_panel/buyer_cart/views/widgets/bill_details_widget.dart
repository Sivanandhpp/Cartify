import 'package:flutter/material.dart';
import '../../../../../core/constants/app_strings.dart';

/// Production-level reusable bill details widget
///
/// Displays itemized bill breakdown with totals and customizable line items
class BillDetailsWidget extends StatelessWidget {
  final String title;
  final double subtotal;
  final double handlingFee;
  final double deliveryPartnerFee;
  final double gstAmount;
  final double deliveryTip;
  final double finalTotal;

  const BillDetailsWidget({
    super.key,
    required this.title,
    required this.subtotal,
    required this.handlingFee,
    required this.deliveryPartnerFee,
    required this.gstAmount,
    required this.deliveryTip,
    required this.finalTotal,
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildBillRow(
            AppStrings.itemTotal,
            '₹${subtotal.toStringAsFixed(2)}',
          ),
          _buildBillRow(
            AppStrings.handlingFee,
            '₹${handlingFee.toStringAsFixed(2)}',
          ),
          _buildBillRow(
            AppStrings.deliveryPartnerFee,
            '₹${deliveryPartnerFee.toStringAsFixed(2)}',
          ),
          _buildBillRow(AppStrings.gst, '₹${gstAmount.toStringAsFixed(2)}'),
          if (deliveryTip > 0)
            _buildBillRow(
              AppStrings.deliveryTip,
              '₹${deliveryTip.toStringAsFixed(2)}',
            ),
          const Divider(),
          _buildBillRow(
            AppStrings.toPay,
            '₹${finalTotal.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
