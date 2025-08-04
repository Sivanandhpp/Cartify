// lib/app/core/models/product/product_model.dart

/// Represents a product in the catalog.
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final List<String> imageUrls;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrls,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
      imageUrls: List<String>.from(json['image_urls']),
    );
  }
}
