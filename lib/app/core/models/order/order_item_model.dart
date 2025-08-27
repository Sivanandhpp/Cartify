/// Represents a single item within an order from seller's perspective
class OrderItem {
  final String id;
  final String orderId;
  final String sellerId;
  final String productId;
  final String productName;
  final int quantity;
  final double priceAtPurchase;
  final OrderItemStatus status;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.sellerId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.priceAtPurchase,
    required this.status,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      sellerId: json['seller_id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      // Safe parsing for quantity (handle both string and number)
      quantity: _parseInt(json['quantity']) ?? 0,
      // Safe parsing for price_at_purchase (handle both string and number)
      priceAtPurchase: _parseDouble(json['price_at_purchase']) ?? 0.0,
      status: OrderItemStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => OrderItemStatus.PENDING,
      ),
    );
  }

  /// Helper method to safely parse int values from API response
  static int? _parseInt(dynamic value) {
    if (value == null) return null;

    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }

    return null;
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
      'order_id': orderId,
      'seller_id': sellerId,
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'price_at_purchase': priceAtPurchase,
      'status': status.toString().split('.').last,
    };
  }

  /// Creates a copy with updated status
  OrderItem copyWith({OrderItemStatus? status}) {
    return OrderItem(
      id: id,
      orderId: orderId,
      sellerId: sellerId,
      productId: productId,
      productName: productName,
      quantity: quantity,
      priceAtPurchase: priceAtPurchase,
      status: status ?? this.status,
    );
  }
}

enum OrderItemStatus {
  PENDING,
  ACCEPTED,
  SHIPPED,
  DELIVERED,
  CANCELLED,
  RETURNED,
}