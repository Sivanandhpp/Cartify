import 'package:cartify/app/core/config/app_config.dart';
import 'package:cartify/app/core/services/api_clean_url.dart';

/// Represents a product category with hierarchical structure
class CategoryModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String? parentId;
  final bool isActive;
  final String userId;
  final List<CategoryModel> children;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.parentId,
    required this.isActive,
    required this.userId,
    this.children = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: ApiCleanUrl.cleanCategoryImageUrl(
        json['image_url']?.toString(),
      ),
      parentId: json['parent_id']?.toString(),
      isActive: json['is_active'] ?? true,
      userId: json['user_id'] ?? '',
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
      'is_active': isActive,
      'user_id': userId,
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
}
