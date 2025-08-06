/// Cart and review related models for Cartify
/// These models handle shopping cart and product review data structures

import 'product_models.dart';

/// Model for cart item
class CartItem {
  final String id;
  final String productId;
  final Product product;
  final int quantity;
  final double unitPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CartItem({
    required this.id,
    required this.productId,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON response
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      productId: json['product_id'] ?? '',
      product: Product.fromJson(json['product'] ?? {}),
      quantity: json['quantity'] ?? 1,
      unitPrice: (json['unit_price'] ?? 0).toDouble(),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product': product.toJson(),
      'quantity': quantity,
      'unit_price': unitPrice,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Calculate total price for this item
  double get totalPrice => unitPrice * quantity;

  /// Create a copy with updated quantity
  CartItem copyWith({
    String? id,
    String? productId,
    Product? product,
    int? quantity,
    double? unitPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Model for shopping cart
class Cart {
  final String id;
  final String userId;
  final List<CartItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON response
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Calculate total items count
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  /// Calculate total cart value
  double get totalValue =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart has items
  bool get isNotEmpty => items.isNotEmpty;

  /// Get formatted total value
  String get formattedTotal => '₹${totalValue.toStringAsFixed(2)}';
}

/// Model for adding item to cart
class AddToCartDto {
  final String productId;
  final int quantity;

  const AddToCartDto({required this.productId, required this.quantity});

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {'product_id': productId, 'quantity': quantity};
  }
}

/// Model for updating cart item quantity
class UpdateCartItemDto {
  final int quantity;

  const UpdateCartItemDto({required this.quantity});

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {'quantity': quantity};
  }
}

/// Model for product review
class ProductReview {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductReview({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON response
  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['id'] ?? '',
      productId: json['product_id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? 'Anonymous',
      rating: json['rating'] ?? 1,
      comment: json['comment'],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'user_name': userName,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Get formatted date
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

/// Model for creating a review
class CreateReviewDto {
  final String productId;
  final int rating;
  final String? comment;

  const CreateReviewDto({
    required this.productId,
    required this.rating,
    this.comment,
  });

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {'product_id': productId, 'rating': rating, 'comment': comment};
  }
}
