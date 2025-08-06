// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:get/get.dart';

class BuyerHomeController extends GetxController {
  // Use new services from core
  final CartStorageService _cartStorageService = Get.find<CartStorageService>();
  final ProductApiService _productApiService = Get.find<ProductApiService>();
  final ProductStorageService _productStorageService =
      Get.find<ProductStorageService>();
  final DashboardApiService _dashboardApiService =
      Get.find<DashboardApiService>();
  final DashboardStorageService _dashboardStorageService =
      Get.find<DashboardStorageService>();

  // Navigation bar visibility control
  final isNavBarVisible = true.obs;
  double _lastScrollOffset = 0.0;

  // Observable state
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;

  // Cart reactive getter
  int get cartItemCount => _cartStorageService.getItemsCount();

  // Data for UI sections using real models
  final RxList<ProductCategory> categories = <ProductCategory>[].obs;
  final RxList<DashboardSection> featuredSections = <DashboardSection>[].obs;
  final RxList<Product> featuredProducts = <Product>[].obs;
  final RxList<Product> popularProducts = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadHomeData();
  }

  /// Load all home screen data from APIs and cache
  Future<void> _loadHomeData() async {
    try {
      isLoading.value = true;

      // Load data in parallel for better performance
      await Future.wait([
        _loadCategories(),
        _loadFeaturedSections(),
        _loadFeaturedProducts(),
        _loadPopularProducts(),
      ]);
    } catch (e) {
      LogService.error('Error loading home data: $e');
      ErrorService.showError('Failed to load home screen data');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load product categories
  Future<void> _loadCategories() async {
    try {
      // Try cached data first
      final cachedCategories = _productStorageService.getCachedCategories();
      if (cachedCategories.isNotEmpty) {
        categories.value = cachedCategories;
      }

      // Fetch fresh data from API
      final apiCategories = await _productApiService.getAllCategories();
      if (apiCategories.isNotEmpty) {
        categories.value = apiCategories;
        await _productStorageService.saveCategories(apiCategories);
      }
    } catch (e) {
      LogService.error('Error loading categories: $e');
    }
  }

  /// Load featured dashboard sections
  Future<void> _loadFeaturedSections() async {
    try {
      // Try cached data first
      final cachedSections = _dashboardStorageService.dashboardSections;
      if (cachedSections.isNotEmpty) {
        featuredSections.value = cachedSections;
      }

      // Fetch fresh data from API
      final apiSections = await _dashboardApiService.getDashboardData();
      if (apiSections.isNotEmpty) {
        featuredSections.value = apiSections;
        await _dashboardStorageService.saveDashboardData(apiSections);
      }
    } catch (e) {
      LogService.error('Error loading featured sections: $e');
    }
  }

  /// Load featured products
  Future<void> _loadFeaturedProducts() async {
    try {
      // Try cached data first
      final cachedProducts = _productStorageService.getCachedFeaturedProducts();
      if (cachedProducts.isNotEmpty) {
        featuredProducts.value = cachedProducts;
      }

      // Fetch fresh data from API
      final apiProducts = await _productApiService.getFeaturedProducts();
      if (apiProducts.isNotEmpty) {
        featuredProducts.value = apiProducts;
        await _productStorageService.saveFeaturedProducts(apiProducts);
      }
    } catch (e) {
      LogService.error('Error loading featured products: $e');
    }
  }

  /// Load popular products
  Future<void> _loadPopularProducts() async {
    try {
      // Get newest products as popular products
      final products = await _productApiService.getNewestProducts(limit: 10);
      if (products.isNotEmpty) {
        popularProducts.value = products;
      }
    } catch (e) {
      LogService.error('Error loading popular products: $e');
    }
  }

  /// Refresh all home screen data
  Future<void> refreshHomeData() async {
    try {
      isRefreshing.value = true;

      // Clear cached data and fetch fresh
      await Future.wait([
        _loadCategories(),
        _loadFeaturedSections(),
        _loadFeaturedProducts(),
        _loadPopularProducts(),
      ]);

      ErrorService.showSuccess('Home data refreshed successfully');
    } catch (e) {
      LogService.error('Error refreshing home data: $e');
      ErrorService.showError('Failed to refresh data');
    } finally {
      isRefreshing.value = false;
    }
  }

  // Method to handle scroll changes for nav bar visibility
  void handleScrollUpdate(double offset) {
    const double threshold =
        50.0; // Minimum scroll distance to trigger hide/show

    if (offset > _lastScrollOffset + threshold) {
      // Scrolling down - hide nav bar
      if (isNavBarVisible.value) {
        isNavBarVisible.value = false;
      }
    } else if (offset < _lastScrollOffset - threshold) {
      // Scrolling up - show nav bar
      if (!isNavBarVisible.value) {
        isNavBarVisible.value = true;
      }
    }

    _lastScrollOffset = offset;
  }

  // Navigation methods
  void onCategoryTap(ProductCategory category) {
    try {
      LogService.info('Navigating to category: ${category.name}');
      Get.toNamed(
        '/buyer-products',
        arguments: {'categoryId': category.id, 'categoryName': category.name},
      );
    } catch (e) {
      LogService.error('Failed to navigate to category: $e');
    }
  }

  void onProductTap(Product product) {
    try {
      LogService.info('Navigating to product: ${product.name}');
      Get.toNamed(
        '/buyer-product-details',
        arguments: {'productId': product.id, 'product': product},
      );
    } catch (e) {
      LogService.error('Failed to navigate to product: $e');
    }
  }

  void onDealTap(DashboardSection deal) {
    try {
      LogService.info('Navigating to deal: ${deal.title}');
      Get.toNamed('/buyer-deals', arguments: {'dealTitle': deal.title});
    } catch (e) {
      LogService.error('Failed to navigate to deal: $e');
    }
  }

  void onSearchTap() {
    try {
      LogService.info('Navigating to search');
      Get.toNamed('/buyer-search');
    } catch (e) {
      LogService.error('Failed to navigate to search: $e');
    }
  }

  void onNotificationTap() {
    try {
      LogService.info('Navigating to notifications');
      Get.toNamed('/buyer-notifications');
    } catch (e) {
      LogService.error('Failed to navigate to notifications: $e');
    }
  }

  void onWishlistTap() {
    try {
      LogService.info('Navigating to wishlist');
      Get.toNamed('/buyer-wishlist');
    } catch (e) {
      LogService.error('Failed to navigate to wishlist: $e');
    }
  }

  void onCartTap() {
    try {
      LogService.info('Navigating to cart');
      Get.toNamed('/buyer-cart');
    } catch (e) {
      LogService.error('Failed to navigate to cart: $e');
    }
  }

  // Quick actions
  Future<void> addToCart(Product product) async {
    try {
      isLoading.value = true;
      LogService.info('Adding product to cart: ${product.name}');

      // Use CartApiService to add item to cart
      await Get.find<CartApiService>().addItemToCart(
        product.id,
        1, // default quantity
      );

      ErrorService.showSuccess('${product.name} added to cart');
    } catch (e) {
      LogService.error('Failed to add to cart: $e');
      ErrorService.showError('Failed to add item to cart');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleWishlist(Product product) async {
    try {
      LogService.info('Toggling wishlist for product: ${product.name}');

      // Update wishlist through storage service
      final productStorage = Get.find<ProductStorageService>();
      final isInWishlist = productStorage.isInWishlist(product.id);

      if (isInWishlist) {
        await productStorage.removeFromWishlist(product.id);
        ErrorService.showSuccess('Removed from wishlist');
      } else {
        await productStorage.addToWishlist(product);
        ErrorService.showSuccess('Added to wishlist');
      }
    } catch (e) {
      LogService.error('Failed to toggle wishlist: $e');
      ErrorService.showError('Failed to update wishlist');
    }
  }
}
