/// Shopping cart and order management models
///
/// This file contains all models related to shopping cart operations,
/// order processing, and order history management for the e-commerce platform.

import '../catalog/catalog_models.dart';
import '../user/user_models.dart';

/// Individual item in the shopping cart
///
/// Represents a single product in the user's cart with quantity
/// and pricing information for checkout calculations.
class CartItem {
  /// Unique identifier for the cart item
  final String id;

  /// ID of the user who owns this cart item
  final String userId;

  /// Product information for this cart item
  final Product product;

  /// Quantity of the product in the cart
  final int quantity;

  /// Price per unit at the time of adding to cart
  final double unitPrice;

  /// Timestamp when the item was added to cart
  final DateTime addedAt;

  /// Timestamp when the item was last updated
  final DateTime updatedAt;

  const CartItem({
    required this.id,
    required this.userId,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.addedAt,
    required this.updatedAt,
  });

  /// Create instance from JSON response
  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    product: Product.fromJson(json['product'] as Map<String, dynamic>),
    quantity: json['quantity'] as int,
    unitPrice: (json['unit_price'] as num).toDouble(),
    addedAt: DateTime.parse(json['added_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'product': product.toJson(),
    'quantity': quantity,
    'unit_price': unitPrice,
    'added_at': addedAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  /// Create a copy with updated values
  CartItem copyWith({
    String? id,
    String? userId,
    Product? product,
    int? quantity,
    double? unitPrice,
    DateTime? addedAt,
    DateTime? updatedAt,
  }) => CartItem(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    product: product ?? this.product,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice ?? this.unitPrice,
    addedAt: addedAt ?? this.addedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  /// Calculate total price for this cart item
  double get totalPrice => unitPrice * quantity;

  /// Check if the requested quantity is available in stock
  bool get isAvailable => quantity <= product.stockQuantity;

  /// Check if there's a price discrepancy (current price vs cart price)
  bool get hasPriceChange => unitPrice != product.price;

  /// Get price difference (positive if price increased, negative if decreased)
  double get priceDifference => product.price - unitPrice;

  /// Get formatted total price
  String get formattedTotalPrice => '₹${totalPrice.toStringAsFixed(2)}';

  /// Get formatted unit price
  String get formattedUnitPrice => '₹${unitPrice.toStringAsFixed(2)}';

  /// Get availability status message
  String get availabilityMessage {
    if (!isAvailable) {
      return 'Only ${product.stockQuantity} item(s) available';
    }
    return 'In Stock';
  }

  @override
  String toString() =>
      'CartItem('
      'id: $id, '
      'product: ${product.name}, '
      'quantity: $quantity, '
      'totalPrice: ${formattedTotalPrice})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          product == other.product &&
          quantity == other.quantity &&
          unitPrice == other.unitPrice;

  @override
  int get hashCode => Object.hash(id, userId, product, quantity, unitPrice);
}

/// Complete shopping cart containing all items and totals
///
/// Represents the user's complete shopping cart with items,
/// pricing calculations, and checkout-ready information.
class Cart {
  /// Unique identifier for the cart
  final String id;

  /// ID of the user who owns this cart
  final String userId;

  /// List of items in the cart
  final List<CartItem> items;

  /// Timestamp when the cart was created
  final DateTime createdAt;

  /// Timestamp when the cart was last updated
  final DateTime updatedAt;

  const Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create instance from JSON response
  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    items: (json['items'] as List)
        .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
        .toList(),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'items': items.map((item) => item.toJson()).toList(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  /// Create a copy with updated values
  Cart copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Cart(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    items: items ?? this.items,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  /// Check if the cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if the cart has items
  bool get isNotEmpty => items.isNotEmpty;

  /// Get total number of items in the cart
  int get itemCount => items.length;

  /// Get total quantity of all items
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  /// Calculate subtotal (sum of all item totals)
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Calculate tax amount (assuming 18% GST)
  double get taxAmount => subtotal * 0.18;

  /// Calculate shipping charges (free for orders above ₹500)
  double get shippingCharges => subtotal >= 500 ? 0.0 : 50.0;

  /// Calculate total amount including tax and shipping
  double get totalAmount => subtotal + taxAmount + shippingCharges;

  /// Get formatted subtotal
  String get formattedSubtotal => '₹${subtotal.toStringAsFixed(2)}';

  /// Get formatted tax amount
  String get formattedTaxAmount => '₹${taxAmount.toStringAsFixed(2)}';

  /// Get formatted shipping charges
  String get formattedShippingCharges =>
      '₹${shippingCharges.toStringAsFixed(2)}';

  /// Get formatted total amount
  String get formattedTotalAmount => '₹${totalAmount.toStringAsFixed(2)}';

  /// Check if all items in cart are available
  bool get areAllItemsAvailable => items.every((item) => item.isAvailable);

  /// Get items that are not available
  List<CartItem> get unavailableItems =>
      items.where((item) => !item.isAvailable).toList();

  /// Get items with price changes
  List<CartItem> get itemsWithPriceChanges =>
      items.where((item) => item.hasPriceChange).toList();

  /// Check if the cart is ready for checkout
  bool get isReadyForCheckout => isNotEmpty && areAllItemsAvailable;

  /// Get checkout validation messages
  List<String> get checkoutValidationMessages {
    final messages = <String>[];

    if (isEmpty) {
      messages.add('Your cart is empty');
    }

    if (unavailableItems.isNotEmpty) {
      messages.add('${unavailableItems.length} item(s) are not available');
    }

    if (itemsWithPriceChanges.isNotEmpty) {
      messages.add(
        '${itemsWithPriceChanges.length} item(s) have price changes',
      );
    }

    return messages;
  }

  /// Find cart item by product ID
  CartItem? findItemByProductId(String productId) {
    try {
      return items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  /// Check if a product exists in the cart
  bool containsProduct(String productId) =>
      findItemByProductId(productId) != null;

  /// Get quantity of a specific product in the cart
  int getProductQuantity(String productId) {
    final item = findItemByProductId(productId);
    return item?.quantity ?? 0;
  }

  @override
  String toString() =>
      'Cart('
      'id: $id, '
      'itemCount: $itemCount, '
      'totalQuantity: $totalQuantity, '
      'totalAmount: ${formattedTotalAmount})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cart &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          items.length == other.items.length;

  @override
  int get hashCode => Object.hash(id, userId, items.length);
}

/// Data transfer object for adding items to cart
///
/// Contains the required information for adding a product to the shopping cart.
class AddToCartDto {
  /// ID of the product to add
  final String productId;

  /// Quantity to add to the cart
  final int quantity;

  const AddToCartDto({required this.productId, required this.quantity});

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'quantity': quantity,
  };

  /// Create instance from JSON
  factory AddToCartDto.fromJson(Map<String, dynamic> json) => AddToCartDto(
    productId: json['product_id'] as String,
    quantity: json['quantity'] as int,
  );

  /// Validate the DTO data
  bool get isValid => productId.isNotEmpty && quantity > 0;

  @override
  String toString() =>
      'AddToCartDto(productId: $productId, quantity: $quantity)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddToCartDto &&
          runtimeType == other.runtimeType &&
          productId == other.productId &&
          quantity == other.quantity;

  @override
  int get hashCode => Object.hash(productId, quantity);
}

/// Data transfer object for updating cart item quantities
///
/// Contains the information needed to update the quantity of an existing cart item.
class UpdateCartItemDto {
  /// New quantity for the cart item
  final int quantity;

  const UpdateCartItemDto({required this.quantity});

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {'quantity': quantity};

  /// Create instance from JSON
  factory UpdateCartItemDto.fromJson(Map<String, dynamic> json) =>
      UpdateCartItemDto(quantity: json['quantity'] as int);

  /// Validate the DTO data
  bool get isValid => quantity > 0;

  @override
  String toString() => 'UpdateCartItemDto(quantity: $quantity)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateCartItemDto &&
          runtimeType == other.runtimeType &&
          quantity == other.quantity;

  @override
  int get hashCode => quantity.hashCode;
}

/// Enumeration of possible order statuses
///
/// Defines the different states an order can be in during its lifecycle
/// from placement to completion or cancellation.
enum OrderStatus {
  /// Order has been placed but not yet confirmed
  pending,

  /// Order has been confirmed and is being prepared
  confirmed,

  /// Order is being processed/packed
  processing,

  /// Order has been shipped
  shipped,

  /// Order is out for delivery
  outForDelivery,

  /// Order has been successfully delivered
  delivered,

  /// Order has been cancelled
  cancelled,

  /// Order has been returned
  returned,

  /// Order has been refunded
  refunded,
}

/// Extension to handle OrderStatus utilities
extension OrderStatusExtension on OrderStatus {
  /// Convert status to string for API communication
  String get value {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.processing:
        return 'processing';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.outForDelivery:
        return 'out_for_delivery';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
      case OrderStatus.returned:
        return 'returned';
      case OrderStatus.refunded:
        return 'refunded';
    }
  }

  /// Create OrderStatus from string value
  static OrderStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'out_for_delivery':
        return OrderStatus.outForDelivery;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'returned':
        return OrderStatus.returned;
      case 'refunded':
        return OrderStatus.refunded;
      default:
        return OrderStatus.pending; // Default fallback
    }
  }

  /// Get display name for the status
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.returned:
        return 'Returned';
      case OrderStatus.refunded:
        return 'Refunded';
    }
  }

  /// Check if the order is in a final state (cannot be modified)
  bool get isFinal =>
      this == OrderStatus.delivered ||
      this == OrderStatus.cancelled ||
      this == OrderStatus.returned ||
      this == OrderStatus.refunded;

  /// Check if the order can be cancelled
  bool get canBeCancelled =>
      this == OrderStatus.pending || this == OrderStatus.confirmed;

  /// Check if the order is active (not cancelled or completed)
  bool get isActive =>
      this != OrderStatus.cancelled &&
      this != OrderStatus.returned &&
      this != OrderStatus.refunded;

  /// Check if the order is in transit
  bool get isInTransit =>
      this == OrderStatus.shipped || this == OrderStatus.outForDelivery;
}

/// Individual item within an order
///
/// Represents a single product in an order with the quantity and pricing
/// information locked at the time of order placement.
class OrderItem {
  /// Unique identifier for the order item
  final String id;

  /// ID of the order this item belongs to
  final String orderId;

  /// Product information for this order item
  final Product product;

  /// Quantity ordered
  final int quantity;

  /// Price per unit at the time of order
  final double unitPrice;

  /// Total price for this item (quantity * unitPrice)
  final double totalPrice;

  const OrderItem({
    required this.id,
    required this.orderId,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  /// Create instance from JSON response
  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json['id'] as String,
    orderId: json['order_id'] as String,
    product: Product.fromJson(json['product'] as Map<String, dynamic>),
    quantity: json['quantity'] as int,
    unitPrice: (json['unit_price'] as num).toDouble(),
    totalPrice: (json['total_price'] as num).toDouble(),
  );

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {
    'id': id,
    'order_id': orderId,
    'product': product.toJson(),
    'quantity': quantity,
    'unit_price': unitPrice,
    'total_price': totalPrice,
  };

  /// Get formatted unit price
  String get formattedUnitPrice => '₹${unitPrice.toStringAsFixed(2)}';

  /// Get formatted total price
  String get formattedTotalPrice => '₹${totalPrice.toStringAsFixed(2)}';

  @override
  String toString() =>
      'OrderItem('
      'id: $id, '
      'product: ${product.name}, '
      'quantity: $quantity, '
      'totalPrice: ${formattedTotalPrice})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          orderId == other.orderId &&
          product == other.product &&
          quantity == other.quantity &&
          unitPrice == other.unitPrice &&
          totalPrice == other.totalPrice;

  @override
  int get hashCode =>
      Object.hash(id, orderId, product, quantity, unitPrice, totalPrice);
}

/// Complete order information with items and status
///
/// Represents a complete order with all items, pricing, shipping information,
/// and current status for order tracking and history.
class Order {
  /// Unique identifier for the order
  final String id;

  /// ID of the user who placed the order
  final String userId;

  /// Current status of the order
  final OrderStatus status;

  /// List of items in the order
  final List<OrderItem> items;

  /// Shipping address for the order
  final Address shippingAddress;

  /// Subtotal amount (sum of all items)
  final double subtotal;

  /// Tax amount applied
  final double taxAmount;

  /// Shipping charges
  final double shippingCharges;

  /// Total amount paid
  final double totalAmount;

  /// Timestamp when the order was placed
  final DateTime createdAt;

  /// Timestamp when the order was last updated
  final DateTime updatedAt;

  /// Expected delivery date (optional)
  final DateTime? expectedDeliveryDate;

  /// Tracking number for shipment (optional)
  final String? trackingNumber;

  /// Order notes or special instructions (optional)
  final String? notes;

  const Order({
    required this.id,
    required this.userId,
    required this.status,
    required this.items,
    required this.shippingAddress,
    required this.subtotal,
    required this.taxAmount,
    required this.shippingCharges,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
    this.expectedDeliveryDate,
    this.trackingNumber,
    this.notes,
  });

  /// Create instance from JSON response
  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    status: OrderStatusExtension.fromString(json['status'] as String),
    items: (json['items'] as List)
        .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
        .toList(),
    shippingAddress: Address.fromJson(
      json['shipping_address'] as Map<String, dynamic>,
    ),
    subtotal: (json['subtotal'] as num).toDouble(),
    taxAmount: (json['tax_amount'] as num).toDouble(),
    shippingCharges: (json['shipping_charges'] as num).toDouble(),
    totalAmount: (json['total_amount'] as num).toDouble(),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
    expectedDeliveryDate: json['expected_delivery_date'] != null
        ? DateTime.parse(json['expected_delivery_date'] as String)
        : null,
    trackingNumber: json['tracking_number'] as String?,
    notes: json['notes'] as String?,
  );

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'status': status.value,
    'items': items.map((item) => item.toJson()).toList(),
    'shipping_address': shippingAddress.toJson(),
    'subtotal': subtotal,
    'tax_amount': taxAmount,
    'shipping_charges': shippingCharges,
    'total_amount': totalAmount,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'expected_delivery_date': expectedDeliveryDate?.toIso8601String(),
    'tracking_number': trackingNumber,
    'notes': notes,
  };

  /// Create a copy with updated values
  Order copyWith({
    String? id,
    String? userId,
    OrderStatus? status,
    List<OrderItem>? items,
    Address? shippingAddress,
    double? subtotal,
    double? taxAmount,
    double? shippingCharges,
    double? totalAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? expectedDeliveryDate,
    String? trackingNumber,
    String? notes,
  }) => Order(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    status: status ?? this.status,
    items: items ?? this.items,
    shippingAddress: shippingAddress ?? this.shippingAddress,
    subtotal: subtotal ?? this.subtotal,
    taxAmount: taxAmount ?? this.taxAmount,
    shippingCharges: shippingCharges ?? this.shippingCharges,
    totalAmount: totalAmount ?? this.totalAmount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
    trackingNumber: trackingNumber ?? this.trackingNumber,
    notes: notes ?? this.notes,
  );

  /// Get total number of items in the order
  int get itemCount => items.length;

  /// Get total quantity of all items
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  /// Get formatted subtotal
  String get formattedSubtotal => '₹${subtotal.toStringAsFixed(2)}';

  /// Get formatted tax amount
  String get formattedTaxAmount => '₹${taxAmount.toStringAsFixed(2)}';

  /// Get formatted shipping charges
  String get formattedShippingCharges =>
      '₹${shippingCharges.toStringAsFixed(2)}';

  /// Get formatted total amount
  String get formattedTotalAmount => '₹${totalAmount.toStringAsFixed(2)}';

  /// Get formatted order date
  String get formattedOrderDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  /// Get formatted expected delivery date
  String get formattedExpectedDelivery {
    if (expectedDeliveryDate == null) return 'Not available';
    final date = expectedDeliveryDate!;
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Check if the order can be cancelled
  bool get canBeCancelled => status.canBeCancelled;

  /// Check if the order is trackable
  bool get isTrackable => trackingNumber != null && trackingNumber!.isNotEmpty;

  /// Get order summary for display
  String get orderSummary {
    return '${items.length} item(s) • ${formattedTotalAmount}';
  }

  @override
  String toString() =>
      'Order('
      'id: $id, '
      'status: ${status.displayName}, '
      'itemCount: $itemCount, '
      'totalAmount: ${formattedTotalAmount})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          status == other.status &&
          totalAmount == other.totalAmount &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(id, userId, status, totalAmount, createdAt);
}

/// Data transfer object for creating new orders
///
/// Contains the required information for placing an order from the cart.
class CreateOrderDto {
  /// ID of the shipping address to use for the order
  final String addressId;

  const CreateOrderDto({required this.addressId});

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {'address_id': addressId};

  /// Create instance from JSON
  factory CreateOrderDto.fromJson(Map<String, dynamic> json) =>
      CreateOrderDto(addressId: json['address_id'] as String);

  /// Validate the DTO data
  bool get isValid => addressId.isNotEmpty;

  @override
  String toString() => 'CreateOrderDto(addressId: $addressId)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateOrderDto &&
          runtimeType == other.runtimeType &&
          addressId == other.addressId;

  @override
  int get hashCode => addressId.hashCode;
}
