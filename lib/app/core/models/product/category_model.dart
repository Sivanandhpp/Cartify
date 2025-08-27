// lib/app/core/models/product/category_model.dart
import 'package:cartify/app/core/config/app_config.dart';

/// Represents a product category with hierarchical structure
class CategoryModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String? parentId;
  final List<CategoryModel> children;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.parentId,
    this.children = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: _cleanCategoryImageUrl(json['image_url']?.toString()),
      parentId: json['parent_id']?.toString(),
      children:
          (json['children'] as List<dynamic>?)
              ?.map(
                (child) =>
                    CategoryModel.fromJson(child as Map<String, dynamic>),
              )
              .toList() ??
          [],
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'parent_id': parentId,
      'children': children.map((child) => child.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Check if this category has child categories
  bool get hasChildren => children.isNotEmpty;

  /// Get all descendant categories (children, grandchildren, etc.)
  List<CategoryModel> get allDescendants {
    final descendants = <CategoryModel>[];
    for (final child in children) {
      descendants.add(child);
      descendants.addAll(child.allDescendants);
    }
    return descendants;
  }

  /// Get all descendant IDs including this category's ID
  List<String> get allDescendantIds {
    final ids = <String>[id];
    for (final child in children) {
      ids.addAll(child.allDescendantIds);
    }
    return ids;
  }

  /// Find a child category by ID (recursive search)
  CategoryModel? findChildById(String categoryId) {
    if (id == categoryId) return this;

    for (final child in children) {
      final found = child.findChildById(categoryId);
      if (found != null) return found;
    }
    return null;
  }

  /// Get cleaned and formatted image URL
  String? get cleanImageUrl => imageUrl;

  /// Check if category has a valid image URL
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  /// Helper method to clean category image URLs by removing curly braces and building absolute URLs
  static String? _cleanCategoryImageUrl(String? url) {
    if (url == null || url.isEmpty) return null;

    // Remove curly braces, square brackets, and extra whitespace
    String cleanUrl = url
        .replaceAll(RegExp(r'[{}[\]]'), '') // Remove {}, []
        .trim(); // Remove leading/trailing whitespace

    if (cleanUrl.isEmpty) return null;

    // Handle comma-separated URLs (take the first one if multiple)
    if (cleanUrl.contains(',')) {
      cleanUrl = cleanUrl.split(',').first.trim();
    }

    // If it's already an absolute URL, return as-is
    if (cleanUrl.startsWith('http') || cleanUrl.startsWith('https')) {
      return cleanUrl;
    }

    // If it's a server-relative path (starts with '/'), prefix base URL
    if (cleanUrl.startsWith('/')) {
      return '${AppConfig.baseUrl}$cleanUrl';
    }

    // If it looks like a relative static path without leading slash, prefix with '/'
    if (cleanUrl.contains('static') ||
        cleanUrl.contains('category') ||
        cleanUrl.contains('image')) {
      return '${AppConfig.baseUrl}/$cleanUrl';
    }

    // For other relative paths, add base URL with leading slash
    return '${AppConfig.baseUrl}/$cleanUrl';
  }
}
