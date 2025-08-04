import 'package:flutter/material.dart';
import '../../../../../core/index.dart';

/// Reusable quantity selector widget for buyer panel
///
/// Provides consistent quantity increment/decrement controls across all buyer panel screens
class QuantitySelectorWidget extends StatelessWidget {
  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final double? width;
  final double? height;
  final double? iconSize;
  final bool isCompact;

  const QuantitySelectorWidget({
    super.key,
    required this.quantity,
    this.onIncrement,
    this.onDecrement,
    this.width,
    this.height,
    this.iconSize,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightPrimary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onDecrement,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.remove,
                size: iconSize ?? 16,
                color: AppColors.lightPrimary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$quantity',
              style: TextStyle(
                fontSize: isCompact ? 12 : 14,
                fontWeight: FontWeight.w500,
                color: AppColors.lightPrimary,
              ),
            ),
          ),
          InkWell(
            onTap: onIncrement,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.add,
                size: iconSize ?? 16,
                color: AppColors.lightPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
