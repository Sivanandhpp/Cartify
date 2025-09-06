import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/core/widgets/app_dialog.dart';
import 'package:cartify/app/modules/seller_panel/seller_dashboard/controllers/seller_data_controller.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SellerProductsController extends GetxController {
  // ===================== DEPENDENCIES =====================
  final SellerDataController _dataController = Get.find<SellerDataController>();
  final ProductService _productService = Get.find<ProductService>();

  // ===================== UI STATE =====================
  final RxList<ProductModel> filteredProducts = <ProductModel>[].obs;
  final RxBool isRefreshing = false.obs;

  // ===================== FILTERS =====================
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString selectedStatus = 'All'.obs;
  final RxString selectedStockFilter = 'All'.obs;

  // ===================== COMPUTED PROPERTIES =====================

  /// Get products from centralized data controller
  List<ProductModel> get products => _dataController.products;

  /// Get loading state from centralized data controller
  bool get isLoading => _dataController.isLoading.value;

  /// Get available categories from centralized data controller
  List<String> get availableCategories => _dataController.extractedCategories;

  /// Statistics computed from filtered products
  int get totalProducts => products.length;
  int get activeProducts => products.where((p) => p.isActive == true).length;
  int get inactiveProducts => products.where((p) => p.isActive == false).length;
  int get lowStockProducts =>
      products.where((p) => p.stockQuantity < 10).length;

  // ===================== LIFECYCLE METHODS =====================

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  /// Initialize controller and set up listeners
  void _initializeController() {
    // Ensure data is loaded (will use cache if available)
    _ensureDataLoaded();

    // Listen to data changes from centralized controller
    ever(_dataController.products, (_) => _applyFilters());

    // Listen to search changes with debounce
    debounce(
      searchQuery,
      (_) => _applyFilters(),
      time: const Duration(milliseconds: 500),
    );

    // Apply initial filters
    _applyFilters();
  }

  /// Ensure data is loaded, fetch if not available
  Future<void> _ensureDataLoaded() async {
    if (!_dataController.isDataLoaded.value) {
      await _dataController.fetchAllData();
    }
  }

  // ===================== DATA OPERATIONS =====================

  /// Refresh products using centralized data controller
  Future<void> refreshProducts() async {
    try {
      isRefreshing.value = true;
      LogService.info('Refreshing seller products');

      await _dataController.refreshProducts();

      LogService.info('Products refreshed successfully');
    } catch (e) {
      LogService.error('Failed to refresh products', e);
      NotificationService.showError(
        title: 'Refresh Failed',
        message: 'Failed to refresh products. Please try again.',
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  // ===================== FILTERING METHODS =====================

  /// Apply all filters using centralized filtering logic
  void _applyFilters() {
    final filtered = _dataController.getFilteredProducts(
      category: selectedCategory.value,
      status: selectedStatus.value,
      stockFilter: selectedStockFilter.value,
      searchQuery: searchQuery.value,
    );

    filteredProducts.assignAll(filtered);

    LogService.debug('Filters applied', {
      'total': products.length,
      'filtered': filteredProducts.length,
      'search': searchQuery.value,
      'category': selectedCategory.value,
      'status': selectedStatus.value,
      'stock': selectedStockFilter.value,
    });
  }

  /// Update category filter
  void updateCategoryFilter(String category) {
    selectedCategory.value = category;
    _applyFilters();
    LogService.debug('Category filter updated', {'category': category});
  }

  /// Update status filter
  void updateStatusFilter(String status) {
    selectedStatus.value = status;
    _applyFilters();
    LogService.debug('Status filter updated', {'status': status});
  }

  /// Update stock filter
  void updateStockFilter(String stockFilter) {
    selectedStockFilter.value = stockFilter;
    _applyFilters();
    LogService.debug('Stock filter updated', {'stockFilter': stockFilter});
  }

  /// Search products
  void searchProducts(String query) {
    searchQuery.value = query;
    // Filter will be applied automatically due to debounce listener
  }

  /// Reset all filters
  void resetFilters() {
    searchQuery.value = '';
    selectedCategory.value = 'All';
    selectedStatus.value = 'All';
    selectedStockFilter.value = 'All';
    _applyFilters();
    LogService.info('All filters reset');
  }

  // ===================== PRODUCT OPERATIONS =====================

  /// Toggle product status with API call and data refresh
  Future<void> toggleProductStatus(ProductModel product) async {
    try {
      final newStatus = !(product.isActive ?? false);

      LogService.info('Toggling product status', {
        'productId': product.id,
        'currentStatus': product.isActive,
        'newStatus': newStatus,
      });

      final updatedProduct = await _productService.toggleProductStatus(
        product.id,
        newStatus,
      );

      if (updatedProduct != null) {
        // Refresh centralized data to reflect changes across all screens
        await _dataController.refreshProducts();

        NotificationService.showSuccess(
          title: 'Status Updated',
          message: 'Product status updated successfully',
        );

        LogService.info('Product status updated successfully', {
          'productId': product.id,
          'newStatus': updatedProduct.isActive,
        });
      } else {
        throw Exception('Failed to update product status');
      }
    } catch (e) {
      LogService.error('Failed to toggle product status', {
        'productId': product.id,
        'error': e.toString(),
      });

      NotificationService.showError(
        title: 'Update Failed',
        message: 'Failed to update product status. Please try again.',
      );
    }
  }

  /// Delete product with confirmation dialog
  Future<void> deleteProduct(ProductModel product) async {
    AppDialog(
      title: 'Delete Product',
      content:
          'Are you sure you want to delete "${product.name}"? This action cannot be undone.',
      confirmText: 'Delete',
      confirmButtonColor: AppColors.error,
      onConfirm: () async {
        Get.back(); // Close dialog first

        try {
          LogService.info('Deleting product', {
            'productId': product.id,
            'productName': product.name,
          });

          final success = await _productService.deleteProduct(product.id);

          if (success) {
            // Refresh centralized data to reflect changes across all screens
            await _dataController.refreshProducts();

            NotificationService.showSuccess(
              title: 'Product Deleted',
              message: 'Product "${product.name}" deleted successfully',
            );

            LogService.info('Product deleted successfully', {
              'productId': product.id,
            });
          } else {
            throw Exception('Failed to delete product');
          }
        } catch (e) {
          LogService.error('Failed to delete product', {
            'productId': product.id,
            'error': e.toString(),
          });

          NotificationService.showError(
            title: 'Delete Failed',
            message: 'Failed to delete product. Please try again.',
          );
        }
      },
      onCancel: () => Get.back(),
    ).show();
  }

  // ===================== NAVIGATION METHODS =====================

  /// Navigate to edit product screen
  void editProduct(ProductModel product) {
    LogService.info('Navigating to edit product', {
      'productId': product.id,
      'productName': product.name,
    });

    Get.toNamed(Routes.SELLER_CREATE_PRODUCT, arguments: product);
  }

  /// Navigate to add new product screen
  void addNewProduct() {
    LogService.info('Navigating to add new product');
    Get.toNamed(Routes.SELLER_CREATE_PRODUCT);
  }

  // ===================== HELPER METHODS =====================

  /// Get products by status
  List<ProductModel> getProductsByStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return products.where((p) => p.isActive == true).toList();
      case 'inactive':
        return products.where((p) => p.isActive == false).toList();
      case 'low_stock':
        return products.where((p) => p.stockQuantity < 10).toList();
      default:
        return products.toList();
    }
  }

  /// Get products by category
  List<ProductModel> getProductsByCategory(String categoryName) {
    if (categoryName == 'All') return products.toList();
    return products
        .where((product) => product.category?.name == categoryName)
        .toList();
  }
}
