import 'product_model.dart';

/// API product model for external data
class ApiProduct {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String subCategory;
  final String volume;
  final double alcoholContentABV;
  final double priceINR;
  final int offerPercentage;
  final double offerPrice;
  final double rating;
  final int reviewCount;
  final String description;
  final String imageUrl;

  const ApiProduct({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.subCategory,
    required this.volume,
    required this.alcoholContentABV,
    required this.priceINR,
    required this.offerPercentage,
    required this.offerPrice,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.imageUrl,
  });

  /// Create ApiProduct from JSON
  factory ApiProduct.fromJson(Map<String, dynamic> json) {
    return ApiProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      category: json['category'] as String,
      subCategory: json['subCategory'] as String,
      volume: json['volume'] as String,
      alcoholContentABV: (json['alcoholContentABV'] as num).toDouble(),
      priceINR: (json['priceINR'] as num).toDouble(),
      offerPercentage: json['offerPercentage'] as int,
      offerPrice: (json['offerPrice'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  /// Convert ApiProduct to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'subCategory': subCategory,
      'volume': volume,
      'alcoholContentABV': alcoholContentABV,
      'priceINR': priceINR,
      'offerPercentage': offerPercentage,
      'offerPrice': offerPrice,
      'rating': rating,
      'reviewCount': reviewCount,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  /// Convert to Product model for cart integration
  Product toProduct() {
    return Product(
      id: id,
      name: name,
      description: description,
      price: priceINR,
      discountPrice: offerPrice,
      imageUrl: imageUrl,
      category: category,
      brand: brand,
      rating: rating,
      reviewCount: reviewCount,
      stockQuantity: 100, // Mock stock
      isInStock: true,
      isOnSale: offerPercentage > 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Get formatted volume with unit
  String get formattedVolume => '$volume ($alcoholContentABV%)';

  /// Get discount percentage as string
  String get discountText => '$offerPercentage% OFF';

  /// Get formatted original price
  String get formattedOriginalPrice => '₹${priceINR.toStringAsFixed(0)}';

  /// Get formatted offer price
  String get formattedOfferPrice => '₹${offerPrice.toStringAsFixed(0)}';

  /// Get formatted rating with review count
  String get formattedRating => '$rating ($reviewCount)';
}
