// lib/app/core/models/cart/cart_model.dart

import 'package:cartify/app/core/models/product/product_model.dart';

/// Represents the user's shopping cart.
class CartModel {
  final String id;
  final List<CartItem> items;
  final double totalPrice;

  CartModel({required this.id, required this.items, required this.totalPrice});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }
}

/// Represents an item within the shopping cart.
class CartItem {
  final String id;
  final int quantity;
  final ProductModel product;

  CartItem({required this.id, required this.quantity, required this.product});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      quantity: json['quantity'],
      product: ProductModel.fromJson(json['product']),
    );
  }
}
