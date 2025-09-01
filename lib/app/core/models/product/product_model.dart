import 'dart:convert';
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/core/services/api_clean_url.dart';
import 'package:get/get.dart';
import 'category_model.dart';
import 'tag_model.dart';
import 'discount_model.dart';

/// Product model tailored for the current API response.
/// Works both for product details and dashboard product list responses.
class ProductModel {
  final String id;
  final String name;
  final String? description;

  /// Price as double (parsed from string or number)
  final double price;

  /// Quantity available (server key: stock_quantity)
  final int stockQuantity;

  /// Example: 'g', 'kg', 'ml', 'L', 'pcs'
  final String? measureUnitCode;

  /// Example: "250.00" (parsed to double)
  final double? measureAmount;

  /// API field `images` may be null, a list, or a single URL
  final List<String> images;

  /// Arbitrary attributes (size, color, origin, etc.)
  final Map<String, dynamic>? attributes;

  /// Average rating parsed to double (string in API)
  final double averageRating;

  /// Product active status (optional, not in every response)
  final bool? isActive;

  final String? categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Nested category object if response includes it
  final CategoryModel? category;

  final List<TagModel> tags;
  final List<DiscountModel> discounts;

  String? get brand => attributes?['brand']?.toString();

  // Check if product has an offer (based on active discounts)
  bool get hasOffer {
    final now = DateTime.now();
    return discounts.any((discount) {
      bool isValidFrom = discount.validFrom == null || discount.validFrom!.isBefore(now);
      bool isValidUpto = discount.validUpto == null || discount.validUpto!.isAfter(now);
      return discount.isActive && isValidFrom && isValidUpto;
    });
  }

  // Get offer price (calculated from active discounts)
  double? get offerPrice {
    if (!hasOffer) return null;
    double currentPrice = price;
    final now = DateTime.now();

    // First, apply percentage discounts
    for (final discount in discounts) {
      bool isValidFrom = discount.validFrom == null || discount.validFrom!.isBefore(now);
      bool isValidUpto = discount.validUpto == null || discount.validUpto!.isAfter(now);
      if (discount.isActive && isValidFrom && isValidUpto && discount.discountPercent != null) {
        currentPrice *= (1 - discount.discountPercent! / 100);
      }
    }

    // Then, apply amount discounts
    for (final discount in discounts) {
      bool isValidFrom = discount.validFrom == null || discount.validFrom!.isBefore(now);
      bool isValidUpto = discount.validUpto == null || discount.validUpto!.isAfter(now);
      if (discount.isActive && isValidFrom && isValidUpto && discount.discountAmount != null) {
        currentPrice -= discount.discountAmount!;
        if (currentPrice < 0) currentPrice = 0; // Prevent negative prices
      }
    }

    return currentPrice < price ? currentPrice : null;
  }

  // Get offer percentage (from the first active percentage discount)
  double? get offerPercentage {
    final now = DateTime.now();
    final activePercentDiscount = discounts.firstWhereOrNull((discount) {
      bool isValidFrom = discount.validFrom == null || discount.validFrom!.isBefore(now);
      bool isValidUpto = discount.validUpto == null || discount.validUpto!.isAfter(now);
      return discount.isActive && isValidFrom && isValidUpto && discount.discountPercent != null;
    });
    return activePercentDiscount?.discountPercent;
  }

  // Get discount percentage (from offerPercentage or calculated from offerPrice)
  double get discountPercentage {
    if (offerPercentage != null) return offerPercentage!;
    if (hasOffer && offerPrice != null) {
      return ((price - offerPrice!) / price) * 100;
    }
    return 0.0;
  }

  // Get effective price (offer price if available, otherwise regular price)
  double get effectivePrice => hasOffer && offerPrice != null ? offerPrice! : price;

  // Display effective price
  String get displayEffectivePrice => '₹${effectivePrice.toStringAsFixed(2)}';

  // Display original price (for strikethrough)
  String get displayOriginalPrice => '₹${price.toStringAsFixed(2)}';

  // Get specific attribute value with type safety
  T? getAttribute<T>(String key) {
    final value = attributes?[key];
    if (value == null) return null;

    if (T == String) return value.toString() as T?;
    if (T == double) return _parseDouble(value) as T?;
    if (T == int) return _parseInt(value) as T?;
    if (T == bool) return (value == true || value == 'true') as T?;

    return value as T?;
  }

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
      isActive: json['is_active'] as bool?, // Added: Parse isActive safely
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
      'is_active': isActive, // Added: Include isActive in JSON
      'category_id': categoryId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'category': category?.toJson(),
      'tags': tags.map((e) => e.toJson()).toList(),
      'discounts': discounts.map((e) => e.toJson()).toList(),
    };
  }

  /// Human-friendly measure like "250 g" or "0.25 kg"
  String get displayMeasure {
    if (measureAmount == null || measureUnitCode == null) return '';
    // Remove trailing zeros for nicer display
    final amountStr = measureAmount == (measureAmount?.roundToDouble())
        ? measureAmount!.toInt().toString()
        : measureAmount!.toString();
    return '$amountStr ${measureUnitCode!}';
  }

  /// Price formatted for UI (example, returns string; adapt to currency formatter)
  String get displayPrice => price.toStringAsFixed(2);

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
  // Parsing helpers
  // -----------------------
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String)
      return int.tryParse(value) ?? (double.tryParse(value)?.toInt() ?? 0);
    return 0;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  static Map<String, dynamic>? _parseAttributes(dynamic value) {
    if (value == null) return null;
    if (value is Map) return Map<String, dynamic>.from(value);
    // try parsing if it's a JSON string
    if (value is String) {
      try {
        final parsed = value.isNotEmpty
            ? Map<String, dynamic>.from(jsonDecode(value))
            : null;
        return parsed;
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}