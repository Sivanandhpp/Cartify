// lib/app/core/models/dashboard/dashboard_model.dart
import 'package:cartify/app/core/index.dart';

/// Represents the entire dashboard structure.
class DashboardModel {
  final List<DashboardSection> sections;

  DashboardModel({required this.sections});

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      sections: (json['sections'] as List)
          .map((section) => DashboardSection.fromJson(section))
          .toList(),
    );
  }
  // Helper methods to get specific sections
  List<BannerModel> get promotionalBanners {
    final section = sections.firstWhere(
      (s) => s.type == 'PROMOTIONAL_BANNERS',
      orElse: () => DashboardSection(type: 'PROMOTIONAL_BANNERS', data: []),
    );
    return section.data.map((item) => BannerModel.fromJson(item)).toList();
  }

  List<CategoryModel> get categories {
    final section = sections.firstWhere(
      (s) => s.type == 'CATEGORIES_GRID',
      orElse: () => DashboardSection(type: 'CATEGORIES_GRID', data: []),
    );
    return section.data.map((item) => CategoryModel.fromJson(item)).toList();
  }

  List<ProductModel> get featuredProducts {
    final section = sections.firstWhere(
      (s) => s.type == 'FEATURED_PRODUCTS',
      orElse: () => DashboardSection(type: 'FEATURED_PRODUCTS', data: []),
    );
    return section.data.map((item) => ProductModel.fromJson(item)).toList();
  }

  String? get featuredProductsTitle {
    final section = sections.firstWhere(
      (s) => s.type == 'FEATURED_PRODUCTS',
      orElse: () => DashboardSection(type: 'FEATURED_PRODUCTS', data: []),
    );
    return section.title;
  }
}



/// Represents a single section in the dashboard.
class DashboardSection {
  final String type;
  final String? title;
  final List<dynamic> data;

  DashboardSection({required this.type, this.title, required this.data});

  factory DashboardSection.fromJson(Map<String, dynamic> json) {
    return DashboardSection(
      type: json['type'],
      title: json['title'],
      data: json['data'],
    );
  }
}
