/// Product and category related models for Cartify
/// These models handle catalog data structures for products and categories

/// Model for product category
class ProductCategory {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductCategory({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON response
  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      imageUrl: json['image_url'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Model for product with all details
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stockQuantity;
  final String categoryId;
  final ProductCategory? category;
  final String? measureUnitCode;
  final double? measureAmount;
  final List<String> imageUrls;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? averageRating;
  final int? reviewCount;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.categoryId,
    this.category,
    this.measureUnitCode,
    this.measureAmount,
    required this.imageUrls,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.averageRating,
    this.reviewCount,
  });

  /// Create from JSON response
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stockQuantity: json['stock_quantity'] ?? 0,
      categoryId: json['category_id'] ?? '',
      category: json['category'] != null
          ? ProductCategory.fromJson(json['category'])
          : null,
      measureUnitCode: json['measureUnitCode'],
      measureAmount: json['measureAmount']?.toDouble(),
      imageUrls:
          (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      averageRating: json['average_rating']?.toDouble(),
      reviewCount: json['review_count'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock_quantity': stockQuantity,
      'category_id': categoryId,
      'category': category?.toJson(),
      'measureUnitCode': measureUnitCode,
      'measureAmount': measureAmount,
      'image_urls': imageUrls,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'average_rating': averageRating,
      'review_count': reviewCount,
    };
  }

  /// Get primary image URL or placeholder
  String get primaryImageUrl {
    if (imageUrls.isNotEmpty) {
      return imageUrls.first;
    }
    return 'assets/images/placeholders/product_placeholder.png';
  }

  /// Check if product is in stock
  bool get isInStock => stockQuantity > 0;

  /// Get formatted price with unit
  String get formattedPrice {
    if (measureAmount != null && measureUnitCode != null) {
      return '₹$price/${measureAmount!.toInt()}$measureUnitCode';
    }
    return '₹$price';
  }

  /// Get stock status text
  String get stockStatus {
    if (stockQuantity == 0) return 'Out of Stock';
    if (stockQuantity < 10) return 'Low Stock';
    return 'In Stock';
  }
}

/// Model for creating a new product
class CreateProductDto {
  final String name;
  final String description;
  final double price;
  final int stockQuantity;
  final String categoryId;
  final String? measureUnitCode;
  final double? measureAmount;

  const CreateProductDto({
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.categoryId,
    this.measureUnitCode,
    this.measureAmount,
  });

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'stock_quantity': stockQuantity,
      'category_id': categoryId,
      'measureUnitCode': measureUnitCode,
      'measureAmount': measureAmount,
    };
  }
}

/// Model for dashboard sections
class DashboardSection {
  final String type;
  final String title;
  final List<dynamic> data;

  const DashboardSection({
    required this.type,
    required this.title,
    required this.data,
  });

  /// Create from JSON response
  factory DashboardSection.fromJson(Map<String, dynamic> json) {
    return DashboardSection(
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      data: json['data'] ?? [],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'type': type, 'title': title, 'data': data};
  }

  /// Get products from data if this is a product section
  List<Product> get products {
    if (type == 'products') {
      return data.map((item) => Product.fromJson(item)).toList();
    }
    return [];
  }

  /// Get categories from data if this is a category section
  List<ProductCategory> get categories {
    if (type == 'categories') {
      return data.map((item) => ProductCategory.fromJson(item)).toList();
    }
    return [];
  }
}
