/// Dashboard models for dynamic home screen content
///
/// This file contains models for the dashboard sections that provide
/// a structured approach to building dynamic mobile app home screens
/// with various content types and layouts.

import '../catalog/catalog_models.dart';

/// Enumeration of different section types available in the dashboard
///
/// Defines the various types of content sections that can be displayed
/// on the home screen, each with its own layout and presentation style.
enum DashboardSectionType {
  /// Hero banner section with promotional content
  banner,

  /// Featured products showcase
  featuredProducts,

  /// Product categories grid
  categories,

  /// Recently added products
  recentProducts,

  /// Top-rated products
  topRated,

  /// Products on sale/discount
  onSale,

  /// Recommended products for the user
  recommended,

  /// Custom promotional section
  promotion,

  /// Popular products in trending
  trending,

  /// Collection of related products
  collection,
}

/// Extension to handle DashboardSectionType utilities
extension DashboardSectionTypeExtension on DashboardSectionType {
  /// Convert section type to string for API communication
  String get value {
    switch (this) {
      case DashboardSectionType.banner:
        return 'banner';
      case DashboardSectionType.featuredProducts:
        return 'featured_products';
      case DashboardSectionType.categories:
        return 'categories';
      case DashboardSectionType.recentProducts:
        return 'recent_products';
      case DashboardSectionType.topRated:
        return 'top_rated';
      case DashboardSectionType.onSale:
        return 'on_sale';
      case DashboardSectionType.recommended:
        return 'recommended';
      case DashboardSectionType.promotion:
        return 'promotion';
      case DashboardSectionType.trending:
        return 'trending';
      case DashboardSectionType.collection:
        return 'collection';
    }
  }

  /// Create DashboardSectionType from string value
  static DashboardSectionType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'banner':
        return DashboardSectionType.banner;
      case 'featured_products':
        return DashboardSectionType.featuredProducts;
      case 'categories':
        return DashboardSectionType.categories;
      case 'recent_products':
        return DashboardSectionType.recentProducts;
      case 'top_rated':
        return DashboardSectionType.topRated;
      case 'on_sale':
        return DashboardSectionType.onSale;
      case 'recommended':
        return DashboardSectionType.recommended;
      case 'promotion':
        return DashboardSectionType.promotion;
      case 'trending':
        return DashboardSectionType.trending;
      case 'collection':
        return DashboardSectionType.collection;
      default:
        return DashboardSectionType.featuredProducts; // Default fallback
    }
  }

  /// Get display title for the section
  String get displayTitle {
    switch (this) {
      case DashboardSectionType.banner:
        return 'Promotions';
      case DashboardSectionType.featuredProducts:
        return 'Featured Products';
      case DashboardSectionType.categories:
        return 'Shop by Category';
      case DashboardSectionType.recentProducts:
        return 'Recently Added';
      case DashboardSectionType.topRated:
        return 'Top Rated';
      case DashboardSectionType.onSale:
        return 'On Sale';
      case DashboardSectionType.recommended:
        return 'Recommended for You';
      case DashboardSectionType.promotion:
        return 'Special Offers';
      case DashboardSectionType.trending:
        return 'Trending Now';
      case DashboardSectionType.collection:
        return 'Collections';
    }
  }

  /// Check if this section type contains products
  bool get containsProducts {
    switch (this) {
      case DashboardSectionType.featuredProducts:
      case DashboardSectionType.recentProducts:
      case DashboardSectionType.topRated:
      case DashboardSectionType.onSale:
      case DashboardSectionType.recommended:
      case DashboardSectionType.trending:
      case DashboardSectionType.collection:
        return true;
      case DashboardSectionType.banner:
      case DashboardSectionType.categories:
      case DashboardSectionType.promotion:
        return false;
    }
  }

  /// Check if this section type contains categories
  bool get containsCategories => this == DashboardSectionType.categories;

  /// Check if this section type is promotional content
  bool get isPromotional =>
      this == DashboardSectionType.banner ||
      this == DashboardSectionType.promotion;
}

/// Banner item model for promotional content
///
/// Represents individual banner items with images, text, and action data
/// for promotional sections and marketing campaigns.
class BannerItem {
  /// Unique identifier for the banner
  final String id;

  /// Banner image URL
  final String imageUrl;

  /// Banner title (optional)
  final String? title;

  /// Banner subtitle or description (optional)
  final String? subtitle;

  /// Action type (e.g., "product", "category", "external_link")
  final String? actionType;

  /// Action data (product ID, category ID, URL, etc.)
  final String? actionData;

  /// Display order for banner sorting
  final int sortOrder;

  /// Whether the banner is currently active
  final bool isActive;

  const BannerItem({
    required this.id,
    required this.imageUrl,
    this.title,
    this.subtitle,
    this.actionType,
    this.actionData,
    required this.sortOrder,
    required this.isActive,
  });

  /// Create instance from JSON response
  factory BannerItem.fromJson(Map<String, dynamic> json) => BannerItem(
    id: json['id'] as String,
    imageUrl: json['image_url'] as String,
    title: json['title'] as String?,
    subtitle: json['subtitle'] as String?,
    actionType: json['action_type'] as String?,
    actionData: json['action_data'] as String?,
    sortOrder: json['sort_order'] as int,
    isActive: json['is_active'] as bool,
  );

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {
    'id': id,
    'image_url': imageUrl,
    'title': title,
    'subtitle': subtitle,
    'action_type': actionType,
    'action_data': actionData,
    'sort_order': sortOrder,
    'is_active': isActive,
  };

  /// Check if the banner has an action configured
  bool get hasAction => actionType != null && actionData != null;

  /// Check if this is a product-linking banner
  bool get isProductBanner => actionType == 'product';

  /// Check if this is a category-linking banner
  bool get isCategoryBanner => actionType == 'category';

  /// Check if this is an external link banner
  bool get isExternalLinkBanner => actionType == 'external_link';

  @override
  String toString() =>
      'BannerItem('
      'id: $id, '
      'title: $title, '
      'hasAction: $hasAction, '
      'isActive: $isActive)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BannerItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          imageUrl == other.imageUrl &&
          title == other.title &&
          subtitle == other.subtitle &&
          actionType == other.actionType &&
          actionData == other.actionData &&
          sortOrder == other.sortOrder &&
          isActive == other.isActive;

  @override
  int get hashCode => Object.hash(
    id,
    imageUrl,
    title,
    subtitle,
    actionType,
    actionData,
    sortOrder,
    isActive,
  );
}

/// Individual dashboard section containing specific content
///
/// Represents a single section in the dashboard with its type,
/// content, and display configuration. Each section can contain
/// different types of data based on its section type.
class DashboardSection {
  /// Unique identifier for the section
  final String id;

  /// Type of the section determining its layout and content
  final DashboardSectionType type;

  /// Display title for the section
  final String title;

  /// Optional subtitle or description
  final String? subtitle;

  /// Products associated with this section (if applicable)
  final List<Product> products;

  /// Categories associated with this section (if applicable)
  final List<Category> categories;

  /// Banner items for promotional sections (if applicable)
  final List<BannerItem> banners;

  /// Display order for section sorting
  final int sortOrder;

  /// Whether the section is currently visible
  final bool isVisible;

  /// Maximum number of items to display in this section
  final int? maxItems;

  /// Whether to show "View All" action for this section
  final bool showViewAll;

  /// Additional metadata for the section
  final Map<String, dynamic>? metadata;

  const DashboardSection({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.products = const [],
    this.categories = const [],
    this.banners = const [],
    required this.sortOrder,
    required this.isVisible,
    this.maxItems,
    this.showViewAll = true,
    this.metadata,
  });

  /// Create instance from JSON response
  factory DashboardSection.fromJson(Map<String, dynamic> json) =>
      DashboardSection(
        id: json['id'] as String,
        type: DashboardSectionTypeExtension.fromString(json['type'] as String),
        title: json['title'] as String,
        subtitle: json['subtitle'] as String?,
        products: json['products'] != null
            ? (json['products'] as List)
                  .map(
                    (product) =>
                        Product.fromJson(product as Map<String, dynamic>),
                  )
                  .toList()
            : const [],
        categories: json['categories'] != null
            ? (json['categories'] as List)
                  .map(
                    (category) =>
                        Category.fromJson(category as Map<String, dynamic>),
                  )
                  .toList()
            : const [],
        banners: json['banners'] != null
            ? (json['banners'] as List)
                  .map(
                    (banner) =>
                        BannerItem.fromJson(banner as Map<String, dynamic>),
                  )
                  .toList()
            : const [],
        sortOrder: json['sort_order'] as int,
        isVisible: json['is_visible'] as bool,
        maxItems: json['max_items'] as int?,
        showViewAll: json['show_view_all'] as bool? ?? true,
        metadata: json['metadata'] as Map<String, dynamic>?,
      );

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.value,
    'title': title,
    'subtitle': subtitle,
    'products': products.map((product) => product.toJson()).toList(),
    'categories': categories.map((category) => category.toJson()).toList(),
    'banners': banners.map((banner) => banner.toJson()).toList(),
    'sort_order': sortOrder,
    'is_visible': isVisible,
    'max_items': maxItems,
    'show_view_all': showViewAll,
    'metadata': metadata,
  };

  /// Create a copy with updated values
  DashboardSection copyWith({
    String? id,
    DashboardSectionType? type,
    String? title,
    String? subtitle,
    List<Product>? products,
    List<Category>? categories,
    List<BannerItem>? banners,
    int? sortOrder,
    bool? isVisible,
    int? maxItems,
    bool? showViewAll,
    Map<String, dynamic>? metadata,
  }) => DashboardSection(
    id: id ?? this.id,
    type: type ?? this.type,
    title: title ?? this.title,
    subtitle: subtitle ?? this.subtitle,
    products: products ?? this.products,
    categories: categories ?? this.categories,
    banners: banners ?? this.banners,
    sortOrder: sortOrder ?? this.sortOrder,
    isVisible: isVisible ?? this.isVisible,
    maxItems: maxItems ?? this.maxItems,
    showViewAll: showViewAll ?? this.showViewAll,
    metadata: metadata ?? this.metadata,
  );

  /// Check if the section has any content
  bool get hasContent =>
      products.isNotEmpty || categories.isNotEmpty || banners.isNotEmpty;

  /// Get the count of items in this section
  int get itemCount {
    if (type.containsProducts) return products.length;
    if (type.containsCategories) return categories.length;
    if (type.isPromotional) return banners.length;
    return 0;
  }

  /// Check if the section should show a "View All" button
  bool get shouldShowViewAll =>
      showViewAll &&
      hasContent &&
      (maxItems == null || itemCount > (maxItems ?? 0));

  /// Get items limited by maxItems (for display purposes)
  DashboardSection get limitedItems {
    if (maxItems == null) return this;

    return copyWith(
      products: type.containsProducts && products.length > maxItems!
          ? products.take(maxItems!).toList()
          : products,
      categories: type.containsCategories && categories.length > maxItems!
          ? categories.take(maxItems!).toList()
          : categories,
      banners: type.isPromotional && banners.length > maxItems!
          ? banners.take(maxItems!).toList()
          : banners,
    );
  }

  @override
  String toString() =>
      'DashboardSection('
      'id: $id, '
      'type: ${type.value}, '
      'title: $title, '
      'itemCount: $itemCount, '
      'isVisible: $isVisible)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardSection &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          title == other.title &&
          subtitle == other.subtitle &&
          sortOrder == other.sortOrder &&
          isVisible == other.isVisible &&
          maxItems == other.maxItems &&
          showViewAll == other.showViewAll;

  @override
  int get hashCode => Object.hash(
    id,
    type,
    title,
    subtitle,
    sortOrder,
    isVisible,
    maxItems,
    showViewAll,
  );
}

/// Complete dashboard response containing all sections
///
/// Main model for the dashboard API response that contains
/// all sections in their proper order for display on the home screen.
class DashboardResponse {
  /// List of dashboard sections in display order
  final List<DashboardSection> sections;

  /// Timestamp when the dashboard data was last updated
  final DateTime lastUpdated;

  /// Version identifier for cache management
  final String? version;

  /// Additional metadata for the dashboard
  final Map<String, dynamic>? metadata;

  const DashboardResponse({
    required this.sections,
    required this.lastUpdated,
    this.version,
    this.metadata,
  });

  /// Create instance from JSON response
  factory DashboardResponse.fromJson(Map<String, dynamic> json) =>
      DashboardResponse(
        sections: (json['sections'] as List)
            .map(
              (section) =>
                  DashboardSection.fromJson(section as Map<String, dynamic>),
            )
            .toList(),
        lastUpdated: DateTime.parse(json['last_updated'] as String),
        version: json['version'] as String?,
        metadata: json['metadata'] as Map<String, dynamic>?,
      );

  /// Convert to JSON for caching
  Map<String, dynamic> toJson() => {
    'sections': sections.map((section) => section.toJson()).toList(),
    'last_updated': lastUpdated.toIso8601String(),
    'version': version,
    'metadata': metadata,
  };

  /// Create a copy with updated values
  DashboardResponse copyWith({
    List<DashboardSection>? sections,
    DateTime? lastUpdated,
    String? version,
    Map<String, dynamic>? metadata,
  }) => DashboardResponse(
    sections: sections ?? this.sections,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    version: version ?? this.version,
    metadata: metadata ?? this.metadata,
  );

  /// Get only visible sections
  List<DashboardSection> get visibleSections =>
      sections.where((section) => section.isVisible).toList();

  /// Get sections sorted by sort order
  List<DashboardSection> get sortedSections {
    final sortedList = List<DashboardSection>.from(sections);
    sortedList.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return sortedList;
  }

  /// Get visible sections sorted by sort order (ready for display)
  List<DashboardSection> get displaySections {
    return sortedSections.where((section) => section.isVisible).toList();
  }

  /// Get sections by type
  List<DashboardSection> getSectionsByType(DashboardSectionType type) =>
      sections.where((section) => section.type == type).toList();

  /// Get all products from all sections
  List<Product> get allProducts =>
      sections.expand((section) => section.products).toList();

  /// Get all categories from all sections
  List<Category> get allCategories =>
      sections.expand((section) => section.categories).toList();

  /// Get all banners from all sections
  List<BannerItem> get allBanners =>
      sections.expand((section) => section.banners).toList();

  /// Check if dashboard has any content
  bool get hasContent => sections.any((section) => section.hasContent);

  /// Get total number of sections
  int get sectionCount => sections.length;

  /// Get total number of visible sections
  int get visibleSectionCount => visibleSections.length;

  @override
  String toString() =>
      'DashboardResponse('
      'sectionCount: $sectionCount, '
      'visibleSections: $visibleSectionCount, '
      'lastUpdated: $lastUpdated, '
      'version: $version)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardResponse &&
          runtimeType == other.runtimeType &&
          sections.length == other.sections.length &&
          lastUpdated == other.lastUpdated &&
          version == other.version;

  @override
  int get hashCode => Object.hash(sections.length, lastUpdated, version);
}
