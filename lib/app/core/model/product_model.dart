/// Enum for the product's availability status.
/// Using an enum is safer and more descriptive than a simple boolean.
enum StockStatus { inStock, outOfStock, preOrder }

/// Enum for the product's publishing status in the backend.
enum ProductStatus {
  published, // Visible to customers
  draft, // Not visible, work in progress
  archived, // Not visible, kept for records
}

/// Represents a single product variant, e.g., a T-shirt in a specific color and size.
class ProductVariant {
  /// Unique identifier for this specific variant.
  final String id;

  /// A name specific to the variant, e.g., "iPhone 15 Pro - 256GB, Natural Titanium".
  /// If null, the parent product name is used.
  final String? name;

  /// Stock Keeping Unit for this variant.
  final String sku;

  /// Price of this specific variant. It can override the parent product's price.
  final double price;

  /// Discounted price for this variant.
  final double? salePrice;

  /// Quantity of this variant in stock.
  final int stockQuantity;

  /// Availability status of this variant.
  final StockStatus stockStatus;

  /// List of image URLs specific to this variant (e.g., showing the blue T-shirt).
  final List<String> imageUrls;

  /// A map defining the attributes of this variant, e.g., {'Color': 'Blue', 'Size': 'M'}.
  final Map<String, String> attributes;

  ProductVariant({
    required this.id,
    this.name,
    required this.sku,
    required this.price,
    this.salePrice,
    required this.stockQuantity,
    required this.stockStatus,
    required this.imageUrls,
    required this.attributes,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] as String,
      name: json['name'] as String?,
      sku: json['sku'] as String,
      price: (json['price'] as num).toDouble(),
      salePrice: (json['salePrice'] as num?)?.toDouble(),
      stockQuantity: json['stockQuantity'] as int,
      stockStatus: StockStatus.values.byName(json['stockStatus'] as String),
      imageUrls: List<String>.from(json['imageUrls'] as List),
      attributes: Map<String, String>.from(json['attributes'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'price': price,
      'salePrice': salePrice,
      'stockQuantity': stockQuantity,
      'stockStatus': stockStatus.name,
      'imageUrls': imageUrls,
      'attributes': attributes,
    };
  }
}

/// The main product model, designed to be flexible for various e-commerce needs.
class ProductModel {
  /// Unique identifier for the product (e.g., UUID from a database).
  final String id;

  /// The main name of the product, e.g., "Men's Classic T-Shirt".
  final String name;

  /// Detailed description of the product. Can contain HTML for rich text formatting.
  final String description;

  /// A shorter, catchy description for list views or promotions.
  final String? shortDescription;

  /// The primary price of the product. For variable products, this might be a starting price.
  final double price;

  /// A discounted price, if the product is on sale.
  final double? salePrice;

  /// The currency code (e.g., "INR", "USD").
  final String currency;

  /// A list of product variants. If empty, it's a "simple" product.
  /// If populated, it's a "variable" product (e.g., different sizes/colors).
  final List<ProductVariant> variants;

  /// The main image used for thumbnails and list views.
  final String thumbnailUrl;

  /// A list of general image URLs for the product.
  /// Variant-specific images should be in the `ProductVariant` model.
  final List<String> imageUrls;

  /// List of categories the product belongs to (e.g., ["Apparel", "Men's", "T-Shirts"]).
  final List<String> categories;

  /// Brand name or a more complex Brand object ID.
  final String brand;

  /// Average user rating, typically from 0.0 to 5.0.
  final double averageRating;

  /// Total number of reviews submitted for this product.
  final int reviewCount;

  /// Technical specifications or additional details.
  /// e.g., {'Material': '100% Cotton', 'Fit': 'Regular'}
  final Map<String, String> specifications;

  /// The date and time when the product was created.
  final DateTime createdAt;

  /// The date and time when the product was last updated.
  final DateTime updatedAt;

  /// Publishing status of the product.
  final ProductStatus status;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    this.shortDescription,
    required this.price,
    this.salePrice,
    this.currency = 'INR', // Default currency
    required this.variants,
    required this.thumbnailUrl,
    required this.imageUrls,
    required this.categories,
    required this.brand,
    this.averageRating = 0.0,
    this.reviewCount = 0,
    required this.specifications,
    required this.createdAt,
    required this.updatedAt,
    this.status = ProductStatus.published,
  });

  /// A computed property to determine if the product is a variable product.
  bool get isVariable => variants.isNotEmpty;

  /// A computed property to check if the product is on sale.
  /// It checks the base price and the prices of all variants.
  bool get isOnSale {
    if (salePrice != null && salePrice! < price) return true;
    return variants.any((v) => v.salePrice != null && v.salePrice! < v.price);
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      shortDescription: json['shortDescription'] as String?,
      price: (json['price'] as num).toDouble(),
      salePrice: (json['salePrice'] as num?)?.toDouble(),
      currency: json['currency'] as String,
      variants: (json['variants'] as List)
          .map((v) => ProductVariant.fromJson(v as Map<String, dynamic>))
          .toList(),
      thumbnailUrl: json['thumbnailUrl'] as String,
      imageUrls: List<String>.from(json['imageUrls'] as List),
      categories: List<String>.from(json['categories'] as List),
      brand: json['brand'] as String,
      averageRating: (json['averageRating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      specifications: Map<String, String>.from(json['specifications'] as Map),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      status: ProductStatus.values.byName(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'shortDescription': shortDescription,
      'price': price,
      'salePrice': salePrice,
      'currency': currency,
      'variants': variants.map((v) => v.toJson()).toList(),
      'thumbnailUrl': thumbnailUrl,
      'imageUrls': imageUrls,
      'categories': categories,
      'brand': brand,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'specifications': specifications,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'status': status.name,
    };
  }
}
