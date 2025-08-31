class DiscountModel {
  final String id;
  final String productId;
  final double? discountAmount;
  final double? discountPercent;
  final bool isActive;
  final DateTime validFrom;
  final DateTime validUpto;
  final String createdBy;

  DiscountModel({
    required this.id,
    required this.productId,
    this.discountAmount,
    this.discountPercent,
    required this.isActive,
    required this.validFrom,
    required this.validUpto,
    required this.createdBy,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id'] ?? '',
      productId: json['product_id'] ?? '',
      discountAmount: json['discount_amount']?.toDouble(),
      discountPercent: json['discount_percent']?.toDouble(),
      isActive: json['is_active'] ?? true,
      validFrom: DateTime.parse(json['valid_from']),
      validUpto: DateTime.parse(json['valid_upto']),
      createdBy: json['created_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'discount_amount': discountAmount,
      'discount_percent': discountPercent,
      'is_active': isActive,
      'valid_from': validFrom.toIso8601String(),
      'valid_upto': validUpto.toIso8601String(),
      'created_by': createdBy,
    };
  }
}