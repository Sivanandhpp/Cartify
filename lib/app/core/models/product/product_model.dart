// lib/app/core/models/product/product_model.dart
import 'dart:convert';

import 'package:cartify/app/core/index.dart';

import 'category_model.dart';

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

  // Convenience getters for common attributes
  String? get brand => attributes?['brand']?.toString();
  
  double? get offerPrice => _parseDouble(attributes?['offer_price']);
  
  double? get offerPercentage => _parseDouble(attributes?['offer_percentage']);
  
  double? get alcoholContent => _parseDouble(attributes?['alcohol_content_abv']);
  
  // Check if product has an offer
  bool get hasOffer => offerPrice != null && offerPrice! > 0;
  
  // Get discount percentage (from attributes or calculated)
  double get discountPercentage {
    if (offerPercentage != null) return offerPercentage!;
    if (hasOffer && offerPrice! < price) {
      return ((price - offerPrice!) / price) * 100;
    }
    return 0.0;
  }
  
  // Get effective price (offer price if available, otherwise regular price)
  double get effectivePrice => hasOffer ? offerPrice! : price;
  
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

  /// Average rating parsed to double (string in API)
  final double averageRating;

  final String? categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Nested category object if response includes it
  final CategoryModel? category;

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
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.category,
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
      images: _parseImages(json['images'] ?? json['image_urls']),
      attributes: _parseAttributes(json['attributes']),
      averageRating: _parseDouble(json['average_rating']),
      categoryId: json['category_id']?.toString(),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      category: json['category'] is Map
          ? CategoryModel.fromJson(Map<String, dynamic>.from(json['category']))
          : null,
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
      'category_id': categoryId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'category': category?.toJson(),
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

  static List<String> _parseImages(dynamic images) {
    if (images == null) return [];

    // Handle List of images
    if (images is List) {
      return images
          .map((e) => _cleanImageUrl(e?.toString() ?? ''))
          .where((s) => s.isNotEmpty)
          .toList();
    }

    // Handle single string URL
    if (images is String) {
      final cleanUrl = _cleanImageUrl(images);
      return cleanUrl.isNotEmpty ? [cleanUrl] : [];
    }

    // Handle Set or other collection types that might be stringified with {}
    if (images is Set) {
      return images
          .map((e) => _cleanImageUrl(e?.toString() ?? ''))
          .where((s) => s.isNotEmpty)
          .toList();
    }

    return [];
  }

  /// Helper method to clean image URLs by removing curly braces and trimming
  static String _cleanImageUrl(String url) {
    if (url.isEmpty) return '';

    // Remove curly braces, square brackets, and extra whitespace
    String cleanUrl = url
        .replaceAll(RegExp(r'[{}[\]]'), '') // Remove {}, []
        .trim(); // Remove leading/trailing whitespace

    // Handle comma-separated URLs (take the first one if multiple)
    if (cleanUrl.contains(',')) {
      cleanUrl = cleanUrl.split(',').first.trim();
    }

    // If it's already an absolute URL, return as-is
    if (cleanUrl.startsWith('http') || cleanUrl.startsWith('https')) {
      return cleanUrl;
    }

    // If it's a server-relative path (starts with '/'), prefix base URL
    if (cleanUrl.startsWith('/')) {
      return '${AppIdentity.baseUrl}$cleanUrl';
    }

    // If it looks like a relative static path without leading slash, prefix with '/'
    if (cleanUrl.contains('static')) {
      return '${AppIdentity.baseUrl}/$cleanUrl';
    }

    return '';
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
