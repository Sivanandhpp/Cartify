/// Dashboard API Service for Cartify
/// Handles fetching dashboard data including featured products,
/// categories, banners, and other home screen content

import 'package:get/get.dart';

import '../../models/product_models.dart';
import '../api_service.dart';
import '../log_service.dart';
import '../error_service.dart';

/// Service for dashboard API calls
class DashboardApiService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  /// Get complete dashboard data for home screen
  /// Returns structured sections for building dynamic UI
  Future<List<DashboardSection>> getDashboardData() async {
    try {
      LogService.info('Fetching dashboard data');

      final response = await _apiService.get('/dashboard');

      if (response.statusCode == 200) {
        final List<dynamic> sectionsData = response.data ?? [];
        final sections = sectionsData
            .map((data) => DashboardSection.fromJson(data))
            .toList();

        LogService.info(
          'Dashboard data fetched successfully with ${sections.length} sections',
        );
        return sections;
      } else {
        LogService.error(
          'Failed to fetch dashboard data: ${response.statusCode}',
        );
        ErrorService.showError('Failed to load dashboard. Please try again.');
        return [];
      }
    } catch (e) {
      LogService.error('Error fetching dashboard data: $e');
      ErrorService.showError('Failed to load dashboard. Please try again.');
      return [];
    }
  }

  /// Get featured products from dashboard
  /// Convenience method to extract featured products
  Future<List<Product>> getFeaturedProducts() async {
    try {
      LogService.info('Fetching featured products');

      final sections = await getDashboardData();
      final featuredSection = sections.firstWhereOrNull(
        (section) => section.type == 'featured_products',
      );

      if (featuredSection != null) {
        final products = featuredSection.products;
        LogService.info('Found ${products.length} featured products');
        return products;
      } else {
        LogService.info('No featured products section found');
        return [];
      }
    } catch (e) {
      LogService.error('Error fetching featured products: $e');
      return [];
    }
  }

  /// Get categories from dashboard
  /// Convenience method to extract categories
  Future<List<ProductCategory>> getDashboardCategories() async {
    try {
      LogService.info('Fetching dashboard categories');

      final sections = await getDashboardData();
      final categorySection = sections.firstWhereOrNull(
        (section) => section.type == 'categories',
      );

      if (categorySection != null) {
        final categories = categorySection.categories;
        LogService.info('Found ${categories.length} categories');
        return categories;
      } else {
        LogService.info('No categories section found');
        return [];
      }
    } catch (e) {
      LogService.error('Error fetching dashboard categories: $e');
      return [];
    }
  }

  /// Get sale products from dashboard
  /// Convenience method to extract sale/discounted products
  Future<List<Product>> getSaleProducts() async {
    try {
      LogService.info('Fetching sale products');

      final sections = await getDashboardData();
      final saleSection = sections.firstWhereOrNull(
        (section) => section.type == 'sale_products',
      );

      if (saleSection != null) {
        final products = saleSection.products;
        LogService.info('Found ${products.length} sale products');
        return products;
      } else {
        LogService.info('No sale products section found');
        return [];
      }
    } catch (e) {
      LogService.error('Error fetching sale products: $e');
      return [];
    }
  }

  /// Get new arrivals from dashboard
  /// Convenience method to extract new products
  Future<List<Product>> getNewArrivals() async {
    try {
      LogService.info('Fetching new arrivals');

      final sections = await getDashboardData();
      final newSection = sections.firstWhereOrNull(
        (section) => section.type == 'new_arrivals',
      );

      if (newSection != null) {
        final products = newSection.products;
        LogService.info('Found ${products.length} new arrivals');
        return products;
      } else {
        LogService.info('No new arrivals section found');
        return [];
      }
    } catch (e) {
      LogService.error('Error fetching new arrivals: $e');
      return [];
    }
  }

  /// Get popular products from dashboard
  /// Convenience method to extract popular/trending products
  Future<List<Product>> getPopularProducts() async {
    try {
      LogService.info('Fetching popular products');

      final sections = await getDashboardData();
      final popularSection = sections.firstWhereOrNull(
        (section) => section.type == 'popular_products',
      );

      if (popularSection != null) {
        final products = popularSection.products;
        LogService.info('Found ${products.length} popular products');
        return products;
      } else {
        LogService.info('No popular products section found');
        return [];
      }
    } catch (e) {
      LogService.error('Error fetching popular products: $e');
      return [];
    }
  }

  /// Get banners from dashboard
  /// Convenience method to extract banner/promotional data
  Future<List<dynamic>> getDashboardBanners() async {
    try {
      LogService.info('Fetching dashboard banners');

      final sections = await getDashboardData();
      final bannerSection = sections.firstWhereOrNull(
        (section) => section.type == 'banners',
      );

      if (bannerSection != null) {
        final banners = bannerSection.data;
        LogService.info('Found ${banners.length} banners');
        return banners;
      } else {
        LogService.info('No banners section found');
        return [];
      }
    } catch (e) {
      LogService.error('Error fetching dashboard banners: $e');
      return [];
    }
  }

  /// Get section by type
  /// Generic method to get any section by its type
  Future<DashboardSection?> getSectionByType(String sectionType) async {
    try {
      LogService.info('Fetching dashboard section: $sectionType');

      final sections = await getDashboardData();
      final section = sections.firstWhereOrNull(
        (section) => section.type == sectionType,
      );

      if (section != null) {
        LogService.info('Found section: $sectionType');
      } else {
        LogService.info('Section not found: $sectionType');
      }

      return section;
    } catch (e) {
      LogService.error('Error fetching section $sectionType: $e');
      return null;
    }
  }
}
