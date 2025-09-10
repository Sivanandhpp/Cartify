import 'dart:convert';
import 'package:cartify/app/core/index.dart';
import 'package:get/get.dart';

/// Product model tailored for the current API response.
/// Works both for product details and dashboard product list responses.
class ProductModel {
  // -----------------------
  // Core Properties
  // -----------------------
  final String id;
  final String name;
  final String? description;
  final double price;
  final int stockQuantity;
  final String? measureUnitCode;
  final double? measureAmount;
  final List<String> images;
  final Map<String, dynamic>? attributes;
  final double averageRating;
  final bool? isActive;
  final String? categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CategoryModel? category;
  final List<TagModel> tags;
  final List<DiscountModel> discounts;

  // -----------------------
  // Computed Properties
  // -----------------------

  /// Get brand from attributes
  String? get brand => attributes?['brand']?.toString();

  /// Check if product has an active offer (based on valid discounts)
  bool get hasOffer => discounts.any(_isDiscountValid);

  /// Get offer price (discount amount from the first valid discount)
  double get offerPrice {
    final validDiscount = discounts.firstWhereOrNull(_isDiscountValid);
    return validDiscount?.discountAmount ?? 0.0;
  }

  /// Get offer percentage (from the first valid discount)
  double get offerPercentage {
    final validDiscount = discounts.firstWhereOrNull(_isDiscountValid);
    return validDiscount?.discountPercent ?? 0.0;
  }

  /// Get effective price (price minus offer price if applicable)
  double get effectivePrice {
    if (hasOffer && offerPrice > 0) {
      return price - offerPrice;
    }
    return price;
  }

  /// Price formatted for UI
  String get displayPrice => '₹${price.toStringAsFixed(2)}';

  /// Display offer price (formatted for UI)
  String get displayOfferPrice => '₹${offerPrice.toStringAsFixed(0)}';

  /// Display offer percentage (formatted for UI)
  String get displayOfferPercentage => '${offerPercentage.toStringAsFixed(0)}%';

  /// Display effective price (formatted for UI)
  String get displayEffectivePrice => '₹${effectivePrice.toStringAsFixed(0)}';

  /// Human-friendly measure like "250 g" or "0.25 kg"
  String get displayMeasure {
    if (measureAmount == null || measureUnitCode == null) return '';
    final amountStr = measureAmount == (measureAmount?.roundToDouble())
        ? measureAmount!.toInt().toString()
        : measureAmount!.toString();
    return '$amountStr ${measureUnitCode!}';
  }

  // -----------------------
  // Constructor
  // -----------------------
  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stockQuantity,
    this.measureUnitCode,
    this.measureAmount,
    List<String>? images,
    this.attributes,
    required this.averageRating,
    this.isActive,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.tags = const [],
    this.discounts = const [],
  }) : images = images ?? [];

  // -----------------------
  // Factory and Serialization
  // -----------------------

  /// Create ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      price: _parseDouble(json['price']),
      stockQuantity: _parseInt(json['stock_quantity'] ?? json['stock']),
      measureUnitCode: json['measure_unit_code']?.toString(),
      measureAmount: _parseDouble(json['measure_amount']),
      images: ApiCleanUrl.cleanImageUrls(json['images'] ?? json['image_urls']),
      attributes: _parseAttributes(json['attributes']),
      averageRating: _parseDouble(json['average_rating']),
      isActive: json['is_active'] as bool?,
      categoryId: json['category_id']?.toString(),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      category: json['category'] is Map
          ? CategoryModel.fromJson(Map<String, dynamic>.from(json['category']))
          : null,
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((e) => TagModel.fromJson(e))
              .toList() ??
          [],
      discounts:
          (json['discounts'] as List<dynamic>?)
              ?.map((e) => DiscountModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  /// Convert ProductModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price.toStringAsFixed(2),
      'stock_quantity': stockQuantity,
      'measure_unit_code': measureUnitCode,
      'measure_amount': measureAmount?.toString(),
      'images': images,
      'attributes': attributes,
      'average_rating': averageRating.toStringAsFixed(2),
      'is_active': isActive,
      'category_id': categoryId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'category': category?.toJson(),
      'tags': tags.map((e) => e.toJson()).toList(),
      'discounts': discounts.map((e) => e.toJson()).toList(),
    };
  }

  // -----------------------
  // Utility Methods
  // -----------------------

  /// Get specific attribute value with type safety
  T? getAttribute<T>(String key) {
    final value = attributes?[key];
    if (value == null) return null;

    if (T == String) return value.toString() as T?;
    if (T == double) return _parseDouble(value) as T?;
    if (T == int) return _parseInt(value) as T?;
    if (T == bool) return (value == true || value == 'true') as T?;

    return value as T?;
  }

  /// Create a copy with updated fields
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? stockQuantity,
    String? measureUnitCode,
    double? measureAmount,
    List<String>? images,
    Map<String, dynamic>? attributes,
    double? averageRating,
    bool? isActive,
    String? categoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
    CategoryModel? category,
    List<TagModel>? tags,
    List<DiscountModel>? discounts,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      measureUnitCode: measureUnitCode ?? this.measureUnitCode,
      measureAmount: measureAmount ?? this.measureAmount,
      images: images ?? this.images,
      attributes: attributes ?? this.attributes,
      averageRating: averageRating ?? this.averageRating,
      isActive: isActive ?? this.isActive,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      discounts: discounts ?? this.discounts,
    );
  }

  // -----------------------
  // Private Helper Methods
  // -----------------------

  /// Check if a discount is valid (active and within date range)
  bool _isDiscountValid(DiscountModel discount) {
    final now = DateTime.now();
    final isValidFrom =
        discount.validFrom == null || discount.validFrom!.isBefore(now);
    final isValidUpto =
        discount.validUpto == null || discount.validUpto!.isAfter(now);
    return discount.isActive && isValidFrom && isValidUpto;
  }

  // -----------------------
  // Private Parsing Helpers
  // -----------------------

  /// Parse dynamic value to double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Parse dynamic value to int
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? (double.tryParse(value)?.toInt() ?? 0);
    }
    return 0;
  }

  /// Parse dynamic value to DateTime
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  /// Parse dynamic value to attributes map
  static Map<String, dynamic>? _parseAttributes(dynamic value) {
    if (value == null) return null;
    if (value is Map) return Map<String, dynamic>.from(value);
    if (value is String) {
      try {
        return value.isNotEmpty
            ? Map<String, dynamic>.from(jsonDecode(value))
            : null;
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
