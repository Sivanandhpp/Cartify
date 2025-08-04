// lib/app/core/models/order/order_model.dart

import 'package:cartify/app/core/models/user/address_model.dart';
import 'package:cartify/app/core/models/cart/cart_model.dart';

/// Represents a customer order.
class OrderModel {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final Address shippingAddress;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      shippingAddress: Address.fromJson(json['shipping_address']),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
