import 'package:flutter/material.dart';

/// Production-level reusable add more items section widget
///
/// Displays a prompt for users to add more items with customizable text and action
class AddMoreItemsWidget extends StatelessWidget {
  final String promptText;
  final String actionText;
  final VoidCallback? onActionPressed;

  const AddMoreItemsWidget({
    super.key,
    required this.promptText,
    required this.actionText,
    this.onActionPressed,
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
      child: Row(
        children: [
          Text(
            promptText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onActionPressed,
            child: Text(
              actionText,
              style: TextStyle(
                fontSize: 14,
                color: Colors.orange[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
