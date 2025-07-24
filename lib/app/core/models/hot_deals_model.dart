import 'product_model.dart';

/// Hot deals section model representing the structure from products.json
///
/// This model represents the hot deals section with its title, description,
/// and list of products from the JSON API response.
class HotDealsModel {
  final String title;
  final String description;
  final List<HotDealProduct> products;

  HotDealsModel({
    required this.title,
    required this.description,
    required this.products,
  });

  /// Create HotDealsModel from JSON
  factory HotDealsModel.fromJson(Map<String, dynamic> json) {
    return HotDealsModel(
      title: json['title'] as String,
      description: json['description'] as String,
      products: (json['products'] as List<dynamic>)
          .map(
            (productJson) =>
                HotDealProduct.fromJson(productJson as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  /// Convert HotDealsModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'HotDealsModel(title: $title, productsCount: ${products.length})';
  }
}

/// Hot deal product specific model matching the JSON structure
///
/// This model represents individual products in the hot deals section
/// with specific fields that match the JSON API response.
class HotDealProduct {
  final String id;
  final String name;
  final String brand;
  final double price;
  final double discountPrice;
  final int discountPercentage;
  final String unit;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String? badge;
  final bool inStock;
  final bool? fastDelivery;

  HotDealProduct({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.discountPrice,
    required this.discountPercentage,
    required this.unit,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    this.badge,
    required this.inStock,
    this.fastDelivery,
  });

  /// Create HotDealProduct from JSON
  factory HotDealProduct.fromJson(Map<String, dynamic> json) {
    return HotDealProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discountPrice'] as num).toDouble(),
      discountPercentage: json['discountPercentage'] as int,
      unit: json['unit'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      imageUrl: json['imageUrl'] as String,
      badge: json['badge'] as String?,
      inStock: json['inStock'] as bool,
      fastDelivery: json['fastDelivery'] as bool?,
    );
  }

  /// Convert HotDealProduct to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'price': price,
      'discountPrice': discountPrice,
      'discountPercentage': discountPercentage,
      'unit': unit,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'badge': badge,
      'inStock': inStock,
      'fastDelivery': fastDelivery,
    };
  }

  /// Convert to the existing Product model for cart operations
  Product toProduct() {
    return Product(
      id: id,
      name: name,
      description: 'Fresh $name from $brand',
      price: price,
      discountPrice: discountPrice,
      imageUrl: imageUrl,
      category: 'Groceries',
      brand: brand,
      rating: rating,
      reviewCount: reviewCount,
      stockQuantity: inStock ? 100 : 0,
      isInStock: inStock,
      isOnSale: discountPercentage > 0,
      tags: badge != null ? [badge!] : [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Get formatted price string with currency symbol
  String get formattedPrice => '₹${price.toStringAsFixed(0)}';

  /// Get formatted discount price string with currency symbol
  String get formattedDiscountPrice => '₹${discountPrice.toStringAsFixed(0)}';

  /// Get display text for unit/weight
  String get displayUnit => unit;

  /// Check if fast delivery is available
  bool get hasFastDelivery => fastDelivery ?? false;

  @override
  String toString() {
    return 'HotDealProduct(id: $id, name: $name, price: $price, discountPrice: $discountPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HotDealProduct && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
