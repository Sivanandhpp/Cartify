// lib/app/core/models/order/order_model.dart

import 'package:cartify/app/core/models/order/order_item_model.dart';
import 'package:cartify/app/core/services/log_service.dart';

/// Represents a customer order from seller's perspective
class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final ShippingAddress shippingAddress;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    try {
      return OrderModel(
        id: json['id']?.toString() ?? '',
        userId: json['user_id']?.toString() ?? '',
        items:
            (json['items'] as List<dynamic>?)
                ?.map(
                  (item) => OrderItem.fromJson(item as Map<String, dynamic>),
                )
                .toList() ??
            [],
        // Safe parsing for total_amount (handle both string and number)
        totalAmount: _parseDouble(json['total_amount']) ?? 0.0,
        shippingAddress: ShippingAddress.fromJson(
          json['shipping_address'] as Map<String, dynamic>? ?? {},
        ),
        status: OrderStatus.values.firstWhere(
          (e) => e.toString().split('.').last == json['status'],
          orElse: () => OrderStatus.PENDING,
        ),
        createdAt:
            DateTime.tryParse(
              json['created_at']?.toString() ?? '',
            )?.toLocal() ??
            DateTime.now().toLocal(),
        updatedAt: json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at'].toString())?.toLocal()
            : null,
      );
    } catch (e, stackTrace) {
      LogService.error('Error parsing OrderModel from JSON', {
        'error': e.toString(),
        'stackTrace': stackTrace.toString(),
        'json': json,
      });
      rethrow;
    }
  }

  /// Helper method to safely parse double values from API response
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;

    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }

    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'total_amount': totalAmount,
      'shipping_address': shippingAddress.toJson(),
      'status': status.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Get seller's portion of the total amount
  double get sellerAmount {
    return items.fold(
      0.0,
      (sum, item) => sum + (item.priceAtPurchase * item.quantity),
    );
  }

  /// Check if all seller items are in specific status
  bool get allItemsDelivered {
    return items.every((item) => item.status == OrderItemStatus.DELIVERED);
  }

  /// Get count of items by status
  int getItemCountByStatus(OrderItemStatus status) {
    return items.where((item) => item.status == status).length;
  }
}

class ShippingAddress {
  final String recipientName;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String pincode;
  final String addressType;

  ShippingAddress({
    required this.recipientName,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
    required this.addressType,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      recipientName: json['recipient_name'] ?? '',
      phone: json['phone'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      addressType: json['address_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipient_name': recipientName,
      'phone': phone,
      'street': street,
      'city': city,
      'state': state,
      'pincode': pincode,
      'address_type': addressType,
    };
  }

  /// Gets formatted address string for display
  String get formattedAddress {
    final parts = [street, city, state, pincode];
    return parts.join(', ');
  }
}

enum OrderStatus { PENDING, CONFIRMED, SHIPPED, DELIVERED, CANCELLED }
