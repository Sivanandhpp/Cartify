
class DiscountModel {
  final String id;
  final String productId;
  final double? discountAmount; // Amount to subtract from price
  final double? discountPercent; // Percentage to apply
  final bool isActive;
  final DateTime? validFrom;
  final DateTime? validUpto;
  final String createdBy;

  DiscountModel({
    required this.id,
    required this.productId,
    this.discountAmount,
    this.discountPercent,
    required this.isActive,
    this.validFrom,
    this.validUpto,
    required this.createdBy,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      discountAmount: _parseDouble(json['discount_amount']), // Safe parsing
      discountPercent: _parseDouble(json['discount_percent']), // Safe parsing
      isActive: json['is_active'] as bool? ?? false,
      validFrom: DateTime.tryParse(json['valid_from']?.toString() ?? ''),
      validUpto: DateTime.tryParse(json['valid_upto']?.toString() ?? ''),
      createdBy: json['created_by']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'discount_amount': discountAmount,
      'discount_percent': discountPercent,
      'is_active': isActive,
      'valid_from': validFrom?.toIso8601String(),
      'valid_upto': validUpto?.toIso8601String(),
      'created_by': createdBy,
    };
  }

  // Helper for safe double parsing (handles strings, numbers, and null)
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
