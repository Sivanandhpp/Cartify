/// Product catalog models for categories, products, and related entities
///
/// This file contains all models related to the product catalog including
/// categories, products with unit-based pricing, images, and product creation DTOs.

/// Product category model representing hierarchical product organization
///
/// Categories provide a way to organize products into logical groups
/// for easier navigation and filtering in the e-commerce platform.
class Category {
  /// Unique identifier for the category
  final String id;

  /// Display name of the category
  final String name;

  /// Detailed description of the category (optional)
  final String? description;

  /// URL to the category's icon or image (optional)
  final String? imageUrl;

  /// Parent category ID for hierarchical structure (optional)
  final String? parentId;

  /// Whether the category is currently active
  final bool isActive;

  /// Display order for sorting categories
  final int sortOrder;

  /// Timestamp when the category was created
  final DateTime createdAt;

  /// Timestamp when the category was last updated
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.parentId,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create instance from JSON response
  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String?,
    imageUrl: json['image_url'] as String?,
    parentId: json['parent_id'] as String?,
    isActive: json['is_active'] as bool,
    sortOrder: json['sort_order'] as int,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'image_url': imageUrl,
    'parent_id': parentId,
    'is_active': isActive,
    'sort_order': sortOrder,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  /// Create a copy with updated values
  Category copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? parentId,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    imageUrl: imageUrl ?? this.imageUrl,
    parentId: parentId ?? this.parentId,
    isActive: isActive ?? this.isActive,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  /// Check if this is a root category (no parent)
  bool get isRootCategory => parentId == null;

  /// Check if category has a parent
  bool get hasParent => parentId != null;

  @override
  String toString() =>
      'Category('
      'id: $id, '
      'name: $name, '
      'isActive: $isActive, '
      'hasParent: $hasParent)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          imageUrl == other.imageUrl &&
          parentId == other.parentId &&
          isActive == other.isActive &&
          sortOrder == other.sortOrder;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    imageUrl,
    parentId,
    isActive,
    sortOrder,
  );
}

/// Product image model for managing product visual assets
///
/// Represents individual images associated with a product,
/// including display order and URL information.
class ProductImage {
  /// Unique identifier for the image
  final String id;

  /// ID of the product this image belongs to
  final String productId;

  /// URL to access the image
  final String imageUrl;

  /// Alternative text for accessibility
  final String? altText;

  /// Display order for image sorting
  final int sortOrder;

  /// Whether this is the primary/featured image
  final bool isPrimary;

  /// Timestamp when the image was uploaded
  final DateTime createdAt;

  const ProductImage({
    required this.id,
    required this.productId,
    required this.imageUrl,
    this.altText,
    required this.sortOrder,
    required this.isPrimary,
    required this.createdAt,
  });

  /// Create instance from JSON response
  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
    id: json['id'] as String,
    productId: json['product_id'] as String,
    imageUrl: json['image_url'] as String,
    altText: json['alt_text'] as String?,
    sortOrder: json['sort_order'] as int,
    isPrimary: json['is_primary'] as bool,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {
    'id': id,
    'product_id': productId,
    'image_url': imageUrl,
    'alt_text': altText,
    'sort_order': sortOrder,
    'is_primary': isPrimary,
    'created_at': createdAt.toIso8601String(),
  };

  /// Create a copy with updated values
  ProductImage copyWith({
    String? id,
    String? productId,
    String? imageUrl,
    String? altText,
    int? sortOrder,
    bool? isPrimary,
    DateTime? createdAt,
  }) => ProductImage(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    imageUrl: imageUrl ?? this.imageUrl,
    altText: altText ?? this.altText,
    sortOrder: sortOrder ?? this.sortOrder,
    isPrimary: isPrimary ?? this.isPrimary,
    createdAt: createdAt ?? this.createdAt,
  );

  @override
  String toString() =>
      'ProductImage('
      'id: $id, '
      'productId: $productId, '
      'isPrimary: $isPrimary, '
      'sortOrder: $sortOrder)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductImage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          productId == other.productId &&
          imageUrl == other.imageUrl &&
          altText == other.altText &&
          sortOrder == other.sortOrder &&
          isPrimary == other.isPrimary;

  @override
  int get hashCode =>
      Object.hash(id, productId, imageUrl, altText, sortOrder, isPrimary);
}

/// Complete product model with unit-based pricing and measurement
///
/// Represents a product in the catalog with comprehensive information
/// including pricing, stock, measurements, and associated media.
class Product {
  /// Unique identifier for the product
  final String id;

  /// Product display name
  final String name;

  /// Detailed product description
  final String description;

  /// Base price per unit
  final double price;

  /// Available stock quantity
  final int stockQuantity;

  /// Category this product belongs to
  final String categoryId;

  /// Category information (populated in detailed responses)
  final Category? category;

  /// Measurement unit code (e.g., "g", "kg", "ml", "l", "pcs")
  final String? measureUnitCode;

  /// Amount per unit (e.g., 250 for "250g")
  final double? measureAmount;

  /// List of product images
  final List<ProductImage> images;

  /// Average rating from reviews (0.0 to 5.0)
  final double averageRating;

  /// Total number of reviews
  final int reviewCount;

  /// Whether the product is currently active/available
  final bool isActive;

  /// Whether the product is featured
  final bool isFeatured;

  /// ID of the seller who created this product
  final String sellerId;

  /// Timestamp when the product was created
  final DateTime createdAt;

  /// Timestamp when the product was last updated
  final DateTime updatedAt;

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
    this.images = const [],
    required this.averageRating,
    required this.reviewCount,
    required this.isActive,
    required this.isFeatured,
    required this.sellerId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create instance from JSON response
  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    price: (json['price'] as num).toDouble(),
    stockQuantity: json['stock_quantity'] as int,
    categoryId: json['category_id'] as String,
    category: json['category'] != null
        ? Category.fromJson(json['category'] as Map<String, dynamic>)
        : null,
    measureUnitCode: json['measure_unit_code'] as String?,
    measureAmount: json['measure_amount'] != null
        ? (json['measure_amount'] as num).toDouble()
        : null,
    images: json['images'] != null
        ? (json['images'] as List)
              .map((img) => ProductImage.fromJson(img as Map<String, dynamic>))
              .toList()
        : const [],
    averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
    reviewCount: json['review_count'] as int? ?? 0,
    isActive: json['is_active'] as bool,
    isFeatured: json['is_featured'] as bool? ?? false,
    sellerId: json['seller_id'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'stock_quantity': stockQuantity,
    'category_id': categoryId,
    'category': category?.toJson(),
    'measure_unit_code': measureUnitCode,
    'measure_amount': measureAmount,
    'images': images.map((img) => img.toJson()).toList(),
    'average_rating': averageRating,
    'review_count': reviewCount,
    'is_active': isActive,
    'is_featured': isFeatured,
    'seller_id': sellerId,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  /// Create a copy with updated values
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? stockQuantity,
    String? categoryId,
    Category? category,
    String? measureUnitCode,
    double? measureAmount,
    List<ProductImage>? images,
    double? averageRating,
    int? reviewCount,
    bool? isActive,
    bool? isFeatured,
    String? sellerId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    price: price ?? this.price,
    stockQuantity: stockQuantity ?? this.stockQuantity,
    categoryId: categoryId ?? this.categoryId,
    category: category ?? this.category,
    measureUnitCode: measureUnitCode ?? this.measureUnitCode,
    measureAmount: measureAmount ?? this.measureAmount,
    images: images ?? this.images,
    averageRating: averageRating ?? this.averageRating,
    reviewCount: reviewCount ?? this.reviewCount,
    isActive: isActive ?? this.isActive,
    isFeatured: isFeatured ?? this.isFeatured,
    sellerId: sellerId ?? this.sellerId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  /// Check if the product is currently in stock
  bool get isInStock => stockQuantity > 0;

  /// Check if the product is low on stock (less than 10 units)
  bool get isLowStock => stockQuantity < 10 && stockQuantity > 0;

  /// Check if the product is out of stock
  bool get isOutOfStock => stockQuantity <= 0;

  /// Get the primary product image
  ProductImage? get primaryImage {
    if (images.isEmpty) return null;

    // First try to find an image marked as primary
    final primaryImages = images.where((img) => img.isPrimary);
    if (primaryImages.isNotEmpty) return primaryImages.first;

    // If no primary image, return the first one
    return images.first;
  }

  /// Get all non-primary images
  List<ProductImage> get secondaryImages =>
      images.where((img) => !img.isPrimary).toList();

  /// Get formatted price with unit information
  String get formattedPrice {
    final priceStr = '₹${price.toStringAsFixed(2)}';
    if (measureAmount != null && measureUnitCode != null) {
      return '$priceStr per ${measureAmount!.toStringAsFixed(0)}$measureUnitCode';
    }
    return priceStr;
  }

  /// Get formatted measurement information
  String? get measurementInfo {
    if (measureAmount != null && measureUnitCode != null) {
      return '${measureAmount!.toStringAsFixed(0)}$measureUnitCode';
    }
    return null;
  }

  /// Get stock status as human-readable string
  String get stockStatus {
    if (isOutOfStock) return 'Out of Stock';
    if (isLowStock) return 'Low Stock';
    return 'In Stock';
  }

  /// Get formatted rating display
  String get formattedRating {
    if (reviewCount == 0) return 'No reviews';
    return '${averageRating.toStringAsFixed(1)} (${reviewCount} reviews)';
  }

  @override
  String toString() =>
      'Product('
      'id: $id, '
      'name: $name, '
      'price: ₹$price, '
      'stock: $stockQuantity, '
      'rating: ${averageRating.toStringAsFixed(1)})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          price == other.price &&
          stockQuantity == other.stockQuantity &&
          categoryId == other.categoryId &&
          measureUnitCode == other.measureUnitCode &&
          measureAmount == other.measureAmount &&
          isActive == other.isActive &&
          sellerId == other.sellerId;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    price,
    stockQuantity,
    categoryId,
    measureUnitCode,
    measureAmount,
    isActive,
    sellerId,
  );
}

/// Data transfer object for creating new products
///
/// Contains all required and optional fields for product creation.
/// Used by sellers and admins to add new products to the catalog.
class CreateProductDto {
  /// Product name
  final String name;

  /// Product description
  final String description;

  /// Price per unit
  final double price;

  /// Initial stock quantity
  final int stockQuantity;

  /// Category ID where the product belongs
  final String categoryId;

  /// Measurement unit code (optional)
  final String? measureUnitCode;

  /// Amount per unit (optional)
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
  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'price': price,
    'stock_quantity': stockQuantity,
    'category_id': categoryId,
    'measure_unit_code': measureUnitCode,
    'measure_amount': measureAmount,
  };

  /// Create instance from JSON
  factory CreateProductDto.fromJson(Map<String, dynamic> json) =>
      CreateProductDto(
        name: json['name'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        stockQuantity: json['stock_quantity'] as int,
        categoryId: json['category_id'] as String,
        measureUnitCode: json['measure_unit_code'] as String?,
        measureAmount: json['measure_amount'] != null
            ? (json['measure_amount'] as num).toDouble()
            : null,
      );

  /// Validate the DTO data
  bool get isValid =>
      name.isNotEmpty &&
      description.isNotEmpty &&
      price > 0 &&
      stockQuantity >= 0 &&
      categoryId.isNotEmpty &&
      (measureUnitCode == null || measureUnitCode!.isNotEmpty) &&
      (measureAmount == null || measureAmount! > 0);

  /// Get validation errors
  List<String> get validationErrors {
    final errors = <String>[];

    if (name.isEmpty) errors.add('Product name is required');
    if (description.isEmpty) errors.add('Product description is required');
    if (price <= 0) errors.add('Price must be greater than 0');
    if (stockQuantity < 0) errors.add('Stock quantity cannot be negative');
    if (categoryId.isEmpty) errors.add('Category is required');
    if (measureUnitCode != null && measureUnitCode!.isEmpty) {
      errors.add('Measure unit code cannot be empty if provided');
    }
    if (measureAmount != null && measureAmount! <= 0) {
      errors.add('Measure amount must be greater than 0 if provided');
    }

    return errors;
  }

  @override
  String toString() =>
      'CreateProductDto('
      'name: $name, '
      'price: ₹$price, '
      'stock: $stockQuantity, '
      'categoryId: $categoryId)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateProductDto &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          description == other.description &&
          price == other.price &&
          stockQuantity == other.stockQuantity &&
          categoryId == other.categoryId &&
          measureUnitCode == other.measureUnitCode &&
          measureAmount == other.measureAmount;

  @override
  int get hashCode => Object.hash(
    name,
    description,
    price,
    stockQuantity,
    categoryId,
    measureUnitCode,
    measureAmount,
  );
}
