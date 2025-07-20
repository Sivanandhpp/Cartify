/// Product model representing an item available for purchase
///
/// This model contains all the necessary information about a product
/// including pricing, inventory, and display information.
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final String imageUrl;
  final List<String> imageUrls;
  final String category;
  final String brand;
  final double rating;
  final int reviewCount;
  final int stockQuantity;
  final bool isInStock;
  final bool isFeatured;
  final bool isOnSale;
  final Map<String, dynamic> specifications;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.imageUrl,
    this.imageUrls = const [],
    required this.category,
    required this.brand,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.stockQuantity = 0,
    this.isInStock = true,
    this.isFeatured = false,
    this.isOnSale = false,
    this.specifications = const {},
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get the effective price (discount price if available, otherwise regular price)
  double get effectivePrice => discountPrice ?? price;

  /// Get discount percentage
  double get discountPercentage {
    if (discountPrice == null) return 0.0;
    return ((price - discountPrice!) / price) * 100;
  }

  /// Check if product has discount
  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  /// Get formatted price string
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  /// Get formatted discount price string
  String get formattedDiscountPrice =>
      discountPrice != null ? '\$${discountPrice!.toStringAsFixed(2)}' : '';

  /// Get formatted effective price string
  String get formattedEffectivePrice =>
      '\$${effectivePrice.toStringAsFixed(2)}';

  /// Create a copy of this product with updated fields
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? discountPrice,
    String? imageUrl,
    List<String>? imageUrls,
    String? category,
    String? brand,
    double? rating,
    int? reviewCount,
    int? stockQuantity,
    bool? isInStock,
    bool? isFeatured,
    bool? isOnSale,
    Map<String, dynamic>? specifications,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      isInStock: isInStock ?? this.isInStock,
      isFeatured: isFeatured ?? this.isFeatured,
      isOnSale: isOnSale ?? this.isOnSale,
      specifications: specifications ?? this.specifications,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discountPrice': discountPrice,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'category': category,
      'brand': brand,
      'rating': rating,
      'reviewCount': reviewCount,
      'stockQuantity': stockQuantity,
      'isInStock': isInStock,
      'isFeatured': isFeatured,
      'isOnSale': isOnSale,
      'specifications': specifications,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: json['discountPrice'] != null
          ? (json['discountPrice'] as num).toDouble()
          : null,
      imageUrl: json['imageUrl'] as String,
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      category: json['category'] as String,
      brand: json['brand'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      stockQuantity: json['stockQuantity'] as int? ?? 0,
      isInStock: json['isInStock'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isOnSale: json['isOnSale'] as bool? ?? false,
      specifications: Map<String, dynamic>.from(json['specifications'] ?? {}),
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}




