import 'package:cartify/app/core/index.dart';
import 'package:get/get.dart';

class BuyerHomeController extends GetxController {
  final DashboardService _dashboardService = Get.find<DashboardService>();

  // Reactive variables for dashboard data
  final Rx<DashboardModel?> _dashboardData = Rx<DashboardModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Getters for reactive variables
  DashboardModel? get dashboardData => _dashboardData.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _errorMessage.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  /// Loads dashboard data from the API
  Future<void> loadDashboardData() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final dashboard = await _dashboardService.getDashboard();

      if (dashboard != null) {
        _dashboardData.value = dashboard;
      } else {
        _errorMessage.value = 'Failed to load dashboard data';
      }
    } catch (e) {
      _errorMessage.value = 'Error loading dashboard: $e';
      LogService.error('Dashboard loading error: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Refreshes dashboard data
  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }

  // Helper methods for easy access to dashboard sections

  /// Gets promotional banners for display
  List<BannerModel> getPromotionalBanners() {
    return _dashboardData.value?.promotionalBanners ?? [];
  }

  /// Gets categories for the categories grid
  List<CategoryModel> getCategories() {
    return _dashboardData.value?.categories ?? [];
  }

  /// Gets featured products
  List<ProductModel> getFeaturedProducts() {
    return _dashboardData.value?.featuredProducts ?? [];
  }

  /// Gets the title for featured products section
  String getFeaturedProductsTitle() {
    return _dashboardData.value?.featuredProductsTitle ?? 'Featured Products';
  }

  /// Checks if promotional banners are available
  bool hasPromotionalBanners() {
    return getPromotionalBanners().isNotEmpty;
  }

  /// Checks if categories are available
  bool hasCategories() {
    return getCategories().isNotEmpty;
  }

  /// Checks if featured products are available
  bool hasFeaturedProducts() {
    return getFeaturedProducts().isNotEmpty;
  }

  /// Gets a specific section by type
  DashboardSection? getSection(String type) {
    final dashboard = _dashboardData.value;
    if (dashboard == null) return null;

    try {
      return dashboard.sections.firstWhere((section) => section.type == type);
    } catch (e) {
      return null;
    }
  }

  /// Checks if a specific section exists and has data
  bool hasSectionData(String type) {
    final section = getSection(type);
    return section != null && section.data.isNotEmpty;
  }

  /// Gets all available section types
  List<String> getAvailableSectionTypes() {
    final dashboard = _dashboardData.value;
    if (dashboard == null) return [];

    return dashboard.sections.map((section) => section.type).toList();
  }

  /// Gets the number of items in a specific section
  int getSectionItemCount(String type) {
    final section = getSection(type);
    return section?.data.length ?? 0;
  }
}
