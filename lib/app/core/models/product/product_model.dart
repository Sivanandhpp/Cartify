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
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: _parsePrice(json['price']),
      stock: _parseStock(json['stock']),
      imageUrls: _parseImageUrls(json['image_urls']),
    );
  }

  static double _parsePrice(dynamic price) {
    if (price is num) return price.toDouble();
    if (price is String) {
      return double.tryParse(price) ?? 0.0;
    }
    return 0.0;
  }

  static int _parseStock(dynamic stock) {
    if (stock is int) return stock;
    if (stock is String) {
      return int.tryParse(stock) ?? 0;
    }
    if (stock is double) return stock.round();
    return 0;
  }

  static List<String> _parseImageUrls(dynamic imageUrls) {
    if (imageUrls is List) {
      return imageUrls.map((url) => url?.toString() ?? '').toList();
    }
    if (imageUrls is String) {
      return [imageUrls];
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'image_urls': imageUrls,
    };
  }
}
