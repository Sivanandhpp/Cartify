// lib/app/core/models/cart/cart_model.dart

import 'package:cartify/app/core/models/product/product_model.dart';

/// Represents the user's shopping cart.
class CartModel {
  final String id;
  final String? userId;
  final List<CartItem> items;
  final double totalPrice;

  CartModel({
    required this.id,
    this.userId,
    required this.items,
    required this.totalPrice,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List? ?? [])
        .map((item) => CartItem.fromJson(item))
        .toList();

    // Calculate total price from items since it's not in the response
    final totalPrice = items.fold<double>(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );

    return CartModel(
      id: json['id'] ?? '',
      userId: json['user_id'],
      items: items,
      totalPrice: totalPrice,
    );
  }
}

/// Represents an item within the shopping cart.
class CartItem {
  final String id;
  final String? cartId;
  final String productId;
  final int quantity;
  final ProductModel product;

  CartItem({
    required this.id,
    this.cartId,
    required this.productId,
    required this.quantity,
    required this.product,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      cartId: json['cart_id'],
      productId: json['product_id'] ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      product: ProductModel.fromJson(json['product'] ?? {}),
    );
  }
}
