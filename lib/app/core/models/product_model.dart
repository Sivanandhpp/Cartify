/// API product model for external data
class Product {
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

  const Product({
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

  /// Create Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
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

  /// Convert Product to JSON
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

  /// Get list of image URLs from comma-separated string
  List<String> get imageList {
    if (imageUrl.isEmpty) return [];
    return imageUrl
        .split(',')
        .map((url) => url.trim())
        .where((url) => url.isNotEmpty)
        .toList();
  }

  /// Get number of images
  int get numberOfImages => imageList.length;

  /// Check if product has discount
  bool get hasDiscount => offerPercentage > 0;

  /// Get discount percentage as double
  double get discountPercentage => offerPercentage.toDouble();

  /// Get formatted price string (using priceINR)
  String get formattedPrice => '₹${priceINR.toStringAsFixed(0)}';

  /// Get formatted discount price string (using offerPrice)
  String get formattedDiscountPrice => '₹${offerPrice.toStringAsFixed(0)}';
}
