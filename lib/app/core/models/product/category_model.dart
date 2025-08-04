// lib/app/core/models/product/category_model.dart

/// Represents a product category.
class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final String? imageUrl;
  final List<CategoryModel> children;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
    required this.children,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      imageUrl: json['image_url'],
      children: (json['children'] as List? ?? [])
          .map((child) => CategoryModel.fromJson(child))
          .toList(),
    );
  }
}
