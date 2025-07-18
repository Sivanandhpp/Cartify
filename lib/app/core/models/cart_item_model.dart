/// Cart item model representing a product added to the shopping cart
///
/// This model contains product information specific to cart operations
/// including quantity, pricing at the time of addition, and cart metadata.
class CartItem {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final double? discountPrice;
  final int quantity;
  final DateTime addedAt;
  final DateTime? updatedAt;
  final Map<String, dynamic> metadata;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    this.discountPrice,
    required this.quantity,
    required this.addedAt,
    this.updatedAt,
    this.metadata = const {},
  });

  /// Get the effective price per item (discount price if available, otherwise regular price)
  double get effectivePrice => discountPrice ?? price;

  /// Get total price for this cart item (price × quantity)
  double get totalPrice => effectivePrice * quantity;

  /// Get discount amount per item
  double get discountAmount =>
      discountPrice != null ? price - discountPrice! : 0.0;

  /// Get total discount for this cart item
  double get totalDiscount => discountAmount * quantity;

  /// Check if this cart item has a discount
  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  /// Get discount percentage
  double get discountPercentage {
    if (!hasDiscount) return 0.0;
    return (discountAmount / price) * 100;
  }

  /// Get formatted price string
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  /// Get formatted discount price string
  String get formattedDiscountPrice =>
      discountPrice != null ? '\$${discountPrice!.toStringAsFixed(2)}' : '';

  /// Get formatted effective price string
  String get formattedEffectivePrice =>
      '\$${effectivePrice.toStringAsFixed(2)}';

  /// Get formatted total price string
  String get formattedTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';

  /// Create a copy of this cart item with updated fields
  CartItem copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productImage,
    double? price,
    double? discountPrice,
    int? quantity,
    DateTime? addedAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
      updatedAt: updatedAt ?? DateTime.now(),
      metadata: metadata ?? this.metadata,
    );
  }

  /// Convert cart item to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'discountPrice': discountPrice,
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Create cart item from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productImage: json['productImage'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: json['discountPrice'] != null
          ? (json['discountPrice'] as num).toDouble()
          : null,
      quantity: json['quantity'] as int,
      addedAt: DateTime.parse(json['addedAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  /// Create cart item from product
  factory CartItem.fromProduct(
    String cartItemId,
    String productId,
    String productName,
    String productImage,
    double price,
    double? discountPrice, {
    int quantity = 1,
    Map<String, dynamic> metadata = const {},
  }) {
    return CartItem(
      id: cartItemId,
      productId: productId,
      productName: productName,
      productImage: productImage,
      price: price,
      discountPrice: discountPrice,
      quantity: quantity,
      addedAt: DateTime.now(),
      metadata: metadata,
    );
  }

  @override
  String toString() {
    return 'CartItem(id: $id, productId: $productId, productName: $productName, quantity: $quantity, totalPrice: $formattedTotalPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.id == id && other.productId == productId;
  }

  @override
  int get hashCode => Object.hash(id, productId);
}

