import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';

/// Utility class for order status management
class OrderStatusUtils {
  OrderStatusUtils._();

  /// Available order item statuses
  static const String pending = 'PENDING';
  static const String accepted = 'ACCEPTED';
  static const String shipped = 'SHIPPED';
  static const String delivered = 'DELIVERED';
  static const String cancelled = 'CANCELLED';

  /// All available statuses
  static const List<String> allStatuses = [
    pending,
    accepted,
    shipped,
    delivered,
    cancelled,
  ];

  /// Statuses that allow updates
  static const List<String> updatableStatuses = [
    pending,
    accepted,
    shipped,
  ];

  /// Get status color for UI
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'accepted':
        return AppColors.info;
      case 'shipped':
        return AppColors.primary;
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.grey;
    }
  }

  /// Get status icon for UI
  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'accepted':
        return Icons.check_circle_outline;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  /// Check if status can be updated
  static bool canUpdateStatus(String currentStatus) {
    return updatableStatuses.contains(currentStatus.toUpperCase());
  }

  /// Get next possible statuses
  static List<String> getNextStatuses(String currentStatus) {
    switch (currentStatus.toUpperCase()) {
      case pending:
        return [accepted, cancelled];
      case accepted:
        return [shipped, cancelled];
      case shipped:
        return [delivered];
      default:
        return [];
    }
  }

  /// Format status for display
  static String formatStatusForDisplay(String status) {
    return status.toLowerCase().split('_').map((word) => 
      word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }
}