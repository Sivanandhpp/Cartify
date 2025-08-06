/// Order related models for Cartify
/// These models handle order data structures and order management

import 'user_models.dart';
import 'cart_models.dart';

/// Enum for order status
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  returned,
}

extension OrderStatusExtension on OrderStatus {
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
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.returned:
        return 'Returned';
    }
  }

  static OrderStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'returned':
        return OrderStatus.returned;
      default:
        return OrderStatus.pending;
    }
  }
}

/// Model for order item
class OrderItem {
  final String id;
  final String orderId;
  final String productId;
  final String productName;
  final String? productImageUrl;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  const OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    this.productImageUrl,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  /// Create from JSON response
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? '',
      orderId: json['order_id'] ?? '',
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      productImageUrl: json['product_image_url'],
      quantity: json['quantity'] ?? 1,
      unitPrice: (json['unit_price'] ?? 0).toDouble(),
      totalPrice: (json['total_price'] ?? 0).toDouble(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'product_image_url': productImageUrl,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
    };
  }

  /// Get formatted unit price
  String get formattedUnitPrice => '₹${unitPrice.toStringAsFixed(2)}';

  /// Get formatted total price
  String get formattedTotalPrice => '₹${totalPrice.toStringAsFixed(2)}';
}

/// Model for complete order
class Order {
  final String id;
  final String userId;
  final String addressId;
  final UserAddress? shippingAddress;
  final List<OrderItem> items;
  final double subtotal;
  final double taxAmount;
  final double shippingFee;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deliveredAt;

  const Order({
    required this.id,
    required this.userId,
    required this.addressId,
    this.shippingAddress,
    required this.items,
    required this.subtotal,
    required this.taxAmount,
    required this.shippingFee,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deliveredAt,
  });

  /// Create from JSON response
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      addressId: json['address_id'] ?? '',
      shippingAddress: json['shipping_address'] != null
          ? UserAddress.fromJson(json['shipping_address'])
          : null,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      taxAmount: (json['tax_amount'] ?? 0).toDouble(),
      shippingFee: (json['shipping_fee'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      status: OrderStatusExtension.fromString(json['status'] ?? 'pending'),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'])
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'address_id': addressId,
      'shipping_address': shippingAddress?.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax_amount': taxAmount,
      'shipping_fee': shippingFee,
      'total_amount': totalAmount,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
    };
  }

  /// Get total items count
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  /// Get formatted order date
  String get formattedOrderDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  /// Get formatted total amount
  String get formattedTotalAmount => '₹${totalAmount.toStringAsFixed(2)}';

  /// Get formatted subtotal
  String get formattedSubtotal => '₹${subtotal.toStringAsFixed(2)}';

  /// Get formatted tax amount
  String get formattedTaxAmount => '₹${taxAmount.toStringAsFixed(2)}';

  /// Get formatted shipping fee
  String get formattedShippingFee => '₹${shippingFee.toStringAsFixed(2)}';

  /// Check if order can be cancelled
  bool get canBeCancelled {
    return status == OrderStatus.pending || status == OrderStatus.confirmed;
  }

  /// Check if order is delivered
  bool get isDelivered => status == OrderStatus.delivered;

  /// Check if order is in progress
  bool get isInProgress {
    return status == OrderStatus.confirmed ||
        status == OrderStatus.processing ||
        status == OrderStatus.shipped;
  }

  /// Get order status color
  String get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return '#FFA500'; // Orange
      case OrderStatus.confirmed:
        return '#007BFF'; // Blue
      case OrderStatus.processing:
        return '#6C63FF'; // Purple
      case OrderStatus.shipped:
        return '#17A2B8'; // Cyan
      case OrderStatus.delivered:
        return '#28A745'; // Green
      case OrderStatus.cancelled:
        return '#DC3545'; // Red
      case OrderStatus.returned:
        return '#6C757D'; // Gray
    }
  }
}

/// Model for creating a new order
class CreateOrderDto {
  final String addressId;

  const CreateOrderDto({required this.addressId});

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {'address_id': addressId};
  }
}

/// Model for order summary (used in checkout)
class OrderSummary {
  final List<CartItem> items;
  final UserAddress shippingAddress;
  final double subtotal;
  final double taxAmount;
  final double shippingFee;
  final double totalAmount;

  const OrderSummary({
    required this.items,
    required this.shippingAddress,
    required this.subtotal,
    required this.taxAmount,
    required this.shippingFee,
    required this.totalAmount,
  });

  /// Calculate order summary from cart and address
  factory OrderSummary.fromCart({
    required List<CartItem> cartItems,
    required UserAddress address,
    double taxRate = 0.18, // 18% GST
    double shippingFee = 50.0,
  }) {
    final subtotal = cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    final taxAmount = subtotal * taxRate;
    final totalAmount = subtotal + taxAmount + shippingFee;

    return OrderSummary(
      items: cartItems,
      shippingAddress: address,
      subtotal: subtotal,
      taxAmount: taxAmount,
      shippingFee: shippingFee,
      totalAmount: totalAmount,
    );
  }

  /// Get total items count
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  /// Get formatted amounts
  String get formattedSubtotal => '₹${subtotal.toStringAsFixed(2)}';
  String get formattedTaxAmount => '₹${taxAmount.toStringAsFixed(2)}';
  String get formattedShippingFee => '₹${shippingFee.toStringAsFixed(2)}';
  String get formattedTotalAmount => '₹${totalAmount.toStringAsFixed(2)}';
}
